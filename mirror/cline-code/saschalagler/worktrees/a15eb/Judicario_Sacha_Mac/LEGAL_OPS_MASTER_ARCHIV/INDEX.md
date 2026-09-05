# 🗂️ LEGAL OPS MASTER ARCHIV — INDEX

> **Erstellt:** 2026-07-28, 20:45  
> **Auftrag:** task_0009 — FETZEN-SAMMLER  
> **Mission:** Alle Fragmente des Legal Ops Advisor aus 10 Fundorten im Home-Verzeichnis einsammeln, katalogisieren und in ein zentrales Unified Archive kopieren. Keine Datei wurde gelöscht — nur kopiert.  
> **Gesamtbestand:** 195 Dateien, 8,7 MB (ohne zips-extrahiert)  
> **Fundorte:** 10 (Verzeichnisse + ZIPs)

---

## 📁 ARCHIV-STRUKTUR (7 Ordner)

| Ordner | Dateien | Größe | Inhalt |
|--------|---------|-------|--------|
| `quellen-app/` | 135 | 2,1 MB | Source Code, Prompts, Agent-Orchester, Design-Docs |
| `distribution/` | 6 | 192 KB | 4 ZIPs + 2 Installations-Skripte |
| `reports-html/` | 7 | 336 KB | Alle HTML-Berichte (6 Prüfberichte + Master-Report) |
| `pruefarchiv/` | 23 | 2,3 MB | Vollständiges Prüfarchiv (Kapitel, Quellen, Tests, Assets) |
| `assets-logos/` | 2 | 2,1 MB | Screenshots (App-Oberfläche) |
| `datenbank/` | 6 | 840 KB | SQLite-DB-Snapshots (live, Sacha, Schellenbacher) |
| `konkurrenz/` | 18 | 272 KB | Judicario-Paket komplett (Commands, MCP, Anleitungen) |

---

## 🔍 FUNDORTE (10 Quellen)

1. **`~/.legal-ops-advisor/`** — Live-Datenbank (716 KB .db)
2. **`~/Applications/Legal Ops Advisor.app/`** — macOS App-Bundle (Info.plist, Launcher)
3. **`~/Desktop/LegalOpsAdvisor_Sacha_Mac/`** — Hauptentwicklung (app/, prompts/, Audit, PDF)
4. **`~/Desktop/legalopsadvisorpaket20260728/`** — Paket (6 HTML-Reports, .zip, DESIGN-IS/)
5. **`~/LegalOpsAdvisor_Sacha_Mac/`** — Zweit-Installation (legal-ops-advisor/, .agents/, .claude/)
6. **`~/Downloads/Legal_Ops_Advisor_Pruefarchiv/`** — Prüfarchiv (kapitel/, quellen/, empirische_tests/, assets/)
7. **`~/Downloads/Judicario_Sacha_Mac/`** — Judicario-Konkurrenzpaket
8. **`~/legal-ops-versand.zip`** — Versand-ZIP (42 KB)
9. **`~/LegalOpsAdvisor_Sacha_Mac.zip`** — Sacha-Mac-ZIP (43 KB)
10. **`~/LegalOpsAdvisor_Schellenbacher.zip`** — Schellenbacher-ZIP (48 KB)



---

## 📦 1. QUELLEN-APP/ (135 Dateien, 2,1 MB)

### 🔧 Python-Source
| Datei | Größe | Quelle |
|-------|-------|--------|
| `app.py` | 23 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `app_v2.py` | 25 KB | ~/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/ ⚠️ neuere Version! |
| `desktop_app.py` | 2,0 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `enterprise_rag.py` | 3,1 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `indexer.py` | 8,3 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `ingest_bulk_folder.py` | 5,7 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `ris_ingest.py` | 3,2 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `ris_lookup.py` | 9,2 KB | ~/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/ |
| `run_eval.py` | 3,8 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `setup.py` | 1,0 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `index.html` | 27 KB | Web-Frontend |
| `Dockerfile` | 466 B | Container-Build |
| `firebase.json` | 486 B | Firebase-Hosting |
| `firestore.rules` | 2,0 KB | Firestore-Regeln |
| `storage.rules` | 508 B | Storage-Regeln |
| `requirements.txt` | 150 B | Python-Deps |
| `dot_env` | 110 B | .env-Kopie |

