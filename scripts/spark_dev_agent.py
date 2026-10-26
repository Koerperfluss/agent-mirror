#!/usr/bin/env python3
"""Autonomer Entwicklungsagent für Qwen auf dem DGX Spark.

Der Agent läuft lokal auf dem Spark, spricht den llama.cpp-Server an und arbeitet
nur innerhalb eines Workspace. Er darf Dateien lesen/schreiben, Tests ausführen und
Git-Status/Diff lesen. Es gibt bewusst keinen freien Shell-Zugriff.

Beispiel:
  python3 spark_dev_agent.py --workspace /pfad/zum/projekt \
      --task "Implementiere Modul X und Tests; führe die Testsuite aus" \
      --test-command "python3 -m unittest discover -s tests -v" \
      --max-steps 10 --json-out agent-run.json
"""
import argparse
import json
import os
import shlex
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

from pi_re_client import NoRedirectHandler, validate_host

SAMPLING = {
    "thinking": {"temperature": 1.0, "top_p": 0.95, "top_k": 20, "min_p": 0.0},
    "instruct": {"temperature": 0.7, "top_p": 0.80, "top_k": 20,
                 "min_p": 0.0, "presence_penalty": 1.5,
                 "repetition_penalty": 1.0},
}

MAX_READ = 20000
MAX_WRITE = 100000
MAX_TOOL_CHARS = 12000
EXCLUDED_PARTS = {".git", ".ssh", "__pycache__", ".pytest_cache"}
SENSITIVE_NAMES = {".env", ".git-credentials"}
SENSITIVE_SUFFIXES = {".pem", ".key", ".p12"}

SYSTEM_NATIVE = """Du bist ein autonomer Entwicklungsagent auf einem DGX Spark.
Arbeite ausschließlich im vorgegebenen Workspace und mit den bereitgestellten Tools.
Du hast keinen freien Shell-Zugriff. Lies Dateien, bevor du sie änderst, schreibe
vollständige Änderungen und führe nach jeder sinnvollen Änderung die Tests aus.
Erfinde keine Testergebnisse oder Dateiinhalte. Wenn die Aufgabe erledigt ist oder
du weitere Informationen vom Menschen brauchst, rufe finish mit einer knappen
Zusammenfassung auf. Arbeite in kleinen, prüfbaren Schritten."""

SYSTEM_JSON = """Du bist ein autonomer Entwicklungsagent auf einem DGX Spark.
Arbeite ausschließlich im vorgegebenen Workspace. Du hast keinen freien Shell-Zugriff.
Antworte pro Turn mit GENAU EINEM JSON-Objekt, ohne Markdown und ohne Text davor:

{"tool":"list_files","arguments":{"pattern":"*.py","limit":100}}
{"tool":"read_file","arguments":{"path":"relative/datei.py"}}
{"tool":"write_file","arguments":{"path":"relative/datei.py","content":"vollständiger Inhalt"}}
{"tool":"run_tests","arguments":{}}
{"tool":"git_read","arguments":{"mode":"status"}}
{"tool":"finish","arguments":{"summary":"Was wurde erreicht?"}}

Werkzeuge: list_files, read_file, write_file, run_tests, git_read, finish.
Lies vor Änderungen, schreibe vollständige Dateien, führe Tests aus und erfinde keine
Ergebnisse. Wenn du fertig bist, benutze finish. Keine anderen Schlüssel."""

