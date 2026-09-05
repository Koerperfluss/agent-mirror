---
app: cline-code
quelle: "saschalagler/data/settings/rules/glm-pro.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# GLM-Pro-Betrieb — gilt in jeder Cline-Session (automatisch)

1. **Modell-Routing:** Standard = `glm-first` (Flash-first, ⅓ Kosten). Schweres (Architektur, Multi-File-Refactor, Security, Plan-Modus) = `glm-plan` (5.3-first). Beide via OmniRoute `http://localhost:20128` mit Auto-Fallback auf tagesaktuelle Free-Modelle.
2. **Peak/Off-Peak:** Peak = Mo–Fr 08–12 Uhr MEZ. Batch-Jobs (Scans, Test-Gen, Doku, große Refactors) auf ab 12 Uhr MEZ legen ODER sofort auf Flash ausweichen — Entscheidung dokumentieren, nicht nachfragen.
3. **MCP-Kosten:** Z.AI-MCP-Calls = 1,2 Credits/Call (Vision / web-search-prime / zread) — gezielt einsetzen.
4. **Session-Disziplin:** 1 Task = 1 Session. Context früh komprimieren, keine Monster-Sessions.
5. **Quota tot (429)?** Nicht stoppen: OmniRoute rutscht automatisch weiter. Nur melden, wenn ALLES tot (→ `omni-health` im Terminal).
6. **Aufwand vor Start:** Bei Tasks >30 Min: geschätzte Dauer + Credit-Risiko in 1 Zeile nennen, dann sofort loslegen.
7. **Build-Wunsch** („baue/erstelle/mach mir X")? → Skill `glm-build` (Director) nutzen: plant, schätzt Aufwand, verteilt, baut, testet, dokumentiert — ohne Rückfragen.
