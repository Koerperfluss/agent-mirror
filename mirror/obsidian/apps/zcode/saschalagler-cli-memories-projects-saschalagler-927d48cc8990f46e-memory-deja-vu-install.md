---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/deja-vu-install.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

---
name: deja-vu-install
description: deja-vu (lokales Session-Gedächtnis) 0.20.2 via brew installiert; Vollintegration
  per deja install --auto (15 MCP, 13 Hooks, 14 Guidance) inkl. ZCode config.json
metadata:
  node_type: memory
  type: project
  originSessionId: sess_e8798d40-41ac-4fb4-8725-69b28c7e7475
---

deja-vu 0.20.2 am 20.09.2026 installiert (`brew install deja-vu`, Binary `/opt/homebrew/bin/deja`). Lokales Tool, das vergangene KI-Coding-Sessions durchsucht („hatten wir das schon gelöst?") — ohne API-Keys, ohne Netz. Index: 349 Cline- + 371 ZCode-Sessions (~41k Nachrichten).

**Why:** Repo `vshulcz/deja-vu` von Sascha geklont und auf Wunsch installiert; anschließend am selben Tag (20.09.) die Vollintegration per README veranlasst.

**How to apply:** Vollintegration ERFOLGT am 20.09.2026: `deja install --auto` installierte **15 MCP-Server, 13 Hooks, 14 Guidance-Dateien** (Claude Code, Cline, ZCode, OpenClaw, opencode, VS Code, Antigravity u. a.) + zusätzlich `deja install zcode zcode-auto`. Beweis: `/Users/saschalagler/.zcode/cli/config.json` enthält `mcp.servers.deja → /opt/homebrew/bin/deja mcp` (stdio). Skills: `~/.agents/skills/deja-search/SKILL.md` und `~/.agents/skills/deja-history/SKILL.md`. Ab neuer Session: Session-Start-Recall aktiv (laufende Sessions brauchen Neustart). Befehle: `deja "frage"`, `deja fix`, `deja wip`, `deja blame`, `deja forget` (Privacy). Relevante Infra: [[sascha-local-infra-ports]].

**End-to-End-Beweis (20.09., auf Saschas „beweise es mir"):** Live-JSON-RPC-Handshake gegen `/opt/homebrew/bin/deja mcp` → Server antwortet `deja 0.20.2`, Tool `deja`. Ein `mode:"recall"`-Call auf „eBay Nespresso Kaffee Anzeige" lieferte als Rang-1-Treffer die echte ZCode-Session `sess_942c93ed…` (Nespresso-eBay-Recherche) — Cross-Session-Gedächtnis verifiziert, nicht nur behauptet.

**Additiv-Verifikation (20.09.):** dejás config.json-Eingriff ist ADDITIV — alle 6 Schaltstellen des LOKI-OS-Harness (Hooks valid/keine leeren matcher, 16 Original-MCPs + deja = 17, 10 Agents, 7 Commands, Sync 5/5) intakt; dejás hooks (hook-context, hook-prompt) stehen als zusätzliche Entries neben gate-enforcer/block-dangerous-git/projects.py/config-health. dejás SessionStart- + UserPromptSubmit-Hooks feuern bereits in Live-Sessions (deja-recall-Blöcke im Hook-Kontext beobachtet). Kanonische Harness-Settings-Sessions: [[loki-os-harness-settings-sessions]].

**Runaway- befund (01.10., Mac-Langsamkeit, REPRODUZIERBAR):** `deja hook-refresh` feuert bei JEDEM Session-Start in den Amok (3× bewiesen: 104 % + 3,5 GB, dann 88,4 % + 2,3 GB, 2,5 min Laufzeit, PPID 1) — jedes Mal per `kill <pid>` gestoppt, kommt aber zurück. Bei Mac-Lag IMMER zuerst `ps aux | grep 'deja hook-refresh'` prüfen. Details: [[mac-langsam-finder-desktop-loop]].

**FIX GESETZT (01.10., „GO B", bewiesen):** Ursache: JEDE deja-Suche (auch die deja-recall-Hooks je Prompt) spawnt einen Background-Refresh (deja druckt wörtlich „refreshing in the background"); bei 3,6-GB-Index/282 Sessions + Rollout-Dateien bis 500 MB = Minuten 100 % CPU + 2–3,5 GB RAM. Keine offizielle Absperr-Option (keine DEJA_*-Env-Vars im Binary, `--no-embed` nur für Suche, brew: 0.20.2 = aktuell). **Fix: alle 5 deja-Hooks aus `~/.claude/settings.json` entfernt** (SessionStart, UserPromptSubmit, PreToolUse, PostToolUse, PreCompact) — Backup `settings.json.bak-20261001`. `~/.zcode/cli/config.json` hatte KEINE deja-hooks (nur mcpServer.deja, der bleibt ✓). deja-MCP + Terminal-Suche bleiben nutzbar; Auto-Recall je Prompt ist weg. Rückgängig = Backup zurückkopieren. ⚠️ `deja hook --help` führt KEINE Hilfe aus, sondern läuft als SUCHE — echte Hook-Befehle heißen `deja hook-prompt/hook-context/hook-tool`. Research-Agent zu dejavu-GitHub-Bug lief noch (Ergebnis nachlegen, Report-Ziel: `~/loki-ki/logs/research_dejavu_hook_refresh_2026-10-01.md`).

**VOLL-FIX ABGESCHLOSSEN (01.10. ~13:00, Research-Agent lieferte Ursache, bewiesen):** Repo **vshulcz/deja-vu** (MIT, brew-Formula heißt `deja-vu` — ⚠️ `brew info deja` war der FALSCHE Formelname, deshalb schien 0.20.2 „aktuell"!). **Bugs offiziell bekannt:** Issue **#3500** (Background-Rebuild Ø 460 % CPU, „no background worker budget"; `hook-context` spawnt detached `hook-refresh` → `index.Ensure()` auf Vollindex — erklärt PPID 1 + „kommt immer wieder", Sentinel nur 2 min), Issue #2718 (unknown hook subcommand → Index-Build). **Fix 3-fach:** (1) `brew upgrade deja-vu` → **0.21.4** (29.09.2026; v0.21.0 parallelisiert Rebuild: 30 s statt 51 s; ⚠️ Index-Format-Migration kann EINMALIGEN Voll-Rebuild auslösen). (2) **Kill-Switch `DEJA_HOOK_REFRESH=1`** existiert bereits in 0.20.2 — eingetragen in `~/.zshrc` (01.10.). (3) 5 Hooks bleiben aus ~/.claude/settings.json entfernt. **Endverifikation: 0 hook-refresh-Prozesse, nur ruhiger `deja mcp` (0,0 % CPU), deja 0.21.4 aktiv.** Optionale weitere Hebel (unausgeführt): Wrapper `~/.config/deja/bin/deja-hook`, `~/.config/deja/exclude` zum Store-Verkleinern. Research-Report: `~/loki-ki/logs/research_dejavu_hook_refresh_2026-10-01.md`. Details Loop-Kontext: [[mac-langsam-finder-desktop-loop]].

**Claude-seitiger Befund (23.09., Diagnose-Workflow dwfrun-30bfea17):** Sascha nutzt Claude Code FAKTISCH NICHT — letzte Session-Transcript unter ~/.claude/projects/ ist vom 15.09. 14:01, deja-Install erst 20.09. 14:18 (find -newermt 2026-09-20 → leer). Saschas Eindruck „feuert nicht" = Nutzungsverhalten, kein Config-Fehler; dejás Verkabelung (settings.json Z. 103/121 + Wrapper + Binary) ist intakt, aber nie in einer Claude-Session angelaufen. 6 Routing-Skills fehlen zusätzlich in ~/.claude/skills (loki-os-health, deja-search, gsd-core, roo-code, ralph-loop, coderabbit — nur dort, ZCode hat alle). Details: [[george-thomas-status]].
