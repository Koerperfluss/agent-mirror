---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-harness-sollstand.md"
stand: 2026-09-23
tags: [spiegel, zcode]
---

---
name: loki-os-harness-sollstand
description: LOKI-OS-Harness Soll-Stand — 6 Schaltstellen in ~/.zcode
  (config/hooks, 17 MCP, 10 Agenten, 7 Commands, Sync-Quelle, 2 Wayfinder-Maps)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_e8798d40-41ac-4fb4-8725-69b28c7e7475
---

LOKI-OS-Harness Soll-Stand (gebaut 13.09.2026 in sess_6ec2db7a/sess_ecb2e5e0/sess_055615ab; verifiziert 20.09.2026):

1. **Config** `~/.zcode/cli/config.json`: valide (Crash-Ursache 06.09.–13.09. war leerer `matcher: ""`), Hooks SessionStart/PreToolUse/UserPromptSubmit — gate-enforcer, block-dangerous-git, config-health.py (Selbstcheck bei Start), fix-subagents.sh, projects.py + deja-Hooks (20.09. additiv).
2. **MCP:** 17 Server (16 original + deja seit 20.09.).
3. **Agenten** `~/.zcode/agents/` (10, alle mit `model:` — gefixt 20.09. Abend): cavecrew ×3 = jetzt LOKALE Kopien (vorher Symlinks ins .gemini-caveman-Plugin) mit GLM-5.3-Flash · code-architect/implementer/qa-tester/config-auditor GLM-5.3-Flash · explore GLM-5.3 · gate-enforcer-test GLM-5.3-Flash (vorher llama-70b) · reviewer bleibt bewusst qwen3.8-max (stärkerer Reviewer, Sascha nicht widersprochen). Backups: `~/.zcode/agents.bak-20260920/` (+ Orig-Symlinks unberührt in .gemini). **23.09.-Aufräumung:** 7 Backup-Dateien (`*.bak-20260921.md`) lagen IM agents-Ordner und blähten die Zahl auf 17 (ZCode liest `*.md` als Agenten-Kandidaten!) → verschoben nach `~/.zcode/agents.bak-20260923/`, `ls` = genau 10. Agenten-Landkarte gesamt: 10 eigene + Plugin/Built-in-Typen (general-purpose, Explore-builtin, feature-dev ×3, agent-sdk ×2, adlc ×4, visual-judge ×4) = **25 Typen**.
4. **Commands** `~/.zcode/commands/` (7): init, kanban, projects, standardskill, todo, feierabend, systemproof.
5. **Eine Quelle:** `~/.agents/STANDARD-SKILLS.md` → `~/.agents/tools/sync-standard-skills.sh` verteilt an 5 Harnesses (ZCode AGENTS.md, Claude CLAUDE.md, Cline CLAUDE.md, Gemini GEMINI.md, Hermes SOUL.md). 20.09. Abend: Routing-Tabelle B erweitert (deja-history, deja-search, cline-session-history, investigate-first) + skill-routing.md — Sync gelaufen und verifiziert. `~/.zcode/skills/` ist leer (Inhalt liegt redundant in skills.bak-20260920; Skills laden kanonisch aus ~/.agents/skills).
6. **Orchestrierung:** loki-dev = 1 Pipeline, 5 Modi (INIT/BUILD/TAKEOVER/FINISH/MAP); 2 Wayfinder-Maps: `~/.agents/.wayfinder/map.md` (Skill-Konsolidierung, Tickets 10+11 offen) und `~/loki-ki/.wayfinder/map.md` (LOKI.OS Körperfluss-Automation, T-01…T-04).

Regel-Änderungen immer: 1× in STANDARD-SKILLS.md editieren + `bash ~/.agents/tools/sync-standard-skills.sh` — nie in die Kopien. **Skills-Mirror (23.09., Sascha-Wut über „6 geroutete Skills fehlen in Claude komplett"):** sync-standard-skills.sh um Mirror-Loop erweitert (Backup `.bak-20260923`) — linkt ab jetzt JEDE fehlende Skill-Mappe aus `~/.agents/skills` als Symlink nach `~/.claude/skills` (kanonisch+Symlink-Muster, sess_055615ab). 23.09. gelinkt: loki-os-health, deja-search, gsd-core, roo-code, ralph-loop, coderabbit + automatisch 3 weitere (frontend-design-hub, fc-nginx-website, skillshare-sync) — alle ✅ SKILL.md erreichbar verifiziert. Kontext: Sascha nutzt Claude Code faktisch nicht (letzte Session 15.09., deja-Install 20.09.) — ZCode ist sein System. Verwandt: [[deja-vu-install]].
