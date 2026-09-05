---
name: atlas-d8-keine-vorannahmen
description: Saschas hartes Design-Gesetz — ATLAS ist eine App FÜR JEDEN, null Vorausgefüllte Körperwerte; Gewicht/Größe nur aus dem Interview; 92kg nur als gekennzeichnetes Beispiel
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**Wut-Auslöser (05.09. Nacht):** „WTF ES SOLL EINE APP FÜR JEDEN SEIN KEINE VORANNAHMEN WIESO 92kg — und onboarding soll völlig interaktiv sein, keine fixen Antworten, Analyse ausgiebig nach Ziel, Übungen, Trainingslogik, Mechaniken, nicht so lieblos wie du denkst."

**Why:** Der OnboardingHost hatte das Gewicht mit `useState(92)` und die Größe mit `useState(178)` VORAUSGEFÜLLT — jeder fremde Endkunde startete mit Saschas Körperwerten. Auch Vision nahm `profile?.weightKg ?? 92` stumm an. Saschas eigene Kalibrierung (92kg) darf NUR in klar als Beispiel gekennzeichneten Demos vorkommen (OUTOTU-Zielbild-PDF).

**How to apply:**
1. **Keine Default-Körperwerte** — Gewicht/Größe = leere Pflichtfelder (placeholder „dein Gewicht"/„deine Größe"), canNext-Gate erst bei echter Eingabe (≥30kg/≥100cm). Umgesetzt in OnboardingHost.tsx (Bundle-Beweis: Gate `i===2?J!=null&&J>=30&&me!=null&&me>=100`, 0 Fundstellen der alten Defaults).
2. **Vision ohne Profil-Gewicht → interaktiv fragen** (scanWeight-Input-Prompt), Report rendert `usedWeight` statt hart 92.
3. **Profil-Prefill für BEKANNTE User bleibt Feature** (profileDb, IndexedDB `atlas-v5-profile`) — nur Neukunden starten leer.
4. **Onboarding-Tiefe:** freie Ziel-Eingaben („Eigenes Ziel…"-Freitext existiert) weiter ausbauen; Coach soll ausgiebig analysieren statt Chip-Katalog abzuarbeiten — D8/D10-Prinzip („Coach denkt, Code rechnet nur wenn der Coach es will").
Verwandt: [[atlas-master-app-verhaeltnis]] (DESIGN_EVOLUTION.md D1–D8), [[atlas-outotu-output-format]].
