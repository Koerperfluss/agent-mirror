# QA — SACHA ↔ THOMAS
## Fragenkatalog: Welche Optionen gibt es, was will Thomas?
Stand: 04.08.2026 · Ziel: Thomas sieht alle Optionen klar und entscheidet. Danach baut Sacha.

---

## Block 1 · Integration
1. Soll der Assistent **in Chipsi integriert** werden (SafeTalk-Pipeline, A1) — also euer Team baut es ein?
2. Oder soll er **lokal auf deinem Rechner** laufen (A2, standalone, maximale Kontrolle)?
3. Oder als **eigener Connector** (A3, wie deine Judicario-Tools) — modular, auch für andere Kunden?

## Block 2 · Hirn / Gedächtnis
4. Dein **Langzeit-Gedächtnis existiert bereits** (Fakten/Entscheidungen/Stil, lokal OKF).
   Soll der Assistent daran **ankoppeln** (A4a, kein Doppel-Gedächtnis) oder ein **neues Hirn** bekommen (A4b)?
5. Was soll das Hirn zusätzlich merken: nur Fakten/Entscheidungen, oder auch
   **Termine (Frequenz/Länge), Themen (besprochen/nicht), offene Punkte**?

## Block 3 · Sprache / STT
6. Transkription **lokal** (faster-whisper, 0 €, Datenschutz) oder **Cloud** (AssemblyAI/Deepgram, bessere Diarization) oder **hybrid**?
7. Ist **Echtzeit-Live** nötig, oder reicht **Post-Meeting-Scan** als erster Schritt?

## Block 4 · Verhalten
8. Bestätigst du die Melde-Regel: **nie unterbrechen; nur bei belegtem Fehler oder wenn gefragt; dann assistieren**?
9. Soll zusätzlich eine **dezente Live-Markierung** (gelb/rot) laufen, oder **nur Report nach Meeting**?

## Block 5 · Prüfungsumfang
10. Nur **rechtliche Fehler** (Norm/Betrag/Frist/Logik/Verfahren) oder auch **Meeting-Struktur** (Termine/Themen/Unklarheiten)?
11. Soll jede Meldung einen **Judicario/RIS-Beleg** tragen (Verbatim-Zwang) — ja/nein?

## Block 6 · Betrieb & Modell
12. Wer betreibt/baut es: **dein Team** (Sacha liefert Konzept/Modul) oder **Sacha** (Co-Development)?
13. Welches Geschäftsmodell bevorzugst du: **Einmal-Lizenz / Modul-Kauf / Stunden / Provision / Revenue-Share**? (siehe ZUSAMMENARBEIT_BRAINSTORM.md)
14. Datenschutz-Grenze: dürfen Audio/Transkript **jemals** die Cloud erreichen (ja/nein/teilweise)?

---

**Nächster Schritt:** Thomas beantwortet 1–14 → Sacha fixiert Architektur (ASSISTENT_OPTIONEN.md)
und baut MVP in der gewählten Kombination.
