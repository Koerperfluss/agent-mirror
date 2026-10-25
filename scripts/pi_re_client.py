import json
import urllib.request
import urllib.error
import argparse
import ipaddress
import os
import socket
import sys

# LOKI.OS - Pi Reverse Engineering Client (Standard Lib Only)

REQUEST_TIMEOUT = 1800  # Sekunden; RE-Antworten mit Reasoning können lang dauern

class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
    """Blockt HTTP-Redirects: Ziel-URL bleibt die geprüfte Host-URL (SSRF-Schutz)."""
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        raise urllib.error.URLError(f"Redirect blockiert ({code} -> {newurl})")

def validate_host(host, allow_lan=False):
    """SSRF-Schutz für die Host-URL.

    - Nur http/https (kein file://, ftp:// ...).
    - Hostname wird aufgelöst; private-, Loopback- und Link-Local-Adressen
      werden blockiert, AUSSER allow_lan=True (für den Betrieb im eigenen
      LAN: DGX Spark / SSH-Tunnel — Standard-Anwendungsfall dieses Tools,
      per --allow-lan oder QFS_ALLOW_LAN=1 bewusst aktiviert).
    """
    from urllib.parse import urlparse
    parsed = urlparse(host)
    if parsed.scheme not in ("http", "https"):
        raise ValueError(f"Ungültiges URL-Schema '{parsed.scheme}' — nur http/https erlaubt.")
    if not parsed.hostname:
        raise ValueError("Host-URL enthält keinen Hostnamen.")
    if not allow_lan:
        try:
            infos = socket.getaddrinfo(parsed.hostname, parsed.port or 80)
        except socket.gaierror as e:
            raise ValueError(f"Hostname nicht auflösbar: {e}")
        for info in infos:
            ip = ipaddress.ip_address(info[4][0])
            if ip.is_private or ip.is_loopback or ip.is_link_local or ip.is_reserved:
                raise ValueError(
                    f"Ziel {ip} ist eine private/lokale Adresse. "
                    "Für eigenen LAN-Server (DGX Spark): --allow-lan oder QFS_ALLOW_LAN=1 setzen.")
    stripped = host.rstrip("/")
    return stripped[:-3] if stripped.endswith("/v1") else stripped

def get_args():
    parser = argparse.ArgumentParser(description="Qwen RE Client für Traktor Reverse Engineering")
    parser.add_argument("--host", default="http://localhost:8080", help="API Host URL")
    parser.add_argument("--task", choices=["hid", "mapping", "capture", "format", "codegen"], default="mapping", help="Task Profil")
    parser.add_argument("--input", default="-", help="Eingabedatei (Hexdump/Capture) oder '-' für stdin")
    parser.add_argument("--question", help="Spezifische Frage zum Input")
    parser.add_argument("--output", help="Optionaler JSON-Output Pfad")
    parser.add_argument("--allow-lan", action="store_true",
                        default=os.environ.get("QFS_ALLOW_LAN", "") == "1",
                        help="Erlaubt private/LAN-Ziele (DGX Spark im eigenen Netz)")
    return parser.parse_args()

PROFILES = {
    "hid": "Analysiere den folgenden HID-Report Deskriptor oder Report-Daten. Identifiziere Achsen, Buttons und Steuerungs-Events.",
    "mapping": "Extrahiere Controller-Mappings aus diesem XML/Text. Erstelle eine Tabelle mit Control-ID zu MIDI/HID Event.",
    "capture": "Analysiere diesen USB/MIDI-Capture Stream. Suche nach Mustern (Delta-Analyse) bei Parameter-Änderungen.",
    "format": "Identifiziere das binäre Datenformat in diesem Hexdump. Achte auf Header, Checksummen und Feldlängen.",
    "codegen": "Generiere aus der folgenden Spezifikation/Daten vollständigen, lauffähigen Code (Swift/CoreAudio/CoreMIDI für macOS oder Python). Nenne Sprache und Framework explizit."
}

SYSTEM_PROMPT = """Du bist ein spezialisierter Entwicklungs-Assistent für einen Traktor-Clone unter macOS (Swift, CoreAudio, CoreMIDI, Xcode).
Deine Aufgabe ist die Analyse von Traktor-Dateien (.tsi, collection.nml), Hardwaredaten und die Generierung von Code für den eigenen DJ-Clone.

STRUKTUR DEINER ANTWORT:
1. BEOBACHTUNG: Neutrale Zusammenfassung der Daten.
2. HYPOTHESE: Deine Interpretation (was bedeutet Byte X?).
3. VERIFIKATION: Welchen Test oder Schritt muss ich als nächstes auf dem Pi ausführen, um die Hypothese zu beweisen?

Regeln:
- Kennzeichne Unsicherheiten explizit mit [UNSICHER].
- Wenn Reasoning-Content verfügbar ist, nutze ihn für die interne Logikfindung.
- Antworte präzise und technisch.
"""

def parse_re_stream(lines):
    """Parst einen OpenAI-SSE-Stream und gibt (content, reasoning) zurück.

    Robust gegen: 'data:' mit/ohne Leerzeichen, Final-Chunks mit leerer
    choices-Liste (llama.cpp sendet dort usage mit), fehlende Delta-Felder.
    """
    full_response = ""
    reasoning = ""
    for line in lines:
        if not line.strip():
            continue
        line_str = line.decode('utf-8')
        if not line_str.startswith("data:"):
            continue
        content = line_str[5:].strip()
        if content == "[DONE]":
            break
        try:
            chunk = json.loads(content)
        except json.JSONDecodeError:
            continue
        choices = chunk.get("choices") or [{}]
        delta = choices[0].get("delta", {}) if choices else {}
        if delta.get("reasoning_content"):
            reasoning += delta["reasoning_content"]
        if delta.get("content"):
            full_response += delta["content"]
            print(delta["content"], end="", flush=True)
    return full_response, reasoning

def main():
    args = get_args()

    try:
        base_url = validate_host(args.host, allow_lan=args.allow_lan)
    except ValueError as e:
        print(f"❌ {e}")
        sys.exit(2)

    # Input lesen
    if args.input == "-":
        input_data = sys.stdin.read()
    else:
        with open(args.input, 'r') as f:
            input_data = f.read()

    # Prompt bauen
    user_content = f"{PROFILES[args.task]}\n\nINPUT DATEN:\n{input_data}"
    if args.question:
        user_content += f"\n\nSPEZIFISCHE FRAGE:\n{args.question}"

    # URL aus der validierten Basis (Schema+IP-Grenze geprüft, Redirects blockiert)
    url = f"{base_url}/v1/chat/completions"
    data = {
        "model": "qwen",
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_content}
        ],
        "stream": True
    }

    headers = {"Content-Type": "application/json"}
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers)

    print(f"📡 Sende Task '{args.task}' an Spark...\n")

    try:
        opener = urllib.request.build_opener(NoRedirectHandler)
        with opener.open(req, timeout=REQUEST_TIMEOUT) as response:
            full_response, reasoning = parse_re_stream(response)
        print("\n")
    except Exception as e:
        print(f"\n❌ Fehler: {e}")
        sys.exit(1)

    if args.output:
        with open(args.output, 'w') as f:
            json.dump({
                "task": args.task,
                "input_preview": input_data[:100],
                "response": full_response,
                "reasoning": reasoning
            }, f, indent=2)
        print(f"💾 Protokoll in {args.output} gespeichert.")

if __name__ == "__main__":
    main()
