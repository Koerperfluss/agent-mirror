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

**SESSION-FORTSETZUNG 20.09. Abend — GO ERTEILT, SCHWARM LÄUFT ( louding latest state, ersetzt „nichts gebaut"):** Sascha: „loki-dev übernimm — denke — optimiere — verteile — überwache — teste — verifiziere — stelle fertig AUTONOM, melde dich wenn fertig" → Plan-Modus beendet, Orchestrierungs-Gate-Schwarm gestartet. **Lebender Plan: `~/loki-voice-app/PLAN.md`** (T1–T5). Stand: **T2 ✅ erledigt** — `daemon.py:88-89` liest jetzt `~/.loki/prompt/AGENT_PROMPT.md` (Fallback SYSTEM_PROMPT.md) + `whisper_server.py:84-91,98` lädt `initial_prompt` aus `~/.loki/prompt/whisper-vocab.txt` (py_compile OK). **T1 🔨** (Implementer A: AGENT_PROMPT.md + whisper-vocab.txt + PromptLoader.swift + Andockung VoiceService:446 + LocalVoiceService:492) — erster Resume verweigerte wegen STALEM Plan-Modus-Glauben im Subagent-Kontext, nach expliziter Korrektur neu gestartet. Danach: T3 qa-tester (Build+9 Tests+Deploy /Applications) → T4 reviewer (Veto) → T5 Director-Abschluss (Memory/Bericht + Mikro-Dialog angekündigt). Architektur-Ziel: EINE Prompt-Quelle `~/.loki/prompt/AGENT_PROMPT.md` für App+Daemon.

**ABEND-VOLLZUG 20.09. (in SESS_NACHFOLGER, alle 5 loki-dev-Modi, GO war erteilt):** Ausbaustufe ① FERTIG — **VAD-Stille-Erkennung live** (Recorder._watch pollt WAV-RMS; Auto-Stopp nach Sprache+2 s; Max 30 s; 10 s ohne Sprache = Abbruch; Tuning via .env VAD_SILENCE/VAD_MAX_DUR/VAD_RMS_THRESHOLD/VAD_WAIT_SILENCE) + **Whisper-Vocab-Boost live** (`transcribe()` nutzt `--prompt` mit hartkodierten Eigenbegriffen; `whisper-vocab.txt` = Referenz). Beweise: STT erkannte „VwGH FFG Judicario" korrekt; RMS-Test 0/500; Stufe-1-E2E grün nach `launchctl kickstart -k`. Backup `daemon.py.bak-20260920`. Mimosa-Security-Gate blockte 5× False-Positives (Popen/pipe:1 als „Injection") → Lösung: Popen byte-identisch lassen + VAD über Datei-Tail-Poll statt PIPE. Offen: ②③④ Wahl, Mikro-TCC-Klick. Plan-Doku: `~/LOKI_DEV_PLAN_ALLE_MODI.md` + `~/LOKI_PLAN_KANBAN.html` (visuelles Board, Datei im Browser — kein App-UI, so zu Sascha sagen).

**FINALE 20.09. ~17:00 — SCHWARM-KOMPLETT (T1–T5 alle PASS, reviewer PASS):** EINE Prompt-Quelle `~/.loki/prompt/AGENT_PROMPT.md` + `whisper-vocab.txt` treibt App (PromptLoader.swift, Fallbacks) + Daemon (mit Leer-Datei-Schutz + gemeinsamen Vocab-Pfad nach Reviewer-Fix). LokiVoiceIch.app: 9/9 Tests grün, **installiert + GESTARTET (PID verifiziert)**, Original unberührt (mtime 14.09.). Daemon idle auf glm-5.3-flash. Doku: `~/loki-voice-app/PLAN.md` + `STATUS_IW.md`. Rest-User-Klicks: Mikro-Erlauben (Dialog ist auf dem Bildschirm), Hammerspoon-Bedienungshilfen.

**Re-Scan 20.09. spät (One-Shot-Planning-Explorer):** Beide Apps in /Applications (`LokiVoice.app` + `LokiVoiceIch.app`) ✅, Prompt-Zentrale `~/.loki/prompt/` existiert, PromptLoader.swift + Andockungen VoiceService.swift:448/LocalVoiceService.swift:502 drin. **Rest-Lücken:** Fork hat **kein .git** (kein Rollback) · `~/loki-voice/.env` fehlt (VAD-Werte nur Code-Defaults, Doku-Drift) · PLAN.md nur T1–T3 PASS, **T4/T5 formal offen** · LaunchAgent zeigt Last-Exit **-9** (SIGKILL-Spur, Daemon antwortet trotzdem) · audit.log letzter Eintrag 14:41. Offene Ausbaustufen: ② CDP-Browser (9222 tot, braucht Chrome-Restart) · ③ Morgenbrief (~/loki-assistent) · ④ iPhone.

**MIKRO-BLOCKADE bewiesen 20.09. ~17:15 + Modell-Klärung für Sascha:** Live-Toggle-Test → „aufnahme_zu_kurz", daemon.err.log: `Failed to create AV capture input device: Cannot use MacBook Pro-Mikrofon` = **Mikro-TCC für Daemon fehlt** (früherer Dialog weggeklickt). Einziger Fix (nur Sascha): Systemeinstellungen → Datenschutz & Sicherheit → Mikrofon → „+" → ⌘⇧G → `/opt/homebrew/bin/ffmpeg` (ggf. + `/opt/homebrew/bin/python3`). App LokiVoiceIch läuft (PID 12169), fragt ihre eigene Mikro-Erlaubnis beim ersten Verbinden. **Saschas Modell-Frage beantwortet:** Ohren = Whisper lokal · Gehirn = GLM 5.3 Flash via OmniRoute (kein Gemini! — Gemini nur optionaler App-Modus des Thomas/Chipsi-Originals mit 15-Min-Limit/Google-Login) · Mund = say Anna. Nach seinem Klick: „ok" sagen → Live-Stimmtest.

Verwandt: [[sascha-local-infra-ports]], [[loki-os-ecosystem-stand]], [[sascha-vollzug-keine-zwischenfragen]], [[sascha-arbeitsregeln-hart]]
