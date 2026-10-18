---
name: memory-enhanced-decision-making
description: Trifft begründete Entscheidungs-Empfehlungen auf Basis von Session-Kontext, Audit-Findings und Memory. Aktivieren bei "entscheide", "was sollen wir tun", "Empfehlung", "/decide".
---

# Memory-Enhanced Decision Making — AUSFÜHRBAR

## Reale Wissensquellen (in dieser Reihenfolge)

1. `~/LOKI_SESSION_CONTEXT.md` — aktueller Stand + offene Punkte
2. `~/loki-ki/docs/AUDIT_LOKI_OS_2026-08-31.md` — verifizierte Findings F-1…F-7 mit Risiko/Aufwand
3. `~/loki-ki/MASTER_TODO.md` — Phasen-Prioritäten
4. claude-mem MCP — vergangene Lösungen ("Haben wir das schon probiert?")
5. Live-Check: `bash ~/.agents/skills/loki-os-health/status_check.sh` — aktueller Systemzustand

## Ablauf

1. **Kontext:** Was ist die Entscheidung? Typ (technisch/strategisch/priorität)?
2. **Memory-Query:** Quellen 1–5 durchgehen, relevante Fakten extrahieren (Quelle zitieren!)
3. **Optionen:** 2–3 Optionen mit Pros/Cons/Risiko — basierend auf Findings, nicht Bauchgefühl
4. **Empfehlung:** 🥇 eine Option klar benennen + Begründung + erste 3 konkrete Schritte
5. **Grenze:** Die ENDTSCHEIDUNG trifft der Nutzer — Empfehlung liefern und warten.

## Format (Tabelle)

| Option | Pros | Cons | Risiko | Aufwand | Quelle |
|---|---|---|---|---|---|
| 🥇 … | … | … | … | … | Audit F-x |
