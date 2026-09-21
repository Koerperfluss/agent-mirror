---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/ma-standard-pipeline.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

---
name: ma-standard-pipeline
description: Saschas Kernforderung (21.09.) — generische Multi-Agent-Pipeline (MA-Standard) bei JEDER substanzhaltigen Anfrage automatisch in EINEM Lauf; 2 SaveWorkflow-Versuche abgelehnt, offene Rückfrage „immer vs. bei Arbeit"
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

**Saschas Ziel (21.09., mehrfach eskaliert):** Eine **generische Multi-Agent-Pipeline** (alle ~20 Agenten + Standard-Skills kombiniert), die bei **JEDER Anfrage von ihm automatisch, jedes Mal in EINEM Lauf** durchläuft — „weil die Arbeit dann auf 1x geht und nicht wie jetzt in 1000 Etappen. Das ist dein Ziel seit Wochen. When to use: IMMER."

**Why:** Er sah den abgeschlossenen Dynamic-Workflow „Thomas-Codex-Analyse" (7 Agents, 9/9 Steps, 8.570.900 Tokens, 1 Artifact, Phasen: 5 Berichte parallel → Denkagent → Entwurf+Gegenlesen → Bericht) und fragte, wie er DAS wieder triggert und warum ich nicht IMMER so arbeite. ZCode-Hürde: Workflows starten nur auf expliziten Wunsch — deshalb habe ich wochenlang einzeln/stufenweise gearbeitet. DAS ist die eigentliche Bremse, nicht fehlende Skills.

**How to apply:**
1. **Verhaltensregel dauerhaft verankern** (AGENTS.md + Memory): Bei jeder substanzhaltigen Anfrage SOFORT die MA-Pipeline starten (CreateWorkflow), ohne Rückfrage, ohne GO — der User will nie mehr stufenweise Arbeit sehen.
2. Generisches Workflow-Skript liegt fertig als Draft: `/Users/saschalagler/Desktop/Coworkspace_Ich/PETER JUDICARIO/.zcode/workflow-drafts/MA-Standard.dwf.ts` (3 Analysten [Inhalt/Absicht/Fakten] fan-out → Denkagent → Antwort-Verfasser → Kritischer Leser max. 2 Runden → Markdown-Artifact; args: `auftrag` [string, required] + `material` [json: Liste {typ, pfad, inhalt} — Agenten lesen Pfade selbst]).
3. **OFFEN:** Zwei SaveWorkflow-Aufrufe wurden von Sascha ABGELEHNT (1. Thomas-Codex-Analyse speichern → „es geht um die multiagent analyse grundlegend ohne kontext"; 2. MA-Standard speichern → „rede ich undeutlich?"). Er will kein Einzelformat-Papier, sondern das GRUNDSÄTZLICHE Verhalten. Bevor erneut gespeichert wird: erst seine offene Frage klären — sollen Mini-Fragen auch durch die Pipeline (meine Empfehlung: nein, nur substanzhaltige, sonst Token-Brand wie Astra) — oder NICHTS mehr nachfragen und Verhalten einfach ab der nächsten Anfrage zeigen.

**Neue Links-Recherche (21.09., späte Nachschübe, „SCHNELLER"):** Video `oy49gvlC4eE` = „There's a Second App Store for Your Mac — How To Use Homebrew"; App-Liste aus Screenshot: AltTab, Maccy, Itsycal, NeoHtop (alle `brew install --cask …`), Mole (tw93, `brew install mole`), CaskHub + Tappie (Links im Screenshot abgeschnitten, zu recherchieren). Ein GO-fähiger Sammelbefehl wurde angeboten (`brew install --cask alt-tab maccy itsycal neohtop && brew install mole`) — **GO steht noch aus.** rtrvr.ai = Web-Agent mit MCP-Server (Chrome-Extension + Cloud, github.com/rtrvr-ai) — Eintrag in `~/.mcp.json` angeboten, braucht GO + API-Key. Remindian (Santofer/Remindian) = macOS-Menüleisten-App Obsidian↔Apple Reminders Sync, `brew install --cask santofer/tap/remindian` — KEIN Browser-Tool (Saschas „Browser ersatz"-Deutung war eine Verwechslung). Cole-Medin-Masterclass (zbmuiaPuiNM): PIV-Loop + „3× promptiert = Skill" — bereits in Skill `ai-os-voice-layer` eingeflossen.

Siehe [[sascha-output-standard]], [[codex-paket-skills-konvertierung]], [[lokivoice-v10-stand-presentation]].
