---
name: loki-os-livestatus-2026-10-11
description: 11.10. Live-Status Deltas — Kernel 8010 TOT, Ollama NEUE lokale
  Modelle (qwen3.5:9b), Hammerspoon down, Hermes/Eigent/AutoClaw2-Versionen,
  paseo-PDF-Name
metadata:
  node_type: memory
  type: project
  originSessionId: sess_9bb02160-ce23-4582-a594-371c1f798aa5
---

11.10.2026 LIVE-GEPRÜFT (curl/pgrep/defaults, Beweise in LOKI-Universum-Visualisierung):

- **LOKI-Kernel :8010 TOT** (HTTP 000) — im Systemprotokoll 23.09. noch ✅. Watchdog `com.sascha.loki.kernel` hat nicht gehalten → Kernel-Neustart prüfen.
- **Ollama :11434 lebt mit NEUEN lokalen Modellen:** `qwen3.5:9b`, `qwen2.5-coder:7b`, `qwen2.5-coder:1.5b` + glm-5.3:cloud/flash:cloud. Memory vom 30.08. („kein echtes lokales Modell") ist ÜBERHOLT — Privacy-Modus (§12) jetzt real möglich.
- **OmniRoute :20128 TOT** (abgebaut auf Nutzer-Wunsch 20.09., korrekt so).
- **Hammerspoon läuft NICHT** (pgrep leer) → Doppel-Strg-Voice-Trigger tot; die 2 TCC-Klicks (Bedienungshilfen + Mikrofon) weiter offen.
- **Voice-Daemon :8078 lebt** (idle, glm-5.3-flash, Tools say/open_url/browser_read/run_command/brain_save…).
- **Apps:** Hermes.app = com.nousresearch.hermes v0.17.0 · Eigent.app = com.eigent.app v1.0.4 · AutoClaw2.app = com.zhipuai.autoclaw2 v2.0.1. LOKI Apps: LOKI OS v18, LOKI Brain, LokiVoice in /Applications.
- **Skills-Zahl live:** zcode 204 · agents 157 · claude 200 · autoclaw 121 (Total 682).
- paseo-PDF heißt exakt `getpaseopaseo Orchestrate multiple coding agents from desktop and mobile.pdf` (im Skill-Liste-Ordner).
- **Integration-Vorschlag:** AutoClaw2 = Produktivitäts-Connector (läuft schon via mcporter) · Hermes = Privacy-Worker mit Ollama-qwen3.5:9b (Pilot) · Eigent = visuelles Kontrollzimmer für Agenten-Schwärme (Test). ZCode bleibt Director, 2 GO-Gates.

Interaktive Karte: `~/.zcode/v2/visualizations/c99caef…/loki-os-universum.html` (Session-Visualisierungsordner). Verwandt: [[appagentteam-flutter-skill-live]] · [[loki-os-ecosystem-stand]]
