---
app: zcode
quelle: "saschalagler/cli/memories/projects/lv-wt-zcode-813ea335008de4bb/memory/loki-voice-app-multi-agent-setup.md"
stand: 2026-10-09
tags: [spiegel, zcode]
---

---
name: loki-voice-app-multi-agent-setup
description: LokiVoiceApp: Haupt-Repo ~/loki-voice-app (master), ZCode-Arbeit in Worktree ~/lv-wt-zcode (Branch t04-*), Integrations-Agent mergt und löscht Worktrees, Mimosa-Hook blockt Commits bei Security-Findings
metadata:
  type: project
---

LokiVoiceApp (Swift-Package, macOS 14) läuft als Multi-Agenten-Pipeline:

- **Haupt-Repo:** `/Users/saschalagler/loki-voice-app` (Branch `master`). Dort wird integriert.
- **ZCode-Worktree:** `/Users/saschalagler/lv-wt-zcode`, Branch `t04-audio-zcode`. Weitere Agenten (cline, master, modular) haben eigene Worktrees + Scratch-Pfade `/tmp/lv-build-<agent>`.
- **Integrations-Ablauf:** Ein Integrations-Agent mergt fertige `t04-*`-Branches per Fast-Forward in master und **löscht danach Worktree-Verzeichnis + Branch** — eigene Folge-Commits nach dem Merge können dabei verwaisen (9.10.2026 geschehen: Worktree wurde um 21:49 gelöscht, während a29f027 schon auf dem Branch lag; Wiederherstellung via `git worktree add` auf Basis des aktuellen master + `git checkout <orphan> -- <files>`).
- **Build/Test (exakt):** `export DYLD_FRAMEWORK_PATH="/Library/Developer/CommandLineTools/usr/lib/swift/pm:/Library/Developer/CommandLineTools/usr/lib/swift/pm/SwiftBuild.framework/Versions/A/PlugIns/SWBBuildService.bundle/Contents/Frameworks" && swift test --scratch-path /tmp/lv-build-zcode` (Xcode-27-Beta-Toolchain braucht DYLD_FRAMEWORK_PATH).
- **Mimosa-Security-Hook** blockiert `git commit` bei Findings (9.10.: Pfad-Traversal in `tools/whisper_server.py` PID-Write → mit `O_NOFOLLOW` gefixt). Fix über Write/Edit-Tools machen, nicht via Bash (PreToolUse-Scan verlangt das). Teststand 9.10.2026: 113 Tests, 1 skipped, grün (inkl. 18 AudioDSPTests aus T-04).
- Verwandt: [[loki-voice-app]] (Körperfluss/GCP-Kontext ist ein anderes Projekt — nicht verwechseln mit barbulls/gen-lang).
