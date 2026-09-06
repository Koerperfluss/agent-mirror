---
name: atlas-lernender-agent-paradigma
description: Saschas produktdefinitionsdurchbruch — ATLAS = LERNENDER KI-Agent (learned-kb.json Systemgedächtnis, adaptives Interview bis zufrieden, Wissen ANWENDEN statt anzeigen) + Glass Engine v2 (three.js Fluid + Spring-Tilt + Bull-Emblem); Plan 06.09. genehmigt, 3 resumed Agents führen aus
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**Sascha hat 4× ExitPlanMode-Pläne in Folge abgelehnt (06.09. Nacht) — der 4. mit „völlig wertlos". Die Ablehnungen definierten sein ECHTES Produkt-Bild für ATLAS (gilt für alle künftigen ATLAS-Pläne/Arbeit):**

## 1. LERNENDER AGENT statt Formular-App (Zitat: „der ki agent soll alles aus diesem projekt aus dem graph gelernt haben, llm lernen, keine fixe abfrage")
- `npm run learn`: LLM destilliert aus `graph.json` + allen 455 KB-Chunks eine **learned-kb.json** (Themen-Synopsen, Dosierungs-Logik, Verletzungs-Protokolle, Übung-Mechaniken, quellenbelegt) = Systemgedächtnis, das der Coach in JEDEM Turn lädt. Wiederausführbar bei KB-Wachstum. Nicht RAG-Schnipsel-Prozierung.

