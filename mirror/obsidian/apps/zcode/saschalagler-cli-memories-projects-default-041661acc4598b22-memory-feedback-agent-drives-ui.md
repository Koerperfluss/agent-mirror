---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-agent-drives-ui.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: feedback-agent-drives-ui
description: Sascha erwartet dass Agenten GUIs/Oberflächen SELBST steuern und
  Dinge selbst anlegen — nicht den Nutzer klicken lassen (2× wütend eingefordert
  06.09.)
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

Sascha (06.09.2026, 2× explizit wütend): „du sollst den agent ODER die agenten je nachdem was gebraucht wird ANLEGEN eigenständig" und „bitte steuere die oberfläche wie auch immer nutze das programm … stelle ein du trottel es ist geöffnet".

**Why:** Er will den Agenten als eigenständigen Operator — sobald ich ihn etwas per UI klicken lasse („deine 1 Aktion: Create klicken"), gilt das als Arbeitsverweigerung. Seine App-Welt: AutoClaw, ZCode, Cline Code, Claude — „das soll in allen so sein".

**How to apply:** Wenn eine Aktion nur per GUI geht: macOS Accessibility nutzen und sie selbst ausführen. Bewährtes Rezept (live bewiesen an AutoClaw-Create-Dialog): Fenster-Bounds via System Events holen → App frontmost setzen (`set frontmost of process … to true`, sonst landen Klicks im falschen Fenster!) → `click at {x,y}` (Element-Log im Ergebnis bestätigt das Ziel) → für Textfeld-Eingabe keystroke NICHT vertrauen (Fokus geht verloren), sondern rekursiv AX-Element suchen (UI-elements-Walk) + `set value of <textfield>` → Buttons per Rekursion finden und `click`. Verifikation per Screenshot (`screencapture -l <windowID>`, Window-ID via Quartz CGWindowList) und/oder Config/Runtime-Datei-Check. Elektro­nen-Apps (Electron) exponieren fast keine nativen AX-Elemente — Koordinaten aus Vision/Prozentangaben + Bestätigungs-Log sind der Weg. Verwandt: [[autoclaw-full-stack-builder]] [[feedback-one-action-not-tables]] [[feedback-gui-not-cli]]
