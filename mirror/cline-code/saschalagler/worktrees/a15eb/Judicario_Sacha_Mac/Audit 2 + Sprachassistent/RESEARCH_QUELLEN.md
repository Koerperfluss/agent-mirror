# RESEARCH_QUELLEN — Zitierte Primärquellen-Forschung zu allen 3 Werkzeugen
Stand: 05.08.2026 · Basis für den Master-Neuaufbau (THOMAS_MASTER_2026.html v2)

> **Methode:** Drei unabhängige Research-Läufe (Agenten-Team, 05.08.2026) haben die
> Primärquellen der drei Werkzeuge DIREKT gelesen und zitiert:
> · **Legal Ops Advisor** → Quellcode (app.py, indexer.py, ris_ingest.py u. a.), SQLite-Inspektion, Dateisystem-Befunde
> · **Judicario** → Plugin-Dateien, Connectoren, alle 8 Command-Dateien (API-Key ausschließlich maskiert)
> · **Chipsi** → PDF-Extraktion (pdftotext/pdfinfo), Audit-Kontext strikt getrennt markiert
>
> **Regel:** Jede Behauptung trägt einen Beleg (Datei:Zeile oder Befund). Die drei Teile
> sind wörtlich aus den Research-Läufen übernommen — nichts geglättet, nichts ergänzt.
> Ergänzend: LEGAL_OPS_MASTER_ARCHIV/INDEX.md (195 Dateien, u. a. app_v2.py + ris_lookup.py,
> die in der auditierten Arbeitskopie FEHLEN) und _ARCHIV/ (Audits 1+2, QA, Optionen).

## INHALT
- **TEIL 1** · Legal Ops Advisor (Sachas Werkzeug) — Code-Ebene, tief
- **TEIL 2** · Judicario (Rechts-Motor, OpenLaw) — Plugin-/Command-Ebene, tief
- **TEIL 3** · Chipsi (Kanzlei-App, Thomas) — PDF-Ebene (sichtbare Schicht)

---

# TEIL 1 · LEGAL OPS ADVISOR

# RESEARCH: Legal Ops Advisor — Primärquellen (Stand 05.08.2026)

> **Methode:** Alle Angaben stammen aus direkt gelesenen Quelldateien, SQLite-Inspektion und
> Dateisystem-Befunden vom 05.08.2026. Die Sekundärquellen (`FULL_AUDIT_LEGAL_OPS.md`,
> `RIS-Fix_Verifikation_2026-07-26.md`) wurden NUR als Kontext verwendet und gegen den Code
> verifiziert — Abweichungen sind ausdrücklich dokumentiert (Abschnitt 3.7). `.venv` wurde
> auftragsgemäß ignoriert. Secrets werden niemals im Wortlaut wiedergegeben.
>
> **Diskrepanz-Check vorab (Ergebnis):** Das FULL_AUDIT erwähnt eine `app.py` mit der
> FastAPI-Logik. **Das ist korrekt: `app.py` EXISTIERT** (23.818 Bytes, 573 Zeilen,
> Dateidatum 22.07.). Sie enthält das komplette Backend. `desktop_app.py` ist lediglich ein
> 66-Zeilen-Launcher, der dieses Backend startet (`from app import app`, desktop_app.py:8).
> Beide Dateien existieren nebeneinander — die alte Doku irrt hier also NICHT. Mehrere andere
> Doku-Behauptungen sind dagegen veraltet (siehe 3.7).

## 1. Was ist es? (Klartext)

Der Legal Ops Advisor ist Sachas persönlicher, auf dem Mac laufender KI-Rechtsassistent:
ein Chat-Programm im Stil eines eigenen kleinen "Digitalen Anwaltsbüros". Man tippt eine
Rechtsfrage ein (oder wirft ein PDF hinein), und das System durchsucht zuerst ein lokales
"Aktenarchiv" (eine SQLite-Datenbank mit den eigenen Dokumenten) und lässt dann eine KI
mit vier einprogrammierten Expertenrollen (Allgemeinrecht, Behinderung/GdB,
Verwaltungsgerichtshof, Compliance) die Antwort formulieren. **Bild/Metapher:** Ein
Aktenordner-Schrank mit einem Team virtueller Juristen dahinter — finden die Juristen die
Antwort im Schrank, zitieren sie daraus; finden sie nichts, müssen sie aus dem Gedächtnis
antworten (und können sich dabei irren, siehe Abschnitt 5). Die KI rechnet idealerweise
lokal auf dem eigenen Gerät (Ollama); ist das lokale Modell nicht erreichbar, wird
automatisch die Google-Gemini-Cloud als Reserve genutzt (app.py:249-262).

## 2. Funktionen (Aufzählung)

- **Rechts-Chat mit 4 Personas** (legal / gdb / vwgh / compliance), automatisch per KI-Router ausgewählt oder manuell wählbar — app.py:167-172, app.py:459-481
- **ZTeam-Modus:** Bei Mehrfach-Routing werden die System-Prompts der gewählten Personas zu einer combined Antwort verschmolzen — app.py:522-530
- **Lokales Aktenarchiv:** PDF/TXT/MD/CSV/JSON werden eingelesen, zerlegt und in einer SQLite-FTS5-Volltextsuche indexiert — indexer.py:96-147, indexer.py:58-80
- **Auto-Indexierung:** Neue Dateien auf dem Desktop werden per Datei-Watcher automatisch eingespeist; beim Start läuft eine Hintergrund-Indizierung aller Desktop-Ordner — app.py:99-153
- **Browser-Upload:** Dateien können im UI hochgeladen werden; ihr Volltext wird der nächsten Chat-Nachricht angehängt — app.py:358-418, index.html:790-809
- **Ad-hoc-Pfadaufnahme:** Erwähnt man im Chat einen `/Users/…`-Dateipfad, wird er automatisch eingelesen/indexiert — app.py:486-490
- **Optionale Websuche:** Nur auf explizites Schlüsselwort `@web` im Chat wird eine DuckDuckGo-Suche (max. 3 Treffer) ausgeführt — app.py:330-338, app.py:492-497
- **Lokale KI-Inferenz (Ollama, Port 11434) mit automatischem Gemini-Cloud-Fallback**, umschaltbar über `BACKEND_MODE` (auto/local/cloud) — app.py:33-38, app.py:226-262
- **RAM-Schutzschalter:** Vor jeder Inferenz wird der freie Speicher geprüft; unter 128 MB wird die Anfrage abgelehnt (HTTP 503) — app.py:45-72, app.py:450-456
- **RIS-Judikatur-Import (Batch-Skript):** Zieht VwGH/OGH-Erkenntnisse aus der offiziellen OGD-API (`data.bka.gv.at`) in die lokale DB, mit Deduplizierung — ris_ingest.py:9-70
- **Bulk-Ingestion:** Multi-Threaded-Massenimport für 100.000+ Dokumente (eigenes Skript, eigene DB-Pfadlogik) — ingest_bulk_folder.py:50-140
- **Hybrid-"Enterprise"-Suche:** Kombination aus Vertex-AI-Datastore-Suche und lokaler FTS5-Suche (mit Fallback auf lokal) — enterprise_rag.py:47-73, app.py:500-514
- **Fallen-Liste im UI:** Zeigt Desktop-Ordner (inkl. `TO DO …`-Unterordner) als klickbare "Akten" — app.py:538-559, index.html:744-776
- **Evaluations-Harness:** Fährt einen CSV-Fragenkatalog gegen das Backend und misst Erfolgsquote, Norm-Treffer (Heuristik) und Latenz — run_eval.py:24-69
- **Betriebs-Endpoints:** `/health`, `/personas`, `/personas/detail`, `/db_stats`, `/cases`, `/upload`, `/ingest_paths`, `/query` — app.py:297-559
- **Desktop-App für macOS:** py2app-Bündelung (Bundle-ID `com.saschalagler.legalopsadvisor`) plus Dockerfile für Cloud-Run-Deployment — setup.py:13-29, Dockerfile:1-21
- **Firebase-Regelwerk vorhanden** (Firestore/Storage mit Rollen lawyer/paralegal/tester) — ABER ohne Anbindung im Backend (siehe 5.7) — firestore.rules:23-46, storage.rules:4-10

## 3. Technik

**Klartext zuerst:** Die App besteht aus drei Etagen. Ganz oben ein Chat-Fenster im Browser-
Stil (eine einzige HTML-Datei). In der Mitte ein Python-Server (FastAPI), der die Fragen
entgegennimmt, die richtigen Experten-Prompts auswählt, im Aktenarchiv sucht und die KI
aufruft. Unten die Datenbank: eine einfache SQLite-Datei mit Volltextsuche, die wie das
Suchregister eines Archivs funktioniert. Die KI selbst läuft bevorzugt lokal (Ollama);
fällt sie aus, springt automatisch Googles Gemini-Cloud ein. Zusätzlich gibt es Werkzeuge
drumherum: einen Massen-Importer für Dokumente, einen Importer für Gerichtsentscheidungen
(RIS) und ein Test-Programm, das Fragenkataloge abfährt.

**Details — Architektur-Schichten:**
1. **Präsentation:** `index.html` (27,7 KB, Vanilla HTML/JS, kein Framework). Backend-URL
   wird dynamisch aufgelöst: URL-Parameter `?backend=` → `localStorage` → wenn nicht
   localhost: Cloud-Run-URL `legal-ops-backend-709873485696.europe-west3.run.app` → sonst
   `http://localhost:7070` (index.html:650-665). Health-Poll alle 15 s, DB-Stats alle 30 s
   (index.html:929-936). Markdown-Rendering inkl. Tabellen und BLUF-Highlight selbstgebaut
   (index.html:879-915).
2. **Desktop-Wrapper:** `desktop_app.py` startet uvicorn auf 127.0.0.1:7070 in einem
   Daemon-Thread und öffnet ein pywebview-Fenster (1200×800) mit Titel „Legal Ops Advisor"
   (desktop_app.py:42-65). Ein LiteRT-LM-Starter (Port 9379) ist enthalten, aber
   **deaktiviert/kommentiert** — Kommentar: „Ollama/phi3:mini & Gemini Cloud API werden
   verwendet" (desktop_app.py:14-47). Hinweis: FULL_AUDIT behauptet, desktop_app.py prüfe
   „das System-Python (.venv)" — **das tut der aktuelle Code nicht** (kein .venv-Check im
   File; vollständig gelesen, 66 Zeilen).
3. **Backend/Middleware:** `app.py` = FastAPI-App v1.0.0 mit CORS-Middleware
   (`allow_origins=["*"]` + `allow_credentials=True`, app.py:77-84; kritisch, siehe 5.6).
   Ein globaler `asyncio.Lock` serialisiert alle LLM-Aufrufe (app.py:43, 521).
