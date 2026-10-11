---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/appagentteam-flutter-skill-live.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: appagentteam-flutter-skill-live
description: 11.10.2026 — /appagentteam-Skill live + flutter-skill 0.9.37
  Native-Binary-Fix (npm-Wrapper-ENOEXEC-Falle) + projektweise-MCP-Regel
metadata:
  node_type: memory
  type: project
  originSessionId: sess_9bb02160-ce23-4582-a594-371c1f798aa5
---

11.10.2026 ABSCHLUSS: **/appagentteam-Skill existiert und ist einsatzbereit** (`~/.zcode/skills/appagentteam/SKILL.md` — R1–R7-Rollen, 6 Phasen, von Parallel-Session angelegt, von mir um bewiesene Fix-Details erweitert) + `~/.zcode/skills/e2e-testing/SKILL.md` aus dem lokalen Repo vorhanden + Routing-Eintrag in `~/.agents/skill-routing.md`.

**flutter-skill auf diesem Mac:**
- `~/.local/bin/flutter-skill` = **Symlink auf Native-Binary** `~/.flutter-skill/bin/flutter-skill-macos-arm64-v0.9.37` (NICHT der npm-Wrapper!)
- **Falle:** npm-Wrapper cli.js crashet mit `spawn ENOEXEC` (Postinstall lädt 0-Byte-Binary; Node-Spawn scheitert, direkter exec läuft). GitHub-Release v0.9.36 hat KEINE Assets → Binary von v0.9.37 holen, unter Wrapper-erwartetem Namen (`-v0.9.36`) ODER Symlink direkt aufs Binary legen (gemacht). Bei npm-Update: Symlink neu setzen.
- **CLI-Trap:** `--port=N` als erstes Argument = „Unknown command" → `FS_PORT=3742 flutter-skill snap` oder Flags nach Subcommand.
- **Live bewiesen (Exit 0):** `flutter-skill serve https://example.com --port=3742` + `FS_PORT=3742 flutter-skill snap` → echter Accessibility-Content. serve nutzt CDP **9222** = Agent-Chrome (passt zu [[browser-doppelsystem-setup]]).
- **MCP-Regel:** flutter-skill-MCP (253 Tools) NIE global in `~/.mcp.json` (Context-Tax) — nur projektweise `.mcp.json` im App-Projekt. Backup: `~/.mcp.json.bak-2026-10-11` (unverändert, 22 Server).
- Flutter-SDK selbst ist NICHT installiert (nur Dart via Homebrew) — Flutter-App-Builds brauchen erst `brew install --cask flutter`.

**Ordner-Analyse (Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /Skill Lsite agentic os/):** flutter-skill-main = E2E-Repo (Quelle für sdks/ios, sdks/android, e2e-testing-Skill) → EINGEBUNDEN. IRIS-AI-main = Electron-App (iris-Skill existiert separat). OmniRoute = Router (20.09. auf Nutzer-Wunsch abgebaut). Auto Sync & Save = Bun/React-Projekt (unklarer Nutzen, kein Handlungsbedarf).
