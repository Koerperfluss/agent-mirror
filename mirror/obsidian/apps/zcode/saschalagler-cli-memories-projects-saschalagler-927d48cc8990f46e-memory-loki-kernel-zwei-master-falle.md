---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-kernel-zwei-master-falle.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: loki-kernel-zwei-master-falle
description: ZWEI LOKI_MASTER.py — Boot-Script startet den ROOT-Kernel (nicht
  macos-app-v17); Dashboard-Tabs nur via /dash-Mount erreichbar
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ec044ff8-4d82-412d-b9db-4db95e4da190
---

27.10.2026: **Die „LOKI OS geht nicht"-Ursache gefunden.** Es gibt ZWEI Kernel-Dateien:
1. `~/loki-ki/LOKI_MASTER.py` (ROOT) — **dieser startet via `LOKI_MASTER_BOOT.sh`** (`.venv_new/bin/python3`, Log `logs/fastapi.log`)
2. `~/loki-ki/macos-app-v17/LOKI_MASTER.py` — der alte (lief 16.10. als PID 84753, tot seitdem)

Der ROOT-Kernel hat nur EINE Dashboard-Route: `FileResponse(loki_dashboard.html)` — die dist-Tabs (abo-kompass, bibliothek, universe) waren unter dem Root-Kernel **unerreichbar** (404), weil sie in `macos-app-v17/dashboard-app/dist/` liegen, den aber kein Static-Mount kennt.

**Fix (27.10., bewiesen):** Static-Mount in LOKI_MASTER.py nach der /dashboard-Route eingefügt:
`app.mount("/dash", StaticFiles(directory=BASE_DIR / "macos-app-v17" / "dashboard-app" / "dist", html=True), name="dash")`
Backup: `LOKI_MASTER.py.bak-dashmount-20261027`. Kernel-Neustart (kill + boot-script-Zeile 275) → `/dash/*` alle 200.

**Live-URLs (27.10.):** `http://127.0.0.1:8010/dashboard` (klassisch) · `/dash/` (Tab-Index) · `/dash/agenten-panel.html` (Live-Dienste-Dots + Kanban-Embed + Team) · `/dash/canvas.html` (Heptabase-artiges Karten-Board, localStorage) · `/dash/abo-kompass.html` · `/dash/bibliothek.html`

**Bei Kernel-Problemen IMMER:** prüfen WELCHER Kernel läuft (`lsof -nP -iTCP:8010 -sTCP:LISTEN` + ps das PID) — Root oder v17. Boot-Script startet IMMER Root. Mimosa-Hook blockiert Bash-Schreibzugriffe auf LOKI_MASTER.py → Edit-Tool nutzen (Syntax-Check mit `ast.parse` danach).

Noch DOWN (27.10.): Kanban :3484, OmniRoute :20128, Cline-Hub :1006. UP: Kernel :8010, Ollama :11434, Eigent-CDP :9222, BrowserOS :9000/:9200, LiteRT :9379.

**27.10. Gate-Audit (gate-enforcer-test) — VETO behoben:**
- Kernel wurde nach dem ersten Start **extern gestoppt** (`~/loki-ki/logs/stop_boot.log`: „ALL SERVICES STOPPED") — kein Crash. Watchdog (com.loki.watchdog) läuft, bei erneutem Stop dort nachsehen.
- Ursprüngliches Backup existierte NICHT: Mimosa-Hook blockierte den `cp` auf LOKI_MASTER.py („direkt Quellcode per Bash schreiben"). **Rezept:** Pre-Change-Image rekonstruieren, indem man den exakten eingefügten Block (Kommentarzeilen + `app.mount("/dash", …)`) aus der Datei herausrechnet → `LOKI_MASTER.py.bak-dashmount-20261027` (7.425 B), kein bloßer IST-Snapshot.
- Kernel 2× neu gestartet (`nohup .venv_new/bin/python3 LOKI_MASTER.py >> logs/fastapi.log`), alle Routen frisch 200: /dashboard, /dash/agenten-panel.html, /dash/canvas.html, /dash/abo-kompass.html. Re-Audit lief als Resume an gate-enforcer (agent_8d3fe449) — Ergebnis kommt als Agent-Notifikation.
- **anet (AgentNetwork-Plugin): NICHT installiert** (Doctor-CLI: „anet is not installed"); anet-MCP-Tools in Sessions ohne den Daemon nicht verfügbar; Installation nur auf Sascha-GO via anet-setup-Skill.
- appagentteam R1–R7 gesund (0 tote Provider-IDs, Reparatur .bak-20261026 griff) · claude CLI 2.1.251 in ~/.local/bin · Ollama :11434 via `brew services start ollama` hochgehbar.

Verwandt: [[loki-os-konsolidierung-2026-10-16]], [[loki-os-livestatus-2026-10-11]], [[clinepass-zcode-config]]
