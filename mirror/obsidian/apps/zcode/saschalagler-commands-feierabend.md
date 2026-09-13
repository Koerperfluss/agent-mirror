---
app: zcode
quelle: "saschalagler/commands/feierabend.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

---
description: Abend-Logbuch: Tag sammeln, ins Logbuch schreiben, Kalender-Eintrag
---

# 🌙 Feierabend-Routine

Führe die folgenden Schritte in dieser Reihenfolge aus:

1. **Tag sammeln**: `python3 ~/.agents/tools/daily_sweep.py` ausführen und Output lesen.
2. **Destillieren**: Pro Projekt 3–5 ADHS-Bullets (kurz, Ergebnis-fokussiert, keine Prosa) mit Tool-Tags wie `[ZCode]`, `[Git]`, `[Cline]` im Chat zeigen.
3. **Logbuch schreiben**: Heutige Datei `~/.agents/memory/logbuch/<heute>.md` ergänzen — **append-only**: Bullets unter der jeweiligen Projekt-Sektion (`## LOKI.OS` usw.) anhängen, bestehende Zeilen NICHT ändern, und der Bereich ab `## ✍️ Meine Notizen` ist TABU (nichts anhängen, nichts ändern). Frontmatter `status: abgeschlossen` setzen. Falls die Datei fehlt: Struktur mit Frontmatter (`date`, `projects`, `status`) und den Sektionen `## <Projekt>`, `## Rohdaten (Sweep)`, `## ✍️ Meine Notizen` anlegen.
4. **Kalender-Event**: Via `osascript` in Kalender.app ein Event „Logbuch <Datum>" für heute 18:00–18:15 anlegen, mit den Bullets als Beschreibung. Vorher prüfen:
   ```applescript
   tell application "Calendar" to get name of calendars
   ```
   Falls ein Gmail-Kalender in der Liste enthalten ist, das Event dort anlegen, sonst im Default-Kalender.
5. **Beweis nennen**: Am Ende explizit den Logbuch-Dateipfad und den bestätigten Kalender-Event-Namen mit Datum nennen.
