---
name: koerperfluss-edu-foerderpilot-takeover
description: 30.09. Übernahme der 2 Antigravity-Unterhaltungen (Körperfluss Edu
  Website + Förderpilot) — Standorte, Antigravity-Konvo-Extraktion,
  Fertigmachungs-Stand und offene Deploy-GO-Punkte
metadata:
  node_type: memory
  type: project
  originSessionId: sess_4bb898d8-5750-44b0-a776-1dcc731622b8
---

**Auftrag 30.09.2026:** 2 Antigravity-Unterhaltungen übernehmen und fertig machen: (1) Körperfluss Edu Website (UI/UX/Userflow), (2) Förderpilot (interaktiver vektorbasierter Förderberater, liquid-fluides Förderungsuniversum).

**Antigravity-Konvo-Extraktion (wichtig, wiederverwendbar):**
- Konvo-Index: `~/.gemini/antigravity/conversation_summaries.db` (SQLite: conversation_id, title, preview, workspace_uris, step_count)
- Konvo-Daten: `~/.gemini/antigravity/conversations/<id>.db` (SQLite, Schema: steps(idx, step_type, step_payload BLOB=Protobuf)) ODER `<id>.pb` — **.pb ist at-rest VERSCHLÜSSELT** (strings liefert 0 Treffer); dann Workspace-SSOT (MISSION.md, ORIGINAL_REQUEST.md, docs/) als Quelle nutzen
- Protokoll-Extract-Script: /tmp/ag_convs/extract_edu.py (User-Text in step_payload Typ 14, Bot Typ 15)

**① Edu-Website** (Konvo `d293022b` „KÖRPERFLUSS EDU - AKTUELL", 4845 Steps):
- Repo: `~/Desktop/Coworkspace_Ich/Körperfluss EDU/Koerperfluss-3D-Upgrade/` · Live: koerperfluss.web.app (Firebase, Projekt **gen-lang-client-0285074833**) · Vite5/React18/TS, Build = `tsc && vite build`
- 3D-Bug „Slicing-Käfig": DOPPELTE Background3D.tsx (src/ + src/components/ + Finder-Duplikat „Background3D 2.tsx"); Fix = `<AnatomicalModel>` in beiden auskommentiert, aber Stand **uncommitted** und Agent brach mit 429 RESOURCE_EXHAUSTED ab
- 41 Routen/46 Pages, ~123 „ 2."-Finder-Duplikate, 9 unpushed/53 dirty commits — MVP-Schnitt als Folge-Ticket
- Builder-Dispatch schlug fehl (Connect-Timeout api.z.ai) — Edu-Bau NICHT fertig

**② Förderpilot** (Konvo `1926eeee` „Refactoring UI Components", 5165 Steps, .pb verschlüsselt):
- Repo: `~/antigravity/Körperfluss-PILOT.AI` („förder-cockpit-für-startups", React19/Vite6/d3/motion) · **Root ist aktive Build-Quelle** (index.html → /index.tsx → Root-App.tsx), src/ = Kopie; Doppelstruktur Root↔src auf byte-identisch synchronisiert (Bereinigung nur mit GO)
- **FERTIG (Commit `9793048`)**: Build+Lint grün (vite6, JS 2,08 MB — Code-Splitting offen), 3-Schritte-Copilot-Einstieg, VectorCloud100 liquid-fluid (velocityDecay 0,52, forceX/Y, Bloom-Einstieg, reduced-motion), Beta-Badges auf Nicht-Funktionstabs, TIP-NÖ (70 %/9.900 €, Kornherr ergänzt) + DigitalArk (action_required) auf SSOT korrigiert (existierten schon, nicht duplizieren!), git init + .gitignore (.env!), Doku **FERTIGMACHUNG_2026-09-30.md**
- Offen: Deploy `npm run build && firebase deploy --only hosting` (site **foerder-cockpit**) = Stopp-Regel, braucht Sascha-GO; Gemini-Key via process.env im Browser (Backend-Proxy fehlt)

**Modell-Empfehlung (30.09., inzwischen belegt):** GLM 5.3 (max) für /Plan/Architektur/Gegenlesen, Flash (max) für Ausführung/Scans/Doku — Flash = 320B MoE, ~8,9× billiger, AA-Index 57; 5.3 = Flagship (CyberGym 84,5); beide mit low/high/max im Z.AI-Plan. Details: [[glm-53-vs-flash-belegte-fakten]]. Verwandt: [[loki-os-v18-endprodukt]], [[sascha-vollzug-keine-zwischenfragen]]
