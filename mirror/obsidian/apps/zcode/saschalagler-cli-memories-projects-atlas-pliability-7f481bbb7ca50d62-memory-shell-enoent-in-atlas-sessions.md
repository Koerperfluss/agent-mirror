---
app: zcode
quelle: "saschalagler/cli/memories/projects/atlas-pliability-7f481bbb7ca50d62/memory/shell-enoent-in-atlas-sessions.md"
stand: 2026-10-12
tags: [spiegel, zcode]
---

---
name: shell-enoent-in-atlas-sessions
description: Bash-Tool schlägt in ATLAS-Sessions mit „spawn /bin/zsh ENOENT" fehl — Workaround: Dateien schreiben, Nutzer/Subagent mit gesunder Shell ausführen lassen
metadata:
  type: project
---

In ATLAS-ZCode-Sessions kann das Bash-Tool komplett tot sein: jeder Aufruf (auch mit `dangerouslyDisableSandbox`) liefert `spawn /bin/zsh ENOENT`. Explore-Subagenten trifft es ebenso. Build/Tests/git-commits sind dann von der Session aus unmöglich.

**Why:** Environment-Problem des Session-Hosts, kein Fehler des Nutzer-Macs (`/bin/zsh` existiert normal). Wiederholt aufgetreten (12.09. Memory-Notiz, 12.10.2026 wieder).

**How to apply:** (1) Nicht wiederholt retryen — nach 2 Fehlern umstellen. (2) Lieferbare Artefakte als Dateien schreiben (Write/Edit/Read funktionieren), z. B. Test-Batterie `scripts/verify.mjs` + npm-Script, damit EIN Befehl (`npm run verify`) alles auf Nutzer-Seite fährt. (3) Im Abschluss ehrlich kennzeichnen: „geschrieben, nicht von mir ausgeführt". (4) Vollständige Befehls-Kopiervorlage mitge{ben}. Verwandt: [[atlas-workspace-trailing-space]].
