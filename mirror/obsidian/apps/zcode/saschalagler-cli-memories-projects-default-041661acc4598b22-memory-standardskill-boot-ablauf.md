---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/standardskill-boot-ablauf.md"
stand: 2026-09-11
tags: [spiegel, zcode]
---

---
name: standardskill-boot-ablauf
description: /standardskill Command-Protokoll (user/zcode) — lädt
  STANDARD-SKILLS.md + skill-routing.md und verlangt verbindliche
  Regel-Bestätigung als Tabelle
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

Der Custom-Command `/standardskill` (user/zcode) ist ein verbindlicher Boot-Ablauf: (1) `~/.agents/STANDARD-SKILLS.md` komplett lesen, (2) `~/.agents/skill-routing.md` lesen, (3) Bestätigung im Chat als Tabelle `| Regel | gilt ab jetzt |` (mind. BLUF Zeile 1, nummerierte Schritte, max 3 Parallel-Agents, PLAN vor Build, keine Rückfragen außer 4 Stopp-Regeln, Flash-first, sequentialthinking bei jeder Anfrage, kein Löschen/Deploy ohne GO), (4) jede Antwort folgt danach; Regelverstoß sofort selbst benennen + korrigieren ohne neue Nutzerfrage.

**Why:** Sascha will Regel-Compliance explizit bestätigt sehen, nicht stillschweigend angenommen.

**How to apply:** Bei `/standardskill` beide Dateien lesen und die Tabelle ausgeben; danach in derselben Session alle Antworten regelkonform halten. Verwandt: [[sequential-thinking-always]], [[skill-reference-etiquette]].
