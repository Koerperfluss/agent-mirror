---
app: zcode
quelle: "saschalagler/commands/kanban.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
description: Öffnet das Kanban-Board (Task-Management, Port 3484)
---

1. Prüfe ob der Kanban-Server läuft: `lsof -iTCP:3484 -sTCP:LISTEN`
2. Falls nicht: starte ihn detached: `cd ~ && nohup kanban --no-open --port 3484 >/tmp/kanban.log 2>&1 & disown`
3. Warte 2 s, öffne `http://localhost:3484` im Browser (`open http://localhost:3484`).
4. Zeige die aktuellen Tasks als Tabelle (Titel | Status | Agent).
