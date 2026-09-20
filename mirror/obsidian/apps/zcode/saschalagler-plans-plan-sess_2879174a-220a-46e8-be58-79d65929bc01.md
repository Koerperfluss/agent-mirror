---
app: zcode
quelle: "saschalagler/plans/plan-sess_2879174a-220a-46e8-be58-79d65929bc01.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

# LOKI SECOND BRAIN — Finaler Bauplan (4-Team-Vollzug)

**Ziel:** Lokaler Second-Brain-Helfer. Du sprichst mit Loki, er merkt sich alles, er findet alles wieder. Speicher = dein echter Obsidian Vault (Finder-sichtbar). ATLAS-Status ist geklärt und ruht.

**Deine 4 Teams im Einsatz:**
| Team | Rolle hier | Wer |
|---|---|---|
| 👁️ Überwachung | After-Facts checken: Dateien da? Index aktuell? | Director (ich) + config-auditor |
| 🧠 Planung | Dieser Plan + Reihenfolge | fertig — Director |
| ⚡ Ausführung | brain.py, Daemon-Tools, Prompt | implementer (Flash) |
| 🛡️ Testung | E2E per Stimme + Reviewer-Veto | qa-tester + reviewer |

**Aufwand: M — ~60–90 Min · ~0–20 Credits (Flash-first)**

## Ausführung (7 Schritte, jede mit Beweis-Pflicht)

1. **Kern anlegen** `~/loki-brain/`: `brain.py` (save/search/session-protocol) + `brain.db` mit FTS5 (Schema 1:1 aus deiner bewährten loki.db geklont) · CLI-Test: `brain.py save "Test" && brain.py search "Test"` → Treffer.
2. **Speicher-Spiegel:** Jeder Eintrag landet doppelt — FTS5-Index UND als Markdown in `~/Documents/Obsidian Vault/Brain/<Thema>.md` + `Daily/<Datum>.md` (dein Vault, kein neues Tool nötig).
3. **Daemon-Tools** (an `~/loki-voice/daemon.py`, Stelle wie run_command): `brain_save(topic, text)` · `brain_search(query)` · `recall_history(query)` (fragt deine déja-Session-Historie) · `read_briefing` (liest assi-Morgenbrief vor + archiviert ihn).
4. **SYSTEM_PROMPT.md erweitern:** Brain-Regeln — „merk dir X" → brain_save · „was wissen wir über X" → brain_search+recall_history · „Morgenbrief" → read_briefing.
5. **M2 Auto-Protokoll:** Nach jedem Gespräch schreibt der Daemon automatisch ein Sitzungsprotokoll (Themen/Aktionen/offen) in `Daily/`.
6. **QA (Team 4):** Daemon-Reload → Live-Tests: „merk dir: Peter zahlt am 5.10." → „was wissen wir über Peter?" → richtige gesprochene Antwort + Datei-Beweise. Morgenbrief-Test. Syntax-Gates alles grün.
7. **Reviewer-Veto + Abschluss:** reviewer prüft alle Diffs (PASS/FAIL) → bei PASS: PROJECT.md, Memory, Kanban-Board final.

## Danach sagst du einfach (Realität):
- „Loki, **merk dir**: …" → gespeichert für immer
- „Loki, **was wissen wir über** …?" → er durchsucht Brain + deine Session-Historie
- „Loki, **Morgenbrief**" → assi-Brief vorgelesen
- Jedes Gespräch hinterlässt automatisch Protokoll im Vault (M2 ✓)

## Bewusst NICHT drin
Kein neues UI · keine Cloud (Speicher 100 % lokal) · keine ATLAS-/Ökosystem-Reparaturen · Deploy-Regeln unangetastet.

## DONE-WHEN
✅ brain_save per Stimme → Datei + Index-Treffer · ✅ brain_search antwortet gesprochen · ✅ Auto-Protokoll nach Gespräch · ✅ déja + Morgenbrief gekoppelt · ✅ qa E2E grün · ✅ reviewer PASS