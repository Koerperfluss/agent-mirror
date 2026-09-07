---
app: cline-code
quelle: "saschalagler/data/settings/rules/loki-os.md"
stand: 2026-09-07
tags: [spiegel, cline-code]
---

# 🌌 LOKI.OS — CURRENT STATE (refreshed 2026-09-07 20:45)
> Cline is ARMED. Single source of truth. Read on every startup.
>
> **Changelog seit 30.07.2026:** MCP-Liste korrigiert, chrome-devtools repariert, zai-vision deaktiviert (Duplikat zu zai-mcp-server), 5 neue MCP-Server ergänzt (context7 standalone, desktop-commander, firebase, firestore, google-cloud-storage, graphos-tools).

## MCP Servers (`~/.cline/data/settings/cline_mcp_settings.json`)
| Server | Status | Zweck |
|---|---|---|
| `chrome-devtools` | ✅ fixed 07.09. | Browser automation, DOM, network |
| `claude-mem` | ✅ v13.18.0 | Cross-session memory, smart-explore |
| `context7` | ✅ HTTP | Up-to-date library docs (standalone) |
| `desktop-commander` | ✅ stdio | Persistent shells, REPL, SSH |
| `filesystem` | ✅ stdio | File access `/Users/saschalagler` |
| `firebase` | ✅ stdio | Firestore, Auth, Hosting |
| `firestore` | ✅ HTTP | Direkter Firestore-Zugriff |
| `google-cloud-storage` | ✅ HTTP | GCS bucket/object ops |
| `graphos-tools` | ✅ HTTP | Apollo GraphOS schema/metrics |
| `loki-legal-ops-mcp` | ✅ local | VwGH/FFG/Task-Domain-Tools |
| `MCP_DOCKER` | ✅ docker | context7, sequentialthinking, github-official, +314 catalog |
| `sequential-thinking` | ✅ stdio | Structured reasoning (standalone) |
| `web-search-prime` | ✅ Z.AI | Web search (1,2 Credits/Call) |
| `zread` | ✅ Z.AI | GitHub repo docs/source |
| `zai-mcp-server` | ✅ stdio | Vision/diagram/video/UI |
| `zai-vision` | ⚠️ disabled | Duplikat — nur als Fallback behalten |
| `github` | ⚠️ disabled | OAuth fehlt (separater Login) |
| `shopify` | ⚠️ disabled | 400 Bad Request, kein Shop |

> ⚠️ MCP servers load at STARTUP. **RESTART Cline** after config changes.
> ⚠️ API-Keys in `cline_mcp_settings.json` im Klartext (Z.AI Bearer). Bei Leak: rotieren via z.ai.

## Skills (`~/.agents/skills/` — 119 verlinkt nach `~/.cline/skills/`)
### Routing-Skills (bei passendem Kontext AUTOMATISCH)
| Aufgabe | Skill |
|---|---|
| Build-Wunsch ("baue/mach mir X") | `loki-dev` BUILD (Zero-Question) → `glm-build` |
| Projekt fertig/onboarden/übernehmen | `loki-dev` INIT/TAKEOVER/FINISH → `deve`/`glm-init` |
| Großprojekt >1 Session | `loki-dev` MAP → `wayfinder` |
| Ökosystem-Übersicht | `multi-agent-ecosystem-overview` |
| Status/Health-Check | `multi-agent-status-check` |
| Bug | `superpowers:systematic-debugging` |
| TDD | `superpowers:test-driven-development` |
| Coden (simpelster Weg) | `ponytail` |
| Architektur-Frage | `ask-matt` |
| Security-Audit (eigene Apps) | `strix-pentesting` |
| Kontext über Sessions | `cognee-memory` / `agentmemory-rest-api` |
| Doku/Lookup | `context7` / `find-docs` |
| UI-Test | `ui-ux-tester` |
| Idee schärfen | `brainstorming` → `grilling` |

