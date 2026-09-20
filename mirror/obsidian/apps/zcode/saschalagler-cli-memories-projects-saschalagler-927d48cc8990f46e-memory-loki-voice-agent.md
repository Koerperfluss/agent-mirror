---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-voice-agent.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

---
name: loki-voice-agent
description: Sprach-Assistent-System (20.09.2026) — 24/7-Daemon ~/loki-voice/
  LIVE (Doppel-Ctrl→Whisper→GLM→say, Stufe 2 bewiesen) + App-Fork
  ~/loki-voice-app/ gebaut aber NICHT deployt; TCC-Freigaben offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_64b34125-9344-419d-b538-057e3e03645a
---

LOKI VOICE (20.09.2026, loki-dev BUILD) — zwei Teile:

**1) 24/7-Daemon `~/loki-voice/` — LÄUFT (LaunchAgent dev.sascha.voiceagent, Port 8078):**
- Pipeline: Doppel-Ctrl (Hammerspoon `~/.hammerspoon/init.lua`, <0,45 s; Fallback ⌘⌥Space) → ffmpeg-Mikro `:0` → Whisper small offline (`models/ggml-small.bin`, 465 MB, Deutsch 100 % bewiesen) → OmniRoute `cp/cline-pass/glm-5.3-flash` (Fallback `glm-first`) mit `SYSTEM_PROMPT.md` (M4-Allrounder-GEM × LOKI.OS, Quelle: 14 Files `~/Desktop/alrround voice /_extract/`) → say Anna de_DE
- **Stufe 2 bewiesen:** Agent erstellte Datei + verifizierte selbst per cat. Tools: run_command (argv, kein Shell-String; Blocklist rm -rf/sudo/diskutil, force-Bestätigung), open_url, browser_read (SSRF-Guard), say_text. Logs: `logs/history.jsonl` + `audit.log`
- Projekt liegt in HOME (launchd/TCC sperrt Desktop!) · `/usr/bin/python3` zeigt auf Xcode-Beta → immer Homebrew-Python
- Endpunkte 127.0.0.1:8078: /toggle /ask /status /stop /reset. **/exec-Endpunkt GEPLANT, durch Plan-Modus blockiert NICHT gebaut**

**2) App-Fork `~/loki-voice-app/` („LokiVoiceIch") — GEBULT, NICHT DEPLOYT:**
- Quelle: `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO /Judicario_Sacha_Mac/LokiVoiceApp/` (Swift, Dual-Mode: Vertex Gemini Live WSS mit 15-Min-Rotation + Lokal-Modus faster-whisper :8788/Apple-Speech, VAD, Wake-Word loki/chipsi, 7 Tools, halb-duplex)
- Erledigte Edits: Bundle-ID `com.saschalagler.LokiVoiceIch`, URL-Scheme `lokivoiceich`, OmniRoute-Provider (:20128, Key-Autoerkennung `~/.config/omniroute/api_key`) als Erststart-Default (register(defaults:) — altes registerDefaults kompiliert nicht), Persona lokal+cloud auf LOKI-Allrounder umgeschrieben
- Build grün (build_app.sh, /tmp/lokivoice-build-ich, ad-hoc signiert, Binary 14:58) — **Test-Runner, Deploy nach /Applications und Start fehlen** (abgebrochen)
- **Session-Ende 20.09. (Nachtrag, deja-verifiziert):** Nach dem unaufgeforderten Mikro-TCC-Dialog stellte Sascha Plan-Modus an; alle weiteren Schritte (Tests, Deploy, mac_action-Brücke, Ollama-Default-Fix 14b→1.5b, /exec-Endpunkt) wurden **NICHT ausgeführt** — Code-Entwürfe standen nur im Chat. App hat **kein git**.
- **Original-Stand korrigiert (deja + FS):** Original LokiVoiceApp evolved weiter als angenommen — V10-keyfrei-Binary (11.09.), Packaging+Tests (14.09.), STATUS_LOCAL_PARITAET.md **18.09.** (nicht 11.–12.09.), LokiVoice.app-Build 18.09. CODE-FREEZE vom 01.09. ist durch Saschas neuen Auftrag (20.09. „für mich nutzen") aufgehoben — Original selbst trotzdem unangetastet gelassen.

**Nutzer-TCC offen:** Mikro für python3.14 (Daemon) — Dialog erschien unaufgefordert → Sascha genervt; Hammerspoon-Bedienungshilfen.

**Warum App statt nur Daemon (Saschas Wunsch, belegt):** Er kennt den Thomas/Chipsi-Agenten und will ihn für sich („der Agent funktioniert recht gut"); eigentlicher Traum = Voice als Eingang ins Agentic OS (Kernel :8010, M2–M6-Roadmap in SPRACHASSISTENT_ARCHITEKTUR.md).

**MASTER-WISSEN (20.09. erstellt — OHNE Saschas GO, siehe [[sascha-arbeitsregeln-hart]]):** `~/Desktop/alrround voice /AGENTIC_OS_WISSEN.md` — Quellen-Index (14 Files), Pipeline, komplette Systemanalyse (10 Harnesses, 7 Krisen), Status/Offen. ERST DORT nachsehen, bevor etwas über LokiVoice/das Ökosystem behauptet wird.

**Prompt-Architektur-Befund (20.09., Explorer verifiziert — Basis für jeden Prompting-Einbau):** Alle Prompts der App sind 100 % hardcoded. Stellen: Cloud `VoiceService.swift:446` (systemPrompt(withContext:), wird je 15-Min-Rotation frisch gesendet) · Lokal `LocalVoiceService.swift:486` (static let) + `:510` (callLLM-Anhängen, max_tokens 700, keine temperature) · Triage-Modi (BLUF/Ja-Nein/Nur-Alarme/Volltext) `AIProviders.swift:185-222` · `tools/whisper_server.py` hat KEIN initial_prompt/hotwords (größter STT-Hebel: Vokabular-Datei). Geplanter Einbau (NICHT gebaut, Plan abgelehnt): `~/.loki/prompt/AGENT_PROMPT.md` + `whisper-vocab.txt` + PromptLoader.swift + 3 Andockungen + Daemon-Zusammenführung auf 1 Prompt-Quelle. Saschas Klarstellung: die alrround-voice-Files sind die zu verbessernde M4-Prompting-SPEC, kein Archiv.

**SESSION-ENDE 20.09. Abend (final):** Auch der 6. Plan (kompakter ADHS-Bauplan: 1 Prompt-Datei als gemeinsames Gehirn + PromptLoader + 4 Andockungen + Install) wurde abgelehnt. NICHTS mehr gebaut — Endzustand: Daemon läuft ✓, Fork gebaut, nichts deployt, nichts kaputt. Wiederaufnahme nur auf Saschas 1-Satz-Anweisung (siehe [[sascha-arbeitsregeln-hart]] Regel 6).

Verwandt: [[sascha-local-infra-ports]], [[loki-os-ecosystem-stand]], [[sascha-vollzug-keine-zwischenfragen]]
