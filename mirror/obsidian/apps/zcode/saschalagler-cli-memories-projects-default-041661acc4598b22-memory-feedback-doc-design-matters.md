---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-doc-design-matters.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: feedback-doc-design-matters
description: Sascha lehnte rohes Plaintext-PDF (reportlab drawString ohne
  Layout) scharf ab — Übergabe-Dokumente brauchen echtes Design (Cover,
  Struktur, Tabellen), selbst wenn er vorher "simpel" sagt
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_6acd283f-12f1-47df-acd6-052ad94ce159
---

07.09.2026: „simpel als Todoliste, PDF mir egal" führte zu einem reportlab-Plaintext-PDF (nur drawString-Zeilen) — Sascha wütend: „das ist dein Design da wirst du behindert, keine Struktur, kein Layout".

**Why:** „Simpel/mir egal" bezieht sich bei Sascha auf UMFANG, nicht auf GESTALTUNG. Er erwartet immer professionelles Layout (Farbbanner/Cover, Sektionen, echte Tabellen, Typografie) — auch bei 1-Seiten-Docs.

**How to apply:** Übergabe-Dokumente nie als reine Textwüste generieren. Entweder docx-Skill mit Cover-Rezept + Tabellen (siehe [[patrick-physiotherapie-sbp]], R4 geplant) oder reportlab mit Platypus (Table/TableStyle, Farbbänder) statt drawString.

**Update 11.09.2026:** (1) **LibreOffice JETZT INSTALLIERT** (`brew install --cask libreoffice`, soffice auf /opt/homebrew/bin/soffice) → DOCX→PDF-Konvertierung verfügbar: `soffice --headless --convert-to pdf` + `pdftoppm -png -r 80` für Seiten-Rendering. (2) **PDF ist das Lieferformat**: Sascha schrie „ERSTELLE EIN VERFICKTES PDF", als nur ein DOCX existierte — Übergabe-Docs primär als PDF liefern, DOCX nur als Beilage. (3) Bewährter Pipeline-Lauf: docx-Skill R4-Cover (GO-1) + echte App-Screenshots via `screencapture -o -x -l <window_id>` + computer-use-AX-Klicks für UI-Zustände → postcheck.py → add_toc_placeholders.py + fix_footer_fields.py → soffice→PDF → alle Seiten als PNG selbst visuell prüfen (Cover-Titlelbruch vorher: Wortgrenzen-Split in calcTitleLayout nötig, festes Char-Slicing bricht mitten im Wort). (4) macOS **Quick-Look-Thumbnails (qlmanage) sind bei DOCX unzuverlässig** — renderten das R4-Cover als vertikalen Letter-Streifen (false alarm); erst LibreOffice-Render ist verlässlich.

**Update 12.09.2026:** **Beste Pipeline für druckfertige Praxis-PDFs (Sitzungs-Zettel) = handgebaut HTML + Print-CSS → headless Chrome**: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf=OUT.pdf file:///tmp/x.html`, dann `pdftoppm -png -r 60` + selbst visuell prüfen. Bewährt: ein Theme pro Patient (Farbkennung Adelina=türkis, Simon=violett), Checkbox-Spans zum Ankreuzen, 4-Spalten-Übungstabellen, SOAP-Block, Footer mit Name/Datum. HTML-Quelle neben das PDF legen (später editierbar). Für übergebene Langtext-Prompts: als `.md` auf Desktop (Copy-Paste-Quelle), z. B. `ANTIGRAVITY_PHYSIO_START_PROMPT.md`-Muster.

**Update 18.09. (LEICHTE SPRACHE FÜR ALLES):** „bitte alles … simpel getrennt leichte sprache" — gilt **nicht nur für Patienten-Doks, sondern auch für Therapeuten-Bögen**. Jeder Bogen: EIN Thema pro Block (7 Blöcke: Satz-Zusammenfassung → Verlauf-Fragen mit Schreiblinien → 3 Tests in Alltagssprache → Regeln zum Abhaken → Übungstabelle → Ampel → Notizen), Fachwörter im Alltag übersetzen („Schnellatmen-Test" statt Hyperventilationsprobe; „Anstrengung 6/10, könnte noch weitermachen" statt RPE ≤ 6), viel Weißraum, klare Trennlinien. Bestätigter finaler Stand: `Adelina_THERAPEUT_Sitzung5_2026-09-18.pdf` (2 S., 7-Block-Format) + `Adelina_ZETTEL_2026-09-18.pdf` (1 S.).

**Update 12.09. Nr. 2 (PATIENTEN-DOKS):** Therapeuten-Zettel (SOAP, Schwellenwerte, Fachjargon) waren „VIEL ZU KOMPLEX" — **Patienten-Blätter brauchen: ALLES in Patientensprache, Freiflächen zum Schreiben (dotted lines), Ja/Nein-Kästen, Smiley-Skala 0–10, Übungen mit Schritt-für-Schritt-Anleitung + Alltags-Metaphern** („Bleistift zwischen Schulterblättern klemmen"), Wochen-Häkelblatt, Notfall-Plan in 3 Schritten. KEINE Fachbegriffe/Schwellenwerte auf Patientenblätter. Bewährte Struktur: 1 Wie geht's heute → 2 Sicherheitsfragen (JA ⛔/NEIN ✓) → 3 Mini-Selbsttests → 4 Übungen heute → 5 Hausaufgaben-Tabelle → 6 Bewertung (besser/gleich/schlechter + Freifeld). Dateien: `Adelina_UEBUNGSZETTEL…pdf` + `Simon_KOPFZETTEL…pdf` in `~/Desktop/Körperfluss/Patientenliste/Adelina/`. HTML-Fallstricke: div-Balance prüfen (non-greedy regex-Schnitte schließen Box nicht → Chrome bricht Layout falsch um); übergroße Boxen mit `page-break-inside:avoid` springen ganz auf neue Seite → halbleere Seiten vermeiden durch kompakte Tabellenzeilen.
