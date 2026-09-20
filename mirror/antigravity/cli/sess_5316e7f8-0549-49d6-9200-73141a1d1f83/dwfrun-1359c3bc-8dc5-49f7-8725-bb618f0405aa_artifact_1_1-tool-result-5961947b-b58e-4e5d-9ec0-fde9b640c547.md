# LOKI.OS System-Selbstprüfung — 20.09.2026

**Gesamturteil Prüfinstanz:** Alle 7 tragenden Befunde wurden mit identischen eigenen Befehlen (lsof, launchctl, stat, curl) unabhängig reproduziert und stimmen exakt überein — kein Widerspruch, kein VETO. Kritischster Punkt bleibt der Kernel auf :8010 (nur Test-Tasks, Atlas nie ingestiert) plus LegalOps DOWN und 74 Tage alter Master-Status.
**Health-Gate:** CHECKPOINT ACTION_NEEDED

### Kernel & Dienste (LOKI.OS / macOS Ports + LaunchAgents)
Kern ist gesund und sicher auf 127.0.0.1 gebunden (v15.3.0, HTTP 200), alle SOLL-DOWN-Dienste sind zu — aber LegalOps :7070 ist unerwartet DOWN, OmniRoute :20128 lauscht auf allen Interfaces (* = LAN-Exposition) und der toolhub-watchdog-LaunchAgent ist mit Exit 126 funktionslos.

| Check | Status | Beweis |
|---|---|---|
| Kernel :8010 (Listener) | PASS | lsof -nP -iTCP:8010 -sTCP:LISTEN → "Python 3152 saschalagler ... TCP 127.0.0.1:8010 (LISTEN)" |
| Kernel :8010 (Health) | PASS | curl -s -m3 -w "|HTTP:%{http_code}" localhost:8010/loki/health → {"status":"ok","version":"15.3.0","keys":{"gemini":true,"anthropic":false},"local_backends":{"litert_lm":{"status":"DOWN"},"ollama":{"status":"fallback"}}}|HTTP:200 |
| OmniRoute :20128 | WARN | lsof -nP -iTCP:20128 -sTCP:LISTEN → "node 1098 saschalagler ... TCP *:20128 (LISTEN)" |
| Ollama :11434 | INFO | lsof -nP -iTCP:11434 -sTCP:LISTEN → "ollama 843 saschalagler ... TCP 127.0.0.1:11434 (LISTEN)" |
| Kanban :3484 | INFO | lsof -nP -iTCP:3484 -sTCP:LISTEN → "node 237 saschalagler ... TCP 127.0.0.1:3484 (LISTEN)" |
| LegalOps :7070 (SOLL UP) | FAIL | lsof -nP -iTCP:7070 -sTCP:LISTEN → leerer Output, Fallback: "(KEIN LISTENER auf 7070)" |
| LM Studio :1234 (SOLL DOWN ok) | PASS | lsof -nP -iTCP:1234 -sTCP:LISTEN → leerer Output, Fallback: "(KEIN LISTENER auf 1234)" |
| LiteRT :9379 (SOLL DOWN ok) | PASS | lsof -nP -iTCP:9379 -sTCP:LISTEN → leerer Output, Fallback: "(KEIN LISTENER auf 9379)"; Kernel-Health bestätigt "litert_lm":{"port":9379,"status":"DOWN","model":"gemma4-12b,gpu,2048"} |
| n8n :5678 (SOLL DOWN ok) | PASS | lsof -nP -iTCP:5678 -sTCP:LISTEN → leerer Output, Fallback: "(KEIN LISTENER auf 5678)" |
| MongoDB :27017 (Fremdling) | INFO | lsof -nP -iTCP:27017 -sTCP:LISTEN → "mongod 845 saschalagler ... TCP 127.0.0.1:27017 (LISTEN)" + "TCP [::1]:27017 (LISTEN)" |
| LaunchAgents (laufend mit PID) | INFO | launchctl list | grep -v com.apple → mit PID: "835 com.sascha.omniroute · 843 com.sascha.ollama · 845 sh.brew.mongodb-community · 838 com.lokivoice.mcp-server · 841 com.sascha.foerderops · 62879 dev.sascha.voiceagent · 7722 com.google.antigravity.ShipIt" |
| LaunchAgents (Fehler-Exits) | WARN | launchctl list | grep -v com.apple → "-  2  com.sascha.omni-check.daily" und "-  126  com.sascha.toolhub-watchdog" |

