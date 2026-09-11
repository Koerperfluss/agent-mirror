---
name: thomas-tasks-drei-recherchen
description: Drei Thomas-Recherchen 11.09. ABGESCHLOSSEN + Anleitung-PDF GELIEFERT
  (Desktop/THOMAS_ANLEITUNG/) — Saschas LokiVoiceApp = Gemini Live/Vertex, THOMAS =
  ChatGPT/OpenAI; Gratis-Stack LocalVoiceService ist DOWNGRADE (Paritäts-Build auf GO
  wartend), Codex→Windows = Login + Config kopieren, Magicline-Open-API via Sport Alliance
metadata:
  node_type: memory
  type: project
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

Am 11.09.2026 gestellt und am selben Tag ABGESCHLOSSEN (2 SSD-Explore-Scans + Web-Recherche, Magicline-Grep abgebrochen aber via Web beantwortet). Ergebnisse:

1. **Loki Voice Kosten (KORRIGIERT durch Sascha 11.09.: „der aktuelle Loki Voice läuft über Gemini … und Thomas über ChatGPT"):** Saschas LokiVoiceApp hängt an Google Gemini Live (Vertex, Projekt `gen-lang-client-0534030583`); **Thomas' Voice-Stack läuft über ChatGPT/OpenAI (Realtime Voice)** — dort die „unmengen"-Kosten (~$0,06/min in + ~$0,24/min out, Dauerbetrieb = hunderte €/Monat). Gratis-Stack für beide: `LokiVoiceApp/Sources/LocalVoiceService.swift` (Apple Speech STT + AVSpeech TTS + OpenAI-kompatibler LLM-Endpoint, Default Z.AI glm-4.5-air, OpenRouter-Free möglich) — im Thomas-Paket nicht aktiviert. Zusatz: faster-whisper-Worker vorhanden (`loki_whisper_worker.py`), Ollama+LM Studio installiert aber nicht angebunden; offener Task „whisper.cpp installieren" im LOKI-Board. Kostenhebel: Push-to-talk statt Always-on (~-90 %).
2. **Codex→Windows:** `~/.codex/` hat KEINEN OpenAI-Login (kein auth.json, keine Sessions) — Login lief über OmniRoute-Gateway (localhost:20128, Key in `.zshrc:179`). Transfer: config.toml + AGENTS.md + skills/ direkt kopieren; auf Windows `npm i -g @openai/codex` → `codex login` (auth.json entsteht lokal, nie kopieren); OMNIROUTE_API_KEY via `setx`; Gateway-Autostart via Task Scheduler statt LaunchAgent; `/Users/…`→`C:\Users\…`, `python3`→`python`. Thomas' Projekt `geotracer-portable-v1` = portables Node-Projekt → ZIP reicht. "George" bei Thomas = Agent-Workspace-Name (`/Users/thomasschellenbacher/george/…`), Codex-Nutzung via ChatGPT-Account-Login.
3. **Magicline-API:** Offizielle Open API der Sport Alliance — Doku: developer.sportalliance.com/apis/magicline/openapi/general-information + magicline.com/de/partner (Postman + Test-Magicline). Auth: Studio-Inhaber beantragt Integration → API-Key per E-Mail, Header `x-api-key`, Base-URL `https://<tenant>.open-api.magicline.com/v1`; Webhooks separater Key. Endpunkte: GET /v1/customers, Memberships/Verträge; No-Code-Shortcut: Make.com-Connector für Magicline existiert.

**Paritäts-Inventar 11.09. (nach Saschas „kein Downgrade"-Einschub, per Code-Lese verifiziert):** Local-Mode ist real ein Downgrade (~10 % der Features). Cloud-`VoiceService.swift` hat: 7 Function-Calling-Tools (`create_task`, `list_tasks`, `complete_task`, `remember`, `recall`, `recall_transcript`, `melde_fehler`), Prüfkopf-Live-Feed (`pruefenLiveStreamChunk` → Judicario-OpenLaw via JSON-RPC/SSE + SafeBox), Wake-Word-Gate („Loki"/„Chipsi"), Echo-Schutz/Barge-in (Z.817), 15-Min-Rotation. `LocalVoiceService.swift` fehlt: ALLE Tool-Calls (0 Treffer), Prüfkopf-Live, Wake-Word, Echo-Schutz, Audio-Befehle („Ton an/aus", „BLUF"). Schlüssel: `AssistantTools.swift` ist bereits modell-unabhängig (Dispatch-Table mit 7 Cases existiert) — Parität = OpenAI-kompatibles Function Calling an den bestehenden Executor anbinden. STT bleibt **Apple Speech, NICHT Whisper** (Sascha-Regel: keine minderwertige Whisper). Paritäts-Tickets: (1) Function Calling in LocalVoiceService, (2) Prüfkopf-Live-Feed verdrahten, (3) Wake-Word+Echo+Audio-Befehle portieren, (4) Paritäts-Test via `RunAllTests.swift`+`e2e.sh`+Reviewer. Skills: ios-swift-development, karpathy-guidelines, ui-ux-tester, Frame loki-dev BUILD. **GO von Sascha noch offen** (Stand 11.09.).

**Offen (Kanban):** Loki-Voice-Paritäts-Tickets 1–4 (auf GO); Thomas-Anleitung als DOCX/PDF; Windows-Transfer-Paket; Magicline-Studio-Key beantragen (Studio-Inhaber-Aktion).

**How to apply:** Bei Wiederaufnahme Ergebnisse nutzen, nicht neu recherchieren. Verwandt: [[web-research-team-skill]], [[loki-project-map]], [[feedback-doc-design-matters]] (Anleitung mit Design bauen).
