# 📦 INVENTAR: legalopsadvisorpaket20260728.zip

> Extrahiert am: 2026-07-28
> Ziel: `/Users/saschalagler/Desktop/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legalopsadvisorpaket20260728/`
> Größe extrahiert: **136K** | Dateien: **15**

## 📋 Dateiliste (Größe | Pfad)

| Bytes | Datei |
|-------|-------|
| 25.235 | `app.py` |
| 3.268 | `CLAUDE.md` |
| 2.528 | `DESIGN-IS-2026-07-28/00-scope.md` |
| 6.870 | `DESIGN-IS-2026-07-28/01-evidence.md` |
| 5.014 | `DESIGN-IS-2026-07-28/02-scorecard.md` |
| 2.893 | `DESIGN-IS-2026-07-28/03-verdict.md` |
| 7.889 | `DESIGN-IS-2026-07-28/04-handoff-prompt.md` |
| 2.204 | `desktop_app.py` |
| 36.807 | `index.html` |
| 1.791 | `prompts/compliance.txt` |
| 1.583 | `prompts/gdb_analyst.txt` |
| 6.520 | `prompts/legal_ops_omni.txt` |
| 1.673 | `prompts/vwgh_researcher.txt` |
| 9.463 | `ris_lookup.py` |

## 🔑 Key-Files

- **`app.py`** (25.235 B) — **WEITERENTWICKELT** (+1.417 B vs. alle anderen). **NEU**: `WATCH_DESKTOP`-Guard, dynamisches Backend-Reporting (`backend_mode` + echtes Modell), **AUTO-GROUNDING**: bei jeder Rechtsfrage automatischer RIS-Live-Lookup via `ris_lookup.py` mit Web-Search-Fallback. Der größte funktionale Sprung aller Versionen.
- **`index.html`** (36.807 B) — **REDESIGNED** (Chipper/Judicario-Ästhetik). **TERRACOTTA-Palette** (`--accent:#d9784f`, `--bg:#101114`), EB Garamond für h1–h4, SVG-Icons, angepasste Spacing/Typography, Logo-Neugestaltung. +10.214 B vs. Versand. Größte UI-Überholung.
- **`prompts/legal_ops_omni.txt`** (6.520 B) — **ERWEITERT** (+1.937 B). Neu: **Abschnitt 8 — ANTI-HALLUZINATIONS-ZWANG**: Verbatim-Pflicht, Kontext-Verifikation, „DATENLAGE UNKLAR"-Mechanismus, Betragssperre ohne Live-Beleg. Härteste Anti-Halluzinations-Regel aller Versionen.
- **`CLAUDE.md`** (3.268 B) — Neuer **„Module & Protokoll"-Abschnitt** ersetzt die alte Deploy-Regel: MODULE_A–E (Volljurist/Steuerberater/Notar/Strategic/E-Government) + Strict CoVe Protocol.
- **`desktop_app.py`** (2.204 B) — **NEUE Defaults**: `BACKEND_MODE=auto`, `WATCH_DESKTOP=0`. Titel: „Legal Ops Advisor v6.0 M4-Native :: Polymath-Core".
- **`ris_lookup.py`** (9.463 B, 198 Zeilen) — **EXKLUSIV NEU**: RIS Live-Lookup für den HEUTE geltenden Gesetzestext (Bundesrecht konsolidiert) via OGD-API. Stemming deutscher Rechts-Suffixe. Kernwaffe gegen Halluzination veralteter Paragraphen/Beträge.
- **`DESIGN-IS-2026-07-28/`** (5 Dateien, 25.194 B) — **EXKLUSIV**: Dieter-Rams-Design-Audit der UI. Scope → Evidence → Scorecard (13/30 → REDESIGN) → Verdict → Handoff-Prompt. Dokumentiert die UI-Überholung vom selben Tag.

## 🏷️ Charakteristik

**FLACHE Struktur** — minimalistisch, nur das Nötigste. Dies ist die **WEITERENTWICKELTSTE** aber auch **SCHLANKSTE** Version. **ENTFERNT** wurden: alle Firebase/Cloud-Dateien, `Dockerfile`, `enterprise_rag.py`, `indexer.py`, `ingest_bulk_folder.py`, `setup.py`, `run_eval.py`, `PROJECT.md`, `legal_knowledge.db`. Fokus: **Auto-Grounding + Anti-Halluzination + Redesign**. Das Paket ist ein Snapshot des aktuellen Entwicklungsstands (2026-07-28) — weniger Infrastruktur, mehr juristische Präzision.

---

## 🔍 UNTERSCHIEDE zu anderen Versionen

| Merkmal | versand | Sacha | Schellenbacher | Paket |
|---------|---------|-------|----------------|-------|
| Struktur | FLAT | Nested | Nested | **FLAT** |
| index.html Palette | Lila | Blau | Blau | **Terracotta** |
| index.html Größe | 26.593 | 27.689 | 27.689 | **36.807** |
| app.py Auto-Grounding | ❌ | ❌ | ❌ | ✅ |
| app.py Größe | 23.818 | 23.818 | 23.818 | **25.235** |
| legal_ops_omni §8 | ❌ | ❌ | ❌ | ✅ |
| legal_ops_omni Größe | 4.583 | 4.583 | 4.583 | **6.520** |
| ris_lookup.py | ❌ | ❌ | ❌ | ✅ |
| DESIGN-IS Audit | ❌ | ❌ | ❌ | ✅ |
| CLAUDE.md | Deploy-Regel | ❌ | ❌ | **Module&Protokoll** |
| Firebase-Deploy | ✅ | teilweise | ❌ | ❌ |
| RAG-Pipeline | ✅ | ✅ | ✅ | ❌ |
| Dateien gesamt | 25 | 24 | 27 | **15** |
| Extrahiert | 156K | 184K | 196K | **136K** |
