---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/active-projects-focus.md"
stand: 2026-09-15
tags: [spiegel, zcode]
---

---
name: active-projects-focus
description: Saschas 3 aktuelle Fokus-Projekte (30.08.2026) + projects.py-Tool
  zur Projektlisten-Ausgabe
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ec864b92-2403-44f6-8057-fd71047cea94
---

Saschas 3 aktuell genannte Fokus-Projekte (30.08.2026): **ATLAS Cali Coach**, **Körperfluss Physio-Web-App**, **FörderOps Assistant** (verwandt mit [[legal-ops]] / Legal Ops Advisor).

**Kanonische Pfade (06.09.2026 per Discovery korrigiert + WIKI.md je Projekt):**
- **Atlas Cali Coach**: kanonisch `~/cali-coach-atlas-final` (React 19/Vite + Swift-iOS `ios/Gymnify`) — ⚠️ Zwillings-Root `~/Desktop/Coworkspace_Ich/atlas + pliability /cali-coach-atlas-final` (gleicher Git-HEAD, Ordnername endet mit LEERZEICHEN) = Drift-Falle. WIKI.md im Root.
- **Körperfluss 3D**: `~/Desktop/Coworkspace_Ich/FIRMEN PROJEKTE/Koerperfluss-3D-Upgrade` (NICHT `~/Desktop/Koerperfluss-3D-Upgrade` — Projektliste war veraltet!). React+Three.js+Firebase, Deploy `--project gen-lang-client-0285074833`, 🔴 keine Tests.
- **Legal Ops Advisor (Thomas/Judicario)**: `~/LegalOpsAdvisor_Sacha_Mac` + Judicario-MCP in `~/loki-ki/services` (läuft 4× parallel ⚠️, 🔴 API-Keys im Klartext).
- **LOKI Voice**: `~/loki-ki/loki-voice` (Python) + Swift-App in `~/Desktop/Coworkspace_Ich/PETER JUDICARIO/Judicario_Sacha_Mac/LokiVoiceApp`.
- Zentraler **WIKI-INDEX**: `~/.zcode/workspace/default/WIKI-INDEX.md` (alle Pfade + Querschnitt-Befunde).

Projektlisten-Tool: `python3 ~/.claude/tools/projects.py` — kuratierte Top-10-Liste aus `~/.claude/projects/-Users-saschalagler/memory/MEMORY.md` (Abschnitt "## Weitere Projekte") × letzte Aktivität aus `~/.claude-mem/claude-mem.db`. Weitere Projekte in der Liste: GCP Billing (Konto 015D43, siehe [[google-cloud-genai-credit]]), LOKI Agent OS, Gemini API Stack, Legal Ops Advisor, Gemini Chrome + Mac, LOKI.OS konsolidiert, BAR BULLS Firebase, Barbulls GoPro Labs.

**OFFEN (30.08.2026):** Die projects.py-Liste war veraltet (neueste Einträge 11.08.). Sascha: „falsch, aktualisiere sofort die Projektliste" — Aktualisierung (claude-mem.db seit 11.08. auswerten + MEMORY.md-Abschnitt „## Weitere Projekte" auffrischen, danach Skript neu ausgeben) noch NICHT ausgeführt, weil Plan Mode alle Bash-/Schreibaktionen blockte; Plan abgelehnt. Sobald Ausführung frei ist: nachholen.

**Chatbot-Plan (30.08.2026):** Für alle 3 Fokus-Projekte als Bots geplant — FörderOps via Vertex-AI-Search-Credit (siehe [[google-cloud-genai-credit]]), Körperfluss-Web-Bot + Atlas via gratis Gemini API. Reihenfolge: FörderOps zuerst; Start auf Saschas Wort „Start FörderOps". Noch NICHT angefangen.

