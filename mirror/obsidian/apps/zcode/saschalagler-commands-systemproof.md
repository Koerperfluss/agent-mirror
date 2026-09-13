---
app: zcode
quelle: "saschalagler/commands/systemproof.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

---
description: Beweist in 60 Sekunden, ob das LOKI-System in DIESEM Chat wirklich aktiv ist. Führt 6 Live-Checks aus und urteilt PASS/FAIL mit Beweisen.
---

# /systemproof — Live-Beweis der System-Aktivierung

Führe SOFORT alle 6 Checks aus und antworte NUR mit der Tabelle + URTEIL:

1. **Regeln geladen?** Kennst du die Begriffe „Schnitt-0-Gate", „pruef-team", „Caveman/ADHS"? (Wenn du diese Anweisung liest, hast du auch AGENTS.md im Kontext → ✅)
2. **Gate-Hook aktiv?** Sag: „baue mir eine test app" würde den 🚦 GATE-Block auslösen — prüfe: erscheint der Block oben in DIESEM Chat als Hook-Injektion? (Falls ja, zitier seine 1. Zeile.)
3. **MCP aktiv?** Rufe `sequentialthinking` mit 1 Mini-Schritt auf → kommt ein Ergebnis?
4. **Agents verfügbar?** Dispatche `@cavecrew-investigator` mit Task „sag OK" → antwortet er?
5. **Commands da?** Existiert diese Datei: `ls ~/.zcode/commands/standardskill.md`
6. **Skills da?** Prüfe `ls ~/.agents/skills/wayfinder/SKILL.md`

## Output-Format
| Check | ✅/❌ | Beweis (1 Zeile) |
|---|---|---|
URTEIL: **SYSTEM AKTIV** (6/6) | **TEILWEISE** (n/6, nenne die toten) | **TOT** (<3/6 → sag „gate tot" im Haupt-Chat, dort wird das Prozess-Log gelesen)
