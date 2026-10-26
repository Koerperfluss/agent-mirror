---
name: local-browser-testing-gotchas
description: Lokale HTML im Playwright-MCP testen — file:// blockiert,
  http.server starten, Cache-Buster gegen Alt-Versionen
metadata:
  node_type: memory
  type: project
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Beim Browser-Test lokaler Dateien (26.10., hub-glass.html):

1. **Playwright-MCP blockiert `file://`** → stattdessen `python3 -m http.server <Port> --bind 127.0.0.1` im Projektordner (Bash mit run_in_background) starten, dann `http://127.0.0.1:<Port>/<datei>` testen; Server danach per TaskStop beenden.
2. **Browser-Cache-Falle:** Nach Datei-Edits liefert `page.goto` ohne Weiteres die ALTE Seite aus dem Cache → Messungen an der Altversion (passierte 26.10.: Drossel schien „kaputt", 23 statt 4 Fehler). Immer mit Cache-Buster neu laden (`…html?v=neu1`) oder Server-Auslieferung per curl gegengeprüfen.
3. Messreihen über Zeit (Konsolen-Fehler-Zählung) erst nach Cache-Buster als beweiskräftig werten; Zähler-Stände zwischen eigenen Tool-Calls können Minuten umfassen (Seite lebt weiter).

**Why:** Diese Fallen kosten sonst Fehldiagnosen an Saschas Live-Apps. **How to apply:** Bei jedem lokalen UI-Test: Server → Cache-Buster-URL → Delta-Messung. Siehe [[uiux-skills-repair-2026-10-26]].
