---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_aaafc084-598e-4c4a-98c2-aef038d78ad7/dwfrun-e3a76000-708a-4263-8213-a88eff93222c_artifact_2_1-tool-result-7cdce567-bf2c-4664-96df-b69d47819e53.md"
stand: 2026-10-10
tags: [spiegel, zcode]
---

# Katalog-Vervollständigung: NÖ + Bundesweit

Ziel war die Original-Vollständigkeit (Original-Angabe: **502 NÖ + 533 bundesweit**).

- NÖ-Listing: **505 Einträge** gelesen (505 mit Detail-Seite) — curl mit Chrome-UA über die NÖ-Listing-Seite und alle 16 Themen-Unterseiten (keine ?page=-Pagination vorhanden), <a href="/foerderung/…">-Links geparst, Titel = Ankertext, nach Name dedupliziert.
- Bundesweit-Listing: **532 Einträge** gelesen (532 mit Detail-Seite) — curl mit Browser-UA auf /foerderungen/bundesweit (plus ?page=2 und alle 15 Themen-Unterseiten /foerderungen/bundesweit/<thema>, die aber alle serverseitig identisch/leer waren — keine echte Pagination), dann 533 eindeutige /foerderung/-Links mit Anchor-Text extrahiert, 1 Duplikatname entfernt.
- Neue Detailseiten geholt: **611**, nur mit Name: **15**, fehlgeschlagen: **15**
- Katalog danach: **1772 gesamt · 506 NÖ · 495 bundesweit** (deterministisch aus der Datei gezählt)
- assets/katalog.js regenerated: ja (lädt mit 1772 Einträgen)

_Differenz zu 502/533 = Einträge der Original-Listing-Seiten, die dort ohne Detailseite laufen oder nur intern gefiltert werden._