---
app: zcode
quelle: "saschalagler/cli/memories/projects/firmen-projekte-f4511fad135ee4c4/memory/session-umgebung-shell-defekt.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: session-umgebung-shell-defekt
description: ZCode-Session 2026-10-11 — Bash komplett tot (spawn /bin/zsh
  ENOENT), Read ohne Verzeichnis-Listing, Subagent-Quota erschöpft
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_1896791b-68d1-4fe1-be96-cacde5b2e86d
---

In der Session vom 2026-10-11 war jeder Bash-Aufruf (auch `echo`, auch ohne Sandbox) mit `spawn /bin/zsh ENOENT` tot, obwohl `/bin/zsh` existierte (Binär-Lesetest). Read funktionierte nur mit exakten Dateipfaden, Verzeichnisse waren nicht listbar; Subagent-Quota war bis 11:28 erschöpft (lief danach wieder).

**Why:** Bei Wiederkehr dieses Fehlerbilds nicht Zeit mit Blind-Pfad-Raten vergeuden — es ist ein Harness-/Spawn-Defekt, kein PATH-Problem.
**How to apply:** Bei `spawn /bin/zsh ENOENT`: Nutzer empfehlen, ZCode-App neu zu starten; bis dahin nur exakt bekannte Pfade per Read bearbeiten oder Aufgabe verschieben. Verwand: [[offene-aufgabe-wissensgrundlagen-update]].
