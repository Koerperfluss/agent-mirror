---
name: loki-second-brain
description: LOKI SECOND BRAIN (20.09.2026) — LOKAL FERTIG & GETESTET. ~/loki-brain/
  (brain.py + FTS5 brain.db + git) gekoppelt an Voice-Daemon :8078 (4 Tools:
  brain_save/brain_search/recall_history/read_briefing) und Obsidian Vault
  (Brain/ + Daily/ mit M2-Auto-Protokoll). Review PASS.
metadata:
  type: project
---

LOKI SECOND BRAIN — SASCHAS LOKALER GEDÄCHTNIS-HELFER (fertig 20.09.2026, Abend):

**Architektur:** Sprache/curl → Daemon :8078 → `~/loki-brain/brain.py` (676 Zeilen) → FTS5 `brain.db` + Obsidian-Vault `~/Documents/Obsidian Vault/Brain/` + `Daily/` (M2-Auto-Sitzungsprotokoll je Interaktion). Lokaler Mirror `~/loki-brain/vault/` als TCC-Fallback. Git-Repo vorhanden (Commits 605f545, 7a775bf).

**Daemon-Tools (in daemon.py verdrahtet, /status zeigt 8 Tools):** `brain_save(topic,text)` („merk dir") · `brain_search(query)` („was wissen wir über") · `recall_history` (déjà-CLI) · `read_briefing` (assi-Morgenbrief vorlesen + archivieren). SYSTEM_PROMPT.md enthält zwingende Brain-Regeln (Zeilen ~54-69).

**Beweise:** 12 E2E-Interaktionen in `Daily/2026-09-20.md` (Peter/FFG/Morgenbrief/déja/Zoetrope alle korrekt) · CLI-Suche live · Review PASS (0 HIGH, 2 MED).

**Build-Historie (wichtig gegen Doppelarbeit):** Plan lief in 2 parallelen Sessions — Builder-Schwarm baute 22:47-23:38 (inkl. test_brain_e2e.py), Director-Session (diese) verifizierte, reviewte (Reviewer-Dispatch 404 → Main-Fallback), dokumentierte (PROJECT.md), committete. NIE wieder von 0 planen — nur erweitern.

**Offen (MED, nicht blocking):** 1) Peter-Duplikate aus Testphase vor Dedupe-Bau (Dedupe-Logik existiert inzwischen, brain.py:112-128) · 2) `reindex_vault` reindiziert nur Brain-Ordner, Daily fällt aus Suchindex · 3) Mikro-TCC-Klick für echte Sprachnutzung weiter offen (User).

**Nutzung:** Doppel-Ctrl → „Loki, merk dir X" / „was wissen wir über X?" / „lies den Morgenbrief" · ohne Mikro: `curl "127.0.0.1:8078/ask?text=..."` · CLI: `python3 ~/loki-brain/brain.py status|save|search|recall|briefing|sync`.

Verwandt: [[loki-voice-agent]], [[sascha-vollzug-keine-zwischenfragen]], [[deja-vu-install]]
