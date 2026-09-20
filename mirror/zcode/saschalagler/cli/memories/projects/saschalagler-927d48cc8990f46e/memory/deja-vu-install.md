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