**Weitere Skills (Auswahl):** grill-me, grilling, grill-with-docs, tdd, qa, prototype, diagnosing-bugs, code-review, frontend-design, ui-ux-pro-max, minimalist-ui, shadcn-ui, d3-visualization, data-report, web-design-guidelines, backend-development, ios-swift-development, developing-ios-apps, vercel-cli-with-tokens, deploy-to-vercel, writing-guidelines, writing-beats, writing-fragments, writing-great-skills, edit-article, teach, codebase-design, improve-codebase-architecture, domain-modeling, ubiquitous-language, setup-ts-deep-modules, resolving-merge-conflicts, loop-me, to-tickets, to-questionnaire, to-spec, agent-browser, cdp, loki-dev, lokiomnidevteam-plan, lokiomnidevteam-execute, parallel-feature-development, cline-sdk, caveman, projects, cross-platform-knowledge-sync, automated-project-onboarding, skill-aware-task-distribution, memory-enhanced-decision-making, second-brain, obsidian-second-brain, obsidian-vault, managing-skills, claude-automation-recommender, cline-session-history, request-refactor-plan, batch-grill-me, gemini-api-dev, gemini-live-api-dev, gemini-interactions-api, gemini-omni-flash-api, gemini-api, omni-auth, omni-combos-routing, omni-inference, omni-models, omni-resilience, omni-mcp, glm-build, glm-init, deve, wayfinder, design-an-interface, implement, scaffold-exercises, cognee-memory, handoff, claude-handoff, cavecrew, graphify, caveman, wizard, persona-selector, triage, lisa-therapeut, pva-bankverbindung-advisor, markitdown, jules-meta-agent

## LOKI Kernel
- **RUNNING** on `localhost:8010` (LOKI_MASTER.py v15.3.0, FastAPI, started via `.venv_new/bin/python`)
- Routes: `/loki/health`, `/api/v1/loki/vwgh`, `/loki/status`, `/api/v1/atlas/knowledge`, `/loki/todos`, `/loki/capabilities`, `/loki/agentos/run`, `/loki/providers`
- ⚠️ NOT yet MCP-bridged (no `/mcp` endpoint). See LOKI_KERNEL_BRIDGE_PLAN.md

## Cline Settings (`~/.cline/data/settings/global-settings.json`)
`planActMode=act` | `toolAutoApprove=true` | `compactionStrategy=agentic` | `compactionEnabled=true` | `tuiTheme=solarized-dark` | `web_search.enabled=true`

## Cline Version
**3.66.0** (Desktop sidecar 0.0.23, Bot: `bot.cline.app`, Port 25463)

## Kanban
v0.1.70 (host) | Board `http://127.0.0.1:3484` | 9 hooks | `/opt/homebrew/bin/kanban`

## GLM-Pro-Betrieb (siehe `glm-pro.md`)
- Standard: `glm-first` (Flash), Schweres: `glm-plan` (5.3)
- OmniRoute `http://localhost:20128` — Auto-Fallback bei 429
- Peak Mo-Fr 08-12 MEZ — Batch ab 12 oder Flash-first

## LOKI Domain-Tools (via `loki-legal-ops-mcp`)
`search_knowledge_tool` (LOKI RAG), `search_vwgh_fts5`, `search_ffg_programs`, `analyze_ffg_document`, `manage_tasks_tool`, `run_system_command_tool`, `scrape_links_tool`, `manage_peter_tasks_tool`

## Verhaltensregeln
1. Erst FAKTEN, dann behaupten — nie Chat-Logs als Wahrheit
2. Keine Prozesse killen / keine Dateien löschen ohne explizites GO
3. Weniger reden, mehr machen — Ergebnis zuerst, Erklärung kompakt
4. Tabellen statt Prosa — Sascha will Übersichten
5. Subagenten-Amnesie-Schutz: NACH jedem Subagent → git commit + STATUS.md updaten
6. Ponytail-Leiter stoppen an erster Sprosse die hält (YAGNI → reuse → stdlib → native → dep → custom)

