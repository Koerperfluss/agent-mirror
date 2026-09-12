---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/thomas-tasks-drei-recherchen.md"
stand: 2026-09-12
tags: [spiegel, zcode]
---

---
name: thomas-tasks-drei-recherchen
description: Drei Thomas-Recherchen 11.09. FERTIG + Paritäts-Build AUSGEFÜHRT
  (9/9 Tests grün, Reviewer PASS, Commit 974e2ce) + Anleitung-PDF + Windows-Paket
  GELIEFERT (Desktop/THOMAS_ANLEITUNG/); offen nur: Mikro-e2e, /Applications-Deploy,
  Magicline-Studio-Key
metadata:
  node_type: memory
  type: project
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

Am 11.09.2026 gestellt und am selben Tag ABGESCHLOSSEN inkl. Paritäts-Build (2 SSD-Explore-Scans + Web-Recherche + Build + Reviewer-Loop). Ergebnisse:

1. **Loki Voice Kosten (KORRIGIERT durch Sascha 11.09.: „der aktuelle Loki Voice läuft über Gemini … und Thomas über ChatGPT"):** Saschas LokiVoiceApp hängt an Google Gemini Live (Vertex, Projekt `gen-lang-client-0534030583`); **Thomas' Voice-Stack läuft über ChatGPT/OpenAI (Realtime Voice)** — dort die „unmengen"-Kosten (~$0,06/min in + ~$0,24/min out). Gratis-Stack: `LocalVoiceService.swift` (Apple Speech STT + AVSpeech TTS + OpenAI-kompatibler LLM, Default Z.AI glm-4.5-air, Key `LOKI_LLM_API_KEY` via Env/Keychain). STT bleibt **Apple Speech, NICHT Whisper** (Sascha-Regel).
   **GEORGE-KLARSTELLUNG (12.09., Sascha wütend — „du hörst mir nicht zu"):** „George" = **Thomas' Assistent, der CODEX ALS UMGEBUNG nutzt** (Workspace `~/george/…`), Voice über ChatGPT — **die Kosten sind TOKEN-basiert**, nicht Audio-Minuten-Marke. Recherche- Facts (Quellen in `Desktop/THOMAS_ANLEITUNG/RECHERCHE_GEORGE_KOSTEN.md`): (a) **Codex billt still `OPENAI_API_KEY` (API-Token, kein Deckel), obwohl mit ChatGPT eingeloggt** — klassische Ursache „unerwartete API-Kosten"; Sofort-Check für Thomas: Env-Key löschen + Abrechnungsquelle auf platform.openai.com prüfen. (b) Codex-API ~$1,25–5/1M in, $10–30/1M out; **ChatGPT-Login = Abo inklusive** (Plus $20/Pro $100–200, 5h-/Wochen-Limits) statt Cash. (c) **Gratis-Weg bei vollen Fähigkeiten:** Codex CLI ist modell-agnostisch (`config.toml → model_provider`) — Saschas eigener Codex läuft genau so gegen OmniRoute localhost:20128 ohne ChatGPT-Token-Billing (lebender Beweis); Voice = die frisch gebaute Split-Pipeline (Apple Speech + Text-LLM + AVSpeech). **Offen: PDF-Kapitel 1+2 auf die George-Fakten aktualisieren?** (Sascha unentschieden.)
2. **Codex→Windows:** Login neu (`npm i -g @openai/codex` → `codex login`, auth.json nie kopieren), config.toml/AGENTS.md kopieren, Pfade/setx/Task-Scheduler anpassen, `geotracer-portable-v1` = portable Node-App → ZIP. ⚠️ **Saschas `~/.codex/config.toml` enthält einen echten Obsidian-MCP-Bearer-Token — nie ungefiltert weitergeben** (Paket nutzt bereinigte Config mit Platzhaltern). `~/.codex/skills` = 119 Symlinks (8 KB) → nicht paketieren.
3. **Magicline-API:** Open API der Sport Alliance — developer.sportalliance.com/apis/magicline/openapi/general-information; Studio-Inhaber beantragt Key (`x-api-key`), Make.com-Connector als No-Code-Weg. **Offen: Studio-Key beantragen.**

**PARITÄTS-BUILD 11.09. NACHMITTAGS AUSGEFÜHRT (GO war per „bitte" erteilt):** `LocalVoiceService.swift` = jetzt Cloud-paritätisch: (a) Function-Calling-Loop im OpenAI-Protokoll (tools + tool_choice auto, tool_calls → `role:"tool"` + tool_call_id, max. 4 Runden, Rundenlimit → „Erledigt."), Dispatch auf bestehenden `AssistantTools.shared.execute`; (b) Prüfkopf-Live-Feed `pruefenLiveStreamChunk` aus jedem finalen Transkript (vor dem Gate); (c) STRENGES Wake-Word-Gate als testbarer Baustein `LocalVoiceService.sprichtMitAgent()` (Wortgrenzen-Regex `\b(loki|chipsi)\b` — „Chips übers Internet"/„Lokus" triggern NICHT); (d) komplette Cloud-Audio-Keyword-Liste (ton an/aus, stumm, stopp, halt, lauter, stimme an, ghetto an); (e) Transkript-Buch `fullTranscript` mit `Du:`/`Loki:`-Zeilen + 120k/90k-Cap; (f) `recall_transcript`-Quelle = aktive Session (`isSessionActive`/`isConnected`, keine Heuristik); (g) Keychain-Key gecacht, Tool-Datei-IO auf userInitiated-Queue. **QA:** `swift build -c release` grün; Testsuite **9/9 grün** — `swift test` bricht an codesign-detritus (xattr hilft nicht zuverlässig), Standalone-Runner nutzen: `swiftc -o /tmp/run_all_tests Tests/RunAllTests.swift $(ls Sources/*.swift | grep -v LokiVoiceApp.swift)`; Reviewer-Prüfinstanz **PASS** (2 Major + 4 Minor, alle gefixt). Bekannter Trade-off: halb-duplex — während LLM/TTS wird nicht mittranskribiert (Doku in STATUS). Bearbeitete Kopie = `Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/Judicario_Sacha_Mac/LokiVoiceApp` (git-Repo auf Judicario_Sacha_Mac-Ebene, Commit **974e2ce**, .gitignore für .build/LokiVoice.app; die PETER-JUDICARIO-Kopie blieb unberührt). Doku: `LokiVoiceApp/STATUS_LOCAL_PARITAET.md`. App-Bundle neu gebaut (ad-hoc signiert) in LokiVoiceApp/LokiVoice.app.

**Übergabe (fertig):** `/Users/saschalagler/Desktop/THOMAS_ANLEITUNG/` — Thomas bekommt NUR `Anleitung_Thomas_LokiVoice_Codex_Magicline.pdf` + `Windows_Paket.zip` (296 KB: bereinigte config.toml, AGENTS.md, Setup-Windows.ps1, PDF); `bilder/`, `pages/`, `generate.js`, `Windows_Paket/` sind nur Quelle.

**Offen (Kanban):** (1) echter Mikro-e2e des Lokal-Modus mit gesetztem `LOKI_LLM_API_KEY` + `e2e.sh`; (2) neue LokiVoice.app nach /Applications — NUR auf GO (überschreibt bestehende App); (3) Magicline-Studio-Key beantragen (Studio-Inhaber-Aktion, Thomas).

**How to apply:** Bei Wiederaufnahme Parität als erledigt behandeln (nicht neu planen); Build/Verify über den Standalone-Runner, nicht `swift test`. Verwandt: [[feedback-kein-downgrade-paritaet]], [[feedback-pruefinstanz-pflicht]], [[feedback-doc-design-matters]], [[loki-project-map]].
