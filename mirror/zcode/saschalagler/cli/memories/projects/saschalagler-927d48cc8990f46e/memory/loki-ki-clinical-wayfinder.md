---
name: loki-ki-clinical-wayfinder
description: Zweite Wayfinder-Map ~/loki-ki/.wayfinder/map.md (LOKI.OS &
  Körperfluss Clinical Automation) — alle 4 Frontier-Tickets T-01..T-04 am
  20.09.2026 existenz- und funktionsverifiziert, noch nicht auf der Map abgehakt
metadata:
  node_type: memory
  type: project
  originSessionId: sess_e8798d40-41ac-4fb4-8725-69b28c7e7475
---

Zweit-Map neben der Skill-Konsolidierungs-Map in `~/.agents/.wayfinder/` — Sascha reagierte empfindlich, als „wayfinder los" zuerst die falsche Map traf: „wieso sind MEINE LOKI OS SYSTEM BAUPLÄNE ARCHITEKTUR NICHT DA?". Immer beide Maps prüfen: `~/.agents/.wayfinder/` UND `~/loki-ki/.wayfinder/`.

**Map-Stand (20.09.2026, live verifiziert):**
- Destination: Vollautomatik Körperfluss — Patienten-Dok-Drop → Agenten-Reasoning (P-03 Physio Lead, P-01 Architect, P-06 Sascha-Clone) → 4-Seiten-Master-Dossier + exakt 1 DIN-A4-Handout via SQLite/FTS5 + Chrome-Headless.
- T-01 `~/loki-ki/services/loki_clinical_pipeline.py` (12,4 KB, 18.09.) — CLI `--help` Exit 0
- T-02 `~/loki-ki/templates/` (template_dossier_a.html, template_worksheet_b.html, handouts/)
- T-03 `~/.local/bin/loki-clinical` — globaler CLI-Wrapper, funktioniert
- T-04 Watchdog-Modus `--watch` im selben Pipeline-Script
- D-01: `~/loki-ki/data/loki.db` (7,6 MB) — 238 EBM-Studien, 54 Patientendossiers
- Fog (Not yet specified): Obsidian-Vault-Integration, Web-UI im LOKI-Dashboard (8010/5188), EBM-Zitationsprüfung via scite.ai
- Next: Tickets T-01..T-04 mit echtem Output (z. B. `loki-clinical --patient Adelina`) verifizieren und auf der Map schließen — nur mit GO.

Verwandt: [[wayfinder-skill-konsolidierung]], [[loki-os-ecosystem-stand]]
