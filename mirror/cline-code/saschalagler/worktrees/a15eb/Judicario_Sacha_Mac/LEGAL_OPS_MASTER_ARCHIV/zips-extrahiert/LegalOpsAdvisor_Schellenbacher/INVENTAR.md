# 📦 INVENTAR: LegalOpsAdvisor_Schellenbacher.zip

> Extrahiert am: 2026-07-28
> Ziel: `/Users/saschalagler/Desktop/LEGAL_OPS_MASTER_ARCHIV/zips-extrahiert/LegalOpsAdvisor_Schellenbacher/`
> Größe extrahiert: **196K** | Dateien: **27**

## 📋 Dateiliste (Größe | Pfad)

| Bytes | Datei |
|-------|-------|
| 1.035 | `LegalOpsAdvisor_Schellenbacher/Anleitung.md` |
| 23.818 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/app.py` |
| 1.995 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/desktop_app.py` |
| 466 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/Dockerfile` |
| 3.196 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/enterprise_rag.py` |
| 27.689 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/index.html` |
| 8.466 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/indexer.py` |
| 5.822 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/ingest_bulk_folder.py` |
| 36.864 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/legal_knowledge.db` |
| 1.791 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/prompts/compliance.txt` |
| 1.583 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/prompts/gdb_analyst.txt` |
| 4.583 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/prompts/legal_ops_omni.txt` |
| 1.673 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/prompts/vwgh_researcher.txt` |
| 150 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/requirements.txt` |
| 3.304 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/ris_ingest.py` |
| 3.856 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/run_eval.py` |
| 1.006 | `LegalOpsAdvisor_Schellenbacher/Mac-App/app/setup.py` |
| 448 | `LegalOpsAdvisor_Schellenbacher/Mac-App/Installieren.command` |
| 693 | `LegalOpsAdvisor_Schellenbacher/Nachricht.txt` |
| 1.791 | `LegalOpsAdvisor_Schellenbacher/Prompts/compliance.txt` |
| 1.583 | `LegalOpsAdvisor_Schellenbacher/Prompts/gdb_analyst.txt` |
| 4.583 | `LegalOpsAdvisor_Schellenbacher/Prompts/legal_ops_omni.txt` |
| 1.673 | `LegalOpsAdvisor_Schellenbacher/Prompts/vwgh_researcher.txt` |
| 375 | `LegalOpsAdvisor_Schellenbacher/START_HIER.txt` |
| 43 | `LegalOpsAdvisor_Schellenbacher/Web-App.txt` |

## 🔑 Key-Files

- **`Mac-App/app/app.py`** (23.818 B) — **IDENTISCH** mit Sacha & Versand. Kein Auto-Grounding.
- **`Mac-App/app/index.html`** (27.689 B) — **IDENTISCH** mit Sacha: Blau-Palette, EB Garamond, Responsive.
- **`Mac-App/app/legal_knowledge.db`** (36.864 B) — **IDENTISCHE Größe** mit Sacha.
- **`Mac-App/Installieren.command`** (448 B) — **ÄHNLICH aber NICHT identisch** mit Sacha: `set -e; cd "$(dirname "$0")/app"` (one-liner), kürzere Prompt-Texte, hat `echo "== Starte App =="` vor dem Start.
- **`Prompts/`** (4 Dateien) — **DUPLIKAT** von `Mac-App/app/prompts/` (byte-identisch). Top-Level abgelegt für einfachen Nutzerzugriff.
- **`START_HIER.txt`** (375 B) — Maßgeschneiderter Einstieg: „SOFORT (ohne Installation): Web-App. LOKAL am Mac: Installieren.command"
- **`Nachricht.txt`** (693 B) — Persönliche Nachricht an „Herr Schellenbacher" — Vorstellung des Tools.
- **`Anleitung.md`** (1.035 B) — Ausführliche Anleitung: Web-App, Mac-App, Prompts, Architektur-Kurzbeschreibung.
- **`Web-App.txt`** (43 B) — Nur der Link: `https://gen-lang-client-0285074833.web.app`

## 🏷️ Charakteristik

**NESTED-Struktur**: `LegalOpsAdvisor_Schellenbacher/Mac-App/app/`. **PERSONALISIERTE Partner-Version** für Herrn Schellenbacher. Prompts sind **DOPPELT** vorhanden (top-level `Prompts/` + `Mac-App/app/prompts/`) — identischer Inhalt. **KEINE Firebase-Cloud-Dateien** (kein `firestore.rules`, `storage.rules`, `firebase.json`). Hat aber `Dockerfile` und `enterprise_rag.py`. **KEIN** `CLAUDE.md`, **KEIN** `PROJECT.md`. Die nutzerfreundlichste Version mit persönlicher Ansprache und gestaffelter Dokumentation.

---

## 🔍 UNTERSCHIEDE zu anderen Versionen

| Merkmal | versand | Sacha | Schellenbacher | Paket |
|---------|---------|-------|----------------|-------|
| Struktur | FLAT | Nested | **Nested (Mac-App/)** | FLAT |
| index.html Palette | Lila | Blau | **Blau** | Terracotta |
| Personalisiert | ❌ | ❌ | ✅ (Nachricht.txt) | ❌ |
| Prompts dupliziert | ❌ | ❌ | ✅ | ❌ |
| legal_knowledge.db | ❌ | ✅ | ✅ | ❌ |
| Firebase-Deploy | ✅ | teilweise | ❌ | ❌ |
| firebase.json | ✅ | ✅ | ❌ | ❌ |
| Installer | ❌ | ✅ (524B) | ✅ (448B) | ❌ |
| CLAUDE.md | ✅ | ❌ | ❌ | ✅ |
| DESIGN-IS Audit | ❌ | ❌ | ❌ | ✅ |
| Anleitung.md | ❌ | ❌ | ✅ | ❌ |
