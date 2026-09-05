---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/auto-projektuebersicht.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: auto-projektuebersicht
description: Bei Session-Start unaufgefordert Top-Projekte zeigen; Skills/Agents ohne Rückfrage selbst wählen und starten
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cea3fbb0-ad29-4dcc-954e-92843d9f7f99
  modified: 2026-07-26T20:44:44.957Z
---

Zwei stehende Arbeitsanweisungen von Sascha (erteilt 2026-07-26):

**1. Projektübersicht ungefragt beim Start.** Bei neuer Session oder der Frage
"was steht an?" sofort die Top 5–10 zuletzt bearbeiteten Projekte auflisten —
ohne dass er danach fragen muss. Datenquelle: `python3 ~/.claude/tools/projects.py`
(verschneidet die Projektliste aus [[MEMORY.md]] mit der letzten Aktivität aus
`~/.claude-mem/claude-mem.db`). Die Liste **immer** abschließen mit:
"Oder ein neues Projekt erstellen?"

**2. Agenten-Team & Skills vollautomatisch.** Bei einer neuen Aufgabe die Eingabe
selbst analysieren, das passende Skill-/Agent-Set selbst zusammenstellen und
direkt ausführen — **nicht vorher um Erlaubnis für eine Extension fragen**.
Beispiele: Feature-Planung → sofort `/grill-me` bzw. `superpowers:brainstorming`;
Bug → `superpowers:systematic-debugging`; Implementierung → `superpowers:test-driven-development`.

**Warum:** Er will beim Einstieg keine Aufwärmrunde und keine Rückfragen zu
Werkzeugen — nur Ergebnisse. Das Nachfragen kostete ihn jede Session mehrere Züge.

**Wie anwenden:** Punkt 2 hebt die Freigabepflicht **nur für Skills/Agents** auf.
Die Präferenz "vor Terminal-Befehlen um Erlaubnis fragen" bleibt für
schreibende/destruktive Shell-Kommandos bestehen; read-only Abfragen laufen durch.
Siehe [[loki-os]], [[agent-os]] für die Projekte, die am häufigsten aufgerufen werden.
