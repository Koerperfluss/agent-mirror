---
app: zcode
quelle: "saschalagler/cli/memories/projects/thomas---chips-judicario-7b0276307052409f/memory/loki-os-system-setup-2026-10-26.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: loki-os-system-setup-2026-10-26
description: System-Setup-Stand 26.10.2026 — BrowserOS-Provider
  (ClinePass=Default läuft, OpenRouter-Key 401 tot, Ollama ok, Gemini blockiert
  auf Login), Master-Doku ~/LOKI_OS_SETUP.md, Judicario-Plugin Quelle im
  Workspace
metadata:
  node_type: memory
  type: project
  originSessionId: session_a9d83d5f6d436ee601e9cc6431e574fc
---

System-Setup-Stand per 26.10.2026 (vollständige Doku: `/Users/saschalagler/LOKI_OS_SETUP.md` — IMMER zuerst dort nachsehen).

**BrowserOS-LLM-Provider (Settings chrome://browseros/settings):**
- **ClinePass (OpenAI Compatible) = DEFAULT** — `cline-pass/glm-5.3-flash` @ api.cline.bot, live getestet. Falle: BrowserOS-"Test connection" scheitert (kein streaming) — echter Chat funktioniert trotzdem ([[chipsi-judicario-stand-2026-09-22]]).
- OpenRouter `openrouter/auto`: **Key tot (401 User not found)** — Provider nicht als Default wählen, bis Sascha neuen Key von openrouter.ai/keys liefert.
- Ollama localhost:11434 läuft (nur qwen3.5:9b). OmniRoute :20128 braucht Key (401).
- Gemini blockiert: aistudio API-Key-Seite verlangt Google-Login im BrowserOS-Fenster; Google AI Pro-Abo ≠ API-Key.

**Judicario-Plugin:** Quelle `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/plugins/judicario/` (Skill + 3 Agenten legal-scout/analyst/reviewer + Client), Marketplace-Ordner = dessen `plugins/`-Parent. Client-Live-Test grün (MRG §30, Exit 0). Installation in ZCode-UI ausstehend. Alter Connector `legal_research` ist tot — Client nutzt `<module>_search`.

**Browser-Regel:** Automatisierung immer über BrowserOS (User-Anweisung, nicht Chrome-devtools-Instanz — dort kein Google-Login). Tabs können crashen → reload reicht.

**Why:**避免 wiederholte Fehldiagnose „keiner funktioniert" — Ursache war der tote OpenRouter-Key, nicht die Konfiguration.
**How to apply:** Bei LLM-Problemen zuerst curl-Direktest der Provider, dann Browser-UI. Default= ClinePass nutzen.