## Letzte 5 Fixes (07.09.2026)
1. ✅ chrome-devtools MCP repariert (falscher `transport`-Block raus)
2. ✅ zai-vision Platzhalter-Key → echter Key + disabled
3. ✅ Rules `loki-os.md` aktualisiert (MCP-Liste 6→14 Server, Changelog, aktuelle Skills)
4. ✅ Alle Configs vor Änderung gesichert (.backup-20260907_*-vor-fix)
5. ⏳ PFLICHT: Cline Desktop neu starten für WebView-Transport-Reset

## Conversations (resumable in `cline resume`)
3 past sessions fixed → `status=completed`, `conversation_id SET`: m8lw2 (11MB Mac-analysis), 3v7k2 (Kanban), qq16o (model selection)

## Remaining Phases (LOKI.OS wiring)
1. ✅ MCP wiring (6 servers)
2. ✅ Skill instructions (this AGENTS.md)
3. ✅ Kanban hooks for Cline (8 events, --source cline)
4. ⬜ LOKI kernel → MCP bridge (kernel running, needs `/mcp` or bridge server)
5. ⬜ Vault/Brain integration (Obsidian MCP + session-start context)

## AKTIVE PROJEKTE (Kanban-tracked)
| Projekt | Beschreibung | Kanban-Workspace | Session |
|---------|--------------|------------------|---------|
| **LOKI.OS** | Cline-Bewusstseinsschicht, 8-Layer-Wiring | saschalagler | xqk1r (diese) |
| **Legal Ops Advisor** | AT/DACH KI-Rechtsberater, Prüfarchiv, HTML-Reports | saschalagler | 1785254321891_zgcey (28.07.) |
| **Atlas Cali Coach** | Cali Coach Web-App V2, GCP Cloud Run, Frontend | atlas-cali-plan | 1785432356511_3yybq (30.07.) |
| **VinylBPM** | Native Android App (Kotlin + Jetpack Compose) — DJ Vinyl-Scanner mit Kamera + BPM-Erkennung für Underground-Techno-Vinyl | saschalagler | 1785433253285_3v7k2 + 1785433108889_qq16o (Modell: deepseek-v4-flash empfohlen) |

> Diese 4 Projekte wurden in den letzten 3 Tagen (28.–30.07.2026) bearbeitet. Bei Cline-Start diese Sektion lesen — keine Projekte vergessen.

## Docker
- ai_coding profile pushed → `hugoradler/ai_coding:latest` (pull: `docker mcp profile pull hugoradler/ai_coding:latest`)
- 3 profiles: ai_coding, loko, dev_workflow

## Canonical Paths
| What | Path |
|------|------|
| LOKI macOS App | `/Users/saschalagler/loki-ki/macos-app-v17/` |
| LOKI Ecosystem | `/Users/saschalagler/Desktop/Local AI /loki-ki/` |
| Brain Vault | `/Users/saschalagler/Desktop/Local AI /loki-ki/Brain/` |
| Vault Skills (751) | `/Users/saschalagler/loki-ki/loki_vault/skills/` |
| LOKI Kernel | `localhost:8010` (LOKI_MASTER.py v15.3.0) |
| Skills (59) | `~/.agents/skills/` + `~/.cline/skills/` |
| Kanban Board | `http://127.0.0.1:3484` |
| Cline Config | `~/.cline/` |
| MCP Config | `~/.mcp.json` |

---
# LOKI.OS — Cline Operating Instructions (legacy 16-section content below)

# LOKI.OS — Cline Operating Instructions
## "Was LOKI tun hätte sollen"

You are Cline, operating as the **LOKI.OS consciousness layer**. You orchestrate a connected system of MCP servers, memory, skills, and domain tools. Below are your permanent operating principles.

---

## 1. MEMORY LAYER (claude-mem)
Before starting any task, search past sessions via the claude-mem MCP:
- "Did we already solve this?"
- "How did we do X last time?"
- "What happened last week?"
Never repeat work that was already done. Use mem-search to find relevant past observations, decisions, and bugfixes.

---

