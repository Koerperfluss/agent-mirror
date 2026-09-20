---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/loki-os-harness-settings-sessions.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

---
name: loki-os-harness-settings-sessions
description: Die 3 kanonischen ZCode-Sessions mit Saschas
  LOKI-OS-Harness-Architektur (Settings/Skills/MCP/Baupläne) — Session-IDs +
  6-Schaltstellen-Soll-Stand
metadata:
  node_type: memory
  type: project
  originSessionId: sess_e8798d40-41ac-4fb4-8725-69b28c7e7475
---

Saschas LOKI-OS-Harness-Architektur ist in 3 kanonischen ZCode-Sessions dokumentiert (von ihm selbst am 20.09.2026 als „DEINE ZCODE CLINE ANTIGRAVITY AGENT HARNESS SETTINGS" benannt — bei Harness-/Architektur-Fragen zuerst diese laden, per ReadSessionContext strategy=handoff):

- **sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc** (13.09.): „ZCode MCP-Setup & Skill-Distribution" — 5 Harnesses aus EINER Quelle `~/.agents/STANDARD-SKILLS.md` (sync via `~/.agents/tools/sync-standard-skills.sh`); Root Cause 13.09: config.json invalid (leerer matcher) → 16 MCPs + Hooks geworfen; 6-Schaltstellen-Soll: config.json valid + hooks (SessionStart/PreToolUse/UserPromptSubmit), `~/.zcode/AGENTS.md` 73 Zeilen, gate-enforcer, 10 Agents in `~/.zcode/agents/`, 7 Commands in `~/.zcode/commands/`, `~/.agents/tools/config-health.py` Selbstcheck-Hook + Skill `pruef-team`
- **sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e** (08.09.): „Zcode Skills analysieren & ausmisten" — 126→96 Skills konsolidiert; LOKI-OS-Endstand: 1 Pipeline (loki-dev, Modi INIT/BUILD/TAKEOVER/FINISH/MAP), 4 Agents (@code-architect/@explore/@implementer max3/@reviewer), 2 Hooks, Prüfebenen-Hierarchie; Hub-1006-Netz-Fix (DNS 1.1.1.1/8.8.8.8, 9,7-GB-Rollout-Datei archiviert)
- **sess_055615ab-ce73-42ee-8e97-3f339e12abb6** (30.08.): „Graphify + Sequential Thinking" — Muster: Skill kanonisch in `~/.agents/skills/<name>/` + Symlink `~/.zcode/skills/<name> → ../../.agents/skills/<name>`; MemoryIngestApp (Swift, Build grün); 6/6 Skills repariert

**Why:** Sascha brannte („DU BIMBO"), weil eine neue Session nur die Wayfinder-Maps kannte, nicht diese Settings-Sessions — alte Session-Kontexte laden nicht automatisch.

**Subagent-Drift (Befund 20.09., Panel vs. `~/.zcode/agents/`):** Alle 10 Agent-Dateien existieren, aber ZCode-Panel „Installed" zeigt nur 7. (a) cavecrew-investigator/builder/reviewer fehlen im Panel — Frontmatter hat kein `model:`-Feld; Muster-Fix: `model:` ergänzen (GLM-5.3-Flash). (b) `gate-enforcer-test` läuft auf ClinePass llama-3.1-70b, `reviewer` auf ClinePass qwen3.8-max (UUID 3a11f548… = ClinePass, Map D8); Soll-Name laut sess_6ec2db7a war „gate-auditor". (c) `~/.zcode/fix-subagents.sh` (SessionStart-Hook) heilt NUR Built-ins (Explore/general-purpose), nicht eigene Agenten. Reparatur angeboten, wartet auf Sascha-GO.

**How to apply:** Vor Harness-/Architektur-/Routing-Änderungen diese 3 Sessions (oder deja `sess_6ec2db7a`) laden; dejás config.json-Eingriffe sind additiv-verträglich (20.09. verifiziert, siehe [[deja-vu-install]]). Verwandt: [[wayfinder-skill-konsolidierung]], [[loki-os-ecosystem-stand]].