4. **Daten-/RAG-Schicht:** `indexer.py` + `legal_knowledge.db` (SQLite im WAL-Modus,
   `busy_timeout=5000`, indexer.py:28-33). DB-Pfad-Auflösung mehrstufig: Env-Variable
   `LEGAL_DB_PATH` → `./legal_knowledge.db` (Startverzeichnis) → Datei neben indexer.py →
   `~/.legal-ops-advisor/legal_knowledge.db` (indexer.py:7-24).

**RAG/FTS5:**
- Schema: `files(id, filepath UNIQUE, filename, mtime, chunk_count)`,
  `chunks(id, file_id, content, chunk_index)` mit ON DELETE CASCADE, dazu virtuelle
  FTS5-Tabelle `chunks_fts` (external content auf `chunks`) plus Insert-/Delete-Trigger
  zur Index-Synchronisation (indexer.py:35-80; per `.schema`-Dump in der DB bestätigt).
- Chunking: zeichenbasiertes Sliding Window, 1200 Zeichen mit 200 Überlappung
  (indexer.py:84-94). **Inkonsistenz:** Das Bulk-Skript chunkt anders (500 Zeichen / 50
  Überlappung, ingest_bulk_folder.py:114-116) und legt die FTS-Tabelle OHNE Trigger an
  (ingest_bulk_folder.py:86-88) — läuft es auf eine leere DB zuerst, landen die Chunks
  nicht im FTS-Index.
- Suche: Query wird per Regex von Sonderzeichen bereinigt (`re.sub(r'[^\w\s]', ' ')`,
  indexer.py:213), dann FTS5-MATCH (indexer.py:219-226); liefert das nichts, Fallback auf
  mehrteilige LIKE-Suche (indexer.py:230-241).
- Inkrementelle Indizierung über `mtime`-Vergleich; unveränderte Dateien werden
  übersprungen (indexer.py:164-173). Scan-Limit: 500 Dateien pro Pfad, Ignorierliste für
  `.venv`, `node_modules` u. a. (indexer.py:131-146).


**Ollama/Lokal-Inferenz:**
- Standard-Modus `BACKEND_MODE=auto` = lokal-first (app.py:33-35). Lokales Modell per Env
  konfigurierbar; Default `LOCAL_LLM_MODEL="gemma4:12b-it-qat"` gegen
  `http://localhost:11434/api/chat`, Timeout 180 s (app.py:36-38). Ein Modell dieses Namens
  ist im gebräuchlichen Ollama-Katalog nicht üblich — fehlt es lokal, greift sofort der
  Cloud-Fallback (Kaskade unten).
- Ollama-Call mit `stream=False` und bewusst `think=False`, damit Reasoning-Modelle ihr
  Token-Budget nicht ins „Denken" kippen und leeren Content liefern (app.py:226-246).
- RAM-Schutz: `RAM_MINIMUM_MB` (Default 128) wird vor jeder Inferenz geprüft — via
  `/proc/meminfo` (Linux) bzw. `vm_stat` (macOS); bei Fehler Annahme 8192 MB
  (app.py:45-72, 450-456).

**Fallback-Kaskade (tatsächliche Reihenfolge im Code):**
1. `auto`/`local` → Ollama-Versuch; wirft er eine Exception, folgt bei `auto` Warnlog +
   Gemini-Fallback, bei `local` eine harte Fehlermeldung ohne Cloud-Call (app.py:249-262).
2. Gemini-Call: API-Key aus Env `GEMINI_API_KEY`/`GOOGLE_API_KEY`, sonst aus `app/.env`,
   sonst aus `~/loki-ki/.env` (app.py:182-200). Danach Modell-Kaskade
   `gemini-2.5-flash → gemini-2.5-pro → gemini-1.5-flash → gemini-1.5-pro`, erstes
   erfolgreiches Modell gewinnt (app.py:202-222); scheitern alle, liefert die Funktion
   Fehlerstatus zurück (app.py:224).
3. `BACKEND_MODE=cloud` → direkt Gemini; `local` → nie Cloud (app.py:34, 255-262).
4. RAG-Ebene: `enterprise_rag.hybrid_enterprise_search` versucht zuerst Vertex-AI-
   Datastore-Suche (Projekt-ID-Default `gen-lang-client-0285074833` — ein Google-
   Beispielprojekt); schlägt sie fehl, liefert sie leer und die lokale FTS5-Suche ergänzt
   (enterprise_rag.py:14-73). Scheitert schon das Modul/das Import, nutzt app.py direkt
   `indexer.search_index` (app.py:500-514).

**RIS-Ingest:** `ris_ingest.py` fragt die offizielle OGD-API
`https://data.bka.gv.at/ris/api/v2.6/Judikatur` ab (Applikation z. B. `Vwgh`,
Entscheidungsart=Erkenntnis, optional Suchworte), lädt das XML-Dokument, entfernt Tags per
Regex, verwirft Texte unter 200 Zeichen und speichert unter Pseudo-Pfad
`ris://<Applikation>/<ID>` mit Dedup-Check; 0,3 s Höflichkeitspause pro Dokument;
eingebauter Selbsttest (`assert strip_xml(...)` vor `main()`) (ris_ingest.py:9-74).


