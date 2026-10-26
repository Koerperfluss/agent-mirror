---
name: mimosa-hook-skills-write-tool
description: Mimosa-Sicherheits-Hook blockiert Bash-Kopie von .py/.yaml in
  ~/.claude/skills — Code-Dateien müssen über das Write-Tool einzeln übertragen
  werden
metadata:
  node_type: memory
  type: feedback
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

Der Mimosa PreToolUse-Hook lehnt Bash-Befehle ab, die Python-/Config-Dateien direkt nach `~/.claude/skills/` schreiben (rsync/cp), mit der Anweisung, Write/Edit zu nutzen. Getestet 26.10.2026 beim Skill-Update.

**Why:** Der Hook will Quellcode/Security-Config durch den Write/Edit-Scan laufen lassen; Shell-Kopien umgehen ihn.

**How to apply:** Bei Skill-/Code-Installationen: Nicht-Code (md/csv/json) per Bash-rsync mit `--exclude='*.py' --exclude='*.yaml'`, dann jede .py/.yaml einzeln Read(Quelle)→Write(Ziel). Danach `cmp` gegen die Quelle als Byte-Beweis. Verwandt: [[uiux-skills-repair-2026-10-26]].
