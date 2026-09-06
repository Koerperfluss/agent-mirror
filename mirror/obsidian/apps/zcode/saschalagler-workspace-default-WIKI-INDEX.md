---
app: zcode
quelle: "saschalagler/workspace/default/WIKI-INDEX.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

# WIKI-INDEX — Aktuelle Projekte (Stand 2026-09-06)

| Projekt | Wiki | Kanonischer Pfad | Stack-Kern | Zustand |
|---|---|---|---|---|
| **Atlas Cali Coach** | `~/cali-coach-atlas-final/WIKI.md` | `~/cali-coach-atlas-final` | React 19/Vite + Swift-iOS | aktiv, main @ 5e61e86, ⚠️ Zwillings-Root |
| **Legal Ops Advisor** (Thomas/Judicario) | `~/LegalOpsAdvisor_Sacha_Mac/WIKI.md` | `~/LegalOpsAdvisor_Sacha_Mac` + MCP in `~/loki-ki/services` | Python RAG + 9-Personas-MCP | läuft (4× MCP ⚠️, 🔴 Keys im Klartext) |
| **LOKI Voice** | `~/loki-ki/loki-voice/WIKI.md` | `~/loki-ki/loki-voice` (Python) + Judicario-Sacha-Mac/LokiVoiceApp (Swift) | google-genai + Swift | Dienste laufen (launchd) |
| **Körperfluss 3D** | `…/FIRMEN PROJEKTE/Koerperfluss-3D-Upgrade/WIKI.md` | `~/Desktop/Coworkspace_Ich/FIRMEN PROJEKTE/Koerperfluss-3D-Upgrade` | React+Three.js+Firebase | main @ f720160, 🔴 keine Tests |
| LOKI Agent OS | (README vorhanden) | `~/agent-os/` | Bash/Claude/Gemini headless | aktiv — `~/agent-os/loki "Ziel"` |
| FörderOps | (kein Wiki — Tool) | `~/.agents/tools/foerderops_web.py` | Python Web-UI | **läuft NICHT** (Port 8765 tot) — Start: `python3 ~/.agents/tools/foerderops_web.py` |

## Querschnitt-Befunde
1. 🔴 **API-Keys im Klartext**: loki-ki/services-MCP-Server (Legal-Ops + Voice) — Env nachziehen
2. **Doppel-Strukturen**: Atlas (2 identische Git-Roots), Legal-Ops (Archiv-Kopie) — immer nur kanonischen Pfad bearbeiten
3. **Test-Lücken**: Körperfluss (gar keine), Atlas (minimal), Legal-Ops (Tests vorhanden)
4. ZCode-Wiki-Feature: Modell-Leiche `builtin:zai-start-plan` → im Wiki-Dialog Modell neu wählen (heißt jetzt `zai-coding-plan`), dann „Generate"