**Sub-Agenten-Prompting:**
- Persona-Dateien in `prompts/`: `legal_ops_omni.txt` (Master-Prompt „v7.0 // SUPREME GOD
  MODE", 4583 Bytes), `gdb_analyst.txt`, `vwgh_researcher.txt`, `compliance.txt` plus
  Backup `legal_ops_omni_v6_backup.txt` (Verzeichnis-Listing).
- Der Master-Prompt definiert 6 „Sub-Agenten" (AGENT_01 Richter/Instanzen, AGENT_02
  Zivilrecht, AGENT_03 Steuer, AGENT_04 Notar/Gesellschaftsrecht, AGENT_05 E-Government,
  AGENT_06 Strategie; legal_ops_omni.txt:9-31), Zero-Assumption-/RAG-Regeln mit Zitierpflicht
  nach österr. Zitierstandard (:33-36), einen 4-Phasen-Loop inkl. Chain-of-Verification und
  Abbruch bei Datenlücke (:38-42), BLUF-Pflicht und Output-Protokoll (:44-58) sowie
  Drift-Defense (:61-62). **Die Datei endet mit Abschnitt 7 — ein Abschnitt 8 („Anti-
  Halluzinations-Zwang") existiert HIER nicht** (siehe 5.1 und 3.7).
- Technisches Routing: Ein Gemini-Call klassifiziert die Anfrage in eine JSON-Liste der
  benötigten Personas (Router-Prompt inline, app.py:459-469); Markdown-Fences werden
  entfernt, JSON geparst; bei Fehlschlag gilt die Default-Persona (app.py:470-481). Mehrere
  Personas → System-Prompts werden zu einem „ZTeam"-Prompt verschmolzen (app.py:522-530).
- Kontextaufbau vor dem LLM-Call: erwähnte `/Users/…`-Pfade werden ad-hoc indexiert und aus
  der Nachricht entfernt; `@web …`-Zeilen durch DuckDuckGo-Ergebnisse ersetzt; danach
  Retrieval (enterprise bzw. lokal); alle Fundstücke werden der Nutzernachfrage
  vorangestellt (app.py:483-517).

**Betrieb/Deployment:**
- Lokal: macOS-App via py2app (`setup.py`); Bündel enthält index.html + 4 Prompts, Bundle-ID
  `com.saschalagler.legalopsadvisor` (setup.py:4-21). Die Paketliste (setup.py:10) umfasst
  u. a. fastapi, webview, PyPDF2, duckduckgo_search — aber NICHT `google-genai` und nicht
  `watchdog` (Konsequenz siehe 5.5).
- Cloud: Dockerfile (python:3.11-slim, uvicorn auf PORT 8080; kopiert app.py, indexer.py,
  enterprise_rag.py, prompts/, index.html; Dockerfile:1-21). `COPY legal_knowledge_demo.db`
  referenziert eine Datei, die im Ordner NICHT existiert (Befund: `ls` → fehlt; ein Build
  würde an dieser Stelle scheitern; Dockerfile:12).
- Firebase: Hosting-Konfiguration (`firebase.json`, ignoriert u. a. `*.db`/`*.py`, Rewrite
  auf index.html) + Firestore-/Storage-Regeln (Users/Cases mit Owner-Bindung und Rollen-
  Whitelist lawyer/paralegal/tester, Default-Deny; Storage nur eigene userId, max. 50 MB,
  nur pdf/text/markdown/json; firestore.rules:23-51, storage.rules:4-10).

**Umgebungsdatei (nur Keys, Werte maskiert):** `app/.env` enthält genau EINEN Key:
`GEMINI_API_KEY=<maskiert, 40 Zeichen>`. Keine weiteren Keys (Befund: `cut -d= -f1 .env`).

**SQLite-Inspektion (Befund 05.08.2026):**
- `app/legal_knowledge.db` (36,9 KB, zuletzt geändert 04.08. 21:41): Tabellen `files`,
  `chunks`, `chunks_fts` (+ FTS-Schattentabellen) und Sync-Trigger vorhanden — aber
  **0 Dateien, 0 Chunks, 0 FTS-Einträge**; Beispielauswahl liefert keine Zeilen. Die DB ist
  leer.
- `~/.legal-ops-advisor/legal_knowledge.db` (716,8 KB, zuletzt 28.07.): **22 Dateien, 264
  Chunks**; Zusammensetzung: 17 × `upload://…`, 5 × lokale Dateipfade, **0 × `ris://…`**
  (ris_ingest hat in keiner der beiden DBs sichtbare Spuren hinterlassen). Beispiel:
  `upload://1_EMAIL_AN_BH_MELK.txt` (2 Chunks), Beginn: E-Mail an eine `…@noel.gv.at`-
  Adresse betreffend § 54b Abs 2 VStG mit mehreren Aktenzeichen (echte Verfahrensdaten).
  Welche DB die laufende App tatsächlich nutzt, hängt von Env-Variable und Startverzeichnis
  ab (indexer.py:7-24) — startet die App aus `app/`, greift die LEERE DB.


**3.7 Diskrepanz-Check: FULL_AUDIT & RIS-Fix-Doku vs. tatsächlicher Code**

| Doku-Behauptung | Befund im auditierten Ordner `app/` |
|---|---|
| FULL_AUDIT: `app.py` = FastAPI-Middleware | ✅ EXISTIERT (23.818 B, 573 Zeilen) und enthält die komplette Logik; `desktop_app.py` ist nur der Launcher (desktop_app.py:8) |
| FULL_AUDIT: desktop_app.py prüft `.venv` | ❌ kein .venv-Check im aktuellen Code (66 Zeilen, vollständig gelesen) |
| FULL_AUDIT: Fenstertitel „v6.0 M4-Native :: Polymath-Core" | ❌ aktueller Titel schlicht „Legal Ops Advisor" (desktop_app.py:59); nur der index.html-Titel trägt „v6.0" (index.html:6) |
| FULL_AUDIT: FTS5-Fix via `" OR ".join(...)` | ❌ Code nutzt Regex-Sanitisierung `re.sub(r'[^\w\s]', ' ')` ohne OR-Verknüpfung (indexer.py:213) |
| FULL_AUDIT: „manuelle Persona-Auswahl entfernt" | ❌ UI hat weiterhin Persona-Buttons + `selectPersona()` (index.html:737-743); /query sendet die gewählte Persona (index.html:833-837) |
| FULL_AUDIT: DB-Schema `files(…, chunks)` | ❌ Spalte heißt `chunk_count` (indexer.py:39-47) — kosmetisch |
| RIS-Fix-Doku: `ris_lookup.py` neu gebaut & integriert | ❌ in `app/` existiert KEIN ris_lookup.py (`find` ohne Treffer); app.py referenziert es nicht (grep: 0 Treffer). Kopien liegen nur unter `LEGAL_OPS_MASTER_ARCHIV/…`; dort ist die Integration in `app_v2.py:508-509` sichtbar — nicht im auditierten `app.py` |
| RIS-Fix-Doku: Anti-Halluzinations-Zwang in `legal_ops_omni.txt` Abschnitt 8 | ❌ Datei endet mit Abschnitt 7 (vollständig gelesen); kein „[zu verifizieren]"-Mechanismus in Prompt oder Code auffindbar |
| RIS-Fix-Doku: Dockerfile um ris_lookup.py ergänzt | ❌ Dockerfile (Dateidatum 22.07.) kopiert kein ris_lookup.py (Dockerfile:13-17) |
| RIS-Fix-Doku: „lokal :7070 verifiziert" mit RIS-Quelle | ⚠️ im vorliegenden Quellstand nicht nachvollziehbar; die Fix-Bausteine fehlen hier (Dateidaten 22.07. vs. Doku-Datum 26.07.) |

**Fazit des Diskrepanz-Checks:** Der auditierte `app/`-Ordner ist ein Quellstand von ~22.07.
Er deckt sich mit dem FULL_AUDIT in der Grobarchitektur (app.py existiert tatsächlich), aber
NICHT mit dem RIS-Fix-Stand vom 26.07. Die gefixten Bausteine (`ris_lookup.py`, `app_v2.py`,
Prompt-Abschnitt 8) existieren nur im `LEGAL_OPS_MASTER_ARCHIV` — die hier geprüfte App hat
daher **keinen Live-RIS-Zugriff und keinen erzwungenen Beleg-Zwang**.


## 4. Stärken (mit Beleg)

- **Mehrschichtiges, durchgängig abgesichertes Fallback-Design:** Jede Ebene hat einen
  Plan B — lokal→Cloud (app.py:249-262), 4-stufige Modell-Kaskade (app.py:202-222),
  FTS5→LIKE-Suche (indexer.py:230-241), Enterprise→Lokal (app.py:500-514), alles in
  try/except verpackt; nichts wirft den Server um.
- **Lokale, kostenlose Datenhaltung statt Cloud-Vektordatenbank:** SQLite FTS5 mit
  Sync-Triggern, WAL-Modus, inkrementelle Indizierung über `mtime` — schnell, offline,
  ohne Drittkosten (indexer.py:28-80, 164-173).
- **Privacy-Design als Absicht klar vorhanden:** Ollama-first, mit `BACKEND_MODE=local`
  hart cloud-frei schaltbar (app.py:34, 255-262) — die Umsetzung hat allerdings Lücken
  (siehe 5.2).
- **Ressourcen-Schutz:** RAM-Prüfung vor jeder Inferenz mit sauberem HTTP 503
  (app.py:450-456); LLM-Aufrufe werden serialisiert (app.py:43, 521).
- **Anmutige Degradierung (Graceful Degradation):** Watchdog optional (app.py:86-94),
  enterprise_rag optional (app.py:500-506), Ollama optional — die App läuft auch ohne
  diese Bausteine.
- **Durchdachtes Prompt-Engineering:** 4-Phasen-Loop mit Chain-of-Verification, Abbruch-
  pflicht bei Datenlücke, BLUF-Zwang, Zitierstandard — für einen Einzelpersonen-Prompt
  bemerkenswert strukturiert (legal_ops_omni.txt:33-58).
- **Ehrliches Evaluations-Tooling:** run_eval.py misst PASSED-Quote, Norm-Treffer-Heuristik
  und Latenz und druckt die Bilanz ausdrücklich als „ERGEBNIS (ehrlich)" (run_eval.py:64-69).
- **Solide (wenn auch ungenutzte) Firebase-Sicherheitsregeln:** Default-Deny, Owner-
  Bindung, keine Selbst-Beförderung der Rolle, Soft-Delete, 50-MB-/Content-Type-Limits
  (firestore.rules:23-51, storage.rules:4-10).
- **Sauberes RIS-Ingest-Werkzeug:** offizielle OGD-API, Deduplizierung, Rate-Limit,
  eingebauter Selbsttest vor dem Lauf (ris_ingest.py:9-74).
- **Transparenz im UI:** Der jeweils aktive System-Prompt ist per Modal einsehbar
  (index.html:718-731); Backend-Status und DB-Statistik werden laufend angezeigt
  (index.html:681-709).

## 5. Schwächen/Risiken (mit Beleg)

**5.1 Halluzinations-Risiko, wenn die DB keine Antwort hat — bestätigt und verschärft.**
Das FULL_AUDIT (Teil 3, Zeilen 61-76) beschreibt es selbst: Die App durchsucht NUR die
lokale SQLite-DB; findet sie nichts, „muss das LLM die Antwort raten" — und dokumentiert
die bewusste Entscheidung GEGEN einen automatischen Web-Zwang. Die Code-Prüfung bestätigt,
dass kein Web-Zwang existiert: Websuche läuft ausschließlich auf das explizite Schlüsselwort
`@web` (app.py:492-497); eine Live-RIS-Abfrage ist in diesem Code-Stand nirgends eingebunden
(grep `ris_lookup`/`ris.bka.gv.at` in app.py: 0 Treffer; `ris_lookup.py` fehlt im Ordner,
Befund: `find`). Der Prompt verlangt zwar Primärquellen-Zitate (legal_ops_omni.txt:33-36),
aber es gibt KEINE technische Durchsetzung — und der in der RIS-Fix-Doku behauptete Prompt-
Abschnitt 8 („Anti-Halluzinations-Zwang", sonst „[zu verifizieren]") existiert in dieser
Datei nicht (sie endet mit Abschnitt 7). Verschärfend kommt der DB-Befund hinzu: Die
Projekt-DB `app/legal_knowledge.db` ist LEER (0 Dateien / 0 Chunks), und auch die Home-DB
enthält nur 22 Dateien ohne jeden RIS-Eintrag (0 × `ris://`). Praktisch heißt das: Retrieval
liefert fast immer nichts → fast jede Antwort stammt rein aus dem Trainingswissen der KI →
das FULL_AUDIT-Risiko ist hier nicht theoretisch, sondern der Normalfall (inkl. des im
RIS-Fix-Dokument belegten Präzedenzfalls: GmbH-Stammkapital „35.000 €" statt korrekt
10.000 €, RIS-Fix_Verifikation §2-Tabelle).


**5.2 Stiller Cloud-Fallback untergräbt das Privatheits-Versprechen.** Der Default-Modus
ist `auto`; ist Ollama nicht erreichbar (und der Default-Modellname `gemma4:12b-it-qat`
ist kein gebräuchliches Ollama-Modell, app.py:37 — ohne manuelle Installation fällt der
Lokalpfad also praktisch immer aus), gehen ALLE Anfragen samt Kontext an Google Gemini —
nur protokolliert als Warnung, nicht sichtbar für den Nutzer (app.py:255-262). Brisant:
Per Upload angehängte Dokumente werden als Volltext in die Chat-Nachricht kopiert
(index.html:802, 821, 833-837) und landen damit im Cloud-Call; ebenso ad-hoc eingelesene
`/Users/…`-Pfade (app.py:486-490, Kontext-Join app.py:516-517). Echter Datenschutz nur mit
explizit `BACKEND_MODE=local`.

**5.3 Keine Authentifizierung + offene CORS-Konfiguration.** Alle Endpunkte (/query,
/upload, /ingest_paths, /cases …) sind ungeschützt (keinerlei Auth-Logik in app.py).
CORS erlaubt `*` bei gleichzeitig `allow_credentials=True` (app.py:78-84). Der Desktop-
Wrapper bindet zwar nur an 127.0.0.1 (desktop_app.py:43), der Standalone-/Docker-Pfad
bindet jedoch an 0.0.0.0 (app.py:573, Dockerfile:21) — im Netz exponiert, ohne jeden
Schutz.

**5.4 Unbeschränkter lokaler Dateizugriff über den Chat.** `/query` extrahiert per Regex
beliebige `/Users/…`-Pfade aus der Nachricht und indexiert sie kommentarlos (app.py:486-
490); `read_local_path` liest beliebige Dateien (app.py:340-356). Keine Beschränkung auf
erlaubte Verzeichnisse → kombiniert mit 5.2 können Dateiinhalte unbeabsichtigt in die
Cloud gelangen; auch Prompt-Injection über Dokumentinhalte ist nicht abgesichert.

**5.5 Verpackungs-/Build-Lücken.** py2app-Paketliste enthält weder `google-genai` noch
`watchdog` (setup.py:10) → in der gebauten Mac-App fehlt die Cloud-Fallback UND der
Datei-Watcher. Das Dockerfile kopiert eine nicht existierende Datei
(`legal_knowledge_demo.db`, Dockerfile:12; Befund: `ls` → fehlt) → Container-Build bricht
ab. Das Bulk-Skript legt die FTS-Tabelle ohne Sync-Trigger an (ingest_bulk_folder.py:86-88)
→ auf einer frischen DB wird der Suchindex nicht befüllt.

**5.6 Datenbank-Fragmentierung.** Vier mögliche DB-Pfade (indexer.py:7-24) plus der
Home-only-Pfad des Bulk-Skripts (ingest_bulk_folder.py:16-18) plus die Docker-Demo-DB;
zueinander inkonsistentes Chunking (1200/200 vs. 500/50). Folge: Welche Daten die App
wirklich „sieht", ist vom Startverzeichnis abhängig — im vorliegenden Audit war die im
Projektordner liegende DB leer, obwohl die Home-DB 264 Chunks enthält.

**5.7 Firebase-Schicht ist Fassade.** `app.py` enthält NULL Referenzen auf Firebase/
Firestore/Storage (grep-Treffer: 0), obwohl Regeln, Hosting-Konfig und Cloud-Storage-
Pakete (requirements.txt:2-3) existieren. Die Multi-User-/Mandanten-Architektur ist im
Backend nicht umgesetzt — die Regeln beschreiben ein System, das es (noch) nicht gibt.

**5.8 „Enterprise RAG" ist faktisch toter Code.** Die Vertex-Suche zeigt per Default auf
das Google-Beispielprojekt `gen-lang-client-0285074833` (enterprise_rag.py:14-16) — dort
existiert kein Rechts-Datastore. Die beworbenen „100.000+ Dokumente" (enterprise_rag.py:3,
ingest_bulk_folder.py:4) haben keine nachweisbare Grundlage im vorliegenden Bestand.

