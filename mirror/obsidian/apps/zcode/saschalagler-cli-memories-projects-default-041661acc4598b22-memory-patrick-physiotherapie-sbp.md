---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/patrick-physiotherapie-sbp.md"
stand: 2026-09-07
tags: [spiegel, zcode]
---

---
name: patrick-physiotherapie-sbp
description: Patrick will Physiotherapie studieren (ohne Matura) — Recherche
  07.09.2026 zu Studienberechtigungsprüfung + FH-Aufnahmeverfahren, Kernfakten
  und Fallstricke
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6acd283f-12f1-47df-acd6-052ad94ce159
---

Patrick (verwandt mit Sascha) will **Physiotherapie (FH-Bachelor) in Österreich studieren, ohne Matura** — Weg über die **Studienberechtigungsprüfung (SBP)**, § 64a UG 2002. Recherche abgeschlossen 07.09.2026, Confidence ~85/100.

**Kernfakten:**
- Patrick braucht **BEIDES**: SBP (ersetzt nur die Matura) **+** FH-Aufnahmeverfahren (Eignungstest/Interview, gilt für alle Bewerber, keine SBP-Befreiung).
- SBP-Voraussetzungen: 20 Jahre (bei letzter Teilprüfung), EU/EWR, Abschluss Schulpflicht + „erhebliche einschlägige Vorbildung" (Hochschule entscheidet, keine fixen Berufsjahre).
- SBP = 5 Teilprüfungen (schriftl. Arbeit + 2–3 Pflichtfächer + 1–2 Wahlfächer), Dauer 1–2 Jahre, Kurse 250–1000 €/Fach.
- **FALLE:** SBP ist studienrichtungsgebunden, und FHs ordnen Physiotherapie VERSCHIEDENEN Gruppen zu — Joanneum: „Medizinische Studien"; Salzburg: „Naturwissenschaftliche Studien"; FH OÖ: Pflichtfach Biologie/Mathematik. → Erst Ziel-FH festlegen, dann SBP-Fächer kombinieren lassen.
- **Abkürzung:** Einschlägige Berufsausbildung ersetzt die komplette SBP — nur Zusatzprüfungen (Beispiel Joanneum: MTF nur Englisch 2; DGKS Physik 1 + Englisch 2; Masseur/BMS: Biologie, Physik 1, Englisch 2). Offen: ob Patrick so eine Ausbildung hat.
- Timing: Bewerbung für 2027/28 ab Winter 2026 (IMC ab 01.12.2026); bedingte Zulassung möglich — Nachweis SBP bis Studienbeginn (FHWN: bis 31.10.) erlaubt Parallelbetrieb.
- FHs mit Physio: Campus Wien, Joanneum, Wiener Neustadt, IMC Krems, Salzburg, OÖ, Tirol, Burgenland, Kärnten.
- Nächster offener Punkt: Patricks Alter + ob einschlägige Ausbildung (Masseur/MTF/Pflege) vorhanden → entscheidet SBP vs. nur Zusatzprüfungen.

**Patrick-Situation (07.09.2026 bestätigt):** über 20 → Altersvoraussetzung SBP **erfüllt**; **KEINE einschlägige Ausbildung** → Abkürzung (Zusatzprüfungen) entfällt, er macht die **volle SBP**. **Ziel-FH: IMC Krems** (akzeptiert externe SBP; Deutsch B2; Aufnahme = Online-Gesundheitstest ~2h biz:Examiner → körperlicher Eignungstest in Krems → Interview mit Motivationsschreiben; nach Zusage Gesundheitszeugnis + Strafregister <3 Monate; Fristen 2027/28: Bewerbung ab ca. 01.12.2026, Frist 15.03.2027 — vor Bewerbung verifizieren). Wichtigster offener Punkt: SBP-Zulassung braucht trotzdem „erhebliche berufliche/sonstige Vorbildung" → Schritt 1 der Todoliste = Anfrage an IMC Krems, ob Patricks Vorbildung genügt. Zeitleiste: Sep 2026 Antrag → 2026/27 Prüfungen → Sep 2027 Studienstart.

**Ohne Berufserfahrung = KEIN Ausschluss (07.09. geklärt):** § 64a Abs 3 UG verlangt „erhebliche **berufliche ODER sonstige** Qualifikation" — auch ohne Beruf zählen sonstige Vorbildungen (Kurse, längeres Selbststudium, Ehrenamt/Sport im Gesundheitsbereich, Pflege Angehöriger, Praktika); Entscheidung beim Rektorat. Praktischer Workaround: 6–12 Monate Pflegehelfer / Physiopraxis-Assistenz / Rettungssanitäter löst SBP-Zulassung + Punkte im IMC-Interview gleichzeitig; verlässlichster Weg sonst: Pflegefachassistenz-Ausbildung (öffnet sogar Direkteinstieg mit nur Zusatzprüfungen). Uni Wien ist streng (Vorbildung „aus dem Bereich des Studiums"), Hochschulen uneinheitlich → erst Liste von Patricks Jobs/Kursen/Ehrenamt erstellen, dann an IMC Krems melden.

**Deliverable (Stand 07.09. spät):** Simple 1-Seiten-PDF `/Users/saschalagler/Desktop/Patrick_Physiotherapie_Weg.pdf` (reportlab-plaintext, Generator `sbp-doc/patrick_pdf.py`) wurde **scharf abgelehnt** („kein Design, keine Struktur, kein Layout") → Sascha will jetzt ein **professionell gestaltetes DOCX** (Cover-Rezept R4 Top Color Block, echte Tabellen, klare Sektionen) mit dem „sonstige Vorbildung"-Punkt als eigenem Abschnitt — **Bau noch offen** (docx npm-Paket installiert in `~/.zcode/workspace/default/sbp-doc/`; kein soffice/LibreOffice → kein direkter PDF-Export). Siehe [[feedback-doc-design-matters]].
