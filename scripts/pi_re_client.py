import json
import urllib.request
import argparse
import sys

# LOKI.OS - Pi Reverse Engineering Client (Standard Lib Only)

def get_args():
    parser = argparse.ArgumentParser(description="Qwen RE Client für Traktor Reverse Engineering")
    parser.add_argument("--host", default="http://localhost:8080", help="API Host URL")
    parser.add_argument("--task", choices=["hid", "mapping", "capture", "format"], default="hid", help="RE Task Profil")
    parser.add_argument("--input", default="-", help="Eingabedatei (Hexdump/Capture) oder '-' für stdin")
    parser.add_argument("--question", help="Spezifische Frage zum Input")
    parser.add_argument("--output", help="Optionaler JSON-Output Pfad")
    return parser.parse_args()

PROFILES = {
    "hid": "Analysiere den folgenden HID-Report Deskriptor oder Report-Daten. Identifiziere Achsen, Buttons und Steuerungs-Events.",
    "mapping": "Extrahiere Controller-Mappings aus diesem XML/Text. Erstelle eine Tabelle mit Control-ID zu MIDI/HID Event.",
    "capture": "Analysiere diesen USB/MIDI-Capture Stream. Suche nach Mustern (Delta-Analyse) bei Parameter-Änderungen.",
    "format": "Identifiziere das binäre Datenformat in diesem Hexdump. Achte auf Header, Checksummen und Feldlängen."
}

SYSTEM_PROMPT = """Du bist ein spezialisierter Reverse Engineering Assistent für DJ-Hardware (Traktor/Native Instruments).
Deine Aufgabe ist die Analyse von Protokollen, Hexdumps und USB-Captures.

STRUKTUR DEINER ANTWORT:
1. BEOBACHTUNG: Neutrale Zusammenfassung der Daten.
2. HYPOTHESE: Deine Interpretation (was bedeutet Byte X?).
3. VERIFIKATION: Welchen Test oder Schritt muss ich als nächstes auf dem Pi ausführen, um die Hypothese zu beweisen?

Regeln:
- Kennzeichne Unsicherheiten explizit mit [UNSICHER].
- Wenn Reasoning-Content verfügbar ist, nutze ihn für die interne Logikfindung.
- Antworte präzise und technisch.
"""

def main():
    args = get_args()

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

    url = f"{args.host.rstrip('/')}/v1/chat/completions"
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

    full_response = ""
    reasoning = ""

    print(f"📡 Sende Task '{args.task}' an Spark...\n")

    try:
        with urllib.request.urlopen(req) as response:
            for line in response:
                if not line.strip(): continue
                line_str = line.decode('utf-8')
                if line_str.startswith("data: "):
                    content = line_str[6:].strip()
                    if content == "[DONE]": break
                    
                    try:
                        chunk = json.loads(content)
                        delta = chunk["choices"][0].get("delta", {})
                        
                        # Streaming Reasoning (falls vom Modell/Server unterstützt)
                        if "reasoning_content" in delta:
                            r_text = delta["reasoning_content"]
                            reasoning += r_text
                            # Optional: Reasoning anzeigen (z.B. in grau)
                            # print(f"\033[90m{r_text}\033[0m", end="", flush=True)
                        
                        if "content" in delta:
                            c_text = delta["content"]
                            full_response += c_text
                            print(c_text, end="", flush=True)
                            
                    except json.JSONDecodeError:
                        continue
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