**Update 06.09. spät:** Sascha nannte die VOLLE Liste (nicht nur 3): LOKI.OS/agent-os (aktiv), Atlas (**an AutoClaw full-stack-builder übergeben**), Legal Ops + Native (🔴 Verschmelzung kaputt), LOKI Voice+Thomas (ein Projekt), Körperfluss 3D, + 4 kleine: TODO App (`~/Desktop/Coworkspace_Ich/Projekt-Task-Planer`, App installiert als `/Applications/TODO APP.app`), Förder-Landschaft-Neubau (`~/Desktop/Coworkspace_Ich/öförderrungen`), Paraletts 3D-Hub + Barbulls Website (beide `…VEREIN ; BARBULLS ; PARALETTS/`). Kanonische Verwaltung jetzt: [[loki-project-map]] / `~/LOKI_PROJECT_MAP.md`.

**Update 08.09. (ATLAS + ZCode-Pipeline):** Atlas hängt seit ~10 h an „App live bekommen" (Blocker UNGEKLÄRT — Build/Deploy/Runtime nie benannt!). Copy-paste /standardskill-Prompt für den Atlas-Chat an Sascha übergeben: TAKEOVER (Koerperfluss/atlas-cali-coach, Live barbulls-app.web.app/Firebase) → BUILD MediaPipe Live-Pose-Estimation clientseitig (offene Prio) → FINISH; Team @code-architect/@explore/@implementer/@reviewer, max 3 parallel, Stopp-Regeln Deploy/Löschen/Push. Nutzung der neuen ZCode-Pipeline (@agents, loki-dev 5 Modi, /kanban, /init) erfordert ⌘Q-Neustart. Parallel lief im Atlas-Tab eine eigene Skill-Konsolidierungs-Session (Plan v2 via code-architect) — ohne Kollision: Endstand 96 aktive Skills, 20 archiviert in ~/.agents/skills-archive/2026-09-08/, siehe [[skills-architektur-2026-09-07]].

**Update 08.09. II (Atlas-Details + Prompt-Feedback):** Neue Kanonische Pfade von Sascha: alle Files `/Users/saschalagler/Desktop/Coworkspace_Ich/atlas + pliability`, Master `…/atlas + pliability/ATLAS_MASTER` UND `/Users/saschalagler/ATLAS_MASTER`; Deploy-Repo `~/cali-coach-atlas-final`. Vorherige Atlas-Session: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3 (Cline-Code/ZCode, Provider cline-pass/glm-5.3-flash, 89.205k Tokens, $1.01) — dort: +156/−5 uncommittete Changes in firebase.json (Cache-Control-Header: index.html no-cache, manifest no-cache, /assets/** immutable), Thema „iOS 27 Berechtigungen" + „Cline Code App fixen". 10h-Live-Blockade immer noch ohne benannte Root Cause. **Feedback**: Sascha will bei Übergaben den fertigen Copy-Paste-PROMPT (einfach, ohne Erklär-Prosa) — „was redest du, gib mir einfach den prompt".

**Update 15.09. (Projektliste TATSÄCHLICH aktualisiert — das 30.08.-OFFEN ist erledigt):** Auf Saschas Befehl („aktualisiere die Liste mit allen Unterhaltungen von zcode cline code cline cli antigravity") alle Chat-Stores gezählt: **ZCode 344 Sessions** (db.sqlite; Top: default-Workspace 104, Beobachter 58, ATLAS-v8-Bau 56), **Cline 259 importiert** (~/.zcode/v2/sessions), **Claude 105 importiert** + 20 Projektordner, **Antigravity 2 Installationen** (Chat-Store 446 KB, aktiv = Physio-Assistent). MEMORY.md-Abschnitt „Weitere Projekte" aktualisiert (Backup .bak-20260915): **+4 neue Projekte** (Vinyl-Scanner 14 Sessions bis 12.09., SBP Patrick-Doc bis 07.09., Antigravity Physio-Assistent, iOS/WebDev-Stack 2026) + GCP-Billing-Zeile auf 24,08-€-Wahrheit korrigiert; je neue Memory-Datei angelegt. ⚠️ Mimosa-Hook blockiert Bash-Schreibzugriffe auf Dateien unter ~/.claude („Bash 直接写源码") → IMMER Edit/Write-Tools nutzen, nie Bash-umleitung.

Verwandt: [[google-cloud-genai-credit]]
