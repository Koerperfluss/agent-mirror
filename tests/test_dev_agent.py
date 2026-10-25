import json
import shlex
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import spark_dev_agent as dev  # noqa: E402


class PathAndToolTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.workspace = Path(self.tmp.name).resolve()

    def tearDown(self):
        self.tmp.cleanup()

    def test_path_escape_and_sensitive_files_are_rejected(self):
        for bad in ("../outside.py", "/etc/passwd", ".git/config", ".env",
                    "keys/server.pem"):
            with self.assertRaises(dev.AgentError, msg=bad):
                dev.safe_path(self.workspace, bad)

    def test_write_read_list_and_symlink_protection(self):
        dev.write_file(self.workspace, "src/module.py", "VALUE = 1\n")
        self.assertEqual(dev.read_file(self.workspace, "src/module.py"),
                         "VALUE = 1\n")
        self.assertIn("src/module.py", dev.list_files(self.workspace, "*.py"))
        link = self.workspace / "outside-link"
        try:
            link.symlink_to(Path("/tmp"))
            with self.assertRaises(dev.AgentError):
                dev.write_file(self.workspace, "outside-link/evil.py", "x")
        except (OSError, NotImplementedError):
            self.skipTest("Symlinks nicht verfügbar")

    def test_run_tests_returns_pass_and_failure(self):
        tests = self.workspace / "tests"
        tests.mkdir()
        (tests / "test_ok.py").write_text(
            "import unittest\n"
            "class T(unittest.TestCase):\n"
            "    def test_ok(self):\n"
            "        self.assertTrue(True)\n",
            encoding="utf-8")
        command = f"{shlex.quote(sys.executable)} -m unittest discover -s tests -v"
        ok = dev.run_tests(self.workspace, command)
        self.assertTrue(ok["passed"], ok["output"])
        (tests / "test_ok.py").write_text(
            "import unittest\nclass T(unittest.TestCase):\n"
            "    def test_bad(self):\n        self.fail('absichtlich')\n",
            encoding="utf-8")
        failed = dev.run_tests(self.workspace, command)
        self.assertFalse(failed["passed"])
        self.assertIn("absichtlich", failed["output"])


class ProtocolTests(unittest.TestCase):
    def test_native_tool_call_parser(self):
        message = {"tool_calls": [{"id": "c1", "function": {
            "name": "read_file", "arguments": '{"path": "a.py"}'}}]}
        calls = dev.parse_tool_calls(message)
        self.assertEqual(calls[0]["name"], "read_file")
        self.assertEqual(calls[0]["arguments"], {"path": "a.py"})

    def test_json_fallback_parser_with_code_fence(self):
        message = {"content": "```json\n" + json.dumps({
            "tool": "list_files", "arguments": {"pattern": "*.py"}}) + "\n```"}
        calls = dev.parse_tool_calls(message)
        self.assertEqual(calls[0]["name"], "list_files")
        self.assertEqual(calls[0]["arguments"]["pattern"], "*.py")

    def test_plain_content_is_not_a_tool_call(self):
        self.assertEqual(dev.parse_tool_calls({"content": "Fertig."}), [])


class AutonomousLoopTests(unittest.TestCase):
    def test_write_test_finish_cycle(self):
        with tempfile.TemporaryDirectory() as tmp:
            workspace = Path(tmp).resolve()
            (workspace / "tests").mkdir()
            command = f"{shlex.quote(sys.executable)} -m unittest discover -s tests -v"
            actions = [
                {"tool_calls": [{"id": "1", "function": {
                    "name": "write_file", "arguments": json.dumps({
                        "path": "tests/test_generated.py",
                        "content": ("import unittest\n"
                                    "class T(unittest.TestCase):\n"
                                    "    def test_ok(self):\n"
                                    "        self.assertEqual(2 + 2, 4)\n")})}}]},
                {"tool_calls": [{"id": "2", "function": {
                    "name": "run_tests", "arguments": "{}"}}]},
                {"tool_calls": [{"id": "3", "function": {
                    "name": "finish", "arguments": json.dumps({
                        "summary": "Test erzeugt und ausgeführt"})}}]},
            ]
            calls = iter(actions)
            seen = []

            def fake_chat(messages, tools):
                seen.append((messages, tools))
                return next(calls)

            agent = dev.DevAgent(
                workspace=workspace, task="Erzeuge einen Test",
                test_command=command, host="http://unused", model="mock",
                protocol="native", final_tests=True, chat_fn=fake_chat)
            result = agent.run()

            self.assertEqual(result["status"], "done")
            self.assertTrue(result["finished"])
            self.assertTrue((workspace / "tests/test_generated.py").is_file())
            self.assertEqual(result["steps"], 3)
            self.assertTrue(result["final_tests"]["passed"])
            self.assertEqual([h["tool"] for h in result["history"]],
                             ["write_file", "run_tests"])
            self.assertTrue(seen[0][1], "Native tools müssen übergeben werden")

    def test_json_protocol_and_read_only(self):
        with tempfile.TemporaryDirectory() as tmp:
            workspace = Path(tmp).resolve()
            actions = iter([
                {"content": json.dumps({"tool": "write_file", "arguments": {
                    "path": "x.py", "content": "x = 1"}})},
                {"content": json.dumps({"tool": "finish", "arguments": {
                    "summary": "blockiert"}})},
            ])

            def fake_chat(messages, tools):
                self.assertEqual(tools, [])
                return next(actions)

            agent = dev.DevAgent(
                workspace=workspace, task="Schreibe x.py", test_command="true",
                host="http://unused", model="mock", protocol="json",
                read_only=True, final_tests=False, chat_fn=fake_chat)
            result = agent.run()
            self.assertFalse((workspace / "x.py").exists())
            self.assertEqual(result["history"][0]["result"]["error"],
                             "read-only: Schreiben deaktiviert")
            self.assertEqual(result["status"], "done")


if __name__ == "__main__":
    unittest.main()
