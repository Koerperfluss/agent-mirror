---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legal-ops-versand/INVENTAR.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# 📦 INVENTAR: legal-ops-versand.zip

> Extrahiert am: 2026-07-28
> Ziel: `/Users/saschalagler/Desktop/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/legal-ops-versand/`
> Größe extrahiert: **156K** | Dateien: **25**

## 📋 Dateiliste (Größe | Pfad)

| Bytes | Datei |
|-------|-------|
| 1.824 | `.firebase/hosting..cache` |
| 68 | `.firebaserc` |
| 443 | `.gcloudignore` |
| 244 | `.gitignore` |
| 23.818 | `app.py` |
| 3.075 | `CLAUDE.md` |
| 1.995 | `desktop_app.py` |
| 466 | `Dockerfile` |
| 3.196 | `enterprise_rag.py` |
| 486 | `firebase.json` |
| 2.038 | `firestore.rules` |
| 26.593 | `index.html` |
| 8.466 | `indexer.py` |
| 5.822 | `ingest_bulk_folder.py` |
| 3.411 | `PROJECT.md` |
| 1.791 | `prompts/compliance.txt` |
| 1.583 | `prompts/gdb_analyst.txt` |
| 4.583 | `prompts/legal_ops_omni.txt` |
| 1.673 | `prompts/vwgh_researcher.txt` |
| 150 | `requirements.txt` |
| 3.304 | `ris_ingest.py` |
| 3.856 | `run_eval.py` |
| 1.006 | `setup.py` |
| 508 | `storage.rules` |

## 🔑 Key-Files

- **`app.py`** (23.818 B) — FastAPI-Backend, `call_llm()` lokal-first + Gemini-Fallback. **ALTE Version**: statisches Backend-Reporting (`"backend": "google-genai-sdk"`), KEIN Auto-Grounding, KEIN WATCH_DESKTOP-Guard.
- **`index.html`** (26.593 B) — **ALTE UI**: Lila-Palette (`--accent:#7c5cbf`), nur Inter + JetBrains Mono, kein EB Garamond, kein Responsive-Media-Query.
- **`CLAUDE.md`** (3.075 B) — Projekt-Gehirn mit **DEPLOY-REGEL** (UI→Firebase, Backend→Cloud Run). Kein Module & Protokoll-Abschnitt.
- **`PROJECT.md`** (3.411 B) — Architektur-Dokumentation (PyWebView, FastAPI, SQLite RAG, Ollama). **EXKLUSIV** in diesem Archiv.
- **`prompts/legal_ops_omni.txt`** (4.583 B) — v7.0, 7 Sektionen. **KEIN** Abschnitt 8 (Anti-Halluzinations-Zwang).
- **`desktop_app.py`** (1.995 B) — **ALTE Version**: kein `BACKEND_MODE=auto`, kein `WATCH_DESKTOP=0` Default.
- **`ris_ingest.py`** (3.304 B) — RIS-Judikatur-Ingester (OGD-API → lokale DB).

## 🏷️ Charakteristik

**FLACHE Ordnerstruktur** — alle Dateien im Root. **VOLLSTÄNDIGES Developer-Setup**: Firebase/Cloud-Deploy (`.firebaserc`, `.gcloudignore`, `Dockerfile`, `firebase.json`, `firestore.rules`, `storage.rules`). Enthält `enterprise_rag.py`, `indexer.py`, `ingest_bulk_folder.py`, `setup.py`, `run_eval.py` — die komplette RAG-Ingestion-Pipeline. **KEIN** `legal_knowledge.db`. **KEINE** nutzerfreundlichen Readme/Starter-Dateien. Dies ist die **Entwickler-Rohversion**, geeignet für Deployment und Weiterentwicklung.

---

## 🔍 UNTERSCHIEDE zu anderen Versionen

| Merkmal | versand | Sacha | Schellenbacher | Paket |
|---------|---------|-------|----------------|-------|
| Struktur | FLAT | Nested | Nested | FLAT |
| index.html Palette | Lila (`#7c5cbf`) | Blau (`#2563eb`) | Blau (`#2563eb`) | **Terracotta** (`#d9784f`) |
| index.html EB Garamond | ❌ | ✅ | ✅ | ✅ |
| app.py Auto-Grounding | ❌ | ❌ | ❌ | ✅ |
| legal_ops_omni.txt §8 | ❌ | ❌ | ❌ | ✅ |
| CLAUDE.md | Deploy-Regel | ❌ fehlt | ❌ fehlt | Module&Protokoll |
| DESIGN-IS Audit | ❌ | ❌ | ❌ | ✅ |
| ris_lookup.py | ❌ | ❌ | ❌ | ✅ |
| ris_ingest.py | ✅ | ✅ | ✅ | ❌ |
| Firebase-Deploy | ✅ | teilweise | ❌ | ❌ |
| legal_knowledge.db | ❌ | ✅ (36K) | ✅ (36K) | ❌ |
| Nutzer-Starter-Dateien | ❌ | ✅ (LIESMICH) | ✅ (START_HIER) | ❌ |
| enterprise_rag.py | ✅ | ✅ | ✅ | ❌ |
| PROJECT.md | ✅ | ❌ | ❌ | ❌ |
