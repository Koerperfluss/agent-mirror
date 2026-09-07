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

## ✅✅ AUSGEFÜHRT + LIVE BEWIESEN (07.09. Früh) — DER AGENT LEBT
**Lern-Lauf KOMPLETT:** learned-kb.json = **23/24 Themen · 8.267 Wörter Systemgedächtnis** (Evidenz-Themen zns/ssc/biomechanik/evidenz/methoden je 380–720 Wörter quellenbelegt + 7 graph-Cluster-Bibliographie-Synopsen). Live produziert: Interview-Frage klingt jetzt nach dem Korpus („…deine Physis nach wissenschaftlichen Standards…").
**Interview E2E BEWIESEN (Dev :5199 + Prod):** Kickoff-Frage kommt → User-Antwort (Ziele/Level/Gewicht/Schulter) → Agent antwortet INDIVIDUELL mit Deep-Reasoning-Nachfrage („**Bevor wir an die Progressionen gehen, müssen wir deine Schulter sichern**: Schmerz 0–10, auch bei Planche Leans?") → Checkliste sprang auf **5/13 erfasst**. Production-Kickoff ebenfalls live („primäres Ziel… Skills/Kraft/Masse?"). Mode default = interview; „KLASSISCH"-Button hält 20-Stufen-Flow als Option (localStorage MODE_STORAGE).

**Lern-Pipeline-Fallen (behoben):** (1) **Timeout-Truncation** — `timeout 590 npm run learn` schaffte nur 8/24 UND schrieb nichts (Ergebnis nur am Ende) → **inkrementelles writeFileSync nach JEDEM Topic + Resume** (loadExistingResults überspringt Fertige); bei Abbruch einfach erneut laufen lassen. (2) Cluster-Synopsen erreichen nie MIN_SYNOPSIS_WORDS=220 (Cluster-Prompt = nur Dateinamen-Bibliographie, ~150 Wörter) → Schwellen-Branch: cluster:* Topics gelten ab 100 Wörtern. (3) Quota-429 auf 3.8 → CHAIN mit 4 Modellen rotiert weiter.

**Interview-Self-Heal (deployed):** 3 Retries mit wachsenden Pausen (20s/40s) + Status-Hint („Google ist kurz überlastet — Wiederholung in 20s…"); **ab Retry 2 läuft der Call keyless über den ATLAS-Proxy** (`apiKey: attempt >= 1 ? '' : apiKey`) — Proxy-Key hat EIGENE Quota (bewiesen: Key direkt 429 während Proxy 200). „Noch mal"-Button bei hartem Fehler.

**Glass Engine v2 deployed (Agent-2 lieferte 5 Commits):** deps three 0.185 + @react-three/fiber 9 + drei 10 + motion 13 · FluidScene (r3f Meta-Blobs, pointer/gyro-lerp, dpr 1.5, pause bei hidden, lazy) · Tilt/GlassPlate (Spring ±7°, specular sheen via CSS-Vars, statisch bei touch/reduced-motion — schützt die 68 DB-Karten) · MobileTabBar-Buttons + DB-Karten als GlassPlate · BullLogo SVG (Hörner+Kopf+Ring, amber, motion-Sheen) in Topbar/Drawer/Start-Header/favicon · Coach-Eingabezeile Glas-Pill.

**Rest-Funktionen (Agent-3, partial vor Netz-Tod):** AgentSettings committed (8c5415a) · Ausbildung Lernkarten+Quiz committed (3d08089a) · GraphViewer.tsx + graph.json → public/ + WissenTab „Liste|🕸 Graph"-Toggle (von ZCode nachgezogen) · Overview-SSC/PR-Band-Teile unklar — beim nächsten Überblick prüfen.

## ✅✅✅ KOMPLETTER LOOP LIVE BEWIESEN (07.09. früh, Produktion, QA-LIVE/20-26)
Interview 0→**11/13** (3 komprimierte Antworten) → „Plan erstellen"-Klick → Plan-Karte mit **KB-Begründungen** (Scapula Push-ups · Tuck Planche 4×8s RPE 7 · Adv. Tuck FL 4×6s · „— [KB: biomechanik]") → **„In Logbuch übernehmen"** → heutiger Tag: **3 Blöcke · 6 Übungen · 20 Sätze** generiert → Onboarding schließt, App offen. E2E-Skript: `QA-LIVE/interview-e2e.sh` (send() via nativem textarea-value-Setter + Enter; state() per `/(\d+)\/13 erfasst/`-Regex).

**Gotchas dabei:**
- **READY_THRESHOLD = 0.8 → 11/13 Pflicht:** Bei 10/13 (0.769) tut ein „Plan erstellen"-Klick **NICHTS** — kein Loading, kein Fehler (runPlan wird erst gerendert/auslösbar wenn planReady). Diagnose-Pflicht bei „Button-Klick ohne Wirkung": zuerst `(document.body.innerText.match(/(\d+)\/13 erfasst/))[1]` prüfen und ggf. eine Antwort mehr senden.
- **Plan-Generierung Self-Heal nachgerüstet** (runPlan): 4 Versuche, ab Retry 2 keyless über Proxy (`apiKey: attempt>=1 ? '' : apiKey`) — identisch zum Dialog-Retry; Google-Abend-Peaks (503/429) übersteht damit auch der Plan-Schritt.
- Retry-Button heißt „**Noch mal**" (nicht „Wiederholen") — Matching danach.
- Logbuch-Verifikation: nicht „blocks zählen" im Tab-Wechsel sofort, sondern `TRAININGSTAGE` + „Tag Mo., 07. Sept. · Fokus … 3 BLÖCKE 6 ÜBUNGEN 20 SÄTZE" im innerText lesen (Block-Zähl-Regex lieferte 0 obwohl Tag da war).
- Watch-Loop-Muster: pro Schritt 22–25s schlafen, JSON-Status per agent-browser eval, `case "$S" in *\"p\":true*) break;; esac`.

## 🔴 MC-REGRESSION (07.09. Nachmittag) — „keine fixe abfrage" kehrt via Prompt-Eigenzeile zurück
Der Agent-Prompt selbst empfahl in STUFE 5 „mit 2–4 Antwort-Optionen wo sinnvoll" → KI stellte A/B/C/D-Fragen (Multiple-Choice = exakt Saschas verbotene fixe Abfrage). **Fix:** STUFE 5 verlangt jetzt OFFENE Fragen (freier Text), NIEMALS Buchstaben-Optionen/Choice-Listen; natürliche Beispiele nur im Satzfluss. **Verifizierungs-Falle:** die gleiche alte Bubble blieb nach Reinstall sichtbar — `simctl install` erhält localStorage; erst `simctl uninstall` + install = frischer Container → frisches Kickoff zeigt die offene Frage (Beweis QA-LIVE/43-ios-frische-antwort.png). Regel: Agent-Prompt-Zeilen gegen Saschas Verbote auditieren, NACHDEM Features gewachsen sind.
