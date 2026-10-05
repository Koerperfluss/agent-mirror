---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/browseros-lokale-modelle-setup.md"
stand: 2026-10-05
tags: [spiegel, zcode]
---

---
name: browseros-lokale-modelle-setup
description: 05.10. Ollama/LM-Studio-Setup für BrowserOS + BrowserOS neo —
  Context 20000 in LaunchAgent gepatcht, GUI-Klicks in beiden Browsern offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_89b60861-cb00-4f8b-9681-cda41c4070c2
---

05.10.2026 — Sascha will **BrowserOS** und **BrowserOS neo** (beide in /Applications, separate Chromium-Profile) mit lokalen Modellen betreiben (Chat Mode; Doku: docs.browseros.com, Kritikpunkt = Context ≥ 15000–20000 nötig, sonst Agent-Loop).

**Server-Seite FERTIG (verifiziert):**
- Ollama 0.35.1 läuft als LaunchAgent `~/Library/LaunchAgents/com.sascha.ollama.plist` — **OLLAMA_CONTEXT_LENGTH=20000 eingetragen** (war Default 4096 = zu wenig), Backup: `~/sicherungen/ollama-20261005/`
- Modelle vorhanden: `qwen2.5-coder:7b` (4,7 GB, passt in 16 GB RAM, empfohlen als Model ID) + `qwen2.5-coder:1.5b`
- LM Studio-Server läuft zusätzlich auf `http://localhost:1234/v1/` mit `glm-4.6v-flash` + `gemma-4-12b-qat` (Alternativ-Weg via „OpenAI Compatible"-Karte, hält nur solange LM Studio offen ist)

**OFFEN (GUI-Klicks, kann ich nicht per CLI):** je Browser in `chrome://browseros/settings` → Ollama-Karte **USE** → Model ID `qwen2.5-coder:7b` → Context Window `20000` → Save. Gleiche Klicks in BrowserOS UND BrowserOS neo. Empfehlung war Ollama (Autostart-Dienst) statt LM Studio. Auf Wunsch per computer-use machbar. Siehe auch [[mac-setup-16gb-m4]], [[sigma-local-ai-stack]].

**05.10. Ergänzung (Sascha-Fragen zu CaskHub/Modell-Landschaft, erklärt):**
- **CaskHub „Adopt"** = manuell installierte Apps (LM Studio 0.4.25+1, Spotify, ZCode, Tailscale, Rectangle, VLC 3.0.23, Google Drive 130→132, Warp sogar 1 Version älter) in Homebrew-Verwaltung überführen → brew updated sie zentral. 21 Casks stehen zur Adoption. Empfohlen adopten: LM Studio (Spotify-ARM64-Debakel-Prävention), Spotify, ZCode, Tailscale, Rectangle, VLC, Vorssaint. Adopt ändert nur Verwaltung, nicht die App.
- **LM-Studio-Modelle (nutzbar, Port 1234):** `gemma-4-12b-qat` (6,66 GB GGUF, Vision+Tool-Calling) und `glm-4.6v-flash` (6,61 GB MLX, Vision, zai-org 9B). Auf 16 GB nie beide parallel laden. Alternative für Browser via „OpenAI Compatible"-Karte.
- **Ollama-Modelle:** `qwen2.5-coder:7b` (4,7 GB) = Hauptmodell für beide Browser; `qwen2.5-coder:1.5b` (1 GB) = Mini-Fallback; glm-5.3-flash:cloud = Cloud, kein Lokalbetrieb. `gpt-oss-20b` (12 GB) als besserer Chat möglich, aber auf dem fanless Air 16 GB nicht alltagstauglich. **Finale Empfehlung: beide Browser auf Ollama + qwen2.5-coder:7b, LM Studio nur zum Spielen/Vision.**