### KI-Clients & Skill-Layer
KI-Clients & Skill-Layer gesund: alle 4 Client-Configs vorhanden (Claude/Gemini heute 14:18 aktualisiert, ZCode 13.09., Antigravity 07.08.), Claude-Code korrekt auf z.ai/api/anthropic mit glm-5.3-flash geroutet, 119 Skills aktiv, 0 kaputte Symlinks in ~/.zcode/skills (nur 2 harmlose Manifest-Dateien), Archiv mit 5 Snapshots, 7 Commands + 10 Agents vorhanden — keine Auffälligkeiten.

| Check | Status | Beweis |
|---|---|---|
| Client-Configs existieren+mtime | PASS | ls -l ~/.claude/settings.json ~/.zcode/v2/config.json ~/.gemini/settings.json ~/.config/antigravity/mcp_config.json → alle 4 vorhanden: claude 6523B Sep 20 14:18, gemini 1200B Sep 20 14:18, zcode/v2 143410B Sep 13 17:47, antigravity 1303B Aug 7 09:18 |
| Claude-Code → z.ai/glm | PASS | grep -nEi 'z\.ai|glm|base.?url' ~/.claude/settings.json → Zeile 4: "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic" + Zeilen 5-9: ANTHROPIC_MODEL "glm-first", OPUS/SONNET/HAIKU "glm-5.3-flash[1m]" |
| Skills-Zähler ~/.agents/skills | INFO | find ~/.agents/skills -maxdepth 2 -name SKILL.md | wc -l → 119 |
| Kaputte Symlinks ~/.zcode/skills | PASS | find ~/.zcode/skills -maxdepth 1 -type l ! -exec test -e {} \; -print | wc -l → 0 (ls -A: nur .skillshare-manifest.json + .bak, keine Symlinks) |
| Archive ~/.agents/skills-archive | INFO | ls ~/.agents/skills-archive → 2026-09-07, 2026-09-08, 2026-09-11, 2026-09-11-google-catalog, 2026-09-11-stale-harness-copies |
| ZCode Commands+Agents | PASS | echo "commands: $(ls ~/.zcode/commands | wc -l)"; echo "agents: $(ls ~/.zcode/agents | wc -l)" → commands: 7, agents: 10 |

### Doku & Memory (loki-memory-sync-Sicht)
Doku/Memory-Schicht ist überwiegend frisch (5 von 6 Kanon-Dateien im 3-Wochen-Fenster, Disk 69 GiB frei, Memory-Index 96 Zeilen) — einziger Ausreißer: LOKI_MASTER_STATUS.md ist mit Stand 08.07.2026 ~10,5 Wochen alt und damit veraltet.

| Check | Status | Beweis |
|---|---|---|
| LOKI_SESSION_CONTEXT.md (Alter/Größe) | PASS | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/LOKI_SESSION_CONTEXT.md → '2026-09-20|26134 bytes|/Users/saschalagler/LOKI_SESSION_CONTEXT.md' |
| SYSTEM_HANDBUCH.md (Alter/Größe) | PASS | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/loki-ki/docs/SYSTEM_HANDBUCH.md → '2026-09-01|15106 bytes|/Users/saschalagler/loki-ki/docs/SYSTEM_HANDBUCH.md' |
| LOKI_MASTER_STATUS.md (Alter/Größe) | FAIL | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/loki-ki/docs/LOKI_MASTER_STATUS.md → '2026-07-08|5333 bytes|/Users/saschalagler/loki-ki/docs/LOKI_MASTER_STATUS.md' |
| MASTER_TODO.md (Alter/Größe) | PASS | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/loki-ki/MASTER_TODO.md → '2026-08-31|3072 bytes|/Users/saschalagler/loki-ki/MASTER_TODO.md' |
| SKILL_LANDKARTE.md (Alter/Größe) | PASS | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/loki-ki/docs/SKILL_LANDKARTE.md → '2026-08-31|9309 bytes|/Users/saschalagler/loki-ki/docs/SKILL_LANDKARTE.md' |
| LOKI_PROJECT_MAP.md (Alter/Größe) | PASS | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/LOKI_PROJECT_MAP.md → '2026-09-06|4869 bytes|/Users/saschalagler/LOKI_PROJECT_MAP.md' |
| MEMORY.md (Zeilenzahl, Doku-Memory-Index) | INFO | wc -l ~/.zcode/cli/memories/projects/default-041661acc4598b22/memory/MEMORY.md → '96 /Users/saschalagler/.zcode/cli/memories/projects/default-041661acc4598b22/memory/MEMORY.md' |
| Disk-Frei df -h / | PASS | df -h / → '/dev/disk3s1s1   460Gi    13Gi    69Gi    16%    ...' |