**5.9 Weitere Beobachtungen (kleiner):** Hartkodierte Nutzerpfade `/Users/saschalagler`
(app.py:126, 541, 566; desktop_app.py:20-23) → nicht portabel; `/cases` gibt die komplette
Desktop-Ordnerstruktur preis (app.py:538-559); veralteter Code-Kommentar („gemini-1.5-pro",
app.py:3-4) vs. tatsächlich `gemini-2.5-flash` (app.py:31); run_eval zielt standardmäßig
auf die produktive Cloud-Run-URL (run_eval.py:2) — Tests könnten Live-Kosten/Last erzeugen.


## 6. Beleg-Verzeichnis (Behauptung → Beleg)

| # | Behauptung | Beleg (Datei:Zeile / Befund) |
|---|---|---|
| 1 | `app.py` existiert und trägt die komplette FastAPI-Logik | Befund: `ls -la app/` → app.py 23.818 B; app.py:77-573 |
| 2 | desktop_app.py ist nur ein Launcher (uvicorn + pywebview) | desktop_app.py:8, 42-65 |
| 3 | Server lauscht im Desktop-Modus auf 127.0.0.1:7070 | desktop_app.py:43 |
| 4 | CORS erlaubt alle Origins + Credentials | app.py:78-84 |
| 5 | BACKEND_MODE auto/local/cloud, lokal-first | app.py:33-35, 249-262 |
| 6 | Ollama-Default `gemma4:12b-it-qat`, Port 11434, think=False | app.py:36-38, 226-246 |
| 7 | Gemini-Kaskade über 4 Modelle; Key-Quellen Env → app/.env → ~/loki-ki/.env | app.py:182-224 |
| 8 | RAM-Schutzschwelle 128 MB mit HTTP 503 | app.py:45-72, 450-456 |
| 9 | 4 Personas + Auto-Router (Gemini-JSON-Routing) | app.py:167-172, 459-481 |
| 10 | ZTeam-Prompt-Verschmelzung bei Mehrfach-Routing | app.py:522-530 |
| 11 | SQLite-Schema files/chunks + FTS5 + Sync-Trigger | indexer.py:35-80; Befund: `.schema`-Dump der DB |
| 12 | Chunking 1200 Zeichen / 200 Überlappung | indexer.py:84-94 |
| 13 | FTS5-Suche mit Regex-Sanitisierung + LIKE-Fallback | indexer.py:213, 219-241 |
| 14 | Inkrementelle Indizierung über mtime; 500-Dateien-Limit | indexer.py:164-173, 143-146 |
| 15 | Mehrstufige DB-Pfad-Auflösung (Env → CWD → Datei → Home) | indexer.py:7-24 |
| 16 | Projekt-DB `app/legal_knowledge.db` ist LEER | Befund: `sqlite3 … COUNT(*)` → files 0, chunks 0, chunks_fts 0 |
| 17 | Home-DB: 22 Dateien / 264 Chunks; 17 uploads, 5 Pfade, 0 RIS | Befund: `sqlite3 ~/.legal-ops-advisor/legal_knowledge.db …` |
| 18 | Beispiel-DB-Eintrag = echtes Verfahrensdocument (BH Melk) | Befund: `SELECT … FROM files LIMIT` → upload://1_EMAIL_AN_BH_MELK.txt; Chunk-Text § 54b VStG |
| 19 | Desktop-Watcher + Hintergrund-Ingest beim Start | app.py:99-153 |
| 20 | Upload-Endpoint speichert als `upload://` und hängt Volltext an | app.py:358-418; index.html:790-809, 821 |
| 21 | Ad-hoc-Ingest beliebiger `/Users/…`-Pfade aus der Nachricht | app.py:486-490 |
| 22 | Websuche NUR über `@web` (DuckDuckGo, max. 3 Treffer) | app.py:330-338, 492-497 |
| 23 | RIS-Batch-Ingest über OGD-API mit Dedup + Selbsttest | ris_ingest.py:9-74 |
| 24 | Bulk-Ingest: 500er-Chunking, FTS ohne Trigger, Home-DB-Pfad | ingest_bulk_folder.py:16-18, 86-88, 114-116 |
| 25 | Enterprise-Hybrid-Suche auf Beispielprojekt-ID | enterprise_rag.py:14-73 |
| 26 | `.env` enthält nur `GEMINI_API_KEY` (Wert maskiert, 40 Zeichen) | Befund: `cut -d= -f1 app/.env`; Wert nie ausgegeben |
| 27 | Master-Prompt: 6 Sub-Agenten, Zero-Assumption, 4-Phasen-Loop, BLUF | legal_ops_omni.txt:9-58 |
| 28 | Prompt endet mit Abschnitt 7; KEIN Abschnitt 8 (Beleg-Zwang) | legal_ops_omni.txt (vollständig gelesen, 62 Zeilen) |
| 29 | Kein ris_lookup.py im auditierten `app/`; nur im MASTER_ARCHIV | Befund: `find … -name 'ris_lookup*'`; grep app.py → 0 Treffer; Archiv: app_v2.py:508-509 |
| 30 | Dockerfile kopiert fehlende `legal_knowledge_demo.db` | Dockerfile:12; Befund: `ls` → Datei fehlt |
| 31 | py2app-Paketliste ohne google-genai/watchdog | setup.py:10 |
| 32 | Firebase-Regeln vorhanden, aber 0 Anbindung im Backend | firestore.rules:23-51, storage.rules:4-10; Befund: grep firebase/firestore in app.py → 0 |
| 33 | Frontend-Backend-Wahl (Param → localStorage → Cloud Run → :7070) | index.html:650-665 |
| 34 | Standalone-/Docker-Pfad bindet an 0.0.0.0 | app.py:573; Dockerfile:21 |
| 35 | FULL_AUDIT-Aussagen zu Halluzination & Web-Zwang-Entscheidung | FULL_AUDIT_LEGAL_OPS.md:61-76 |
| 36 | RIS-Fix-Behauptungen (ris_lookup, Abschnitt 8, Dockerfile-Fix) | RIS-Fix_Verifikation_2026-07-26.md §1-2 (hier gegen Code falsifiziert, Zeilen 5-9) |
| 37 | Eval-Harness mit ehrlicher Bilanz + Norm-Treffer-Heuristik | run_eval.py:24-31, 64-69 |
| 38 | Hardkodierte Nutzerpfade `/Users/saschalagler` | app.py:126, 541, 566; desktop_app.py:20-23 |

**Schlussbemerkung (ehrlich):** Die App ist ein ernstzunehmendes, durchdachtes Einzelprojekt
mit sauberer RAG-Grundlage und mehrschichtigen Fallbacks. Ihr größtes operationelles Risiko
ist nicht der Code selbst, sondern die Lücke zwischen Anspruch und Datenlage: Die Prompts
versprechen Primärquellen-Treue, aber der geprüfte Stand hat weder Live-RIS-Zugriff noch
Beleg-Zwang, und die lokale Wissensbasis ist im Projektordner leer bzw. in der Home-DB ein
kleiner, RIS-freier Aktenrest. Die in den Doku-Dateien beschriebenen Fixes existieren —
aber nur im Archiv, nicht in der hier auditierten Arbeitskopie.



---

# TEIL 2 · JUDICARIO

# RESEARCH: Judicario — Primärquellen (Stand 05.08.2026)

> Geprüft ausschließlich anhand der Primärquellen im Ordner `judicario/` + Sekundärquelle `JUDICARIO_RESEARCH.md`. Jede Behauptung trägt einen Beleg (Datei:Zeile); Auflösung in § 8. Der API-Key wird nirgends im Wortlaut zitiert, sondern nur maskiert als `jud_gtSG0t_…`.

## 1. Was ist es? (Klartext)

Judicario ist der **Rechts-Motor von OpenLaw**, der in Claude eingebaut wird: kein eigenes UI, kein eigenes Gedächtnis — Claude bleibt Cockpit und Speicher, Judicario liefert die juristische Substanz (Gesetzestexte, Rechtsprechung, Steuer-Berechnungen, Versicherungsdeckung) für AT, DE, CH und EU. Amtliche Gesetzestexte liefert der Motor sogar wörtlich (verbatim, gemeinfrei), damit Claude nichts paraphrasieren muss (Beleg: `JUDICARIO_RESEARCH.md:34,49`). Technisch ist es ein MCP-Connector-Paket: 6 bzw. 8 Module, jedes eine HTTP-URL zum selben Gateway (Beleg: `.mcp.json:2-24`, `Connectoren_URLs.txt:4-15`). Drei Einbauwege: Claude Code per Doppelklick-Script, Claude Desktop als lokales Plugin, Claude Web per manuellem URL-Eintrag (Beleg: `LIESMICH.txt:4-6`). Ausgeliefert als "enterprise"-Tarif mit 100.000 Credits (Beleg: `README.md:5`).

## 2. Module & Konnektoren

| Modul | Inhalt (lt. Quellen) | `.mcp.json` | `Connectoren_URLs.txt` | `README.md` | Install-Script |
|---|---|---|---|---|---|
| at | Judicario Österreich | ✅ Z. 2 | ✅ Z. 4-5 | ✅ Z. 8 | ✅ Z. 9 |
| de | Judicario Deutschland | ✅ Z. 6 | ✅ Z. 6-7 | ✅ Z. 9 | ✅ Z. 9 |
| ch | Judicario Schweiz | ✅ Z. 10 | ✅ Z. 8-9 | ✅ Z. 10 | ✅ Z. 9 |
| eu | Judicario EU & Menschenrechte | ✅ Z. 14 | ✅ Z. 10-11 | ✅ Z. 11 | ✅ Z. 9 |
| ip | Judicario IP · Copyright & Trademark (EU) | ✅ Z. 18 | ✅ Z. 12-13 | ✅ Z. 12 | ✅ Z. 9 |
| steuer | Judicario Steuer · Abgabenrecht (AT) | ✅ Z. 22 | ✅ Z. 14-15 | ✅ Z. 13 | ✅ Z. 9 |
| insurance | Versicherungsdeckung (von `/deckungscheck` benötigt) | ❌ | ❌ | ❌ | ✅ Z. 9 |
| steuer-de | DE-Steuer-Spezialfälle (von `/steuer` mitbenutzt) | ❌ | ❌ | ❌ | ✅ Z. 9 |

