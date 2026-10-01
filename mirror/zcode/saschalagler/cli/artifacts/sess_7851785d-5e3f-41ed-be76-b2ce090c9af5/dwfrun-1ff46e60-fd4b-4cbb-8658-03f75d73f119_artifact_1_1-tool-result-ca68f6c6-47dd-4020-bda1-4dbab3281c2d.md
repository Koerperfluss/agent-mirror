# Fertige E-Mails mit PDF-Anhaengen — Beweisbericht

Gmail-Web-Links koennen keine Anhaenge vorbefuellen (Google-Limitierung). Deshalb liegen jetzt 5 fertige .eml-Dateien mit eingebetteten PDFs bereit: Doppelklick oeffnet sie im Mail-Programm mit Anhang — nur noch Senden.

| E-Mail | Empfaenger | Anhaenge | Beweis |
|---|---|---|---|
| 1_STRAFEN_Sammelantrag_54b_VStG.eml | strafen.bhme@noel.gv.at | SAMMELANTRAG_BH_MELK_54b_VStG_ALLE_STRAFEN.pdf, AMS_Bescheid_Notstandshilfe_Sascha_Lagler_18_09_2026.pdf | md5-identisch verifiziert |
| 2_VERKEHR_Vorstellung_57_AVG.eml | verkehr.bhme@noel.gv.at | VORSTELLUNG_MES1-K-264-274_ME-450GA.pdf | md5-identisch verifiziert |
| 2b_VERKEHR_Vollzugsaufschub_44_KFG.eml | verkehr.bhme@noel.gv.at | ANTRAG_VOLLZUGSAUFSCHUB_MES1-K-264-274.pdf, Gmail - 2 E 2866_26w (Ihr Zeichen 5261604) – Ratenzahlungsangebot, Unpfändbarkeit § 291a EO & Antrag BG Melk – Sascha Lagler.pdf, AMS_Bescheid_Notstandshilfe_Sascha_Lagler_18_09_2026.pdf | md5-identisch verifiziert |
| 3_GV_HINUM_291a_EO.eml | guenther.hinum@justiz.gv.at | ANTRAG_BG_MELK_2E2940_26b.pdf, AMS_Bescheid_Notstandshilfe_Sascha_Lagler_18_09_2026.pdf | md5-identisch verifiziert |
| 4_SVS_Ratenzahlung.eml | svs@svs.at | ANTRAG_SVS_ZAHLUNGSVEREINBARUNG.pdf | md5-identisch verifiziert |

## Automatik-Pruefung (md5 je Anhang gegen Quell-PDF)
- 1_STRAFEN_Sammelantrag_54b_VStG.eml: 2 Anhaenge md5-identisch (SAMMELANTRAG_BH_MELK_54b_VStG_ALLE_STRAFEN.pdf, AMS_Bescheid_Notstandshilfe_Sascha_Lagler_18_09_2026.pdf)
- 2_VERKEHR_Vorstellung_57_AVG.eml: 1 Anhaenge md5-identisch (VORSTELLUNG_MES1-K-264-274_ME-450GA.pdf)
- 2b_VERKEHR_Vollzugsaufschub_44_KFG.eml: 3 Anhaenge md5-identisch (ANTRAG_VOLLZUGSAUFSCHUB_MES1-K-264-274.pdf, Gmail - 2 E 2866_26w (Ihr Zeichen 5261604) – Ratenzahlungsangebot, Unpfändbarkeit § 291a EO & Antrag BG Melk – Sascha Lagler.pdf, AMS_Bescheid_Notstandshilfe_Sascha_Lagler_18_09_2026.pdf)
- 3_GV_HINUM_291a_EO.eml: 2 Anhaenge md5-identisch (ANTRAG_BG_MELK_2E2940_26b.pdf, AMS_Bescheid_Notstandshilfe_Sascha_Lagler_18_09_2026.pdf)
- 4_SVS_Ratenzahlung.eml: 1 Anhaenge md5-identisch (ANTRAG_SVS_ZAHLUNGSVEREINBARUNG.pdf)

## Offen / nicht geprueft
- Absenden bleibt bei Sascha (Doppelklick + Senden); es wurde nichts versendet
- Apple Mail muss das Konto koerperfluss@gmail.com enthalten, sonst in einem anderen Mail-Programm oeffnen
- Die verbindliche Erklaerung in 2b (Fahrzeug wird bis zur Wiederherstellung des Versicherungsschutzes nicht im oeffentlichen Verkehr verwendet) steht unterschrieben im PDF — Sascha hat sie noch nicht bestaetigt

## Unabhaengiger Blick
**Ergebnis: Bericht nennt Prüfergebnisse, liefert aber weder Pfade noch Hash-Werte — 4 unklare Stellen, 6 unbelegte Behauptungen, 5 Lücken. Nur Text gelesen, keine Dateien geprüft.**

## 1. Unklare Stellen
1. **„md5-identisch verifiziert"** — womit identisch? Die Prüfungs-Sektion sagt „gegen Quell-PDF", aber neither Quell-Pfade noch Hash-Werte stehen im Bericht. Leser kann es nicht nachvollziehen.
2. **Anhang Nr. 2 in 2b** („Gmail - 2 E 2866_26w (Ihr Zeichen …).pdf") — Dateiname enthält Kommas; unklar ob 1 oder mehrere Dateien. Format unklar (PDF-Export einer Gmail-Mail?).
3. **„steht unterschrieben im PDF — Sascha hat sie noch nicht bestaetigt"** — Widerspruch: unterschrieben, aber nicht bestätigt? Wer hat unterschrieben, was fehlt zur Bestätigung? Und: darf 2b trotzdem versandfertig sein?
4. **Zwei Geschäftszahlen ohne Erklärung**: 2 E 2866/26w (in 2b-Anhang) vs. 2E2940/26b (E-Mail 3) — beides BG Melk, Verhältnis unklar.

## 2. Behauptungen ohne Beleg im Text
1. „Google-Limitierung" für Gmail-Anhänge — keine Quelle.
2. „5 fertige .eml-Dateien … bereit" — kein Speicherort, keine Auflistung als Dateisystem-Beweis.
3. „md5-identisch" ×9 — keine Hash-Werte, kein Befehl, kein Output im Bericht.
4. „Doppelklick oeffnet sie im Mail-Programm mit Anhang" — nicht getestet belegt.
5. Empfängeradressen (strafen.bhme@…, guenther.hinum@…, svs@svs.at) — keine Herkunft.
6. „unterschrieben im PDF" (2b) — keine Prüfung dokumentiert.

## 3. Was fehlt
1. **Absoluter Pfad** der 5 .eml-Dateien.
2. **md5-Werte + Quell-PDF-Pfade** (Reproduzierbarkeit der Prüfung).
3. **Betreff/Text/From** der E-Mails — Bericht sagt nichts über den Inhalt der Mails; From (koerperfluss@gmail.com) erscheint nur indirekt im „Offen"-Abschnitt.
4. **Dateigrößen** der .eml (Empfänger-Größenlimits).
5. **Nächster Schritt zu 2b** — Erklärung unbestätigt, Mail trotzdem fertig: Risiko nicht als blockierend markiert.