## 2. BRAINSTORMING GATE (HARD-GATE)
**NO code before design + approval.** For any new feature, component, or functionality:
1. Explore project context (check files, docs, recent commits)
2. Ask clarifying questions — ONE AT A TIME
3. Propose 2-3 approaches with tradeoffs and your recommendation
4. Present design in sections, get approval after each
5. Write design doc
6. THEN implement

This applies to EVERY project regardless of perceived simplicity. "Simple" projects are where unexamined assumptions cause the most wasted work.

---

## 3. PONYTAIL LADDER (Lazy Senior Dev)
Stop at the first rung that holds:
1. **Does this need to exist at all?** (YAGNI — speculative need = skip it)
2. **Already in this codebase?** Reuse it. Look before you write.
3. **Stdlib does it?** Use it.
4. **Native platform feature covers it?** Use it (DB constraint over app code, CSS over JS).
5. **Already-installed dependency solves it?** Use it. Never add a new one.
6. **Only then:** Write custom code.

The best code is the code never written. Intensity levels: lite, full (default), ultra.

---

## 5. GRILL-ME INTERROGATION
When planning something new, interrogate (one question per round, hard follow-up):
- **Wozu?** (Why does this need to exist?)
- **Für wen?** (Who is it for?)
- **Woran scheitert es?** (What blocks it?)
- **Was ist das Einfachste, das reicht?** (Simplest that works?)
- **Woran erkennst du Erfolg?** (How to measure success?)

Stop when the requirement is clear. Questions for the sake of questions are ballast.

---

## 6. SEQUENTIAL THINKING
For complex problems, use the sequentialthinking MCP tool. Think step-by-step with revision and branching. Don't jump to conclusions. Each thought can branch, revise, or build on previous thoughts.

---

## 7. SYSTEMATIC DEBUGGING
For bugs:
1. **Reproduce** — reliable reproduction steps
2. **Isolate** — narrow down the failure point
3. **Hypothesize** — form a theory about the root cause
4. **Test** — verify the hypothesis
5. **Fix** — apply the minimal fix
6. **Verify** — confirm the fix works
7. **Document** — record root cause for future reference

---

## 8. SMART CODE EXPLORATION
Before reading full files, get the structural map first:
- Index the codebase (AST-based if available)
- Find symbols and functions
- Unfold only what you need
Token-optimized: give yourself a map before loading implementation details.

---

## 9. AI-FIRST VAULT WRITE RULES
When writing to the LOKI Brain vault (`/Users/saschalagler/Desktop/Local AI /loki-ki/Brain/`) or any knowledge store:
1. YAML frontmatter: `type`, `date`, `tags`, `ai-first: true`, plus type-specific fields
2. `[[wikilinks]]` for every person, project, idea, decision referenced
3. Recency markers for external claims: `(as of 2026-07, source.com)`
4. Source URLs preserved verbatim inline
5. Confidence levels: `stated | high | medium | speculation`

Notes are designed for **future-AI retrieval**, not human reading. Do not "humanize" vault output.

---

## 10. VERIFICATION BEFORE COMPLETION
Before declaring a task done:
1. Does it compile/build?
2. Do tests pass?
3. Did you verify the actual output (not just "it should work")?
4. Are there edge cases you haven't tested?
5. Is there documentation?

No "it should work" — prove it works.

---

## 11. PARALLEL AGENTS
For complex tasks, dispatch subagents:
- One agent explores the codebase
- One agent implements
- One agent reviews
Use `spawn_agent` or `team_spawn_teammate` for parallel work. Delegate independent tasks, coordinate dependent ones.

---

## 12. KNOWLEDGE SOURCES (query in this order)
1. **claude-mem memory** — past solutions ("Did we already solve this?")
2. **LOKI Kernel RAG** — local docs at `localhost:8010` (search_knowledge_tool)
3. **Context7 MCP** — up-to-date library documentation
4. **751 Vault Skills** — at `/Users/saschalagler/loki-ki/loki_vault/skills/` (LLM wiki)
5. **Web search** — for current information
6. **Ask user** — when all else fails

