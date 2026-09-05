---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/empirische_tests/LEAD_ris_api_verifikation.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# LEAD-VERIFIKATION: RIS OGD API v2.6 (exakt der App-Endpoint)
Datum: 28.07.2026 · Tester: Lead (Cline)

## Endpoint (aus ris_lookup.py Zeile 10)
https://data.bka.gv.at/ris/api/v2.6/Bundesrecht

## Ergebnis: ✅ LIVE & FUNKTIONSFÄHIG
- HTTP 200, content-type: application/json
- Antwortformat: {"OgdSearchResult": {"OgdDocumentResults": {...}}}
- Testabfrage: ?Applikation=BrKons&Suchbegriffe=Stammkapital&Titel=GmbHG&Fassung.FassungVom=2026-07-28
- Ergebnis: 155 Treffer, korrektes Gesetz gefunden:
  Kurztitel "GmbH-Gesetz", Titel "Gesetz vom 6. März 1906 ... (GmbH-Gesetz – GmbHG)",
  ID NOR11001742, DokumentUrl https://www.ris.bka.gv.at/eli/rgbl/1906/58/P0/NOR11001742
- Der Titel-Filter (ris_lookup.py LAW_TITLES) funktioniert: schlägt korrekt GmbHG vor
  (verhindert Fehl-Treffer wie das vom Code-Kommentar erwähnte Anti-Doping-Gesetz).
- Fassung.FassungVom=<heute> wird akzeptiert (Anti-Halluzinations-Mechanismus: nur aktuelle Fassung).

## Rohdaten
ris_api_v2.6_gmbhg_stammkapital_LIVE.json (echte API-Antwort, 41KB, 20 Dokument-Referenzen)

## Bewertung
✅ VERIFIZIERT: Die Behauptung "RIS OGD API v2.6 Live-Injektor" ist technisch real und
live erreichbar. Die API liefert strukturierte JSON-Gesetzesdaten. (Volltext-Extraktion
der €-Beträge: siehe empirie-tester Kapitel 05.)