### 🧠 Prompts (5 Dateien)
| Datei | Größe | Beschreibung |
|-------|-------|-------------|
| `prompts/legal_ops_omni.txt` | 4,5 KB | Haupt-Persona v6 |
| `prompts/legal_ops_omni_v6_backup.txt` | 3,1 KB | Backup v6 |
| `prompts/compliance.txt` | 1,8 KB | Compliance-Persona |
| `prompts/gdb_analyst.txt` | 1,5 KB | GDB-Analyst-Persona |
| `prompts/vwgh_researcher.txt` | 1,6 KB | VwGH-Researcher-Persona |

### 🤖 Agent-Orchester (`.agents/` — 116 Dateien)
**6 Agent-Rollen:** `orchestrator`, `worker` (m1, m2), `explorer`, `reviewer` (m3_1, m3_2), `challenger`, `auditor`. Jeder mit BRIEFING.md, handoff.md, ORIGINAL_REQUEST.md, progress.md.

### 📋 DESIGN-IS-2026-07-28/
| Datei | Größe |
|-------|-------|
| `00-scope.md` | 2,5 KB |
| `01-evidence.md` | 6,7 KB |
| `02-scorecard.md` | 4,9 KB |
| `03-verdict.md` | 2,8 KB |
| `04-handoff-prompt.md` | 7,7 KB |

### 📄 Dokumentation & Sonstiges
| Datei | Größe |
|-------|-------|
| `CLAUDE_v2.md` | 3,2 KB |
| `PROJECT.md` | 3,3 KB |
| `FULL_AUDIT_LEGAL_OPS.md` | 6,5 KB |
| `LIESMICH.txt` | 335 B |
| `Web-Version.txt` | 154 B |
| `legal_knowledge.db` | 36 KB |
| `Prompt-Optimierung für Rechtsagenten - Google Gemini.pdf` | 445 KB |
| `.claude/skills/legal-ops-deploy/SKILL.md` | 2,0 KB |

### 🔬 Rechtsagent_Audit_2026-07-26/


---

## 📦 2. DISTRIBUTION/ (6 Dateien, 192 KB)

| Datei | Größe | Quelle |
|-------|-------|--------|
| `legal-ops-versand.zip` | 41 KB | ~/legal-ops-versand.zip |
| `LegalOpsAdvisor_Sacha_Mac.zip` | 42 KB | ~/LegalOpsAdvisor_Sacha_Mac.zip |
| `LegalOpsAdvisor_Schellenbacher.zip` | 47 KB | ~/LegalOpsAdvisor_Schellenbacher.zip |
| `legalopsadvisorpaket20260728.zip` | 45 KB | ~/Desktop/legalopsadvisorpaket20260728/ |
| `Legal_Ops_lokal_installieren.command` | 524 B | Desktop/LegalOpsAdvisor_Sacha_Mac/ |
| `Judicario_in_Claude_Code_installieren.command` | 727 B | Downloads/Judicario_Sacha_Mac/ |

---

## 📦 3. REPORTS-HTML/ (7 Dateien, 336 KB)

| Datei | Größe | Beschreibung |
|-------|-------|-------------|
| `00_MASTER_REPORT.html` | 204 KB | **Master-Prüfbericht** (kompletter Audit) |
| `LEGAL_OPS_ADVISOR_MASTER_AUDIT_REPORT_2026.html` | 15 KB | Master-Audit-Report |
| `Human_Clear_Legal_Ops_Comparison.html` | 16 KB | Human vs Clear Vergleich |
| `Judicario_Case_Audit_Scheinecker_v1_4.html` | 12 KB | Judicario Case Audit |
| `Legal_Ops_Kanban_Audit.html` | 47 KB | Kanban-Audit |
| `Legal_Ops_Sales_Matrix_2026.html` | 14 KB | Sales-Matrix |
| `System_Audit_Rechtsvergleich_2026.html` | 14 KB | System-Audit Rechtsvergleich |

---

## 📦 4. PRUEFARCHIV/ (23 Dateien, 2,3 MB)

### 📊 Hauptdokumente
| Datei | Größe |
|-------|-------|
| `00_MASTER_REPORT.html` | 204 KB |
| `TEAM_BRIEFING.md` | 2,6 KB |