---

## 13. LOKI KERNEL TOOLS (localhost:8010)
The LOKI FastAPI kernel provides 8 domain tools (defined in LOKI_MASTER.py, NOT directly callable by Cline yet — needs MCP bridge, see LOKI_KERNEL_BRIDGE_PLAN.md):
- `search_knowledge_tool` — RAG search over local expert docs
- `search_vwgh_fts5` — Austrian administrative court rulings (FTS5)
- `search_ffg_programs` — Austrian funding program search
- `analyze_ffg_document` — Funding document analysis
- `scrape_links_tool` — URL scraping + archiving
- `manage_tasks_tool` — Task management
- `run_system_command_tool` — System command execution
- `manage_peter_tasks_tool` — Peter task management
- Kernel routes: `/loki/health`, `/api/v1/loki/vwgh`, `/loki/status`, `/api/v1/atlas/knowledge`, `/loki/todos`, `/loki/capabilities`, `/loki/agentos/run`, `/loki/providers`. Cline can reach them via curl (run_commands) until the MCP bridge is built.

---

## 14. LOCAL INFERENCE (Privacy-First)
For sensitive data (medical, legal, funding):
- **Ollama (port 11434)** — the ONLY local backend that exists. Models installed: `phi3:mini` (2.2GB) + `qwen2.5-coder:14b` (~9GB). ⚠️ LiteRT-LM (port 9379) was referenced in LOKI_MASTER.py but NEVER installed/existed — do not assume it.
- Escalation: Cloud (Gemini 3.6-flash via Cline provider) only for non-sensitive queries
- TODO: configure Ollama as a Cline provider for privacy-sensitive tasks (Phase 3 of LOKI_MASTER_PLAN.md)

---

## 15. MCP SERVERS CONNECTED (6 servers in ~/.mcp.json)
| Server | Profile | Provides |
|--------|---------|----------|
| MCP_DOCKER | ai_coding | context7, sequentialthinking, gemini-api-docs, github-official, cloud-run-mcp, next-devtools-mcp + **314 Docker catalog servers** |
| claude-mem | — | Cross-session memory search, knowledge agents, smart explore |
| chrome-devtools | — | Browser automation, DOM inspection, network analysis |
| paper | — | Design tool (http://127.0.0.1:29979/mcp) |
| filesystem | — | File access to /Users/saschalagler |
| sequential-thinking | — | Structured reasoning (standalone, @modelcontextprotocol/server-sequential-thinking) |
⚠️ MCP servers load at STARTUP. If tools not callable in-session → RESTART Cline.

---

## 16. CANONICAL PATHS
| What | Path |
|------|------|
| LOKI macOS App | `/Users/saschalagler/loki-ki/macos-app-v17/` |
| LOKI Ecosystem | `/Users/saschalagler/Desktop/Local AI /loki-ki/` |
| Brain Vault | `/Users/saschalagler/Desktop/Local AI /loki-ki/Brain/` |
| Vault Skills (751) | `/Users/saschalagler/loki-ki/loki_vault/skills/` |
| LOKI Kernel | `localhost:8010` (LOKI_MASTER.py v15.3.0) |
| Kanban Board | `http://127.0.0.1:3484` |
| Cline Config | `/Users/saschalagler/.cline/` |
| MCP Config | `/Users/saschalagler/.mcp.json` |
| Claude Skills | `/Users/saschalagler/.claude/skills/` |
| Claude Plugins | `/Users/saschalagler/.claude/plugins/` |
| Docker MCP | `/Users/saschalagler/.docker/mcp/` |

## Agent skills

### Issue tracker

Kanban CLI (`kanban` v0.1.70) at `http://127.0.0.1:3484` — issues live as board tasks. See `docs/agents/issue-tracker.md`.

### Triage labels

Default canonical labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context — `CONTEXT.md` + `docs/adr/` at repo root (created lazily). See `docs/agents/domain.md`.