### Automations & Hooks
Automations-Schicht gesund: Hooks aktiv (3 Events, Gate feuert), Health-Check fehlerfrei; einziger Auffälliger bleibt der MongoDB-Fremdling auf :27017 (localhost-only, Brew-Install), mirror-Agent ist gewollt.

| Check | Status | Beweis |
|---|---|---|
| config.json Hooks | PASS | python3 -c '...json.load(config.json)...' → 'valide, hooks.enabled = True; events: [PreToolUse, SessionStart, UserPromptSubmit]; mcp: 17' |
| config-health.py | PASS | python3 ~/.agents/tools/config-health.py → '✓ Selbstcheck gelaufen: config ok, 17 MCP-Server, AGENTS.md ok, Gate feuert' (kein ❌) |
| MongoDB :27017 (Fremdling) | WARN | lsof -nP -iTCP:27017 -sTCP:LISTEN → 'mongod 845 saschalagler TCP 127.0.0.1:27017 (LISTEN)' (+ ::1) |
| dev.mirror.sync (gewollt) | INFO | ls ~/Library/LaunchAgents | grep -iE 'mongo|mirror' → 'dev.mirror.sync.plist, sh.brew.mongodb-community.plist'; grep im Plist → '/Users/saschalagler/Projects/agent-mirror/scripts/mirror-sync.sh' |
| crontab | INFO | crontab -l 2>/dev/null | head -5 → (leer, keine Ausgabe) |

### Wissensspeicher & Kernel-Sicht
Kernel v15.3.0 läuft, lokaler Wissensspeicher ist intakt (loki.db 7,3 MB, VwGH-Quelle da, Vault liefert Notes) — aber Atlas-Ingest fehlt komplett (FAIL) und die Task-Bridge enthält nur Test-Tasks (WARN); LiteRT-Backend ist DOWN, Ollama fällt ein.

| Check | Status | Beweis |
|---|---|---|
| Kernel :8010 /loki/health | PASS | curl -sS -m 3 http://localhost:8010/loki/health → {"status":"ok","version":"15.3.0","keys":{"gemini":true,"anthropic":false},"local_backends":{"litert_lm":{"status":"DOWN"},"ollama":"fallback"}} HTTP:200 |
| Kernel :8010 /loki/capabilities | INFO | curl -sS -m 3 -o /dev/null -w %{http_code} http://localhost:8010/loki/capabilities → 200; 1. Zeile: {"generated":"2026-09-01T12:38:06","skills":[{"name":"antigravity-support",...}] |
| Kernel :8010 /tasks | WARN | curl -sS -m 3 http://localhost:8010/tasks → [{"id":0,"text":"- [ ] Test-Task Bridge"},{"id":1,"text":"- [ ] Test-Task Bridge"}] HTTP:200 |
| Atlas-Ingest /api/v1/atlas/knowledge | FAIL | curl -sS -m 3 http://localhost:8010/api/v1/atlas/knowledge → {"error":"Knowledge base not yet ingested"} HTTP:200 |
| Vault /api/vault | PASS | curl -sS -m 3 http://localhost:8010/api/vault → {"notes":[{"title":"2026-09-11.md","path":"Daily_Notes/2026-09-11.md",...}]} HTTP:200 |
| loki.db | PASS | ls -lh ~/loki-ki/data/loki.db → -rw-r--r-- 1 saschalagler staff 7.3M Sep 18 13:13 /Users/saschalagler/loki-ki/data/loki.db |
| VwGH-Quelle | PASS | ls ~/loki-ki/data | grep -i vwgh → vwgh_erkenntnisse (exit 0) |
| Brain-Alt-Pfad | INFO | ls -d '/Users/saschalagler/Desktop/Local AI /loki-ki/Brain' → ls: No such file or directory (exit 1) |

