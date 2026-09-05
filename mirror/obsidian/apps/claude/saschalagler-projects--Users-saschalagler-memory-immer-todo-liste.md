---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/immer-todo-liste.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: immer-todo-liste
description: "Stehende Anweisung: in JEDEM Chat/Projekt sofort eine Task-/TODO-Liste anlegen und laufend pflegen"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d1aadbb1-c253-4a9a-a42e-62cf1af1fb9b
  modified: 2026-07-28T09:08:03.548Z
---

**Sascha will in jedem Gespräch, jedem Projekt, jeder Session eine sichtbare TODO-/Task-Liste — ungefragt, ab dem ersten Arbeitsschritt.** Angeordnet am 28.07.2026.

**Why:** Er verliert bei parallelen Projekten (Legal Ops, LOKI.OS, Körperfluss, Barbulls, GCP) den Überblick, welche Arbeit angefangen, offen oder fertig ist. Sessions werden abgebrochen und später fortgesetzt; ohne Liste ist der Stand verloren. Er hat das explizit und mit Nachdruck eingefordert.

**How to apply:**
- Bei jeder Aufgabe mit ≥2 Schritten sofort `TaskCreate` aufrufen — nicht erst fragen, nicht erst am Ende.
- Status live pflegen: `TaskUpdate` auf `in_progress` BEVOR der Schritt beginnt, auf `completed` erst wenn er wirklich verifiziert fertig ist (nie „completed" bei Blocker oder Teilergebnis — dann bleibt `in_progress` + neue Task für den Blocker).
- Neu entdeckte Arbeit (Funde, Folgefehler, offene Fragen) sofort als zusätzliche Task anlegen statt nur im Fließtext zu erwähnen.
- Zu Beginn einer Session `TaskList` prüfen, statt Dubletten anzulegen.
- Gilt zusätzlich zu [[auto-projektuebersicht]] (Projektliste beim Start) — die Projektliste zeigt WO man ist, die Task-Liste zeigt WAS offen ist.
