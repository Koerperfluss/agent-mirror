---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/toolchain-provider-spof.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: toolchain-provider-spof
description: "Alle KI-Tools (Claude Code, Cline, ZCode) hingen an einem Z.ai-Kontingent; npm-Mirror blockierte zusätzlich die Cline-CLI"
metadata: 
  node_type: memory
  type: project
  originSessionId: c273261d-5025-4954-814a-e67431dd0013
  modified: 2026-08-30T15:54:11.536Z
---

Am 30.08.2026 fielen Claude Code, Cline Code.app, Cline CLI und ZCode.app gleichzeitig aus. Zwei unabhängige Ursachen:

**1. Provider-Single-Point-of-Failure.** Alle drei GUI-Tools liefen über den Z.ai GLM Coding Plan, dessen Kontingent bis 01.09.2026 20:18 erschöpft war (HTTP 429, Code 1310, live verifiziert).
- Claude Code: `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic` in `~/.claude/settings.json` — diese Zeile überschreibt jeden `/login`, deshalb half die Anthropic-Anmeldung nicht.
- Cline Code.app: `providerId: "zai-coding-plan"`
- ZCode.app: ist Z.ai's eigene App (`dev.zcode.app`)
- `omniroute` 3.8.50 ist installiert und genau für solche Fallbacks gebaut, war aber nicht eingebunden.

**2. npm-Mirror.** `~/.npmrc` zeigte auf `registry.npmmirror.com`, der `@cline/cli-darwin-arm64` nur bis 3.0.15 führt. `cline@3.0.60` fordert 3.0.60 als **optionalDependency** — npm überspringt fehlende optionale Pakete stillschweigend, also landete der Wrapper ohne Binary. Fix: Registry auf `registry.npmjs.org`, dann `npm i -g cline@latest --force`.

**Diagnose-Fallen, die zweimal zu falschen Schlüssen führten:**
- `npm view` fragt die konfigurierte Registry ab — über einen Mirror gemessene Versionsstände sind wertlos. Gegen `https://registry.npmjs.org/<paket>` per curl gegenprüfen.
- `@cline` liegt **nested** unter `node_modules/cline/node_modules/@cline/`, nicht auf Top-Level. `ls` auf Top-Level meldet fälschlich "fehlt"; verlässlich ist nur `cline --version`.
- Vorhandene Dateien und laufende Prozesse beweisen **nicht**, dass eine App funktioniert. Bei "nichts geht mehr" die Logs lesen: `~/.cline/data/logs/hub-daemon.log` zeigte `run.heartbeat` mit `elapsedMs` bis 2.970.549 (49 Min) — Cline meldet bei totem Provider keinen Fehler, es hängt. Verstärkt durch `API_TIMEOUT_MS=3000000`.

Keine Datenverluste: `~/.cline` (4,6 GB), Kanban-Workspaces, 223 Sessions, `~/.zcode` (1,6 GB) blieben intakt.

Siehe auch [[loki-os]], [[agent-os]].
