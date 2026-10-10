**HolDirMehr — Fertigstellung für deine Privatnutzung (alles gratis)**

Ziel: Du gibst einmal deine Angaben ein → dein persönlicher Bericht mit allen passenden Förderungen, dauerhaft gespeichert, ohne Zahlung.

| # | Schritt | Details |
|---|---|---|
| 1 | **Mein Profil (speichern)** | Quiz-Antworten landen in localStorage. Landing zeigt danach „Mein Bericht"-Button (Direkteinstieg ohne Neu-Quiz) + „Angaben ändern". Bericht läuft auch ohne URL-Parameter aus dem Profil. |
| 2 | **6 Fragen + optionale Zusatzangaben** | Nach dem Bericht: optionale Sektion „Genauere Treffer" (berufstätig/Pension/Selbstständig, Behinderung ja/nein) — Angaben verfeinern das Matching, kein Zwang. |
| 3 | **Echte Summe statt Demo-Zahl** | Bericht-Kopf rechnet aus deinen echten Treffern: „X Förderungen, zusammen bis zu €Y" (aus Höchstbeträgen), Sortierung nach Passung/Betrag. |
| 4 | **Besseres Matching** | Firmen-, Gemeinde- und Vereins-Förderungen werden anhand des Antragsteller-Felds standardmäßig ausgeblendet (Umschalter „auch Firmen-Förderungen zeigen" im Bericht). Zusatzangaben (Beruf/Behinderung) fließen in die Treffer ein. |
| 5 | **App bleibt nach Session-Ende nutzbar** | Katalog zusätzlich als `assets/katalog.js` eingebettet → App läuft per Doppelklick auf `index.html` (ohne Server); zusätzlich `HolDirMehr-starten.command` auf dem Desktop (startet lokalen Server + öffnet Browser). |
| 6 | **Bericht als PDF** | Druck-Stylesheet + „Als PDF speichern"-Button im Bericht (wie im Original: für dich/Bank/Energieberater). |
| 7 | **Abschluss-Test (bis grün)** | Komplett-Durchlauf im Browser: Quiz → Profil gespeichert → Bericht mit echten Treffern → PDF-Druckansicht → Detail → Listing; 0 Konsolenfehler; Deploy + Screenshots; README/Memory final. |

Dateien: `app.js`, `katalog-ui.js`, `index.html`, `check.html`, `bericht.html` (+ generierte `katalog.js`, Desktop-`.command`, README). Keine neuen Abhängigkeiten, kein Backend, keine Zahlung. Aufwand ca. 45–60 Min.