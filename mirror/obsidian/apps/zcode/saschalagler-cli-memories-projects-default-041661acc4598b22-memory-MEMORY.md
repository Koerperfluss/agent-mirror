---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/MEMORY.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

# Memory Index

- [ZCode-Projektgruppen-Mechanik](zcode-projektgruppen-mechanik.md) — 06.09.: Chatliste links = tasks-index.sqlite (Gruppen+node_orders+members), externes SQL wirkt erst nach ⌘Q-Neustart; Claude/Cline-Chat-Importer import-chats-loki.py (259 Cline-Chats drin); Restore-.command auf Desktop

- [FörderOps-Assistent](foerderops-assistent.md) — 30.08. aktiv, 06.09. spät Web-UI 8765 LÄUFT WIEDER (kein Autostart!); 70 Wissensdokumente; digi4KMU 50k existiert NICHT; Cap-Table Leon 26/Lisa 26/Sascha 25/Peter 23; 🔴 $350k-Blocker: Webgo-NS-Switch
- [GUI nicht CLI](feedback-gui-not-cli.md) — 30.08. Sascha: „ich will eine grafische oberfläche" — IMMER Web-UI bauen, nie nur Terminal-Befehl
- [Sequential Thinking immer](sequential-thinking-always.md) — 30.08. Nutzer-Regel: mcp sequentialthinking bei JEDER Anfrage aufrufen; verankert in ~/.agents/STANDARD-SKILLS.md A.3 + skill-routing.md (alle 5 Harnesses)
- [Aktive Fokus-Projekte](active-projects-focus.md) — 30.08.: Atlas Cali Coach, Körperfluss Physio-Web, FörderOps; Projektlisten-Tool `python3 ~/.claude/tools/projects.py`
- [Google Cloud GenAI Credit](google-cloud-genai-credit.md) — 867,15 € "GenAI App Builder" bis 23.04.2027 (Billing 015D43…, Projekt koerperfluss-antigravity); gilt NUR für Vertex AI Search & Conversation, NICHT normale Gemini API

- [Sigma Local-AI-Stack](sigma-local-ai-stack.md) — 30.08. 08:00 FERTIG: LM Studio + OpenClaw = Primärweg (läuft, Gemma 4 12B, Vision/Tool-Calling, max_tokens≥100); Sigma Qwen 3.5 9B "Activate" JETZT möglich (Port 8787 frei, Engine b9357 unterstützt qwen35), aber NICHT nötig; **Root Cause 07:55 gelöst: Port 8787 war von Loki-Voice blockiert (EADDRINUSE → still failure)**; **LERNE: NIEMALS User-Services killen ohne zu fragen** (Loki-Voice entladen war Fehler — Optionen anbieten: Loki-Port ändern, Sigma-Port-Flag, socat-Forward, LM-Studio-Weg); Cloud=OpenRouter/Claude 4.5; openclaw.json HAT LM-Studio-Provider bereits fertig; GLM 4.6V im LM Studio Hub

- [Foto-Restaurierung Opa A4](foto-restaurierung-opa-a4.md) — FINALE 26.08. früh: 8 Fotos als A4-JPEG (3508px/q90/300dpi, 11 MB) in druckfertig/ per reinem Lanczos; Quelle jetzt ~/Desktop/opa 70iger fotos/; Upscayl-CLI (upscayl-bin + remacri) dokumentiert; Lesson: „einfach nur skaliere" = wörtlich minimal, JPEG statt PNG

- [Mac setup: fanless M4 Air 16 GB](mac-setup-16gb-m4.md) — fanless MacBook Air M4, 16 GB RAM / 38 GB disk (2026-08-26), macOS 26.6, Python 3.14.6 + uv 0.11.18; RAM constrains local models; Qwen 3.5 9B for Sigma

- [Mac-Cleanup 2026-08-25](mac-cleanup-2026-08-25.md) — AUSGEFÜHRT: Docker K8s aus (VM 1 % idle), Adobe KOMPLETT weg, 18 Dienste/Leichen entfernt (Restore: ~/launchagents_backup + ~/deinstall_backup), TCC-auditiert (Spotify/WhatsApp FDA entzogen); 26.7-Update-Lauf gestartet, Ausgang offen — 7507=GUI blockt Daemon, Beta-Toggle nur GUI-authoritativ (Runde 7)

- [LOKI autostarts orphaned](loki-autostarts-orphaned.md) — com.loki.master + com.loki.v15 ENTFERNT 25.08.; omniroute/lokivoice/legalops sind gewollt

- [web-research-team skill](web-research-team-skill.md) — v1.1: modes, 3 iron laws, browser tiers + handoff, delta research, runlog; control-browser main-agent-only, max 3 parallel subagents

- [ZCode-Setup verifiziert](zcode-setup-verified.md) — 26.08.: 14 MCP-Server, 16 Plugins, Skill-Drift 112/110 (4 Skills), Obsidian↔Cline-Sync offen; sequential-thinking = MCP in config.json + ~/.mcp.json (Symlink auf Cline), kein Skill

- [Vorssaint-Tool-Check](vorssaint-mac-tools-research.md) — ersetzt Rectangle + Clipboard-Manager, NICHT eqMac (kein EQ) / BetterDisplay (kein DDC/CI) / Monocle (kein Tiling)

- [Skill install conventions](skill-install-conventions.md) — ~/.agents/skills canonical, relative symlink into ~/.zcode/skills, register in skill-routing.md; npx skills add -g does this automatically

- [cdp skill (browser-harness-js)](cdp-skill-browser-harness.md) — Chrome-via-CDP JS harness installed 2026-08-23; CLI on PATH, REPL on 127.0.0.1:9876, Chrome CDP port 9223

- [gstack deep-dives knowledge base](gstack-deep-dives-knowledge-base.md) — ~/.agents/knowledge/gstack-deep-dives with graphify graph (90 nodes, 21 communities); check before building new skills

- [Skill reference etiquette](skill-reference-etiquette.md) — [$name] tags mean: load the skill AND apply its methodology for real

- [One action, not tables](feedback-one-action-not-tables.md) — nach "mach selbst/volle Freigabe": selbst prüfen, handeln; Nutzer-Aktion = EINE klare Aktion, keine Szenario-Tabellen

- [Z.AI Coding Plan Limits](zai-coding-plan-limits.md) — weekly+5h Credit-Caps selbst auf Pro; [1310]=Cap; Fanout verbrennt Quota; 3 Z.AI-MCP-Server eingetragen mit Key-Platzhalter- [AutoClaw Full-Stack-Builder](autoclaw-full-stack-builder.md) — 06.09. Agent+7 Skills+Write-Guard eingerichtet; JWT pro-Modell in openclaw.json, nur additiv editieren; Config greift nach App-Neustart
- [Legal-Ops-Native-Status](legal-ops-native-status.md) — 06.09. P0-Diagnose: Verschmelzung FUNKTIONIERT (live verifiziert, Port 7070/Ollama); „kaputt" = 4-App-Varianten-Wirrwarr → Aufräumen mit GO; STATE.md im Projekt
- [LOKI Projekt-Map](loki-project-map.md) — 06.09. 17:30: Legal-Ops gelöst, Atlas-Takeover läuft LIVE in AutoClaw, TODO-App fertig, Paraletts=Prototyp, Barbulls=Wix+Scaffold; Q1 entlastet, Q1b Home-Repo neu; Source of Truth = ~/LOKI_PROJECT_MAP.md