TOOL_SPECS = [
    {
        "type": "function",
        "function": {
            "name": "list_files",
            "description": "Listet Dateien relativ zum Workspace.",
            "parameters": {
                "type": "object",
                "properties": {
                    "pattern": {"type": "string", "description": "Glob, z. B. *.py"},
                    "limit": {"type": "integer", "minimum": 1, "maximum": 500},
                },
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "read_file",
            "description": "Liest eine UTF-8-Textdatei im Workspace.",
            "parameters": {
                "type": "object",
                "properties": {"path": {"type": "string"}},
                "required": ["path"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "write_file",
            "description": "Schreibt eine vollständige UTF-8-Textdatei im Workspace.",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string"},
                    "content": {"type": "string"},
                },
                "required": ["path", "content"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "run_tests",
            "description": "Führt den vom Betreiber konfigurierten Testbefehl aus.",
            "parameters": {"type": "object", "properties": {}},
        },
    },
    {
        "type": "function",
        "function": {
            "name": "git_read",
            "description": "Liest Git-Status oder Diff; ändert nichts.",
            "parameters": {
                "type": "object",
                "properties": {
                    "mode": {"type": "string", "enum": ["status", "diff"]},
                },
                "required": ["mode"],
            },
        },
    },
    {
        "type": "function",
        "function": {
            "name": "finish",
            "description": "Beendet den Lauf mit einer Zusammenfassung.",
            "parameters": {
                "type": "object",
                "properties": {"summary": {"type": "string"}},
                "required": ["summary"],
            },
        },
    },
]



class AgentError(RuntimeError):
    pass


def normalize_host(host):
    host = host.rstrip("/")
    return host[:-3] if host.endswith("/v1") else host


def _cap(text):
    return text if len(text) <= MAX_TOOL_CHARS else text[:MAX_TOOL_CHARS] + "\n...[gekürzt]"


def _sensitive(relative):
    parts = set(relative.parts)
    if parts & EXCLUDED_PARTS:
        return True
    if relative.name in SENSITIVE_NAMES or relative.name.startswith("id_rsa"):
        return True
    return relative.suffix.lower() in SENSITIVE_SUFFIXES


def safe_path(workspace, relative):
    """Löst einen relativen Pfad auf und verhindert Ausbrüche aus dem Workspace."""
    if not isinstance(relative, str) or not relative.strip():
        raise AgentError("Pfad fehlt")
    candidate = Path(relative)
    if candidate.is_absolute() or ".." in candidate.parts:
        raise AgentError(f"Pfad nicht erlaubt: {relative}")
    if _sensitive(candidate):
        raise AgentError(f"Geschützter Pfad: {relative}")
    resolved = (workspace / candidate).resolve()
    try:
        resolved.relative_to(workspace)
    except ValueError as exc:
        raise AgentError(f"Pfad außerhalb des Workspace: {relative}") from exc
    return resolved


def list_files(workspace, pattern="*", limit=200):
    pattern_path = Path(pattern)
    if pattern_path.is_absolute() or ".." in pattern_path.parts:
        raise AgentError("Ungültiges Glob-Muster")
    limit = max(1, min(int(limit), 500))
    found = []
    for item in workspace.rglob(pattern):
        if not item.is_file():
            continue
        relative = item.relative_to(workspace)
        if _sensitive(relative):
            continue
        try:
            item.resolve().relative_to(workspace)
        except ValueError:
            continue
        found.append(relative.as_posix())
        if len(found) >= limit:
            break
    return sorted(found)


def read_file(workspace, path):
    target = safe_path(workspace, path)
    if not target.is_file():
        raise AgentError(f"Keine Datei: {path}")
    text = target.read_text(encoding="utf-8", errors="replace")
    return _cap(text)


def write_file(workspace, path, content):
    if not isinstance(content, str):
        raise AgentError("content muss Text sein")
    if len(content) > MAX_WRITE:
        raise AgentError(f"Inhalt zu groß ({len(content)} > {MAX_WRITE} Zeichen)")
    target = safe_path(workspace, path)
    if target.exists() and target.is_symlink():
        raise AgentError("Symbolische Links werden nicht beschrieben")
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8")
    return {"path": path, "characters": len(content)}


def run_tests(workspace, command, timeout=300):
    argv = shlex.split(command)
    if not argv:
        raise AgentError("Testbefehl ist leer")
    env = os.environ.copy()
    env["PYTHONDONTWRITEBYTECODE"] = "1"
    try:
        proc = subprocess.run(argv, cwd=workspace, env=env, timeout=timeout,
                              capture_output=True, text=True)
    except FileNotFoundError as exc:
        raise AgentError(f"Testbefehl nicht gefunden: {argv[0]}") from exc
    except subprocess.TimeoutExpired as exc:
        return {"passed": False, "exit_code": None, "timed_out": True,
                "output": _cap(f"Timeout nach {timeout}s")}
    output = (proc.stdout or "") + (proc.stderr or "")
    return {"passed": proc.returncode == 0, "exit_code": proc.returncode,
            "timed_out": False, "output": _cap(output.strip())}


def git_read(workspace, mode):
    if mode == "status":
        argv = ["git", "-C", str(workspace), "status", "--short"]
    elif mode == "diff":
        argv = ["git", "-C", str(workspace), "diff", "--no-ext-diff", "--"]
    else:
        raise AgentError("git_read mode muss status oder diff sein")
    try:
        proc = subprocess.run(argv, timeout=30, capture_output=True, text=True)
    except (OSError, subprocess.TimeoutExpired) as exc:
        raise AgentError(f"Git-Lesen fehlgeschlagen: {exc}") from exc
    if proc.returncode not in (0, 1):
        raise AgentError(f"Git-Fehler: {_cap(proc.stderr.strip())}")
    return {"mode": mode, "output": _cap(proc.stdout.strip())}


def execute_tool(workspace, name, arguments, test_command, test_timeout=300,
                 read_only=False):
    args = arguments if isinstance(arguments, dict) else {}
    if name == "list_files":
        return {"files": list_files(workspace, args.get("pattern", "*"),
                                    args.get("limit", 200))}
    if name == "read_file":
        return {"path": args.get("path"), "content": read_file(workspace, args.get("path"))}
    if name == "write_file":
        if read_only:
            raise AgentError("read-only: Schreiben deaktiviert")
        return {"written": write_file(workspace, args.get("path"), args.get("content"))}
    if name == "run_tests":
        if read_only:
            raise AgentError("read-only: Testausführung deaktiviert")
        return run_tests(workspace, test_command, test_timeout)
    if name == "git_read":
        return git_read(workspace, args.get("mode", "status"))
    if name == "finish":
        return {"finished": True, "summary": str(args.get("summary", ""))}
    raise AgentError(f"Unbekanntes Werkzeug: {name}")


def extract_json_object(text):
    """Extrahiert das erste JSON-Objekt, auch aus einem Markdown-Codeblock."""
    if not isinstance(text, str):
        return None
    cleaned = text.strip()
    if cleaned.startswith("```"):
        cleaned = cleaned.split("\n", 1)[-1]
        if cleaned.rstrip().endswith("```"):
            cleaned = cleaned.rstrip()[:-3]
    start = cleaned.find("{")
    if start < 0:
        return None
    try:
        obj, _ = json.JSONDecoder().raw_decode(cleaned[start:])
    except json.JSONDecodeError:
        return None
    return obj if isinstance(obj, dict) else None


def parse_tool_calls(message):
    """Unterstützt native OpenAI-Toolcalls und das JSON-Fallback-Protokoll."""
    calls = []
    for index, call in enumerate(message.get("tool_calls") or []):
        function = call.get("function") or {}
        raw_args = function.get("arguments") or "{}"
        try:
            arguments = json.loads(raw_args) if isinstance(raw_args, str) else raw_args
        except json.JSONDecodeError:
            arguments = {"_parse_error": raw_args}
        calls.append({"id": call.get("id") or f"call_{index}",
                      "name": function.get("name", ""), "arguments": arguments})
    if calls:
        return calls
    obj = extract_json_object(message.get("content") or "")
    if obj and isinstance(obj.get("tool"), str):
        arguments = obj.get("arguments") or {}
        if not isinstance(arguments, dict):
            arguments = {"_parse_error": arguments}
        return [{"id": None, "name": obj["tool"], "arguments": arguments}]
    return []



class DevAgent:
    def __init__(self, workspace, task, test_command, host, model,
                 mode="thinking", max_steps=8, max_tokens=4096, timeout=600,
                 test_timeout=300, api_key=None, protocol="auto", read_only=False,
                 final_tests=True, chat_fn=None, retries=1, allow_lan=None):
        self.workspace = Path(workspace).resolve()
        if not self.workspace.is_dir():
            raise AgentError(f"Workspace fehlt: {self.workspace}")
        self.test_command = test_command
        if allow_lan is None:
            allow_lan = os.environ.get("QFS_ALLOW_LAN", "") == "1"
        self.host = validate_host(normalize_host(host), allow_lan=allow_lan)
        self.model = model
        self.mode = mode
        self.max_steps = max_steps
        self.max_tokens = max_tokens
        self.timeout = timeout
        self.test_timeout = test_timeout
        self.api_key = api_key
        self.protocol = protocol
        self.read_only = read_only
        self.final_tests = final_tests
        self.chat_fn = chat_fn
        self.retries = retries
        self.use_tools = protocol != "json"
        initial_system = SYSTEM_JSON if protocol == "json" else SYSTEM_NATIVE
        self.messages = [{"role": "system", "content": initial_system},
                         {"role": "user", "content": task}]
        self.history = []

    def _payload(self, messages, use_tools):
        payload = {"model": self.model, "messages": messages,
                   "max_tokens": self.max_tokens, "stream": False,
                   **SAMPLING[self.mode]}
        if use_tools:
            payload["tools"] = TOOL_SPECS
            payload["tool_choice"] = "auto"
        return payload

    def _post(self, messages, use_tools):
        if self.chat_fn is not None:
            return self.chat_fn(messages, TOOL_SPECS if use_tools else [])
        payload = self._payload(messages, use_tools)
        headers = {"Content-Type": "application/json"}
        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"
        req = urllib.request.Request(
            f"{self.host}/v1/chat/completions",
            data=json.dumps(payload, ensure_ascii=False).encode("utf-8"),
            headers=headers)
        try:
            opener = urllib.request.build_opener(NoRedirectHandler)
            with opener.open(req, timeout=self.timeout) as resp:
                data = json.load(resp)
        except urllib.error.HTTPError as exc:
            detail = exc.read().decode("utf-8", "replace")[:1000]
            raise AgentError(f"API HTTP {exc.code}: {detail}") from exc
        except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as exc:
            raise AgentError(f"API-Fehler: {exc}") from exc
        choices = data.get("choices") or []
        if not choices:
            raise AgentError(f"Antwort ohne choices: {data}")
        return choices[0].get("message") or {}

    def _model(self, messages):
        last_error = None
        for attempt in range(self.retries + 1):
            try:
                return self._post(messages, self.use_tools)
            except AgentError as exc:
                last_error = exc
                unsupported = any(marker in str(exc)
                                  for marker in ("API HTTP 400", "API HTTP 422"))
                if self.use_tools and self.protocol == "auto" and unsupported:
                    self.use_tools = False
                    self.protocol = "json"
                    messages[0] = {"role": "system", "content": SYSTEM_JSON}
                    continue
                if attempt < self.retries:
                    time.sleep(1 + attempt)
                    continue
                raise
        raise last_error or AgentError("Modellaufruf fehlgeschlagen")


    def _append_native(self, message):
        assistant = {"role": "assistant", "content": message.get("content") or ""}
        if message.get("tool_calls"):
            assistant["tool_calls"] = message["tool_calls"]
        self.messages.append(assistant)

    def run(self):
        status = "max_steps"
        summary = ""
        finished = False
        steps = 0
        for step in range(1, self.max_steps + 1):
            steps = step
            print(f"[{step}/{self.max_steps}] Modell wird gefragt ...", flush=True)
            message = self._model(self.messages)
            calls = parse_tool_calls(message)
            if not calls:
                summary = (message.get("content") or "").strip()
                status = "done" if summary else "no_action"
                break
            self._append_native(message)
            stop = False
            for call in calls:
                name = call["name"]
                arguments = call["arguments"]
                print(f"[{step}] {name} "
                      f"{json.dumps(arguments, ensure_ascii=False)[:300]}", flush=True)
                if name == "finish":
                    summary = str(arguments.get("summary", ""))
                    status = "done"
                    finished = True
                    stop = True
                    break
                try:
                    result = execute_tool(self.workspace, name, arguments,
                                          self.test_command, self.test_timeout,
                                          read_only=self.read_only)
                except (AgentError, OSError, ValueError) as exc:
                    result = {"error": str(exc)}
                result_text = _cap(json.dumps(result, ensure_ascii=False))
                self.history.append({"step": step, "tool": name,
                                     "arguments": arguments, "result": result})
                if call["id"]:
                    self.messages.append({"role": "tool", "tool_call_id": call["id"],
                                          "name": name, "content": result_text})
                else:
                    self.messages.append({"role": "user",
                                          "content": f"TOOL_RESULT {result_text}"})
            if stop:
                break

        final_test_result = None
        if self.final_tests and not self.read_only and status == "done":
            print("Finale Testsuite ...", flush=True)
            try:
                final_test_result = run_tests(self.workspace, self.test_command,
                                              self.test_timeout)
            except AgentError as exc:
                final_test_result = {"passed": False, "exit_code": None,
                                     "output": str(exc)}
            if not final_test_result.get("passed"):
                status = "tests_failed"
        return {"status": status, "finished": finished, "summary": summary,
                "steps": steps, "protocol": self.protocol,
                "final_tests": final_test_result, "history": self.history,
                "workspace": str(self.workspace)}



def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", default=os.getcwd(),
                        help="Projektordner, in dem der Agent arbeiten darf")
    task_group = parser.add_mutually_exclusive_group(required=True)
    task_group.add_argument("--task", help="Entwicklungsauftrag")
    task_group.add_argument("--task-file", help="Textdatei mit Entwicklungsauftrag")
    parser.add_argument("--test-command",
                        default="python3 -m unittest discover -s tests -v",
                        help="Vom Betreiber festgelegter Testbefehl")
    parser.add_argument("--host", default=os.getenv("SPARK_HOST", "http://127.0.0.1:8080"))
    parser.add_argument("--model", default=os.getenv("SPARK_MODEL", "qwen3.8-flash-next"))
    parser.add_argument("--mode", choices=list(SAMPLING), default="thinking")
    parser.add_argument("--protocol", choices=["auto", "native", "json"], default="auto",
                        help="Tool-Protokoll; auto versucht native OpenAI-Tools")
    parser.add_argument("--max-steps", type=int, default=8)
    parser.add_argument("--max-tokens", type=int, default=4096)
    parser.add_argument("--timeout", type=int, default=600)
    parser.add_argument("--test-timeout", type=int, default=300)
    parser.add_argument("--api-key", default=os.getenv("SPARK_API_KEY", ""))
    parser.add_argument("--read-only", action="store_true",
                        help="Keine Schreib- oder Testaktionen")
    parser.add_argument("--no-final-tests", action="store_true",
                        help="Keine zusätzliche Testsuite nach dem Lauf")
    parser.add_argument("--retries", type=int, default=1)
    parser.add_argument("--json-out", default="", help="Protokoll als JSON speichern")
    args = parser.parse_args()

    try:
        task = (Path(args.task_file).read_text(encoding="utf-8")
                if args.task_file else args.task).strip()
        agent = DevAgent(
            workspace=args.workspace, task=task, test_command=args.test_command,
            host=args.host, model=args.model, mode=args.mode,
            max_steps=args.max_steps, max_tokens=args.max_tokens,
            timeout=args.timeout, test_timeout=args.test_timeout,
            api_key=args.api_key, protocol=args.protocol,
            read_only=args.read_only, final_tests=not args.no_final_tests,
            retries=args.retries)
        result = agent.run()
    except (AgentError, OSError) as exc:
        print(f"Agent-Fehler: {exc}", file=sys.stderr)
        return 1

    print(json.dumps({key: result[key] for key in
                      ("status", "finished", "summary", "steps", "protocol")},
                     ensure_ascii=False, indent=2))
    if result.get("final_tests") is not None:
        tests = result["final_tests"]
        print(f"Tests: {'OK' if tests.get('passed') else 'FEHLER'} "
              f"(Exit {tests.get('exit_code')})")
    if args.json_out:
        Path(args.json_out).write_text(
            json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"Protokoll: {args.json_out}")
    if result["status"] == "done":
        return 0
    return 2 if result["status"] == "max_steps" else 1


if __name__ == "__main__":
    sys.exit(main())
