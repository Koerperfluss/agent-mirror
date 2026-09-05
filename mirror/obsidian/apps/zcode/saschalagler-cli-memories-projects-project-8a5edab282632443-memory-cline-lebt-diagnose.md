---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/cline-lebt-diagnose.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: cline-lebt-diagnose
description: "Cline-tot-Panik" war 01.09. Fehlalarm — Standard-Diagnose: Prozesse/Ports checken (App+CLI+Hub 25463, Kanban 3484), 7890-Proxy-Fehler ist Altlast
metadata:
  type: project
---

Saschas Panik „cline weg, Datenbank/memory weg, nichts geht" (01.09.) war FALSCH-ALARM: Alle Prozesse liefen die ganze Zeit; der gepastete `ECONNREFUSED 127.0.0.1:7890` war ein Altlast-Fehler aus totem Proxy-Port — in KEINER Config vorhanden (geprüft: .zshrc, .env.loki, .claude-router.sh, cline_mcp_settings.json, global-settings.json; „7890"-Treffer in Sessions waren nur Token-Zahlen).

**Why:** Er verwechselt alte Session-Logs mit aktuellem Zustand; jede Panik kostet sonst 10+ Minuten Re-Diagnose.

**How to apply:** Bei „Cline tot"-Meldung diese 3 Checks: (1) `pgrep -fl "cline|kanban"` → App (/Applications/Cline Code.app), CLI (/opt/homebrew/bin/cline), hub-daemon sollten laufen; (2) Daten-Beweis: `ls ~/.cline/data/sessions | wc -l` (nie weg); (3) wenn API-Fehler mit Port 7890 → Altlast ignorieren, Provider-Status prüfen (providers.json lastUsedProvider — zai-coding-plan war damals 429-blockiert bis 20:18, Cline „hing" optisch daran). Regel: erst Prozesse messen, dann erst Config anfassen. Verwandt: [[cline-cli-version-trap]].