**Die 6-vs-8-Diskrepanz (exakt dokumentiert):**
- Die Plugin-Konfiguration registriert **6 Module**: `judicario-at/-de/-ch/-eu/-ip/-steuer` (Beleg: `.mcp.json:2,6,10,14,18,22`).
- README, plugin.json und die Connector-URL-Liste nennen ebenfalls exakt diese **6** (Beleg: `README.md:5,8-13`, `plugin.json:3`, `Connectoren_URLs.txt:4-15`).
- Das Claude-Code-Install-Script registriert dagegen **8 Module**: die Schleife `for m in at de ch eu ip steuer insurance steuer-de` (Beleg: `Judicario_in_Claude_Code_installieren.command:9`) und meldet "Fertig - 8 Judicario-Connectoren registriert" (Beleg: ebenda:13; Kommentar "registriert 8 Modul-Connectoren" ebenda:2).
- **Konsequenz:** Auf dem Claude-Code-Weg sind `insurance` und `steuer-de` verfügbar, auf dem Desktop-/Web-Weg (Plugin + `.mcp.json`) fehlen sie. Dabei benötigt `/deckungscheck` genau die Versicherungs-Tools (`judicario_deckungspruefung`, `judicario_versicherung_norm`, `judicario_versicherung_klausel`, Beleg: `commands/deckungscheck.md:6-7`), und `/steuer` verweist auf DE-Spezial-Tools wie `judicario_steuer_engine` (Beleg: `commands/steuer.md:6-9`). Wer Judicario als Desktop-Plugin oder in Claude Web installiert, bekommt also zwei Commands, deren zugehörige Konnektoren dort nicht mitgeliefert werden.

Alle Module zeigen auf denselben Gateway-Pfad `https://gateway.openlaw.cc/mcp/{modul}/` und nutzen denselben API-Key als URL-Parameter `?k=…` (Beleg: `.mcp.json:4,8,12,16,20,24`, `Connectoren_URLs.txt:5,7,9,11,13,15`).



## 3. Funktionen/Workflows (die 8 Slash-Commands)

| Command | Was er tut (aus der jeweiligen Command-Datei) |
|---|---|
| `/norm` | Schlägt den amtlichen Gesetzestext nach (`judicario_gesetz`) und findet anwendende Judikatur (`judicario_rechtsprechung_zu_norm`); Zusammenfassung von Tatbestand + Leitsätzen mit Fundstellen (Beleg: `commands/norm.md:5-8`). |
| `/recherche` | Recherchiert Rechtsprechung via `judicario_urteilssuche` (Jurisdiktionen AT/DE/CH/EU/EGMR); jede zitierte Entscheidung wird mit `judicario_dokument` (RS-Nr/ECLI/CELEX/GZ) verifiziert — "KEINE unverifizierten Zitate" (Beleg: `commands/recherche.md:5-8`). |
| `/gutachten` | Erstellt ein strukturiertes Rechtsgutachten im Gutachtenstil; jede Rechtsbehauptung ist mit Judikatur zu belegen, Literatur nur als Kurzzitat (`judicario_fachliteratur`), Zitate verifizieren; Ergebnis + offene Tatfragen + Beweislast klar benennen (Beleg: `commands/gutachten.md:5-9`). |
| `/schriftsatz` | Entwirft einen einbringungsfertigen Schriftsatz (Klage/Berufung/Beschwerde/Antrag); tragende Normen/RS werden mit `judicario_dokument` VERIFIZIERT, optional `docx-kanzlei`-Skill fürs Kanzlei-Layout, Formvorschriften für Gerichtseingaben beachten (Beleg: `commands/schriftsatz.md:5-9`). |
| `/fall-triage` | Ersteinschätzung eines eingehenden Falls über alle Korpora via `judicario_landkarte`; leitet Risiko/Dringlichkeit (explizit: Fristen!) und 3–5 konkrete nächste Schritte ab (Beleg: `commands/fall-triage.md:5-7`). |
| `/rechtsvergleich` | Grenzüberschreitender Vergleich AT/DE/CH/EU: `judicario_landkarte` pro Jurisdiktion, dann gezielte Norm-/Urteilssuche; Ergebnis als tabellarische Gegenüberstellung mit Fundstellen je Rechtsordnung (Beleg: `commands/rechtsvergleich.md:5-7`). |
| `/steuer` | Steuerrecht AT/DE: Judikatur (VwGH/BFG bzw. BFH/FG) + Richtlinien (EStR/KStR bzw. EStH/UStAE/AEAO) + Normen mit Rz; Rechnen "IMMER deterministisch" über `judicario_steuer_berechnung` bzw. `judicario_steuer_engine` für DE-Spezialfälle (Beleg: `commands/steuer.md:5-9`). |
| `/deckungscheck` | Prüft Versicherungsdeckung (AT/DE): `judicario_deckungspruefung` mit Sachverhalt + Sparte als Gerüst, Vertiefung über VersVG↔VVG-Normen und AVB-Klauseln; Ergebnis Deckung ja/nein/offen + Obliegenheiten/Ausschlüsse mit Fundstellen (Beleg: `commands/deckungscheck.md:5-8`). |

## 4. Technik

- **Transport:** Alle sechs Einträge in `.mcp.json` sind `"type": "http"` — Streamable HTTP über MCP (Beleg: `.mcp.json:3,7,11,15,19,23`); das Install-Script registriert mit `claude mcp add --transport http -s user` auf User-Ebene (Beleg: `Judicario_in_Claude_Code_installieren.command:11`).
- **Gateway:** zentraler Endpunkt `gateway.openlaw.cc`, Pfad `/mcp/{modul}/`, API-Key als Query-Parameter `?k=…` (Beleg: `.mcp.json:4`).
- **Auth:** ein einziger API-Key (`jud_gtSG0t_…`) für alle Module — Details in § 5.
- **Response-Format (lt. Sekundärquelle):** JSON mit den Feldern `kind`, `modus`, `hinweis`, `treffer` (z. B. `at_norms.results[]` mit `_id`, `law_key`, `canonical_key`, `text_content`); amtlicher Gesetzestext kommt verbatim in `text_content`, mit Hinweis "darf WÖRTLICH/verbatim ausgegeben werden" (Beleg: `JUDICARIO_RESEARCH.md:30-49`).
- **Betriebsverhalten (lt. Sekundärquelle):** Judicario ist HTTP-JSON-RPC über MCP; der Gateway ist direkt per HTTP-POST ansprechbar, ohne Claude; Latenz ~1,2 s Verbindungsaufbau, ~0,3–0,8 s pro Tool-Call; der SSE-Stream droppt nach ~165 s → Reconnect erforderlich (Beleg: `JUDICARIO_RESEARCH.md:62-66`).
- **Plugin-Metadaten:** Name `judicario`, Version `0.2.0`, Autor "Judicario / OpenLaw", Kontakt berger@openlaw.cc; Beschreibung nennt die 6 freigeschalteten Module (Beleg: `plugin.json:2-8`).
- **Anleitungen:** `Anleitung_DE.html` (~94 KB) und `Guide_EN.html` (~94 KB) liegen bei; `LIESMICH.txt` verweist jedoch auf "Anleitung_DE.pdf (oder Guide_EN.pdf)", die im Verzeichnis nicht existieren (Beleg: Verzeichnislisting `judicario/` vs. `LIESMICH.txt:3`).



## 5. Sicherheits-Befunde

**Klartext zuerst:** Der Schlüssel zum gesamten Rechts-Motor liegt offen im Paket — jeder, der diese Dateien sieht (Rechner, Backup, geteilte ZIPs, Screenshot), hat vollen Zugriff auf alle Module und das Credit-Kontingent. Es gibt keinen Schlüssel pro Nutzer und keinen pro Modul: ein Generalschlüssel für alles.

1. **API-Key steht im Klartext an drei Stellen der Auslieferung:**
   - `.mcp.json`: in allen sechs Modul-URLs als `?k=jud_gtSG0t_…` (Beleg: `.mcp.json:4,8,12,16,20,24`).
   - `Connectoren_URLs.txt`: in allen sechs URL-Zeilen als `?k=jud_gtSG0t_…` (Beleg: `Connectoren_URLs.txt:5,7,9,11,13,15`).
   - `Judicario_in_Claude_Code_installieren.command`: als Variable `KEY="jud_gtSG0t_…"` (Beleg: ebenda:8), in Zeile 11 per `$KEY` in alle acht URLs eingesetzt (Beleg: ebenda:11).
   - Zusätzlich vervielfältigt durch den Duplikat-Ordner: die verschachtelte Kopie `judicario/Judicario_Sacha_Mac/judicario/.mcp.json` ist byte-identisch (MD5-geprüft) und enthält denselben Key sechsmal; ebenso das dortige Install-Script.
2. **EIN Key für alle Module:** Alle sechs `.mcp.json`-URLs enthalten exakt dieselbe Zeichenfolge `jud_gtSG0t_…` (Beleg: `.mcp.json:4,8,12,16,20,24`); das Script nutzt eine einzige `KEY`-Variable für alle acht Module (Beleg: `Judicario_in_Claude_Code_installieren.command:8-9`). Damit ist keine Modul-Autorisierung, keine Nutzer-Trennung und kein gezielter Key-Widerruf möglich — ein Leck kompromittiert alles.
3. **Key im URL-Query-Parameter:** Der Key wandert als `?k=…` mit der URL (Beleg: `.mcp.json:4`) und landet dadurch typischerweise in Server-/Proxy-Logs, Browserverlauf und in jeder Datei/Kopie, in der die URL steht (siehe Punkt 1). Ein Authorization-Header wird nicht verwendet.
4. **Weitergabe-Personalisierung:** Das Paket ist auf eine Person zugeschnitten (`Judicario_Sacha_Mac`, inkl. Distributions-ZIPs `Judicario_Sacha_Mac.zip`/`Judicario_Sacha_Windows.zip`, Beleg: Verzeichnislisting `judicario/Judicario_Sacha_Mac/`) — wird derselbe Key an weitere Empfänger verteilt, ist er nicht mehr zuordenbar.
5. **Support-Kontakt im Klartext:** Technik-Support mit E-Mail und Mobilnummer hinterlegt (Beleg: `LIESMICH.txt:8`) — für ein Audit nur eine Randnotiz.

## 6. Stärken (mit Beleg)

- **Verifikations-Disziplin in den Workflows:** `/recherche` verbietet unverifizierte Zitate explizit und schreibt Prüfung jeder Entscheidung über `judicario_dokument` vor (Beleg: `commands/recherche.md:7-8`); `/schriftsatz` verlangt VERIFIZIEREN tragender Normen/RS (Beleg: `commands/schriftsatz.md:6-7`). Das ist die richtige Architektur gegen Halluzination.
- **Deterministisches Rechnen:** Steuerberechnungen laufen nie über das LLM, sondern über `judicario_steuer_berechnung`/`judicario_steuer_engine` — "Rechnen IMMER deterministisch" (Beleg: `commands/steuer.md:8-9`).
- **Verbatim-Gesetzestext:** Amtliche Normtexte kommen wörtlich aus dem Backend (`text_content`, gemeinfrei), statt vom Modell paraphrasiert zu werden (Beleg: `JUDICARIO_RESEARCH.md:34,42-49`).
- **Breite Abdeckung:** AT/DE/CH/EU inkl. EGMR als Jurisdiktionen (Beleg: `commands/recherche.md:6`), plus Fachdomänen IP (`README.md:12`), Steuer (`README.md:13`) und Versicherung (`README.md:23`).
- **Einfache Installation für alle drei Claude-Umgebungen** mit klarem Schnellstart (Beleg: `LIESMICH.txt:4-6`) und idempotentem Script (vorheriges `claude mcp remove` je Modul, Beleg: `Judicario_in_Claude_Code_installieren.command:10`).
- **Durchdachte Aufgaben-Zerlegung:** eigene Commands für Triage, Recherche, Gutachten, Schriftsatz und Rechtsvergleich statt eines Monolith-Prompts (Beleg: `README.md:16-23`, Verzeichnis `commands/`).



