---
name: atlas-design-system
description: ATLAS Gesamtkonzept docs/DESIGN-SYSTEM.md v1.0 (07.09. committed) — Identität „ruhiger Titan", Gesetze F1–F6, Farb/Typo/Raum-Tokens, 3 Materialschichten, Komponenten-Verträge, Fix-Queue, Governance; entstand nach Saschas „DU SOLLST EIN VERFICKTES GESAMTKONZEPT ENTWICKELN"
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**Auslöser (07.09., Wut):** „DU SOLLST EIN VERFICKTES GESAMTKONZEPT ENTWICKELN … nimm autoclaw oder cline oder claude design dafür" — Einzel-Parameter-Fixes (Blob-Tiefe, Vignette) ohne bindendes Gesamtdokument empfand er als Stümperei. Antwort: **`~/ATLAS_MASTER/app/docs/DESIGN-SYSTEM.md` v1.0** (committed) als die Design-Bibel neben UI_USERFLOW_SPEC.md.

**Kern (1 Satz):** BARBULLS ATLAS = *der ruhige Titan* (offizielles Minotaurus-Logo: Kraft im Lotussitz) → dunkle Kammer (#030303 warm), gebranntes Bernstein als Markenlicht, Glasplatten als Content, Text als Gravur — Kraft × Disziplin × Evidenz.

**Die 6 Gesetze (Review-Frage immer: „welche Zeile bricht der Commit?"):**
- **F1** Kalte Farben (Cyan) NUR Daten/Charts, warme (Amber) NUR Marke/Aktion — Cyan-Buttons = Bug
- **F2** Negativraum: Gruppen ≥24px, Klickziele nie <8px; Leerraum >120px ohne Inhalt = Defekt
- **F3** Tiefenlicht-Test: Graustufen-Screenshot — hellstes Feld MUSS der primäre Text sein (der Test, den die Blob-Katastrophe nicht bestand)
- **F4** Kein Glas ohne Funktion (nur tragende/interaktive Flächen)
- **F5** Motion aus aktueller Position (motion-Springs, nie linear/CSS für Ortswechsel); reduced-motion tötet alles außer Opacity
- **F6** Kein Spinner >300ms — Skeleton oder atemendes ATLAS-Emblem

**Inhalt des Dokuments:** Farbtoken (bg #030303, bg-raised #0b0906 warm-SCHWARZ nie blau, amber #f59e0b, amber-deep #b45309, ember #7c2d12, cyan #06b6d4 Daten-only, ink warmweiß #f5f2ec, dim #8a8177) · Typo-Skala 9/11/13/15/18/24/32, UPPERCASE-Gravur-Labels · 8px-Raster, Tab-Bar 54px+SafeArea, Content ≥88px · 3 Materialschichten (Bühne+Backdrop-Lichtfeld / Glasplatten / Gravur) · Motion-Tabelle (Spring-Morph Tab-Wechsel, Press ab pointer-down, Kill-Switch bewusst HART 150ms) · Komponenten-Verträge (1 primary-Button pro Viewport, Chat-Bubble ≤620px mit Klartext-Quellen-Fußnote, States leer/geladen/Fehler/aus mit 1 Satz+1 CTA) · Screen-Specs der Kern-Reise · **Fix-Queue 6 Verstöße** (KPI-Duplikat, Vision-Doppelbutton+Scrollbars, FAB-Overlap, Tab-Indikator morpht nicht, Key-Jargon im 20-Stufen-Modus, „LETZTE 0 SÄTZE") · **Governance:** UI-Commit ohne Gesetzes-Referenz im Body = nicht mergen; Dokument ändert sich nur mit Saschas GO.

**Unabhängige Kritik (Gewaltenteilung [[agenten-selbstueberwachung]]):** Kritik-Agent (baut NICHT) auditiert Screenshots+Code gegen F1–F6 und das Konzept selbst — sein Bericht treibt die Fix-Queue, nicht mein Selbsturteil.

**DESIGN V2 LIVE UMGESETZT (07.09. Nachmittag, Bundle index-HMtHfw8H, QA-LIVE/44→45 Vorher/Nachher):** Saschas Instinkt „ist das ein modernes passendes Design?" war RICHTIG — helle Glanzkugeln VOR dem Content = Spielzeug-Look. Fix: Blobs nach hinten verlagert (base z −2,5/−4,5 → −6,5/−8,5), entsättigt (#f59e0b/#d97706 → #b45309/#92400e/#78350f), Glow halbiert, Speed halbiert (ruhig=premium), roughness 0,15→0,22 (tötet Plastik-Glanz), transmission 0,8, Container-Opacity 0,55→0,4 + **Vignette** (radial-gradient Ränder/Unten ins #030303). Dazu **Tab-Wechsel = echter motion-Spring-Morph** (App.tsx: AnimatePresence mode="wait" + motion.div fade+rise+blur, stiffness 340/damping 32, useReducedMotion-Guard) — motion v13 war schon in package.json, war NIE verdrahtet („geplant aber nie verkabelt"-Muster prüfen!). F3-Graustufen-Test besteht jetzt: hellstes Feld = Chat-Bubble/Text.

**How to apply:** Jeder ATLAS-UI-Task startet mit DESIGN-SYSTEM.md-Lektüre (.clinerules-Lesepflicht erweitern), Befunde immer als Gesetz-Zitat + Schwere; neue Design-Ideen = erst Vorschlag ins Dokument (GO-Gate), dann Code. Bei „ist das modern?"-Fragen: F3-Graustufen-Test als objektive Antwort statt Geschmacksdiskussion. Verwandt: [[atlas-master-app-verhaeltnis]] (Design-V2-Blob-Parameter), [[atlas-standort-korrigiert]] (UI_USERFLOW_SPEC = Flow-Bibel).
