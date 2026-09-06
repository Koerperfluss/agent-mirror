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

**Gate-Enforcement 06.09. (Abend 2):** `~/.agents/tools/gate-enforcer.py` als **UserPromptSubmit-Hook** registriert in ZCode (`config.json` hooks.events), Cline (`~/.cline/hooks/settings.json`) UND Claude (`~/.claude/settings.json`) — feuert bei Build-Triggern (baue/erstelle/mach mir/übernimm/onboard/fertig) die Gate-Injektion (Schnitt 0), Fragen/Analyse bleiben leer (ANTI-Regex). Backups: `*.bak-gate-20260906`. Unit-getestet (Trigger→Gate, „was ist…"→leer). Hooks greifen je App erst nach Session-/App-Neustart. Ollama.app = kein Harness, kein Gate nötig.

**UI-Steuerungs-Lektionen (06.09. 15:4x, live bewiesen):** (1) Agenten MÜSSEN per UI angelegt werden — App überschreibt openclaw.json beim Speichern mit ihrem Session-Stand, Datei-Edit allein fliegt raus. (2) UI-Klick-Rezept: Accessibility an → Fenster-Bounds (System Events) → `click at {x,y}` (Vorher App frontmost setzen!) → Element-Log bestätigt Ziel → für Textfeld-Eingabe: rekursiver AX-Finder (UI elements walk) + `set value` (keystroke verliert Fokus) → Button per Rekursion finden + click. Beweis: mac-operator komplett ferngesteuert erstellt (Name-Feld gesetzt → Create → Runtime zeigte 5 Agenten). (3) AutoClaw lief transloziert (AppTranslocation/Quarantäne) — Fix: `xattr -dr com.apple.quarantine /Applications/AutoClaw.app` + Restart. (4) App überschreibt IDENTITY/USER bei Agent-Create mit Generik — danach LOKI-Versionen zurückschreiben. (5) AutoClaw-Chat-Begriffe: „Agent Cluster"=Badge im Chat-Input (Parallel-Agent-Modus), Model-Auswahl=GLM-5.3-Flash-Dropdown, „Connect"=Telegram/WhatsApp-Bridge oben rechts.

**Update 06.09. (Abend):** Skills konsolidiert zu **loki-dev** (Master `~/.agents/skills/loki-dev/`, 5 Modi INIT/BUILD/TAKEOVER/FINISH/MAP) — glm-init/glm-build/deve/lokiomnidevteam-plan/-execute sind jetzt 3-Zeilen-Wrapper (Autoclaws Originale in `SKILL.md.bak-20260906`). **Schnitt-0-Orchestrierungs-Gate** eingebaut (Pflicht-Schritt): Sequential-Thinking-Zerlegung → TodoWrite sofort → PLAN-Tabelle im Chat (Stufe|Agent|Skill|Modell|~Tokens|~Zeit|Dep) → PLAN.md im Projekt; Grund: Nutzervorwurf „Plan nie sichtbar" war berechtigt — Skills sind passiver Text ohne Enforcement, jetzt ist das Gate in loki-dev + STANDARD-SKILLS (alle Harnesses gesynct) verankert. Parallelitäts-Regel dynamisiert: Task-Graph-berechnet, Budget-Default 3 (Quota-Schutz ZAI-Caps), mehr mit 1-Zeilen-Begründung. **mac-operator** Agent angelegt (Agent 5 in openclaw.json, Guard-Roots 5) — bedient Programme/macOS, Stop-Regel: nie User-Services killen ohne GO.