## 7. Schwächen (mit Beleg)

- **Klartext-API-Key an mehreren Stellen, EIN Key für alles** — größter Befund, siehe § 5 (Beleg: `.mcp.json:4`, `Connectoren_URLs.txt:5`, `Judicario_in_Claude_Code_installieren.command:8`). Kein Header-basiertes Auth-Schema, keine Schlüssel-Rotation oder -Scoped ersichtlich.
- **6-vs-8-Modul-Diskrepanz:** Das Install-Script registriert 8 Konnektoren inkl. `insurance` und `steuer-de` (Beleg: `Judicario_in_Claude_Code_installieren.command:9,13`), doch `.mcp.json`, README, plugin.json und URL-Liste kennen nur 6 (Beleg: `.mcp.json:2-24`, `README.md:5,8-13`, `plugin.json:3`, `Connectoren_URLs.txt:4-15`). Auf Desktop-/Web-Weg sind `/deckungscheck` und DE-Steuer-Tools ohne zugehörigen Konnektor (Beleg: `commands/deckungscheck.md:6-7`, `commands/steuer.md:6-9`).
- **Duplikat-/Wildwuchs-Struktur:** Im Paket liegt ein vollständiger verschachtelter Duplikat-Baum `judicario/Judicario_Sacha_Mac/` mit eigener `judicario/`-Kopie (byte-identisch per MD5), zwei Distributions-ZIPs (`Judicario_Sacha_Mac.zip` ~139 KB, `Judicario_Sacha_Windows.zip` ~139 KB) und `.DS_Store`-Dateien (Beleg: Verzeichnislisting `judicario/` und `judicario/Judicario_Sacha_Mac/`). Risiko: Drift zwischen Kopien und unbeabsichtigte Key-Weiterverbreitung über ZIPs.
- **Doku-Inkonsistenz:** `LIESMICH.txt` verweist auf `Anleitung_DE.pdf`/`Guide_EN.pdf`, vorhanden sind aber nur die gleichnamigen `.html`-Dateien (Beleg: `LIESMICH.txt:3` vs. Verzeichnislisting `judicario/`).
- **Instabiler Stream:** Der SSE-Stream bricht nach ~165 s ab und braucht einen Reconnect (Beleg: `JUDICARIO_RESEARCH.md:66`) — relevant für lange Recherchen.
- **README-Zielangabe weicht ab:** README adressiert "Claude Desktop" (Beleg: `README.md:3,25`), das Install-Script hingegen Claude Code (Beleg: `Judicario_in_Claude_Code_installieren.command:2`), und `LIESMICH.txt` nennt zusätzlich Claude Web (Beleg: `LIESMICH.txt:6`) — drei Zielplattformen, aber keine einzelne Quelle deckt alle konsistent ab.
- **Kein Hinweis auf Datenschutz/AVV im Paket:** Trotz personenbezogener Falldaten und Support-Weitergabe per WhatsApp findet sich in den geprüften Primärquellen kein Datenschutz-/Auftragsverarbeitungs-Hinweis (negativer Befund: keine Fundstelle in den gelisteten Dateien).

## 8. Beleg-Verzeichnis (Behauptung → Datei:Zeile)

Pfad-Präfix aller Primärquellen: `/Users/saschalagler/Desktop/Judicario_Sacha_Mac/judicario/`; die Sekundärquelle liegt unter `/Users/saschalagler/Desktop/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/_ARCHIV/JUDICARIO_RESEARCH.md`.

| # | Behauptung | Beleg |
|---|---|---|
| 1 | `.mcp.json` definiert 6 Module (at, de, ch, eu, ip, steuer) | `.mcp.json:2,6,10,14,18,22` |
| 2 | Alle 6 Einträge sind `"type": "http"` | `.mcp.json:3,7,11,15,19,23` |
| 3 | Gateway `gateway.openlaw.cc/mcp/{modul}/`, Key als `?k=…` (maskiert `jud_gtSG0t_…`) | `.mcp.json:4` |
| 4 | Derselbe Key in allen 6 Modul-URLs der `.mcp.json` | `.mcp.json:4,8,12,16,20,24` |
| 5 | URL-Liste mit 6 Modulen + Klartext-Key je URL | `Connectoren_URLs.txt:4-15` (Keys: :5,:7,:9,:11,:13,:15) |
| 6 | plugin.json: Name `judicario`, v0.2.0, OpenLaw, 6 "freigeschaltete" Module | `.claude-plugin/plugin.json:2-8` (Modul-Liste: :3) |
| 7 | Tarif enterprise, 100000 Credits, 6 Module | `README.md:5` |
| 8 | Connector-Zuordnung 6 Module | `README.md:8-13` |
| 9 | 8 Workflows/Tiles als Slash-Commands | `README.md:16-23` |
| 10 | Installationsweg "Lokales Plugin hochladen" | `README.md:25` |
| 11 | Drei Installationswege (Code/Script, Desktop/Plugin, Web/URLs) | `LIESMICH.txt:4-6` |
| 12 | Anleitung referenziert PDFs, nur HTML vorhanden | `LIESMICH.txt:3` vs. `ls judicario/` |
| 13 | Support-Kontakt inkl. WhatsApp-Nummer | `LIESMICH.txt:8` |
| 14 | Script registriert 8 Modul-Connectoren (Kommentar) | `Judicario_in_Claude_Code_installieren.command:2` |
| 15 | EIN Key als Variable `KEY="jud_gtSG0t_…"` (maskiert) | `Judicario_in_Claude_Code_installieren.command:8` |
| 16 | Schleife über 8 Module: at de ch eu ip steuer insurance steuer-de | `Judicario_in_Claude_Code_installieren.command:9` |
| 17 | Registrierung via `claude mcp add --transport http -s user` | `Judicario_in_Claude_Code_installieren.command:11` |
| 18 | Abschlussmeldung "8 Judicario-Connectoren registriert" | `Judicario_in_Claude_Code_installieren.command:13` |
| 19 | `/norm`: Gesetz + Judikatur zur Norm, mit Fundstellen | `commands/norm.md:5-8` |
| 20 | `/recherche`: Urteilsuche + Pflicht zur Verifikation; keine unverifizierten Zitate | `commands/recherche.md:5-8` |
| 21 | `/gutachten`: Gutachtenstil, Belegpflicht, Kurzzitat-Literatur, Ergebnis/Tatfragen/Beweislast | `commands/gutachten.md:5-9` |
| 22 | `/schriftsatz`: einbringungsfertig, VERIFIZIEREN, docx-kanzlei, Formvorschriften | `commands/schriftsatz.md:5-9` |
| 23 | `/fall-triage`: Landkarte, Fristen/Dringlichkeit, 3-5 nächste Schritte | `commands/fall-triage.md:5-7` |
| 24 | `/rechtsvergleich`: Landkarte pro Jurisdiktion, Tabelle mit Fundstellen | `commands/rechtsvergleich.md:5-7` |
| 25 | `/steuer`: AT/DE-Judikatur/Richtlinien/Normen; deterministisches Rechnen über Engine | `commands/steuer.md:5-9` |
| 26 | `/deckungscheck`: Deckungsprüfung + VersVG↔VVG + AVB-Klauseln; Deckung ja/nein/offen | `commands/deckungscheck.md:5-8` |
| 27 | Response-Format `kind/modus/hinweis/treffer` + verbatim `text_content` | `_ARCHIV/JUDICARIO_RESEARCH.md:30-49` |
| 28 | HTTP-JSON-RPC, direkter POST möglich, Latenzwerte, SSE-Drop nach 165 s | `_ARCHIV/JUDICARIO_RESEARCH.md:62-66` |
| 29 | Duplikat-Baum + 2 ZIPs; innere `.mcp.json`/Script byte-identisch (MD5) | `ls judicario/Judicario_Sacha_Mac/`; MD5-Vergleich beider Dateien |

---
*Erstellt am 05.08.2026 im Rahmen des Judicario-Audits. Keine andere Datei wurde verändert. API-Key ausschließlich maskiert zitiert.*



---

# TEIL 3 · CHIPSI

# RESEARCH: Chipsi — Primärquelle PDF + Audit-Kontext (Stand 05.08.2026)

> **Trenn-Regel in diesem Dokument:**
> **[PDF-BELEG]** = direkt im PDF `chipsi/Chipsi.pdf` sichtbar/wörtlich enthalten.
> **[AUDIT-KONTEXT]** = aus `AUDIT_2_TIEFENANALYSE.md` (Audit 2, Abschnitte 3, 4.3, 4.4, 5.6, 6, 7, 8, 9, Anhang A) übernommener Kontext — **nicht** im PDF überprüfbar.
> **[PDF-ABWESENHEIT]** = im PDF nicht sichtbar (Abwesenheit ist kein Beweis, dass es das Feature nicht gibt).

---

## 1. Was ist es? (Klartext)

**Klartext zuerst:** Chipsi ist eine fertige Kanzlei-App für Juristen — wie eine **digitale Aktenmappe, die auch noch Fragen beantworten kann**. Man chattet mit ihr wie mit einem Assistenten, sie holt sich das juristische Fachwissen von Judicario und kann zusätzlich Akten, Vorlagen und ein Langzeit-Gedächtnis.

**Die Auto-mit-Motor-Metapher [AUDIT-KONTEXT]:**
- **Judicario = der Motor.** Eine Rechts-Bibliothek mit Such-Roboter, die Gesetzestexte und Urteile wortwörtlich liefert. Hat aber kein eigenes Gesicht (keine Oberfläche) und kein Gedächtnis — ein Motor, den jemand einbauen muss.
- **Chipsi = das Auto mit eingebautem Motor.** Die fertige App (Oberfläche, Chat, Akten, Vorlagen, Gedächtnis, Meeting-Mitschrift), die Judicario als Antrieb nutzt.
- Konsequenz: Ohne Chipsi (oder Claude) läuft Judicario nicht sichtbar; ohne Judicario fehlt Chipsi die Rechts-Bibliothek.

**Einordnung:** SaaS/Abo-Dienst in der Cloud für den Rechts- und Steuerbereich (Selbstbeschreibung im PDF: „Rechts- & Steuer-Assistenz“) [PDF-BELEG für die Selbstbezeichnung; Cloud/Abo = AUDIT-KONTEXT].

---

## 2. Was zeigt das PDF? (Befund + Grenzen der Auswertbarkeit)