## Unabhängige Prüfinstanz

| Befund | Urteil | Eigener Beweis |
|---|---|---|
| OmniRoute :20128 | BESTÄTIGT | lsof -nP -iTCP:20128 -sTCP:LISTEN → 'node 1098 saschalagler ... TCP *:20128 (LISTEN)' — läuft und an allen Interfaces (*) gebunden, nicht localhost. |
| LegalOps :7070 (SOLL UP) | BESTÄTIGT | lsof -nP -iTCP:7070 -sTCP:LISTEN → leerer Output, EXIT=1; auch lsof -nP -iTCP:7070 ohne Filter → kein Treffer — kein Listener auf 7070, LegalOps DOWN. |
| LaunchAgents (Fehler-Exits) | BESTÄTIGT | launchctl list | grep -v com.apple → '- 2 com.sascha.omni-check.daily' und '- 126 com.sascha.toolhub-watchdog' — beide nicht laufend mit Fehler-Exit 2 bzw. 126, exakt wie behauptet. |
| LOKI_MASTER_STATUS.md (Alter/Größe) | BESTÄTIGT | stat -f '%Sm|%z|%N' -t '%Y-%m-%d' ~/loki-ki/docs/LOKI_MASTER_STATUS.md → '2026-07-08|5333|/Users/saschalagler/loki-ki/docs/LOKI_MASTER_STATUS.md'; date → 2026-09-20 = exakt 74 Tage alt, 5333 Bytes. |
| MongoDB :27017 (Fremdling) | BESTÄTIGT | lsof -nP -iTCP:27017 -sTCP:LISTEN → 'mongod 845 saschalagler TCP 127.0.0.1:27017 (LISTEN)' plus IPv6 '[::1]:27017' — läuft nur an localhost gebunden, nicht an allen Interfaces. |
| Kernel :8010 /tasks | BESTÄTIGT | curl -sS -m 3 -w '%{http_code}' http://localhost:8010/tasks → [{"id":0,"text":"- [ ] Test-Task Bridge"},{"id":1,"text":"- [ ] Test-Task Bridge"}] HTTP:200 — Bridge antwortet, aber nur 2 Test-Tasks, keine echten Aufgaben. |
| Atlas-Ingest /api/v1/atlas/knowledge | BESTÄTIGT | curl -sS -m 3 -w '%{http_code}' http://localhost:8010/api/v1/atlas/knowledge → {"error":"Knowledge base not yet ingested"} HTTP:200 — Fehlmeldung exakt reproduziert, Wissensbasis nicht ingestiert. |

## Offene Entscheidungen (wayfinder-Tickets aus dem Verhör)

| # | Entscheidung | Empfehlung |
|---|---|---|
| Q1 | Autostart: loki-up.command für Kernel+LegalOps+Kanban | bauen |
| Q2 | LiteRT/LM Studio DOWN lassen | abhaken |
| Q3 | MongoDB-Fremdling disablen | ja (reversibel) |
| Q4 | Atlas-Ingest + Task-Bridge bauen | ja, jetzt |
| Q5 | Coder-Modell qwen2.5-coder:7b statt 14b | 7b (16-GB-RAM) |
| Q6 | 4 fehlende Keys in .env.loki | Sascha holt sie / abhaken |
| Q7 | Kanonische Doku (SESSION_CONTEXT, SYSTEM_HANDBUCH, MASTER_STATUS) auf 20.09. | ja |
