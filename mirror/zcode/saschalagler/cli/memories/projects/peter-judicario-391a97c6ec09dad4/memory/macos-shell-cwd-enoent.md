---
name: macos-shell-cwd-enoent
description: Bash "spawn /bin/zsh ENOENT" = Arbeitsverzeichnis existiert nicht —
  Ordner rekonstruieren entblockt die Shell
metadata:
  node_type: memory
  type: project
  originSessionId: sess_0f956bae-0115-4221-a569-0d1744955ece
---

Auf Saschas Mac: Wenn Bash nur `spawn /bin/zsh ENOENT` wirft (auch mit Sandbox aus), ist **nicht** die Shell kaputt — das Harness-Arbeitsverzeichnis existiert nicht mehr (Spawn mit totem cwd = ENOENT).

**Why:** 12.09.2026: Ordner `Desktop/Coworkspace_Ich/PETER JUDICARIO` wurde außerhalb der Session gelöscht/verschoben; Read der Binary `/bin/zsh` ("Unsupported or binary text encoding") bewies, dass die Shell existiert.

**How to apply:** Per Write irgendeine Datei im (fehlenden) cwd anlegen — Write erzeugt Elternordner → Shell spawnt wieder. Danach mit absoluten Pfaden arbeiten. Verwandt: [[zcode-computer-use-status]]