### 🎨 Assets
| Datei | Größe |
|-------|-------|
| `assets/legal-ops-logo.png` | 574 KB |
| `assets/polymath-core.png` | 607 KB |
| `assets/DESIGN_TOKENS.md` | 1,3 KB |

### 📖 Kapitel/ (10 Prüfkapitel)
| # | Datei | Größe |
|---|-------|-------|
| 01 | `kapitel/01_pruefvorgabe_methodik.md` | 3,6 KB |
| 02 | `kapitel/02_system_architektur_modelle.md` | 8,9 KB |
| 03 | `kapitel/03_agenten_orchester_userflow.md` | 5,9 KB |
| 04 | `kapitel/04_skills_prompts_extensions.md` | 17,9 KB |
| 05 | `kapitel/05_ris_daten_genauigkeit.md` | 5,5 KB |
| 06 | `kapitel/06_empirie_schnelligkeit_eval.md` | 3,1 KB |
| 07 | `kapitel/07_kommunikation_output.md` | 2,1 KB |
| 08 | `kapitel/08_vergleichsmatrix_gesamt.md` | 4,1 KB |
| 08b | `kapitel/08b_konkurrenz_deepdive.md` | 7,8 KB |
| 09 | `kapitel/09_bewertung_urteil.md` | 6,6 KB |

### 📝 Quellen
| Datei | Größe |
|-------|-------|
| `quellen/Scheinecker_v1.4_Zwischenbericht.txt` | 28,5 KB |

### 🧪 Empirische Tests
| Datei | Größe |
|-------|-------|
| `empirische_tests/LEAD_ris_api_verifikation.md` | 1,3 KB |
| `empirische_tests/db_fts5_funktionstest_roh.txt` | 637 B |
| `empirische_tests/db_inspektion_roh.txt` | 2,5 KB |
| `empirische_tests/db_snapshot_legal_knowledge.db` | 700 KB |
| `empirische_tests/db_snapshot_legal_knowledge.db-shm` | 32 KB |
| `empirische_tests/db_snapshot_legal_knowledge.db-wal` | 0 B |

---

## 📦 5. ASSETS-LOGOS/ (2 Dateien, 2,1 MB)

| Datei | Größe | Beschreibung |
|-------|-------|-------------|
| `Bildschirmfoto 2026-07-22 um 11.03.23.png` | 266 KB | Screenshot Desktop |
| `Bildschirmfoto 2026-07-22 um 13.50.04.png` | 1,8 MB | Screenshot App |

---

## 📦 6. DATENBANK/ (6 Dateien, 840 KB)

| Datei | Größe | Quelle |
|-------|-------|--------|
| `live_legal_knowledge.db` | 700 KB | `~/.legal-ops-advisor/` **Live-DB (20× größer!)** |
| `live_legal_knowledge.db-shm` | 32 KB | `~/.legal-ops-advisor/` |
| `live_legal_knowledge.db-wal` | 0 B | `~/.legal-ops-advisor/` |
| `sacha_mac_legal_knowledge.db` | 36 KB | Desktop/LegalOpsAdvisor_Sacha_Mac/app/ |
| `sacha_mac_v2_legal_knowledge.db` | 36 KB | ~/LegalOpsAdvisor_Sacha_Mac/app/ |
| `schellenbacher_legal_knowledge.db` | 36 KB | Desktop/.../Schellenbacher/Mac-App/app/ |

---

## 📦 7. KONKURRENZ/ (18 Dateien, 272 KB)

### 📄 Judicario-Hauptverzeichnis
| Datei | Größe |
|-------|-------|
| `Anleitung_DE.html` | 92 KB |
| `Guide_EN.html` | 92 KB |
| `AUDIT_Legal_Ops_Advisor_vs_Judicario.md` | 19 KB |
| `Connectoren_URLs.txt` | 933 B |
| `LIESMICH.txt` | 378 B |
| `Judicario_in_Claude_Code_installieren.command` | 727 B |

### ⚙️ Plugin-Konfiguration
| Datei | Größe |
|-------|-------|
| `judicario/README.md` | 1,4 KB |
| `judicario/.mcp.json` | 802 B |
| `judicario/.claude-plugin/plugin.json` | 448 B |

### 📋 Judicario Commands (8 Stück)


---

## 📊 STATISTIK

