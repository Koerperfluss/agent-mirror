## Antwort auf deine Frage (bewiesen, nicht geraten)

**JA — alle 4 sendefertigen PDFs sind mit deiner Unterschrift versehen.** Ich habe jede Seite jedes PDFs komplett gelesen (Sichtprüfung, nicht nur grep):

| PDF | Unterschrift | Inhalt geprüft |
|---|---|---|
| **VORSTELLUNG_MES1-K-264-274_ME-450GA.pdf** | ✅ Signaturbild „eigenhändig", S. 2 | § 57 Abs. 2+3 AVG, 5 Anträge, Datum 01.10.2026 |
| **SAMMELANTRAG_BH_MELK_54b_VStG_ALLE_STRAFEN.pdf** | ✅ Signaturbild „eigenhändig", S. 2 | alle 5 GZ, 35 €/Monat **ab 15.11.2026** (neu!), Vollstreckungsaufschub, Beilagen |
| **ANTRAG_BG_MELK_2E2940_26b.pdf** | ✅ Signaturbild „eigenhändig" | § 291a EO, 3×53 € **ab 15.11.2026**, IBAN korrekt |
| **ANTRAG_SVS_ZAHLUNGSVEREINBARUNG.pdf** | ✅ Signaturbild „eigenhändig" | 2×38,43 € (15.10. + 15.11.), VSNR ok |

Die Signaturquelle **`unterschrift.png`** liegt im Fallakten-Ordner — die `.typ`-Quellen aller Schriftsätze ebenfalls.

**NICHT unterschrieben (nur Entwürfe, kein PDF):** `GROVER_HARDSHIP_STUNDUNGSANTRAG.md` (Karte 6 — Empfänger steht aber drin: **inkasso@rechnungen.grover.com**), `COEO_RATEPAY_SAMMELEINSPRUCH.md` + `PAIR_FINANCE_BESTREITUNG.md` (Karte 7).

## Plan (nach GO — ich mache alles alleine, du kommst zurück und klickst nur)

1. **Laufenden Workflow `dwfrun-20813457` per AmendWorkflow erweitern** (Prüfer laufen gerade, deren Arbeit bleibt im Cache — kostet fast nichts):
   - Der Cockpit-Mechaniker kompiliert **Grover-PDF**: `GROVER_HARDSHIP_STUNDUNGSANTRAG.md` → PDF (typst) **mit `unterschrift.png`**, abgelegt in `id austria neu ` + `Fallakten_September_2026`.
   - Karte 6 bekommt den echten 1-Klick-Gmail-Link an inkasso@rechnungen.grover.com (cc support@grover.com) statt nur Suchlink.
   - Karte 7: Empfänger aus den coeo/PAIR-Entwürfen übernehmen (falls drin), sonst Gmail-Suchlinks — nichts wird erfunden.
   - Cockpit-Daten korrigiert übernehmen: Ratenbeginn **15.11.2026** (Sammelantrag + GV Hinum), nicht 15.10.
2. **Workflow läuft fertig**: Baseline-Gate → Reparatur → Node-Automatiktest (alle file://-Ziele auf Disk geprüft, Gmail-Links vollständig, KEIN Auto-Open, localStorage, Pfeiltasten) → Prüfbericht.
3. **Endkontrolle durch mich**: Gate-Ergebnis + Dateipfade als Beweis melden. Du öffnest dann selbst das fertige Cockpit — nichts startet von selbst.

**Nicht drin:** Senden in Gmail (deine 1-Min-Klicks), Original-Cockpit wird als Backup gesichert (`.bak-2026-10-01`), keine Dateien gelöscht.