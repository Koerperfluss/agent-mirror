---
name: loki-second-brain-handoff
description: NÄCHSTES PROJEKT „LOKI SECOND BRAIN" (20.09.) — Bauplan fertig, via ~/Desktop/HANDOFF_ANTIGRAVITY.md an Antigravity übergeben (lokal: Obsidian-Vault + FTS5, 2 neue Daemon-Tools, déjà- + Morgenbrief-Kopplung)
metadata:
  type: project
---

**LOKI SECOND BRAIN — Bauplan an Antigravity übergeben (20.09. ~17:20).**

- **Handoff-Datei (kanonisch):** `~/Desktop/HANDOFF_ANTIGRAVITY.md` — selbständig lesbar (Ist-Stand Voice-System, 7 Build-Schritte mit Beweis-Pflicht, Stop-Regeln, Pfade, Suggested Skills). Erst DORT nachlesen, bevor das Projekt angefasst wird.
- **Kern:** „Loki, merk dir X" / „was wissen wir über Y" — Speicher = Markdown in `~/Documents/Obsidian Vault/Brain/` (+ `Daily/` Sitzungsprotokolle, M2), Index = `~/loki-brain/brain.db` (FTS5, Schema-Klon aus loki.db `fts_clinical_knowledge` → `fts_memory`), Kern = `~/loki-brain/brain.py` (~150 Zeilen, CLI + importierbar).
- **Daemon-Erweiterung:** Tools `brain_save` + `brain_search` (Andockung wie run_command) + Prompt-Regel „merk dir…" → brain_save; dazu `recall_history` (déjà-CLI) + `read_briefing` (liest `~/loki-assistent/data/brief_latest.txt` vor).
- **Bewusst NICHT drin:** kein UI, keine Cloud, keine Ökosystem-Reparaturen (OmniRoute-LAN-Bindung, LegalOps-Duplikate, Kernel :8010 = separate Tickets).
- **Status:** wartet auf Antigravity-Ausführung ODER Sascha sagt „baue es hier" → dann ZCode-Schwarm (implementer/qa/reviewer wie in [[loki-voice-agent]]).
- Saschas Reaktion auf den Plan: „Für was gibt es ein Top-Projekt" — er will Aufträge als saubere übergabefähige Tickets, nicht als Chat-Verlust.

Verwandt: [[loki-voice-agent]], [[sascha-arbeitsregeln-hart]], [[loki-os-ecosystem-stand]]
