---
name: thomas-tasks-drei-recherchen
description: Drei Thomas-Recherchen 11.09. ABGESCHLOSSEN — Loki Voice: Gratis-Stack
  LocalVoiceService ist DOWNGRADE (keine Tools/Prüfkopf/Wake-Word, Paritäts-Plan steht),
  Codex→Windows = Login + Config kopieren (Pfade anpassen), Magicline-Open-API via Sport
  Alliance Developer Portal
metadata:
  node_type: memory
  type: project
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

Am 11.09.2026 gestellt und am selben Tag ABGESCHLOSSEN (2 SSD-Explore-Scans + Web-Recherche, Magicline-Grep abgebrochen aber via Web beantwortet). Ergebnisse:

1. **Loki Voice Kosten:** Thomas' Voice-Stack hängt an Google Gemini Live (Vertex, Projekt `gen-lang-client-0534030583`) — Kosten = kontinuierliches Audio-Streaming. **Gratis-Stack existiert bereits** in `LokiVoiceApp/Sources/LocalVoiceService.swift`: Apple Speech (STT, on-device) + AVSpeechSynthesizer (TTS) + OpenAI-kompatibler LLM-Endpoint (Default Z.AI glm-4.5-air, OpenRouter-Free möglich). Nicht eingeschaltet, nur Mode wählen. Zusatz: faster-whisper-Worker vorhanden (`loki_whisper_worker.py`), Ollama+LM Studio installiert aber nicht angebunden; offener Task „whisper.cpp installieren" im LOKI-Board. Kostenhebel: Push-to-talk statt Always-on (~-90 %).
2. **Codex→Windows:** `~/.codex/` hat KEINEN OpenAI-Login (kein auth.json, keine Sessions) — Login lief über OmniRoute-Gateway (localhost:20128, Key in `.zshrc:179`). Transfer: config.toml + AGENTS.md + skills/ direkt kopieren; auf Windows `npm i -g @openai/codex` → `codex login` (auth.json entsteht lokal, nie kopieren); OMNIROUTE_API_KEY via `setx`; Gateway-Autostart via Task Scheduler statt LaunchAgent; `/Users/…`→`C:\Users\…`, `python3`→`python`. Thomas' Projekt `geotracer-portable-v1` = portables Node-Projekt → ZIP reicht. "George" bei Thomas = Agent-Workspace-Name (`/Users/thomasschellenbacher/george/…`), Codex-Nutzung via ChatGPT-Account-Login.
3. **Magicline-API:** Offizielle Open API der Sport Alliance — Doku: developer.sportalliance.com/apis/magicline/openapi/general-information + magicline.com/de/partner (Postman + Test-Magicline). Auth: Studio-Inhaber beantragt Integration → API-Key per E-Mail, Header `x-api-key`, Base-URL `https://<tenant>.open-api.magicline.com/v1`; Webhooks separater Key. Endpunkte: GET /v1/customers, Memberships/Verträge; No-Code-Shortcut: Make.com-Connector für Magicline existiert.

**Offen (Kanban):** Loki-Voice-Paritäts-Tickets 1–4 (auf GO); Thomas-Anleitung als DOCX/PDF; Windows-Transfer-Paket; Magicline-Studio-Key beantragen (Studio-Inhaber-Aktion).

**How to apply:** Bei Wiederaufnahme Ergebnisse nutzen, nicht neu recherchieren. Verwandt: [[web-research-team-skill]], [[loki-project-map]], [[feedback-doc-design-matters]] (Anleitung mit Design bauen).
