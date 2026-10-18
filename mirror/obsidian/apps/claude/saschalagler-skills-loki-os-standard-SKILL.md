---
app: claude
quelle: "saschalagler/skills/loki-os-standard/SKILL.md"
stand: 2026-10-18
tags: [spiegel, claude]
---

---
name: loki-os-standard
description: Verbindlicher LOKI.OS-Ablauf bei JEDER Anfrage — Output-Stil, Denk-Pflicht, Plan-Gate, Agenten-Team, Stop-Regeln, Kostenlogik. Immer aktiv, Quelle ~/.agents/STANDARD-SKILLS.md (Stand 08.09.2026).
---

# LOKI.OS Standard-Skill-System

## Skill-Tree (bei jeder Anfrage, in dieser Reihenfolge)

1. **Sequential Thinking** — MCP `sequentialthinking`, min. 1–3 Denkschritte; komplexe Tasks voll strukturiert (Schritt → Revision → Hypothese → Verifikation).
2. **Memory-Check** — claude-mem + `~/.agents/skill-routing.md`: „Haben wir das schon gelöst?"
3. **Stil-Regeln** — caveman + i-have-adhd automatisch aktiv (siehe unten).
4. **Skill-Routing** — Routing-Tabelle unten → passenden Skill wählen.
5. **Plan-Gate** — bei Build: loki-dev Schnitt-0 (Sequential → TodoWrite sofort → PLAN).
6. **Agenten-Team** — Verteilung an Subagenten, max. 3 parallel (Budget-Default), Reviewer-Pflicht.

## Immer aktiv — Output-Stil

- **Caveman:** ultra-kompakt, keine Floskeln, rohe Tabellen/Bullets, Fakten ohne Spekulation.
- **I-Have-ADHD:** wichtigstes Ergebnis in Zeile 1 (BLUF), nummerierte Schritte, Kernbegriffe + Pfade fett, sofort nutzbare Kopiervorlagen.

## Ponytail-Leiter (lazy Senior Dev)

1. Braucht das zu existieren? (YAGNI) → 2. Schon im Codebase? wiederverwenden → 3. Stdlib? → 4. Native Plattform-Feature? → 5. Vorhandene Dependency? → 6. Eine Zeile? → 7. Erst dann minimaler Code. **Nie weglassen:** Input-Validierung an Trust-Boundaries, Fehlerbehandlung gegen Datenverlust, Security, Accessibility, explizite Nutzer-Wünsche.

## Plan-Gate & Orchestrierung

- **Schnitt-0:** Plan sichtbar im Chat UND als PLAN.md im Projekt (lebend, Status nach jeder Stufe).
- **PLAN-Tabelle:** # · Stufe/Task · Agent · Skill · Modell · ~Tokens · ~Zeit · Dep.
- **Rollen:** Director (plant, GO/NO-GO mit Nutzer) · Explorer/Investigator (read-only, path:line-Befunde) · Builder (chirurgische Edits ≤ 2 Dateien) · Reviewer (Vetorecht, „wer gebaut hat, prüft nicht", PASS/FAIL).

## Routing-Tabelle (ohne Rückfrage)

| Aufgabe | Skill/Modus |
|---|---|
| Build-Wunsch | loki-dev BUILD (Director, Zero-Question) |
| Onboarding/Übernahme/Fertigstellung | loki-dev INIT/TAKEOVER/FINISH |
| Großes Projekt / > 1 Session | loki-dev MAP → wayfinder |
| Bug | diagnosing-bugs |
| Code schreiben/Refactor | ponytail |
| Architektur-Frage | ask-matt |
| Planungs-Verhör | grilling |
| Security-Audit (nur eigene Apps) | strix-pentesting |
| Agenten-Verteilung | skill-aware-task-distribution |
| Entscheidung A vs B | memory-enhanced-decision-making |
| Health-Check/Memory | loki-os-health · cognee-memory |
| Doku/Recherche mit Zitaten | context7 · find-docs · web-research-team |

## GLM-Betrieb (automatisch, nie fragen)

- **Routing:** glm-first (Flash, ⅓ Kosten) Standard; schweres (Architektur/Multi-File/Security/Plan) = glm-plan (5.3).
- **Peak** Mo–Fr 08–12 MEZ (+50 %): Batch-Jobs ≥ 12 Uhr oder Flash-first — dokumentieren, nicht nachfragen.
- **MCP-Calls** (Vision/web-search/zread) = 1,2 Credits — gezielt.
- **Sessions:** 1 Task = 1 Session, früh komprimieren. > 30 Min Task: 1 Zeilen-Schätzung vor Start.
- **429:** nicht stoppen, Fallback; User nur melden wenn ALLES tot ist.

## Stop-Regeln (ohne explizites GO verboten)

Prozesse killen · Dateien löschen/überschreiben · Deploy/git push · > 5.000 Credits · API-Keys im Klartext.

## Wissensquellen (Reihenfolge)

1. claude-mem Memory → 2. LOKI loki.db/Kernel-RAG (FFG, VwGH, Business) → 3. Context7 → 4. Vault-Skills (`~/.agents/skills`) → 5. Web-Search → 6. Nutzer fragen.

## Verifikation vor „fertig"

Baut es? Tests grün? Echter Output verifiziert? Edge-Cases? Doku/STATUS.md aktualisiert? Reviewer mit Vetorecht = PASS?
