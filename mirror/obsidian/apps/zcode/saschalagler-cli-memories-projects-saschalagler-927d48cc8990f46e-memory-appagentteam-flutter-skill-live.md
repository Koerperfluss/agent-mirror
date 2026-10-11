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

**Cline-Sync 11.10.:** appagentteam via `skillshare sync cline` verteilt (~/.cline/skills/appagentteam/SKILL.md, 143 Skills gesamt). **skillshare-Lektion:** Quelle ist `sources.skills: ~/.agents/skills` (config.yaml) — dort müssen Skills als **echte Ordner** liegen; **Symlinks in der Quelle werden von der Discovery übersprungen** (140 statt 157). `~/.config/skillshare/skills/` ist nur das „universal"-Target, nicht die Quelle. skillshare sync sichert Backups nach `~/.local/share/skillshare/backups/`. Cline-Warnung: always-loaded Context ~10,6k Tokens (Budget 10k).

**Ordner-Analyse (Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /Skill Lsite agentic os/):** flutter-skill-main = E2E-Repo (Quelle für sdks/ios, sdks/android, e2e-testing-Skill) → EINGEBUNDEN. IRIS-AI-main = Electron-App (iris-Skill existiert separat). OmniRoute = Router (20.09. auf Nutzer-Wunsch abgebaut). Auto Sync & Save = Bun/React-Projekt (unklarer Nutzen, kein Handlungsbedarf).

**11.10. Fortsetzung (08:50):** openclaw-CLI (Task #12) war BEREITS im PATH — OpenClaw v2026.9.2, installiert 08:20 von der Cline-mimo-Session (Subagent bewies `which openclaw` → ~/.local/bin/openclaw + `--version` Exit 0) → Task geschlossen, nichts geändert. **appagentteam Live-Lauf wartet als Task #17 (P1)** — erster echter Team-Flug, App-Wahl bei Sascha. Parallel-Subagenten-Muster bewiesen: implementer (schreibend) + explorer (nur lesend) gleichzeitig im Background, Ergebnis kommt als Task-Notification.

**11.10. KORREKTUR + Browser-Backend-Fund (09:15):** Der CDP-Port **9222 gehört aktuell EIGENT** (curl /json/list = 9 Tabs, eigent-browser-toolkit + unser flutter-skill-Test-Tab „Example Domain") — nicht mehr der alte Agent-Chrome. **D. h.: flutter-skill/E2E-Tests laufen direkt über Eigent** (läuft dauerhaft) → Task #16 („Eigent :9222 als Browser-Backend") damit faktisch erledigt, kein Extra-Chrome nötig. Hermes-CLI bewiesen (`hermes --version` = v0.17.0, auth.json eingeloggt), AutoClaw-Bedingung: App offen, sonst mcporter-Server offline (mcporter v0.9.0 von mir nachinstalliert). Skills-Global: `skillshare sync --all` aktuell (8 Targets, 139–142 Skills), legal-ops-omni-Feinkorrektur: war Symlink in Quelle → echte Kopie → auch bei Cline (Task #27 done). Kern-Rest: **Task #17 erster Live-Flug.**
