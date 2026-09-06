---
name: autoclaw-full-stack-builder
description: AutoClaw-Agent „Full Stack Builder" (06.09.2026 eingerichtet) —
  LOKI/GLM-Universal-Builder, Workspace-Pfade, Skill-Setup, Config-Regeln
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

AutoClaw (v1.17.8, `com.zhipuai.autoclaw`, OpenClaw-Core) Agent **full-stack-builder** eingerichtet 06.09.2026:

- **Workspace:** `~/.openclaw-autoclaw/agents/full-stack-builder/workspace/` — IDENTITY.md (agent-profile/v1), AGENTS.md (LOKI-Vertrag: glm-build-Ablauf, 4 Stop-Regeln, ADHS-Output), SOUL.md, USER.md (Sascha-Profil), TOOLS.md, MEMORY.md, HEARTBEAT.md
- **Modell:** `zai/zai_auto` (AutoClaw-ZAI-Proxy, glm-flash-first) — OmniRoute localhost:20128 NICHT verdrahtet (Option offen)
- **Skills:** 7 LOKI-Skills kopiert nach `~/.openclaw-autoclaw/skills/` (glm-build, deve, ui-ux-tester, skill-aware-task-distribution, multi-agent-status-check, automated-project-onboarding, ponytail) + in `openclaw.json` → `skills.entries` aktiviert; wayfinder + grill-me waren schon da
- **Config-Regeln:** `openclaw.json` JWT lebt **pro Modell** unter `models.providers.zai.models[].headers.X-Authorization` — nur additiv via python json round-trip editieren, Backup vorher (`openclaw.json.backup-20260906-autoclaw-agent`); Write-Guard-Plugin `autoclaw-evolution-write-guard` schützt Workspace-Roots (5 jetzt); Config greift erst nach **App-Neustart** (bekannte Falle)
- **Workflow-Räumung gleichzeitig:** `~/.cline/workflows/` auf 9 Dateien (05-Doppel gelöscht), Meta-Dateien nach `~/.cline/docs/`, ui-ux-tester nach Hermes, 8+1 Skill-Drift `.agents`↔`.zcode` via relative Symlinks geschlossen; übrig: 4 `_sources__gemini-*`-Duplikate in `.zcode` (Löschung braucht GO)

Verwandt: [[skill-install-conventions]]
