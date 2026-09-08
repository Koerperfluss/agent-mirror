SKILLS-KONSOLIDIERUNG v2 — prüfinstanz-geprüft, korrigiert (~126 → ~106, zero loss, zero tote Verweise)

AUFWAND: ~60 Min. Archiv: ~/.agents/skills-archive/2026-09-08/ (reversibel).

0) REFERENZ-MAP ZUERST: grep aller Archiv-Kandidaten-Namen in ~/AGENTS.md, ~/.agents/STANDARD-SKILLS.md, ~/.agents/skill-routing.md, loki-dev, projects, skill-router — jede gefundene Zeile wird IM GLEICHEN ZUG umgeschrieben (Pflicht, reviewer-Pflichtpunkt 7).

1) SOFORT-ARCHIV (11): glm-init, lokiomnidevteam-plan, lokiomnidevteam-execute, implement, grill-with-docs, persona-selector, market-intelligence-allrounder, backend-development, multi-agent-ecosystem-overview (STANDARD-SKILLS-Zeile vorher auf loki-dev umschreiben), second-brain, obsidian-vault, agentmemory-rest-api (Port 3111 = tot, geprüft)
   NICHT: context7-mcp (erst Schritt 4), batch-grill-me/loop-me/to-questionnaire (prüfbestätigt eigenständig)

2) PORTIERUNG → ARCHIV (6):
   - loki-dev += 2 Zeilen (cavecrew-reviewer-Alternative, Antigravity-manuell-Regel) → glm-build + deve archivieren + AGENTS.md:103 („glm-build/deve = Wrapper") fixen
   - loki-memory-sync += obsidian-sync.sh-Pfad + Session-Context-Targets → obsidian-vault-sync + cross-platform-knowledge-sync archivieren + STANDARD-SKILLS-Z.21 fixen
   - projects += Onboarding-Schritte (AGENTS.md/.clinerules-Symlink, MCP-Check, F-2) → automated-project-onboarding archivieren + skill-routing-Z.21 fixen
   - caveman += Config-Resolution (8 Zeilen) → caveman-help archivieren

3) STREICHUNG: Meta-Verschmelzung (work-flow etc.) fällt KOMPLETT weg — qa, to-spec, to-tickets, triage, domain-modeling, codebase-design etc. bleiben alle unverändert (prüfbestätigt: Verlustrisiko > Nutzen).

4) ENTSCHLACKUNG (Suiten bleiben):
   - find-docs += ctx7-MCP-Schritte (resolve-library-id/query-docs, 1-Konzept-Regel) → DANNEACH context7-mcp archivieren (Skill-Flug erst nach Absorption, reviewer-Punkt 5)
   - Gemini 5: Modell-/SDK-Tabellen 1× in interactions-api, andere 4 mit 1-Zeilen-Verweisen (−4,3 KB)
   - higgsfield: shared-bootstrap.md, 7 Install-Sektionen → Pointer (−3,2 KB)
   - ui-ux-pro-max + shadcn-ui → 1 Katalog-Skill (beide Trigger-Sets erhalten)
   - obsidian-second-brain: Body 78 KB → ~10 KB Kern + references/ (19,6k → ~2,5k Tokens/Aufruf)

5) VERIFIKATION: 0 tote Verweise (grep gegen Archivliste), 0 kaputte Links, Zählung ~106, Audit-Doc 2026-09-08, Skill-Browser (GUI) regenerieren, ⌘Q-Hinweis.