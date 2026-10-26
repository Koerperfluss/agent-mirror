---
app: zcode
quelle: "saschalagler/cli/memories/projects/agent-os-d3ae7b502a46e7f0/memory/mimosa-hook-write-constraints.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: mimosa-hook-write-constraints
description: Mimosa-Hook blockt Writes/Pushes — funktionierende Gegenmuster
  (SSRF-Guard-Inline, keine Subprocess-Tests, manuelle Push-Zeile)
metadata:
  node_type: memory
  type: feedback
  originSessionId: session_58f3f4bfcb9a88671e0595593de28702
---

Mimosa-Security-Hook intercepted in diesem Setup Edit/Write UND `git push`.

**Why:** Er markiert dynamische URLs ohne Guard (SSRF), `../`/os.pardir/Path(__file__) in Tests (Pfad-Traversal) und Subprocess+Tempfile-Muster in Testdateien; Pre-Push scannt den gesamten Workspace und blockt auch bei Fundstellen in fremden Projekten (z.B. ~/agent-os/agentos).

**How to apply:** (1) Bei Skripten mit urlopen: vor dem Request `validate_host()` definieren (nur http/https, private/Loopback-IPs via ipaddress blocken, opt-in `--allow-lan`/Env für LAN-Nutzung) + `NoRedirectHandler` + `build_opener` statt `urlopen` — solche Edits passieren. (2) Unit-Tests: keine Subprocess-/Tempdir-/`..`-Muster; Shell-Checks stattdessen manuell via Bash laufen lassen und in VALIDATION.md dokumentieren; Import-Pfade via cwd-relativ (`scripts`) oder Env (`QFS_SCRIPTS_DIR`). (3) Wenn Push durch fremde Workspace-Findings blockt: Security-Gate nicht umgehen, stattdessen fertige Push-Zeile an Nutzer übergeben. (4) Simultan laufende Nutzer-Sessions können Dateien zwischen Reads ändern ("File has been modified since read") → vor Edit neu lesen und fremde Änderungen (z.B. neue Task-Choices) respektieren, nicht reverten. Kontext: [[qwen-flash-spark-project]].
