---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/atlas-outotu-output-format.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: atlas-outotu-output-format
description: Saschas verbindliches Output-Format für ALLE ATLAS-Analysen =
  „ATLAS OUTOTU PERFEKT.pdf" (Bio-Feed/Kinetic-Chain-Scan-Stil)
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_9889d067-3d73-469e-835a-f54a1450b23c
---

Sascha hat am 05.09.2026 `~/Desktop/ATLAS OUTOTU PERFEKT.pdf` als verbindliches Ausgabeformat bestimmt: **Jeder Analyse-Output der ATLAS-App (Vision-Report, Coach-Analysen, Logbuch-Analysen, Übungs-Bewertungen) soll strukturell und stilistisch diesem PDF folgen** — nicht nur der Vision-Tab.

**Why:** Sascha nennt es „PERFEKT" — es ist sein Produkt-Gesicht (BARBULLS v4.0 High-Tech-Bio-Feed, kalibriert auf 92kg, fordernder Trainer-Ton). Flache Chat-Antworten ohne diese Struktur empfindet er als wertlos.

**How to apply:**
1. **Format-Schema (aus dem PDF, 1:1):**
   - Header: `BARBULLS v4.0 · BIOMETRISCHES FEED · ATLAS VISION V2` + `SYSTEM CALIBRATED @ <gewicht>KG` + Abschnittstitel in gepunkteten CAPS-Labels (tracking-[0.25em], amber)
   - **KINETIC CHAIN SCAN:** je Körpersegment (HANDGELENK · ELLBOGEN · SCHULTER/SCAPULA · RUMPF/CORE · KÖRPERSCHWERPUNKT) ein Status-Badge `OK` (grün) / `WARNING` (amber) / `CRITICAL` (rot) + deutsche Physio-Analyse + konkreter Ausführungs-Cue (z. B. „Griff fest wie Zange")
   - **IDENTIFIED CORE SKILL:** erkannte Übung + Stufe (z. B. „TUCKED PLANCHE (VORBEREITUNG/EINSTIEG)") + 2-3 Sätze Gesamtbewertung mit kg-Bezug
   - **WEAK LINKS / COMPENSATIONS:** Listen der kritischen Schwachstellen/Kompensationen
   - **DRILL PROTOCOL:** nummerierte Drills, jeder mit FOKUS (CAPS), TARGET DRILL (konkrete Übung, cyan-markiert) + RATIONALE (biomechanische Begründung inkl. Körpergewicht-Bezug)
   - **BIO-EVOLUTION:** Progressionsempfehlung (erst Form perfektionieren, dann Dauer/Last steigern)
   - Abschluss: `SYNC WITH INTELLIGENCE` / `UPLOAD TRAINING DATA`-CTA
2. **Bereits implementiert für Vision:** `src/vision/chainScan.ts` (Gemini-JSON-Schema) + `src/vision/ChainScanReport.tsx` (UI) in `~/ATLAS_MASTER/app` — für neue Analysen dieses Schema WIEDERVERWENDEN statt neue Formate erfinden.
3. Gemini-Prompts müssen dieses JSON-Schema erzwingen („Antworte AUSSCHLIESSLICH gültiges JSON, exakt dieses Schema"), Deutsch, präzise, fordernd, auf Athletengewicht kalibriert.
4. Siehe auch [[atlas-standort-korrigiert]] (App-Pfad, OUTOTU=Vision-Design) und [[sascha-beweis-echtprojekte]].
5. **Design-Kontext 05.09. Nacht:** `~/ATLAS_MASTER/app/DESIGN_EVOLUTION.md` (D1–D8) ist das übergeordnete Design-Gesetz (Higgsfield × Liquid Glass × BARBULLS + Motion-Tokens) — der OUTOTU-Report ist dort als Gesetz D8 „Wissen als Substanz" verankert; geplanter nächster Schritt: OUTOTU-Report als **Default-Demo mit Beispieldaten im Vision-Tab sichtbar machen** (auch ohne Gemini-Key), damit Sascha sein Zielbild sofort sieht.