### 2.1 Formale Befunde zum PDF selbst [PDF-BELEG]
- **Datei:** `Chipsi.pdf`, 1 Seite, 61.276 Bytes, PDF 1.4, unverschlüsselt.
- **Erzeugt:** „iOS Version 26.6 (Build 23G71) Quartz PDFContext“ am **So 26.07.2026, 17:27 CEST** → das PDF ist ein **Druck-/Export-Erzeugnis von einem iOS-Gerät** (iPhone/iPad), kein gestaltetes Dokument.
- **Format:** 440 × 738 pt (Smartphone-artiges Hochformat) → praktisch ein **Screenshot-Export eines App-Bildschirms**.
- **Echte Textschicht vorhanden** (pdftotext liefert Text, kein reines Bild); Extraktion ergibt ~1.800 Zeichen. Vollständig auswertbar, aber der **Inhalt ist nur ein einzelner Ausschnitt** einer Unterhaltung.

### 2.2 Inhalt: Was die eine Seite zeigt [PDF-BELEG]
Das Bild zeigt **eine einzige Chipsi-Unterhaltung** mit zwei Ebenen:

1. **Obere Hälfte — rohe Judicario-Daten (vermutlich aufgeklappte Quellen-/Detailansicht):**
   Ein JSON-Datensatz einer OGH-Entscheidung, mitten im Feld beginnend (oberhalb abgeschnitten, beginnt mit `"Weihnachtsremuneration" ],`) und mitten im Spruch endend („… mangels der Voraussetzungen des § 46 Abs 1 Z 1“ — der Satz bricht ab). Sichtbare Felder: `gericht: "OGH"`, `entscheidungsdatum: "1994-04-02"`, `year: 1994`, `normen: ["§ 508a Abs 2 ZPO", "§ 46 Abs 1 Z 1 ASGG", "§ 510 Abs 3 ZPO"]`, `normalized_gz: "9ObA1004/94"`, `ecli: ""` (leer), `topic`/`kernaussagen` (Kollektivverträge dürfen Kündigungsfreiheit nicht durch übermäßige finanzielle Belastungen einschränken), `rs_numbers: null`, `spruch_outcome: null`, `volltext.spruch`.
   → **Chipsi zeigt Judicario-Rohdaten strukturiert an**; der Screenshot zeigt den Anfang UND das Ende des Datensatzes (die Mitte fehlt bzw. ist herausgescrollt).
   - Datums-Zeile: **„Quelle: Judicario · 26.07.2026, 17:21“** → Chipsi beschriftet Judicario-Zulieferung mit Quelle + Zeitstempel.

2. **Untere Hälfte — der gerenderte Chat:**
   - Frage/Thema: **„Bindungsklauseln bei Ausbildungskosten in Österreich“**
   - Antwort-Überschrift: **„Kurze Antwort“**; daneben Schalter **„Konnektoren · aus“** sowie die Modi **„Extended“** und **„Erweiterte Tiefenrecherche“**.
   - Antworttext (wörtlich): *„Ja, solche Bindungsvereinbarungen sind in Österreich grundsätzlich legal — aber nur unter strengen gesetzlichen Voraussetzungen, die in § 2d AVRAG (Angestelltengesetz-Änderungsgesetz) abschließend geregelt sind. Es handelt sich dabei nicht um ein Kreditgeschäft, das nur Banken vorbehalten wäre.“*
     - **Zeichen-Artefakt sichtbar:** im Rohexport steht `sind.&Es handelt` — zwischen zwei Sätzen steht ein falsches „&“ (Rendering-/Tippfehler in der angezeigten Antwort).
   - Eingabezeile: **„Nachricht an Chipsi …“**
   - Fußzeile/Branding: **„Chipsi · Rechts- & Steuer-Assistenz“** und der Haftungshinweis **„Antworten können Fehler enthalten · Zitationsrichtlinie“**.
   - Rechts oben: **„Überall“** und Budget-Anzeige **„17k / 500k“**.

### 2.3 Grenzen der Auswertbarkeit (ehrliche Einordnung)
- **Nur 1 Seite, 1 Momentaufnahme.** Kein Aktenbereich, keine Vorlagen, kein SafeTalk, keine Einstellungen, keine Gedächtnis-Verwaltung sichtbar. **[PDF-ABWESENHEIT]**
- Der JSON-Datensatz ist **oben und unten abgeschnitten** — die Mitte der Unterhaltung bzw. weitere Quellen fehlen.
- **„Konnektoren · aus“ ist mehrdeutig:** Aus dem Screenshot allein ist nicht bestimmbar, ob damit alle Such-/Judicario-Konnektoren gemeint sind oder ein Teil-Schalter — auffällig ist, dass trotzdem eine Judicario-Quelle angezeigt wird. **[PDF-BELEG für die Anzeige; Deutung offen]**
- Keine Rückschlüsse möglich auf: Server-Architektur, Verschlüsselung, verwendete KI-/STT-Modelle, Datenhaltung. **[PDF-ABWESENHEIT]**
- Das PDF ist ein **Export von 17:27 Uhr**, die Judicario-Quelle darin von **17:21 Uhr** → der Screenshot entstand Minuten nach der Abfrage, am selben Tag. **[PDF-BELEG]**

---

## 3. Beobachtbare Funktionen (je 1 Zeile + Quelle)

| Funktion | Befund | Quelle |
|---|---|---|
| Chat-Interface „Nachricht an Chipsi …“ | Sichtbar, aktiv nutzbar | [PDF-BELEG] |
| Rechts-/Steuer-Assistenz-Branding | „Chipsi · Rechts- & Steuer-Assistenz“ wörtlich | [PDF-BELEG] |
| Judicario-Anbindung | Quelle „Judicario“ mit Zeitstempel + Roh-JSON-Felder sichtbar | [PDF-BELEG] |
| Antwort-Modi | „Kurze Antwort“, „Extended“, „Erweiterte Tiefenrecherche“ | [PDF-BELEG] |
| Konnektoren-Schalter | Anzeige „Konnektoren · aus“ (Bedeutung im Detail offen) | [PDF-BELEG] |
| Kontext-Budget-Anzeige | „17k / 500k“ rechts oben sichtbar | [PDF-BELEG] |
| Scope-Anzeige „Überall“ | Sichtbar (passt zum Gedächtnis-Scope im Audit) | [PDF-BELEG] |
| Disclaimer + Zitationsrichtlinie | „Antworten können Fehler enthalten · Zitationsrichtlinie“ | [PDF-BELEG] |
| Gerenderte Judicario-Antwort | Untere Chathälfte zeigt sauber gerenderte Kurzfassung | [PDF-BELEG] |
| Gedächtnis-Kategorien Fakt/Entscheidung/Stil/Vorhaben/User | Nicht im PDF sichtbar; aus Audit | [AUDIT-KONTEXT] |
| Gedächtnis-Controls pinnen/archivieren/löschen/konsolidieren | Nicht im PDF sichtbar; aus Audit | [AUDIT-KONTEXT] |
| Akten (Ordnerstruktur) | Nicht im PDF sichtbar; aus Audit | [AUDIT-KONTEXT] |
| Vorlagen | Nicht im PDF sichtbar; aus Audit | [AUDIT-KONTEXT] |
| SafeTalk (Meeting-Aufzeichnung/Transkription) | Nicht im PDF sichtbar; aus Audit | [AUDIT-KONTEXT] |
| Suche | Nicht im PDF sichtbar; aus Audit | [AUDIT-KONTEXT] |
| E-Gov/Amtswege | Nicht sichtbar; Fehlen aus Audit | [AUDIT-KONTEXT] + [PDF-ABWESENHEIT] |

---

## 4. Technik soweit sichtbar

### 4.1 Kontext-Budget und Scope-Anzeige [PDF-BELEG]
- Die Anzeige **„Überall · 17k / 500k“** belegt: Chipsi führt ein Budget mit (vermutlich Kontextfenster), von dem zum Aufnahmezeitpunkt **~3,4 % (17k von 500k Tokens)** belegt waren.
- Der Audit-Kontext bestätigt die Zahl und ordnet sie ein: Kontext-Budget „17k/500k“, Scope „Überall“ gehört zur Gedächtnis-Schicht. **[AUDIT-KONTEXT]**

### 4.2 Judicario-Datenformat [PDF-BELEG]
- Chipsi empfängt Judicario-Ergebnisse als **strukturiertes JSON** mit den Feldern: `gericht`, `entscheidungsdatum`, `year`, `normen[]`, `normalized_gz`, `ecli`, `topic`, `kernaussagen[]`, `rs_numbers`, `spruch_outcome`, `volltext.spruch`.
- **Exakte Übereinstimmung** mit Anhang A des Audits, der dieselbe Feldliste dokumentiert — der Audit-Kontext ist hier durch das PDF gedeckt. **[PDF-BELEG + AUDIT-KONTEXT deckungsgleich]**

### 4.3 OKF-Gedächtnis lokal [AUDIT-KONTEXT — im PDF NICHT sichtbar]
- Das Langzeit-Gedächtnis liegt laut Audit **lokal im OKF-Format**; Format, Verschlüsselung und Such-Index sind **undurchsichtig** („Tresor mit unbekanntem Schloss“), ohne Quellcode nicht prüfbar.
- Das PDF zeigt davon nur die indirekte Spur „Überall · 17k / 500k“. **[PDF-BELEG nur für diese Anzeige]**

### 4.4 Cloud-SaaS [AUDIT-KONTEXT]
- Chipsi ist ein **Abo-Dienst (SaaS) in der Cloud**; Kanzlei-Daten verlassen das Gerät („Cloud-Mappe“). Im PDF weder belegbar noch widerlegbar. **[PDF-ABWESENHEIT]**

### 4.5 SafeTalk-Engine unbekannt [AUDIT-KONTEXT]
- SafeTalk schreibt Meetings mit und transkribiert, aber: **welche Sprach-zu-Text-Engine**, ob Sprecher-Trennung, ob Zeitstempel — **unbekannt** („Röhre“). Offene Frage Nr. 2 des Audits an Thomas. Im PDF kommt SafeTalk gar nicht vor. **[PDF-ABWESENHEIT]**

### 4.6 Server-Herkunft ungeklärt [AUDIT-KONTEXT]
- Offen: eigener Chipsi-Dienst oder openlaw-Gateway (Audit-Frage Nr. 3). **[PDF-ABWESENHEIT]**

### 4.7 Antwort-Erzeugung im Belegfall [PDF-BELEG + AUDIT-KONTEXT]
- Die Rechtsantwort im PDF (§ 2d AVRAG zu Bindungsklauseln/Ausbildungskosten) ist juristisch plausibel formuliert und nennt die einschlägige Norm für Ausbildungskostenrückersatz; die zusätzlich angezeigte OGH-Entscheidung 9ObA1004/94 (Kollektivvertrag darf Kündigungsfreiheit nicht übermäßig belasten; Stichwort Weihnachtsremuneration) ist thematisch verwandt (Bindungs-/Rückzahlungsklauseln im Arbeitsrecht).
- **Eine automatische Verifikation von Zitat oder Inhalt findet sichtbar nicht statt** — es bleibt beim Disclaimer. **[PDF-BELEG für Disclaimer + Antwort; AUDIT-KONTEXT für die fehlende Prüfkopplung]**

