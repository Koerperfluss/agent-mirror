---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-doc-design-matters.md"
stand: 2026-09-11
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