## 2. ADAPTIVES INTERVIEW statt 20 fixer Screens (Zitat: „interaktive anpassung, empfehlung aufgrund deep reasoning und datenbank welche übungen welcher plan, adaptive abfrage .. so lange bis zufrieden, dann logbuch")
- Die 20 UI_USERFLOW_SPEC-Punkte = **interne Checkliste** des Agenten (abgehakt was sich aus dem Dialog ergibt), NICHT Formular-Karussell
- Individuelle Nachfragen per Deep Reasoning aus den Antworten („Planche bei 92kg mit Schulter-Vorgeschichte — Schmerz bei supported holds?"), KB-belegte Zwischen-Empfehlungen (Übungen, Herangehen, Prioritäten)
- **Loop bis Sascha „zufrieden/passt" sagt → ERST DANN Plan + Logbuch-Generierung**

## 3. WISSEN ANWENDEN, NICHT ANZEIGEN (Zitate: „zns readiness killswitch was macht da hier? das wissen soll angewendet werden nicht nur einsehbar" · „ssc weg damit")
- **GESTRICHEN:** ZNS-Readiness-Tile, SSC/Prilepin-Karte, Kill-Switch als UI-Element, Readiness-Badge als Gimmick
- Stattdessen: ZNS-Load/SSC/Pain/Psychologie fließen in die **Reasoning-Kette** — der Coach SAGT die Konsequenz („heute GELB, deshalb nur Isometrie"), der User braucht kein Dashboard
- Kill-Switch bleibt nur als Schutz im Dialog (Coach bricht ab/warnt)

## 4. GLASS ENGINE v2 — echte 3D-Fluid-Interaktion (Zitat nach Balken/Stagger/Pills-Vorschlag: „ist das für dich eine 3d fluide interaktive hochmoderne glasmorph app?")
- CSS-Utility-Tweaks (Progress-Balken statt Dots, .stagger, Glas-Pills, Bull-SVG) = explizit UNGENÜGEND
- Gefordert: **three.js/react-three-fiber** Hintergrund-Scene (flüssige Glas-Blobs Amber/Cyan, Pointer- UND Gyroskop-reaktiv), **motion/framer-motion Spring-Physik** (morphende Seitenübergänge via layoutId, Drag-Sheets), Karten als 3D-Glasplatten mit Pointer-Tilt + Specular-Sheen + Parallax-Tiefe, kinematisches Onboarding

## 5. Pläne müssen ALLE ~34 App-Funktionalitätenlisten enthalten (Details [[sascha-plan-vollstaendigkeit]])

**How to apply:** Jeder ATLAS-Plan/PR leads mit dem Agent-Paradigma (Lernen→Interview→Anwenden); nie wieder Dashboard-Kacheln für Wissen; Redesign nur als echte 3D/Physik-Arbeit. Verwandt: [[atlas-d8-keine-vorannahmen]] · [[atlas-outotu-output-format]] · [[sascha-plan-vollstaendigkeit]].

## ✅ PLAN GENEHMIGT (06.09. Nacht, nach 5 Versuchen) — Ausführung läuft über 3 resumed Agents
Der finale ExitPlanMode wurde genehmigt, nachdem (a) „hast du alles kapiert?" mit 6-Punkt-Kurzfassung bestätigt wurde und (b) der Plan exakt die 3 Agent-Blueprints enthielt. **Beide Executor-Agents hatten im Plan-Mode-Lock nur Blueprint-Pläne geliefert (kein Code!) — die detaillierten Umsetzungen liegen bereit:**

**Lern-Agent (4 Commits, von mir auszuführen):** ① `scripts/learn.mjs`: liest Key aus .env.local, gruppiert 455 Chunks nach topic, pro Thema 1 Gemini-Call (temp 0.4, deutsche Synopse 300–600 Wörter mit Pflicht-Sektionen Prinzipien/Dosierung/Verletzung/Mechanik/Progression + Quellen) → `src/data/learned-kb.json` {learnedAt, model, topics[{topic,synopsis,sources}]}; graph.json-Cluster optional (Pfad-Varianten scheiterten → Kandidatenliste + `ATLAS_WISSENS_GRAPH=`-Override). ② `src/coach/agent.ts`: buildAgentPrompt(checklist, learnedKb) mit JSON-Only-Contract {say, checklist, recommendation?{title,text,sources}, readyForPlan}; Checkliste 13 Keys (ziele, koerper, level, verletzungen, ausstattung, zeitbudget, rhythmus, schlaf, schmerz, prs, motivation, ton, kalibrierung), completionRatio, parseChecklistUpdate, checklistToProfile→AthletProfile. ③ `src/coach/AdaptiveInterview.tsx`: Glass-Chat („x/13 erfasst"-Leiste), ≥80% (≥11/13) + „passt"-Keyword → saveProfile + buildPlanUserPrompt → parseCoachPlan → Plan-Karte → planToTrainingDay+saveDay → onDone; OnboardingHost-Mode-Switch „KI-Interview (empfohlen)" vs „Klassisch (8 Formulare)", Mode in localStorage. ④ Tiles weg (OverviewTab — ABER überlassen dem Parallel-Agent, Konfliktvermeidung).

**Glass-Engine (6 Schritte):** Deps three/r3f/drei/motion waren NOCH NICHT installiert → Schritt 0 `npm i`. FluidScene.tsx: r3f-Canvas fixed z-0 pointer-events-none, dpr [1,1.5], 4 Icosahedron-Blobs mit CPU-Vertex-Displacement (3-Sinus-Noise), Pointer-Lerp + deviceorientation, Pause bei document.hidden; AppShell-Root bg transparent. Tilt.tsx `GlassPlate`: Spring ±7° (stiffness 260/damping 20), Specular via CSS-Vars --mx/--my, statisch bei touch/reduced-motion; **CSS-Konflikt:** index.css `.glass-card:hover{transform:…}` muss via `.glass-tilt:hover{transform:none!important}` überbrückt werden. BullLogo.tsx: geometrischer Bull-Head (Hörner+Kopf+Nasenring, amber) → AppShell-Topbar + ShellDrawer-Brand + CoachChat-Start-Header (CoachChat NICHT gesperrt) + favicon.svg.

**Rest-Funktionen (5 Schritte):** AgentSettings.tsx (atlas_agent_settings: tone/reasoning kurz|standard|tief/kbQuotes/tier; „Wissen neu lernen"→Hint npm run learn; Daten-Reset NUR hier) · Keyless-Defusierung aller Prompts außer CoachChat/OnboardingHost · Ausbildung: Lernkarten+Mini-Quiz offline aus knowledge.json (kein externes Tool!) · graph.json → public/ + Canvas-Force-Viewer ohne d3-Dep · Overview: SSC-Karte raus, PR-Badge (bestes Set je Übung) + 4-Wochen-Volumenband rein.
