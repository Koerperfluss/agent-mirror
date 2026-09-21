---
name: ma-standard-pipeline
description: MA-Standard-Workflow GLOBAL GESPEICHERT (21.09.) — schlanke Multi-Agent-Pipeline mit 3 Agenten (Analyst → Denker-Verfasser → Kritischer Leser), Trigger „MA: <Aufgabe>"; Sascha wollte zuerst IMMER/automatisch, hat sich auf 3 Agenten geeinigt
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

**Saschas Ziel (21.09., mehrfach eskaliert):** Eine **generische Multi-Agent-Pipeline** (alle ~20 Agenten + Standard-Skills kombiniert), die bei **JEDER Anfrage von ihm automatisch, jedes Mal in EINEM Lauf** durchläuft — „weil die Arbeit dann auf 1x geht und nicht wie jetzt in 1000 Etappen. Das ist dein Ziel seit Wochen. When to use: IMMER."

**Why:** Er sah den abgeschlossenen Dynamic-Workflow „Thomas-Codex-Analyse" (7 Agents, 9/9 Steps, 8.570.900 Tokens, 1 Artifact, Phasen: 5 Berichte parallel → Denkagent → Entwurf+Gegenlesen → Bericht) und fragte, wie er DAS wieder triggert und warum ich nicht IMMER so arbeite. ZCode-Hürde: Workflows starten nur auf expliziten Wunsch — deshalb habe ich wochenlang einzeln/stufenweise gearbeitet. DAS ist die eigentliche Bremse, nicht fehlende Skills.

**Stand 21.09. (ERLEDIGT):** **MA-Standard ist global gespeichert** unter `~/.zcode/workflows/MA-Standard.dwf.ts` — SCHLANKE Version mit **3 Agenten** (Analyst → Denker-Verfasser → Kritischer Leser, 1 Fix-Runde; Sascha: „SO VIEL DU BRAUCHST NICHT 2 oder 3" = 7er-Version abgelehnt). Args: `auftrag` (string, required) + `material` (json-Liste {typ, pfad} — Agenten lesen Pfade selbst). **Trigger:** Sascha sagt „MA: <Aufgabe>" → CreateWorkflow `saved: { name: "MA-Standard", args: { auftrag, material } }`. Zwei Compile-Fixes beim Speichern: deutsche Anführungszeichen „…" innerhalb von Persona-Strings zerbrechen den TS-String (nur gerade " escapen/vermeiden) + Agentennamen müssen im Run eindeutig sein (2. Verfasser = „Ueberarbeiter").

**How to apply:** Bei „MA: …" oder wenn Sascha eine Multi-Agent-Tiefenanalyse will → CreateWorkflow saved MA-Standard. Mini-Fragen („was ist X") NICHT durch die Pipeline (Token-Brand-Risiko wie Astra) — offene Frage „immer vs. bei Arbeit" hat er nie beantwortet; der gespeicherte whenToUse sagt „substanzhaltige Anfragen". Ob er die Auto-IMMER-Verhaltensregel in AGENTS.md haben will, ist weiterhin offen — NICHT unaufgefordert nochmal anfassen (Eskalations-Regel: [[sascha-output-standard]]).

**Links-Recherche (21.09., „SCHNELLER"):** Video `oy49gvlC4eE` = „There's a Second App Store for Your Mac — How To Use Homebrew"; App-Liste: AltTab, Maccy, Itsycal, NeoHtop (`brew install --cask …`), Mole (`brew install mole`), CaskHub + Tappie (Links abgeschnitten, unklar). Sammelbefehl angeboten — **GO steht aus.** rtrvr.ai = Web-Agent mit MCP-Server (github.com/rtrvr-ai) — Eintrag in `~/.mcp.json` angeboten, braucht GO + API-Key. Remindian = macOS-Menüleisten-App Obsidian↔Reminders, `brew install --cask santofer/tap/remindian` — KEIN Browser-Tool. Cole-Medin-Masterclass (zbmuiaPuiNM): PIV-Loop + „3× promptiert = Skill" — in Skill `ai-os-voice-layer` eingeflossen.

Siehe [[sascha-output-standard]], [[codex-paket-skills-konvertierung]], [[lokivoice-v10-stand-presentation]].
