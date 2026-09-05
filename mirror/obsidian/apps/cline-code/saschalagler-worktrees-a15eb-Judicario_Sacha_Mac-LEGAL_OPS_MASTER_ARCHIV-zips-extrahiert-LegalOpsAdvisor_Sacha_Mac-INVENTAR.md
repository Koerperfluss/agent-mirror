---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/LegalOpsAdvisor_Sacha_Mac/INVENTAR.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# 📦 INVENTAR: LegalOpsAdvisor_Sacha_Mac.zip

> Extrahiert am: 2026-07-28
> Ziel: `/Users/saschalagler/Desktop/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/LegalOpsAdvisor_Sacha_Mac/`
> Größe extrahiert: **184K** | Dateien: **24**

## 📋 Dateiliste (Größe | Pfad)

| Bytes | Datei |
|-------|-------|
| 23.818 | `LegalOpsAdvisor_Sacha_Mac/app/app.py` |
| 1.995 | `LegalOpsAdvisor_Sacha_Mac/app/desktop_app.py` |
| 466 | `LegalOpsAdvisor_Sacha_Mac/app/Dockerfile` |
| 3.196 | `LegalOpsAdvisor_Sacha_Mac/app/enterprise_rag.py` |
| 486 | `LegalOpsAdvisor_Sacha_Mac/app/firebase.json` |
| 2.038 | `LegalOpsAdvisor_Sacha_Mac/app/firestore.rules` |
| 27.689 | `LegalOpsAdvisor_Sacha_Mac/app/index.html` |
| 8.466 | `LegalOpsAdvisor_Sacha_Mac/app/indexer.py` |
| 5.822 | `LegalOpsAdvisor_Sacha_Mac/app/ingest_bulk_folder.py` |
| 36.864 | `LegalOpsAdvisor_Sacha_Mac/app/legal_knowledge.db` |
| 1.791 | `LegalOpsAdvisor_Sacha_Mac/app/prompts/compliance.txt` |
| 1.583 | `LegalOpsAdvisor_Sacha_Mac/app/prompts/gdb_analyst.txt` |
| 3.220 | `LegalOpsAdvisor_Sacha_Mac/app/prompts/legal_ops_omni_v6_backup.txt` |
| 4.583 | `LegalOpsAdvisor_Sacha_Mac/app/prompts/legal_ops_omni.txt` |
| 1.673 | `LegalOpsAdvisor_Sacha_Mac/app/prompts/vwgh_researcher.txt` |
| 150 | `LegalOpsAdvisor_Sacha_Mac/app/requirements.txt` |
| 3.304 | `LegalOpsAdvisor_Sacha_Mac/app/ris_ingest.py` |
| 3.856 | `LegalOpsAdvisor_Sacha_Mac/app/run_eval.py` |
| 1.006 | `LegalOpsAdvisor_Sacha_Mac/app/setup.py` |
| 508 | `LegalOpsAdvisor_Sacha_Mac/app/storage.rules` |
| 524 | `LegalOpsAdvisor_Sacha_Mac/Legal_Ops_lokal_installieren.command` |
| 335 | `LegalOpsAdvisor_Sacha_Mac/LIESMICH.txt` |
| 154 | `LegalOpsAdvisor_Sacha_Mac/Web-Version.txt` |

## 🔑 Key-Files

- **`app/app.py`** (23.818 B) — IDENTISCH mit Versand-Version. Kein Auto-Grounding, statisches Backend-Reporting.
- **`app/index.html`** (27.689 B) — **BLAUE Palette** (`--accent:#2563eb`, `--bg:#0b1220`), EB Garamond für h1/h2, responsive `@media`-Query. +1.096 B größer als Versand (Responsive-CSS).
- **`app/legal_knowledge.db`** (36.864 B) — SQLite-Datenbank mit indizierten Rechtsdokumenten. **EXKLUSIV** in Sacha & Schellenbacher (nicht in Versand/Paket).
- **`app/prompts/legal_ops_omni_v6_backup.txt`** (3.220 B) — **EXKLUSIV**: v6.0-Backup mit MODULE_A–E-Struktur (Volljurist/Steuerberater/Notar/Strategic/E-Government). Älteres Prompt-Format.
- **`app/prompts/legal_ops_omni.txt`** (4.583 B) — v7.0, identisch mit Versand & Schellenbacher.
- **`LIESMICH.txt`** (335 B) — Nutzer-Starter: „OHNE Installation testen: Web-Version. LOKAL: Doppelklick auf .command"
- **`Web-Version.txt`** (154 B) — Link: `https://gen-lang-client-0285074833.web.app`
- **`Legal_Ops_lokal_installieren.command`** (524 B) — Mac-Installer: prüft Python, fragt API-Key, erstellt venv, startet App.

## 🏷️ Charakteristik

**NESTED-Struktur**: Alle App-Dateien in `LegalOpsAdvisor_Sacha_Mac/app/`. **Sachas persönliche Version** mit `legal_knowledge.db` (36K). UI ist **WEITERENTWICKELT** gegenüber Versand (Blau-Palette, EB Garamond, Responsive). **Unvollständiges Firebase-Setup**: hat `firebase.json`, `firestore.rules`, `storage.rules`, `Dockerfile`, aber **KEIN** `.firebaserc`, `.gcloudignore`, `.gitignore`. **KEIN** `CLAUDE.md`, **KEIN** `PROJECT.md`. Enthält v6-Backup-Prompt. Nutzerfreundliche Starter-Dateien vorhanden.

---

## 🔍 UNTERSCHIEDE zu anderen Versionen

| Merkmal | versand | Sacha | Schellenbacher | Paket |
|---------|---------|-------|----------------|-------|
| Struktur | FLAT | Nested | Nested | FLAT |
| index.html Palette | Lila | **Blau** | **Blau** | Terracotta |
| index.html EB Garamond | ❌ | ✅ | ✅ | ✅ |
| app.py Auto-Grounding | ❌ | ❌ | ❌ | ✅ |
| legal_ops_omni §8 | ❌ | ❌ | ❌ | ✅ |
| v6 Backup Prompt | ❌ | ✅ | ❌ | ❌ |
| legal_knowledge.db | ❌ | ✅ | ✅ | ❌ |
| Firebase-Deploy | ✅ | teilweise | ❌ | ❌ |
| CLAUDE.md | ✅ | ❌ | ❌ | ✅ |
| DESIGN-IS Audit | ❌ | ❌ | ❌ | ✅ |
| PROJECT.md | ✅ | ❌ | ❌ | ❌ |