| Metrik | Wert |
|--------|------|
| **Dateien insgesamt** | 195 |
| **Ordner (Top-Level)** | 7 |
| **Fundorte (Quellen)** | 10 |
| **Gesamtgröße** | 8,7 MB |
| **Größte Datei** | `Bildschirmfoto 2026-07-22 um 13.50.04.png` (1,8 MB) |
| **Kleinste Datei** | `legal_knowledge.db-wal` (0 B) |
| **Python-Dateien** | 14 (.py) |
| **HTML-Dateien** | 9 (.html) |
| **Markdown-Dateien** | ~130 (.md) |
| **Prompt-Dateien** | 5 (.txt) |
| **Datenbanken** | 6 (.db) |
| **ZIP-Archive** | 4 (.zip) |
| **Screenshots** | 3 (.png) |
| **PDFs** | 1 (.pdf) |

---

## ⚠️ HINWEISE & BEFUNDE

1. **Keine Dateien wurden gelöscht** — alle Kopien sind zusätzlich zum Original.
2. **Versionen-Konflikt `app.py`**: `app.py` (23 KB, v1) vs. `app_v2.py` (25 KB, v2). Die v2 aus `~/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/` ist neuer.
3. **Prompts-Versionen**: `legal_ops_omni.txt` existiert in v6 (4,5 KB) und v7 (6,5 KB im Paket). Backup: `legal_ops_omni_v6_backup.txt`.
4. **Datenbank-Drift**: Live-DB (716 KB) vs. Sacha/Schellenbacher-DBs (je 36 KB). Die Live-DB ist ~20× größer — vermutlich durch RIS-Importe befüllt.
5. **ZIPs extrahiert**: Die 4 ZIPs wurden bereits nach `zips-extrahiert/` entpackt (task_0010-Bereich). Diese sind nicht im 195er-Count enthalten.
6. **App-Bundle**: Das `.app`-Bundle unter `~/Applications/` wurde nicht separat kopiert (Inhalte sind über andere Pfade abgedeckt).
7. **e-gov-portal-registry**: Nicht auffindbar an erwarteter Stelle — existiert möglicherweise nur im git-Tree oder wurde umbenannt.

---

## 📋 QUELLEN-ZUORDNUNG

| Quelle | Ziel-Ordner | Dateien |
|--------|-------------|---------|
| `~/.legal-ops-advisor/` | `datenbank/` | 3 (live_db + WAL/SHM) |
| `~/Applications/Legal Ops Advisor.app/` | (abgedeckt durch andere Pfade) | - |
| `~/Desktop/LegalOpsAdvisor_Sacha_Mac/` | `quellen-app/`, `distribution/`, `datenbank/` | ~35 |
| `~/Desktop/legalopsadvisorpaket20260728/` | `reports-html/`, `distribution/` | 8 |
| `~/LegalOpsAdvisor_Sacha_Mac/` | `quellen-app/`, `assets-logos/` | ~130 |
| `~/Downloads/Legal_Ops_Advisor_Pruefarchiv/` | `pruefarchiv/`, `reports-html/` | 23 |
| `~/Downloads/Judicario_Sacha_Mac/` | `konkurrenz/`, `distribution/` | 18 |
| `~/legal-ops-versand.zip` | `distribution/` | 1 |
| `~/LegalOpsAdvisor_Sacha_Mac.zip` | `distribution/` | 1 |
| `~/LegalOpsAdvisor_Schellenbacher.zip` | `distribution/` | 1 |

---

> 🏁 **task_0009 abgeschlossen. Fetzen gesammelt: ✅**  
> 195 Dateien aus 10 Fundorten im Unified Archive.  
> **Nächste Schritte:** task_0010 (ZIP-Vergleich durch zip-extraktor), task_0011 (HTML-Reports Dashboard durch html-sammler).

| Command | Größe |
|---------|-------|
| `commands/recherche.md` | 444 B |
| `commands/norm.md` | 380 B |
| `commands/gutachten.md` | 525 B |
| `commands/schriftsatz.md` | 412 B |
| `commands/fall-triage.md` | 301 B |
| `commands/rechtsvergleich.md` | 295 B |
| `commands/steuer.md` | 507 B |
| `commands/deckungscheck.md` | 409 B |

| Datei | Größe |
|-------|-------|
| `RIS-Fix_Verifikation_2026-07-26.md` | 4,0 KB |
| `Bildschirmfoto 2026-07-26 um 23.09.53.png` | 762 KB |