---

## 5. Stärken (mit Quellenangabe)

1. **Fertige, benutzbare App-Oberfläche** — Chat, Modus-Wahl, Quellen-Anzeige, Eingabezeile, alles an einem Ort. **[PDF-BELEG]** · Produktumfang im Audit mit 4/5 bewertet **[AUDIT-KONTEXT]**
2. **Judicario sauber eingebaut** — Roh-JSON mit Quelle + Zeitstempel („Quelle: Judicario · 26.07.2026, 17:21“) plus gerenderte Kurzfassung in derselben Ansicht. **[PDF-BELEG]** · „rendert Judicario-Antworten sauber“ **[AUDIT-KONTEXT]**
3. **Transparenz über das Kontext-Budget** — „17k / 500k“ offen sichtbar, der Nutzer sieht die Reserven. **[PDF-BELEG]** · Budget-Dokumentation im Audit **[AUDIT-KONTEXT]**
4. **Echtes Langzeit-Gedächtnis vorhanden** (Kategorien Fakt/Entscheidung/Stil/Vorhaben/User; Controls pinnen/archivieren/löschen/konsolidieren) — im Gegensatz zu Judicario, das keines hat. **[AUDIT-KONTEXT]** · im PDF nur die Scope-/Budget-Zeile als Spur **[PDF-BELEG]**
5. **Kanzlei-Organisation inklusive** — Akten (Ordner) und Vorlagen als App-Bestandteile. **[AUDIT-KONTEXT]** (im PDF nicht abgebildet **[PDF-ABWESENHEIT]**)
6. **Antwort-Modi für unterschiedliche Tiefe** — „Kurze Antwort“ vs. „Extended“/„Erweiterte Tiefenrecherche“. **[PDF-BELEG]**
7. **Thematisch passende, normengestützte Antwort** im Belegfall (Bindungsklauseln → § 2d AVRAG als abschließende Regelung) mit nachvollziehbarer OGH-Quelle. **[PDF-BELEG]**

---

## 6. Schwächen/Lücken (mit Quellenangabe)

| # | Schwäche/Lücke | Klartext | Quelle |
|---|---|---|---|
| 1 | **SafeTalk ohne Prüfung** | Schreibt Meetings mit, prüft aber nichts („Mitschreiben ohne Mitdenken“); STT-Engine, Sprecher-Trennung, Zeitstempel unbekannt. | [AUDIT-KONTEXT] · SafeTalk im PDF nicht sichtbar [PDF-ABWESENHEIT] |
| 2 | **Gedächtnis passiv** | Merkt sich Fakten, prüft/korrigiert sie aber nicht aktiv („Notizbuch, das nicht mitdenkt“). | [AUDIT-KONTEXT] · im PDF nur die Budget-/Scope-Anzeige [PDF-BELEG nur Anzeige] |
| 3 | **Disclaimer statt Verifikation** | Statt Zitate/Inhalte automatisch zu prüfen, steht unten „Antworten können Fehler enthalten · Zitationsrichtlinie“; zudem sichtbares Zeichen-Artefakt („sind.&Es“) in der Antwort. | [PDF-BELEG] · Audit-Empfehlung „Zitate automatisch prüfen — gegen ‚kann Fehler enthalten‘“ [AUDIT-KONTEXT] |
| 4 | **Kein E-Gov / keine Amtswege** | Keine Ausführungsfähigkeit (Einreichungen, Behördenwege); im PDF keinerlei E-Gov-Spur. | [AUDIT-KONTEXT] + [PDF-ABWESENHEIT] |
| 5 | **OKF-Tresor undurchsichtig** | Lokales Gedächtnis-Format, Verschlüsselung und Such-Index ohne Quellcode nicht prüfbar („Tresor mit unbekanntem Schloss“). | [AUDIT-KONTEXT] · im PDF nicht sichtbar [PDF-ABWESENHEIT] |
| 6 | **Cloud-Mappe: Daten verlassen das Gerät** | SaaS in der Cloud; Kanzlei-Daten liegen extern. | [AUDIT-KONTEXT] |
| 7 | **„Konnektoren · aus“ unklar** | Im Beleg-Screenshot sind Konnektoren ausgeschaltet, zugleich wird eine Judicario-Quelle angezeigt — Bedeutung/Wirkung des Schalters aus dem PDF nicht klärbar. | [PDF-BELEG für Anzeige; Deutung offen] |
| 8 | **Antwort-Artefakt im Beleg** | Zeichen-/Renderingfehler in der angezeigten Antwort (`&` zwischen Sätzen) — Qualitätsrisiko bei Kanzlei-Output. | [PDF-BELEG] |
| 9 | **Abgeschnittene Quellenansicht** | Der Judicario-JSON ist oben/unten abgeschnitten; ob Chipsi Quellen vollständig hält, ist aus dieser einen Seite nicht beurteilbar. | [PDF-BELEG für den Ausschnitt] |
| 10 | **Keine PDF-Belege für Akten/Vorlagen/SafeTalk** | Diese Kernfeatures stammen nur aus dem Audit-Kontext; die Primärquelle hier deckt sie nicht ab. | [PDF-ABWESENHEIT] + [AUDIT-KONTEXT] |

**Offene Fragen an Thomas (aus Audit, unbeantwortet):** OKF-Format/Verschlüsselung/Such-Index · SafeTalk-Engine/Sprecher-Trennung/Zeitstempel · eigener Server vs. openlaw-Gateway. **[AUDIT-KONTEXT]**

---

## 7. Beleg-Verzeichnis

### 7.1 Primärquelle (PDF — `chipsi/Chipsi.pdf`, ausgewertet 05.08.2026)
| Beleg | Fundstelle im PDF (wörtlich) | Verwendet für |
|---|---|---|
| Metadaten | iOS 26.6 Quartz PDFContext, erzeugt 26.07.2026 17:27 CEST, 440×738 pt, 1 Seite, 61.276 B, unverschlüsselt | §2.1 |
| Kontext-Budget | „Überall“ + „17k / 500k“ (rechts oben) | §2.2, §4.1, §5.3 |
| Judicario-Quelle mit Zeitstempel | „Quelle: Judicario · 26.07.2026, 17:21“ | §2.2, §5.2 |
| Judicario-JSON-Felder | `gericht:"OGH"`, `entscheidungsdatum:"1994-04-02"`, `year:1994`, `normen[…]`, `normalized_gz:"9ObA1004/94"`, `ecli:""`, `topic`, `kernaussagen[]`, `rs_numbers:null`, `spruch_outcome:null`, `volltext.spruch` | §2.2, §4.2 |
| Entscheidungs-Thema | „Bestätigung, dass Kollektivverträge die Kündigungsfreiheit des Arbeitnehmers nicht durch übermäßige finanzielle Belastungen einschränken dürfen.“ + Stichwort „Weihnachtsremuneration“ | §2.2, §4.7 |
| Frage | „Bindungsklauseln bei Ausbildungskosten in Österreich“ | §2.2 |
| Antwort-Modi | „Kurze Antwort“, „Extended“, „Erweiterte Tiefenrecherche“ | §2.2, §3, §5.6 |
| Konnektoren-Schalter | „Konnektoren · aus“ | §2.2, §6.7 |
| Antworttext | „Ja, solche Bindungsvereinbarungen sind in Österreich grundsätzlich legal — aber nur unter strengen gesetzlichen Voraussetzungen, die in § 2d AVRAG (Angestelltengesetz-Änderungsgesetz) abschließend geregelt sind. Es handelt sich dabei nicht um ein Kreditgeschäft, das nur Banken vorbehalten wäre.“ (inkl. Artefakt „sind.&Es“) | §2.2, §4.7, §6.8 |
| Eingabezeile | „Nachricht an Chipsi …“ | §3 |
| Branding | „Chipsi · Rechts- & Steuer-Assistenz“ | §1, §3 |
| Haftungshinweis | „Antworten können Fehler enthalten · Zitationsrichtlinie“ | §2.2, §6.3 |

### 7.2 Sekundärquelle (Audit-Kontext — `AUDIT_2_TIEFENANALYSE.md`, klar getrennt)
| Beleg | Fundstelle im Audit | Verwendet für |
|---|---|---|
| Auto-mit-Motor-Bild | §3 „Die zwei Werkzeuge in Klartext“ | §1 |
| Chipsi-Funktionsliste (Akten, Vorlagen, Langzeit-Gedächtnis lokal, SafeTalk, Suche, Rendering) | §4.3 | §3, §5 |
| Stärken/Schwächen-Tabelle Chipsi („SafeTalk prüft nicht · Gedächtnis passiv · keine Amtswege“) | §4.4 | §5, §6 |
| SafeTalk „Mitschreiben ohne Mitdenken“ / Röhre (STT unbekannt, keine Sprecher-Trennung) | §5.6 | §4.5, §6.1 |
| Gedächtnis passiv / „Notizbuch, das nicht mitdenkt“ | §5.6 | §6.2 |
| OKF-Format undurchsichtig / „Tresor mit unbekanntem Schloss“ | §5.6 | §4.3, §6.5 |
| Cloud-SaaS / „Cloud-Mappe“ | §5.6 | §4.4, §6.6 |
| Schwächen-Katalog (Nr. 3 SafeTalk hoch, Nr. 4 Gedächtnis passiv, Nr. 7 Tresor, Nr. 9 kein E-Gov) | §6 | §6 |
| Scorecard (Produktumfang 4, Gedächtnis 3 passiv, Speicher/Transparenz 3 undurchsichtig) | §7 | §5.1 |
| Empfehlung „Zitate automatisch prüfen — gegen ‚kann Fehler enthalten‘“ | §8 | §6.3 |
| Offene Fragen 1–3 (OKF, SafeTalk-Engine, Server) | §9 | §4.5, §4.6, §6 |
| Anhang A: Kontext-Budget „17k/500k“, Gedächtnis-Kategorien, Scope „Überall“, Controls, Judicario-JSON-Feldliste | Anhang A | §4.1, §4.2, §3 |

### 7.3 Auswertungswerkzeuge & Grenzen
- `pdftotext -layout` und `pdftotext` (Textschicht vollständig lesbar), `pdfinfo` (Metadaten) — Auswertung am 05.08.2026.
- **Kein Quellcode vorhanden** — sämtliche Technik-Aussagen über das PDF hinaus sind Audit-Kontext und entsprechend markiert.
- **Ehrliche Gesamteinordnung:** Das PDF belegt eine funktionierende Chat-App mit Judicario-Anbindung, Quellenanzeige und Budget-Transparenz. Alles Weitere (Akten, Vorlagen, SafeTalk, OKF-Gedächtnis, Cloud-Architektur) stammt aus dem Audit-Kontext und ist über diese eine PDF-Seite **weder bestätig- noch widerlegbar**.




