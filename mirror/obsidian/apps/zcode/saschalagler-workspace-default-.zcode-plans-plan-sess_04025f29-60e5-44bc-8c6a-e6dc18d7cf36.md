---
app: zcode
quelle: "saschalagler/workspace/default/.zcode/plans/plan-sess_04025f29-60e5-44bc-8c6a-e6dc18d7cf36.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# Fix-Plan: Sigma-Stack (Browser + Eclipse LLM) lauffähig machen

## Root Cause (fixiert)
1. `models/model/` ist leer — der 4,9-GB-Download der App ist geplatzt (Fehlerdialog bei 37,5 %, `is_downloading: false`, kein Resume, Dateien aufgeräumt)
2. Ohne .gguf startet der llama-server (Port 10345) nicht (`server_running: false`)
3. Deshalb: Activate-Klick im Sigma Browser = stiller Fehlschlag. Agent-Settings (OpenClaw/Hermes/Gemini) sind unschuldig — Gemini-Cloud läuft als aktives Agent-Backend

## Schritte (nach Freigabe ausführen)

1. **Speicher-Check**: `df -h` — mindestens ~10 GB frei nötig (gestern: 38 GB)
2. **Sigma Eclipse LLM beenden** (sauber via osascript/pkill)
3. **GGUF manuell laden statt App-Downloader** (der robusteste Weg, resume-fähig):
   - `curl -L -C - -o ".../models/model/model.gguf" "https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-IQ4_XS.gguf"` (~5,2 GB)
   - Fortschritt sichtbar; bei Abbruch einfach derselbe Befehl wieder (setzt fort)
4. **Uncensored-Hinweis**: Toggle in der App AUS lassen (sonst lädt sie ERNEUT 4,9 GB von einem anderen Mirror). Der manuell geladene Standard-Build ist der stabile Weg. Wer später uncensored will: abliterated GGUF manuell tauschen.
5. **App starten → Activate klicken** → Health-Check: `curl http://127.0.0.1:10345/health` + `ipc_state.json` prüfen (`server_running: true`)
   - Fallback A: Falls die App `model.gguf` nicht erkennt → Datei in `model.bin` umbenennen (GGUF-Magic bleibt identisch), App neu starten
   - Fallback B: Falls immer noch Error-Dialog → App-eigenen Download nochmal mit stabilem Netz (über Nacht), da kein Resume: eine Unterbrechung = wieder von 0
6. **Sigma Browser**: neu starten → Modell aktivieren (jetzt mit laufendem Backend) → Test-Prompt im Agent-Chat. Danach entscheiden: lokales Qwen als Agent-Backend (privat, langsam) oder Gemini Cloud (schnell) — beide konfigurierbar in sigma://settings/agentSettings
7. **Empfohlen aufräumen**: Desktop-Backups von gestern (`sigma-modell-backup-*`, `sigma-settings-backup.json`, `Sigma-Eclipse-Fix.sh`) nach `~/.Trash` verschieben, sobald der Server läuft
8. **Sicherheits-Empfehlung (explizit freigeben)**: Atomic Hermes.app nach `~/.Trash` verschieben (anonymer Vendor, unsigniert, überhöhte Zugriffsrechte). Dessen "Hermes Agent"-Eintrag verschwindet damit aus dem Sigma-Browser. OpenClaw (default agent) kann bleiben — läuft lokal auf Qwen.
9. **Memory-Update**: browser-umstieg-sigma.md mit neuem Stand (Download-Reset-Kette, manuelle GGUF-Lösung, Hermes-Bewertung)

## Erwartung nach Fix
- llama-server auf 10345 läuft, Modell aktivierbar im Browser
- Performance: ~15–20 tok/s (fanless M4, 16 GB) — erster Prompt einer langen Seite dauert (DeltaNet/Metal-Limitation)
- Wenn RAM-Druck: ctx_size von 12000 → 8000 in settings.json

## Benötigte Freigaben
- Bash-Terminalbefehle (Download, Health-Check, App-Steuerung)
- Datei-Verschiebungen (GGUF, Backups → Trash)
- Optional: Atomic Hermes.app → Trash (Sicherheitsempfehlung)