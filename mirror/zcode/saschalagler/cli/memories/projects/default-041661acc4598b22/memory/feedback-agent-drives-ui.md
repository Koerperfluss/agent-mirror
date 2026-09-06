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

**How to apply:** Wenn eine Aktion nur per GUI geht: macOS Accessibility nutzen und sie selbst ausführen. Bewährtes Rezept (live bewiesen an AutoClaw-Create-Dialog): Fenster-Bounds via System Events holen → App frontmost setzen (`set frontmost of process … to true`, sonst landen Klicks im falschen Fenster!) → `click at {x,y}` (Element-Log im Ergebnis bestätigt das Ziel) → für Textfeld-Eingabe keystroke NICHT vertrauen (Fokus geht verloren), sondern rekursiv AX-Element suchen (UI-elements-Walk) + `set value of <textfield>` → Buttons per Rekursion finden und `click`. Verifikation per Screenshot (`screencapture -l <windowID>`, Window-ID via Quartz CGWindowList) und/oder Config/Runtime-Datei-Check. Elektro­nen-Apps (Electron) exponieren fast keine nativen AX-Elemente — Koordinaten aus Vision/Prozentangaben + Bestätigungs-Log sind der Weg.

**Ergänzt 06.09. spät (Chat-Anlegen + Klick-Fallen):** Saschas Erwartung geht weiter: auch **Unterhaltungen/Chats pro Projekt grafisch sortiert anlegen** („DU HAST NOCH IMMER NICHT DIE CHATS ANGELEGT GRAFISCH SORTIERT") — in AutoClaw je Projekt einen Chat im passenden Agenten, benannt/sortierbar. Klick-Fallen dabei live gelernt: (1) hängendes **screencaptureui-Overlay** (von Nutzer-Screenshots) frisst jeden Klick-Dispatch → `killall screencaptureui` zuerst prüfen; (2) Fenster-**Bounds ändern sich** zwischen Aktionen → immer frisch via Quartz holen; (3) beste Loop: Ziel-App frontmost → computer-use `screenshot` → `zoom` → `left_click` (receipt zeigt `resolved_app_ref`-Ziel = Kontrolle) → Text via osascript `keystroke` MIT ASCII (Umlaute vermeiden). Verwandt: [[autoclaw-full-stack-builder]] [[feedback-one-action-not-tables]] [[feedback-gui-not-cli]] [[loki-project-map]]
