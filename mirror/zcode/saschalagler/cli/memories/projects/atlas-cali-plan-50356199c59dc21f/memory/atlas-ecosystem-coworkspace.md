---
name: atlas-ecosystem-coworkspace
description: ATLAS Cali Coach App-Ökosystem — kanonischer Pfad in
  Coworkspace_Ich (trailing space!), 2 Produktions-Apps, Security-Befunde,
  Go-Live-Pfad
metadata:
  node_type: memory
  type: project
  originSessionId: sess_67d3c1ad-366c-46f1-956b-df836df383fd
---

**Kanonischer Pfad (Achtung, trailing space!):** `/Users/saschalagler/Desktop/Coworkspace_Ich/atlas + pliability /Atlas Cali Plan/` — Leerzeichen nach "pliability"; `cali plan 12 sets ` hat auch trailing space. Das alte `~/Desktop/Atlas Cali Plan/` (CWD mancher Sessions) ist leer/tomb; die Master-Docs nennen noch die alten Pfade (stale).

**Master-Dokumente dort:** `ATLAS_MASTER.md` (SSOT: Vision, C4/BPMN, 6 Tabs, ZNS/SSC-Engine-Logik, Recovery-Protokoll, Deployment-Topologie) · `ATLAS_STAND_2026-07-30.md` (verifizierter Ist-Stand) · `atlas_project_map.md` (24-Verzeichnisse-Inventar, Duplikat-Netzwerk, Merge-Plan).

**Zwei Produktions-Apps:** A = `cali-coach-atlas-final` (~12k LOC, React 19/Vite 7, Gemini SDK, ZNS/SSC/SessionManager LIVE, VisionInterface STUB) = Kanon, NICHT live. B = `Atlas_Cali_Commercial_V2` (~3k LOC, React 18) = alter Deploy ist "live" auf Vercel. iOS-Strang: `cali plan 12 sets /` = Gymnify Pro (SwiftUI, production ready nach eigenen Docs).

**CRITICAL Security (Stand 30.07., unverifiziert ob behoben):** (1) Gemini-Key `AIzaSy…` geleakt in 13 Dateien inkl. kompiliertem Bundle → rotieren. (2) GitHub-Remote `Koerperfluss/atlas-cali-commercial-v2` vergiftet (Credential-Stealer-Workflows auf main) → nie pushen/Vercel verbinden. (3) `gho_`-Token in `~/.git/config` im Klartext. Go-Live-Pfad: Key-Rotation → A bereinigen (base '/', global_brain 444MB raus) → Serverless-Proxy `/api/coach` → `vercel --prod` vom Mac (CLI v53.1.1 da, nur login nötig), neues sauberes Projekt.

**Lesson Agent-Teams:** 3 Spawn-Agents scheiterten am Sub-Agent-Modell-Kontingent (429 auf glm-5.2) — Haupt-Agent machte es direkt. 6 parallele Repair-Agents liefen dagegen sauber. → Kontingent vorher checken, Fallback einplanen.

**Berater-Fix 27.08.2026 — FERTIG: gebaut, 12/12 Unit-Tests grün (`npm test`), LIVE auf https://cali-coach-atlas.web.app (in `~/cali-coach-atlas-final/`):** NEU `src/core/Advisor.ts`: ZNS-Zeitmodell (ZNSEngine.calculateStrain, endlich benutzt), 6-Wochen-Zyklus ab 10.08.2026 mit Rollover + Deload W4, Psoas-Veto (Pain ≥4 → Recovery-Tag; ≥2 → FL −30 %), Push:Pull-7-Tage-Bilanz, Band-Trigger (2× Hold ≥5s → Band schwächer), Hold-Abfall >30 % → Satz weniger; `chatContext()` injiziert Livedaten in Gemini-Prompt. SessionManager: 12-Set-Session-Deckel + Set-Details persistiert + ISOMETRIC-Limit. App.tsx: Heute-Karte oben im Logbuch-Tab (Empfehlung+Readiness+Regeln), Auto-Tageswahl (einmalig), Gemini-Key via `x-goog-api-key`-Header statt URL-Query, Kill-Switch-Quittierung schreibt `atlas_kill_ack` → Advisor erzwingt Recovery-Tag, ID-Mismatch-Fix Hyphen/Unterstrich, Pläne auf 3 Sätze × 4 Übungen = 12. PWA: manifest+icon.svg+Apple-Meta. `vite.config.ts` base '/'. Der run.app-„gemini-2.0-flash deprecated"-Fehler = Alt-Bundle; Code nutzt 2.5-flash. **Deploy-Falle:** Firebase-CLI hatte falsches aktives Projekt (barbulls-app) → immer `--project gen-lang-client-0285074833` mitgeben. Tests: `tests/advisor-test.ts` (tsx). Wichtig: Bash funktionierte in dieser Session wieder (nach Tagen ENOENT) — Zustand volatil, bei Ausfall auf Read/Write + Agenten ausweichen.

**Mimosa-Deep-Audit AUSSTEHEND (27.08.):** `/mimosa-deep-audit` lief — Skill `$mimosa-security-scan` (v1.0.3) lud korrekt, ABER die Scan-MCP-Tools (`security_scan_start/status/cancel/resume`) sind in der ZCode-Session NICHT registriert (nur der Mimosa-PreToolUse-Hook aktiv) → gemäß Scan-Vertrag sauber gestoppt, kein Eigenbau-Ersatz. Nächster Schritt: User aktiviert Mimosa-MCP-Server (config.json/Addon) + ZCode-Neustart, dann Retry mit Ziel `/Users/saschalagler/cali-coach-atlas-final` (depth deep — würde u. a. den Gemini-Key-Leak versiegelt bestätigen).

**Projekt-Learning (26.08.2026, LÄUFT):** User-Auftrag = erschöpfendes Learning ALLER Verzeichnisse (nur Master-Docs war ihm zu wenig, s. [[task-scope-clarify-first]]). 4 parallele Hintergrund-Explore-Agenten gestartet: (1) Web-Codebasen Commercial_V2/CALI_COACH_ATLAS/cali-logbook/Archiv+Duplikate, (2) iOS-Strang Gymnify/SharedCoachCore/CaliCoachPro/AppPrototype, (3) Wissen: Evidenz-Studienlage/lauri-UML/atlas+/docs/OLIVER/Posture/Assets, (4) CaliCoach-Capacitor/cali-Java/Configs/.claude+.cline+alle losen Root-Dateien. **Synthese + Second-Brain-Schreiben noch ausstehend** — nächste Session: Berichte einsammeln oder Agenten resumed. User-Endziel aus abgeschnittener Nachricht offen („um am Ende e…").

Trainings-Seite des Ökosystems: [[atlas-cali-plan-tool]] · [[atlas-clinical-profile]].
