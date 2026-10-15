# SPEC — Flaky/Bugfix-Backlog (gsd-core, Stand 15.10.2026 21:30)

Pipeline: ① gsd-core → ② roo-code → ③ ralph-loop → ④ code-audit → ⑤ e2e-test
Erstellt von Cline (Haupt-Agent), weil Subagenten-Team tot (Cline-Credits −0,09 $).

## Backlog-Items mit DONE-WHEN

### A. LegalOps MCP :7070 „4× dupliziert" (F-3 aus Universe-PDF vom 11.10.)
- **DONE-WHEN:** `loki-legal-ops-mcp` existiert genau1× je Harness-Config, alle Configs JSON-valide, Server antwortet auf MCP-`initialize`.
- **Befund15.10.:** Eintrag je1× in `~/.mcp.json` (Claude-kompat), `~/.cline/data/settings/cline_mcp_settings.json` (Cline), `~/.zcode/cli/config.json` (ZCode). `~/.agents/mcp.json`: kein Eintrag. Typ=`stdio` → jeder Host spart EIGENEN Prozess = **korrektes Verhalten, kein Bug**. Die „4 Prozesse" vom Port-Scan waren Host-Instanzen, keine Duplikate in einer Config.
- **Ergebnis:** Struktur KONFORM. Kein Change nötig. Server live verifiziert (initialize → serverInfo loki-legal-ops-mcp v1.0.0).

### B. Atomic Hermes.app entfernen
- **DONE-WHEN:** App + Reste gelöscht, Universe-PDF aktualisiert.
- **Status:** BLOCKIERT auf Nutzer-GO (Löschen = Stopp-Regel).

### C. ZCode-3.15.3-Volume austeilen
- **Status:** BLOCKIERT auf Nutzer-GO.

### D. ClinePass E2E-Chat
- **DONE-WHEN:** `stream:true`-Chat gegen `cline-pass/glm-5.3-flash` liefert Inhalt (kein429).
- **Status:** TIME-GATED — Reset ~00:10 MEZ. (Kanban task_0006.)

## Geänderte Dateien dieser Session (Audit-Grundlage)
1. `~/.zcode/v2/provider_config.json` — ClinePass12 Modelle + Key sk_e399… (Backups .bak-clinepass-*, .bak-keysync-*)
2. `~/.zcode/AGENTS.md` — ClinePass-Block Zeilen74–115 (Backup .bak-clinepass-*)
3. `~/.hermes/config.yaml` — default minimax-m3:cloud → gemma4:31b-cloud (Backup .bak-cline-sync-*)
4. `~/Desktop/LOKI-ABO-DASHBOARD.html` — neu, Steuerpult
5. `~/LOKI_SESSION_CONTEXT.md` — Status-Eintrag 15.10.
