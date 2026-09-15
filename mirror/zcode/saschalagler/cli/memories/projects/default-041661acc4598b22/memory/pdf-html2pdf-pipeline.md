---
name: pdf-html2pdf-pipeline
description: Funkierende HTML→PDF-Pipeline auf Saschas Mac (Playwright via
  omniroute-NODE_PATH + pdf-lib in /tmp/pdfdeps) samt Fallstricken — genutzt für
  LOKI-OS_Standard-Skills.pdf 13.09.
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

**HTML→PDF auf diesem Mac (13.09.2026 bewährt, 3-Seiten-A4-Dark-PDF im Judge-Review 3/3 pass):**

```bash
PDF_SKILL_DIR=/Users/saschalagler/.zcode/cli/plugins/cache/zcode-plugins-official/document-skills/0.1.4/skills/pdf
NODE_PATH=/opt/homebrew/lib/node_modules/omniroute/node_modules:/tmp/pdfdeps/node_modules \
  node "$PDF_SKILL_DIR/scripts/html2pdf-next.js" in.html --output out.pdf --width 210mm --height 297mm
```

- **Playwright** existiert NUR in omniroutes node_modules (`/opt/homebrew/lib/node_modules/omniroute/node_modules/playwright`) — kein globales Playwright, daher NODE_PATH.
- **pdf-lib** (Post-Processing-Pflicht des Skripts) ist temporär in `/tmp/pdfdeps/node_modules` installiert (`cd /tmp/pdfdeps && npm install pdf-lib`) — **nach Reboot weg, neu installieren**.
- Metadata: `pymupdf` nutzen (`d.set_metadata(...); d.saveIncr()`) — pikepdf fehlt im pdf.py-CLI.
- Vorab-Check: `poster_validate.py check-html` (0 errors = grün; TINY_FONT-Warnings ok).

**Fallstricke (2 h gelernt):**
1. `html2pdf-next.js` ENTFERNT fixe Höhe + `overflow:hidden` von `.page`-Containern („content will paginate naturally") → `position:absolute`-Footer müssen statisch werden (`margin-top` statt `auto`), sonst spillen Seiten als fast-leere Folgeseiten.
2. Zu-voll-Seiten-Spill: nach jedem Render Seitenzahl prüfen (pymupdf), die spillende Seite per Zeilen-Kürzung/Table-Rows-Zusammenlegung retten statt Markup umbauen.
3. Deliverable-Artifact: `~/Desktop/LOKI-OS_Standard-Skills.pdf` + `LOKI-OS_Standard-Skills.html` (Quelle, Sascha-Frage nach Skill-System-Übersicht 13.09.).

**PDF-LESEN (15.09.):** Nutzer-PDF-Anhänge kann GLM-5.3-Flash NICHT direkt lesen ([1210] „Failed to parse the file / model does not support PDF input") → IMMER Text per **pdftotext** extrahieren (poppler installiert: `pdftotext -layout in.pdf out.txt`) und im Bash greppen; funktioniert zuverlässig auch bei 650-KB-PDFs. Bei sensiblen Anhängen (Bank/Sozialhilfe) NUR zielgerichtet nach Suchbegriffen greppen, Rest nicht auswerten.

Verwandt: [[feedback-doc-design-matters]] [[feedback-gui-not-cli]]
