# ATLAS Berater-Fix — die Output-Logik deiner echten App

## Audit-Ergebnis (warum die App sich dumm anfühlt)

Deine Berater-Logik **existiert** — aber sie ist toter Code. `utils/autoregulation.ts` (Psoas-Veto, Form-Break-Regress, RPE-Delta) hat **keinen einzigen Importeur** in der live App. Die ZNS-Uhr läuft mit Fake-Datum (immer „48h her"), Hold-Zeiten werden **nicht gespeichert** (kein Trend, kein „Band reduzieren"-Trigger), der Gemini-Chat kennt weder Logbuch noch ZNS-Stand, und beim Öffnen berechnet **nichts** einen Tagesvorschlag. Dazu: kein PWA-Manifest (nicht installierbar) und `vite base:'/app/'` bricht beide Deploys.

## Der Plan — Quelle: `~/cali-coach-atlas-final/` (die App hinter cali-coach-atlas.web.app)

**Neue Datei 1: `src/core/Advisor.ts`** (~150 Z.) — das Gehirn:
- `today()` liest echte Historie + ZNS-Zerfallsmodell (`ZNSEngine.calculateStrain`, endlich benutzt) + Zyklus-Kalender (Start-Datum → Deload-Woche 4)
- Output-Objekt: `{ tag: "A"|"B"|"C"|"Recovery", volumenFaktor: 0.5–1.0, anpassungen: [...], begruendung: "..." }`
- Regeln eingebaut: Top-Set-Bruch → Volumen halbieren · Psoas-Signal → FL −30 % · Plateau 3 Wo → Frequenz+ · DOMS → Legs schieben · Handgelenk → HSPU→Dips · Push:Pull ≥ 1:1-Warnung · 12-Set-Limit pro Bewegungsmuster

**Neue Datei 2: Skill-Gedächtnis** (Erweiterung `LogbookService`): Sätze mit reps/gewicht/TUT/qualität/pain persistieren, Trend der letzten Sessions, Progressions-Trigger (Hold >5s sauber ×2 Sessions → „Band eine Stufe schwächer" als aktive Karte).

**Änderungen an `App.tsx`** (chirurgisch, 6 Stellen):
1. **Heute-Karte** oben im Logbuch-Tab: Advisor-Empfehlung beim Öffnen — Tag, Volumen-%, Anpassungen mit je 1-Zeilen-Begründung (das, was du vermisst hast)
2. Nach Session-Speichern: Advisor-Delta („nächste Session: −30 % FL")
3. **Chat-Kontext**: System-Prompt bekommt ZNS-Score + letzte 3 Sessions + Hold-Trends + aktive Advisor-Regeln injiziert → der Berater weiß endlich, was du zuletzt gemacht hast
4. Gemini: Modell bleibt 2.5-flash, Key aus URL-Param raus → Header (`x-goog-api-key`)
5. Kill-Switch: Quittieren erzwingt Recovery-Tag statt „weiter wie nichts war"
6. Session-Save schreibt echte Set-Daten (füttert 1+2)

**Klein aber kriegsentscheidend:**
- `index.html` + `public/manifest.webmanifest` + Theme-Color → endlich als App aufs iPhone installierbar
- `vite.config.ts`: `base: '/'` — behebt den Asset-Pfad-Bruch auf web.app UND run.app

**`DEPLOY.md`** (neu): 2 Befehle für dich (`npm run build` + `firebase deploy`), plus run.app-Variante, plus Erinnerung Gemini-Key-Rotation.

## Was ich NICHT mache (bewusst)
- Kein Redesign — Layout ist dir egal, die Logik ist der Fix
- Keine der 2 toten App-Generationen (MainHub/pages/*) anfassen
- VisionInterface/MediaPipe unangetastet (separater Auftrag)

## Risiko
Bash ist tot → ich kann nicht bauen/testen. Gegenmittel: konservatives TS, chirurgische Edits, jede Änderung mit Zeilenbezug dokumentiert. Build+Deploy laufen über DEPLOY.md (du oder eine Shell-Session — 2 Befehle).