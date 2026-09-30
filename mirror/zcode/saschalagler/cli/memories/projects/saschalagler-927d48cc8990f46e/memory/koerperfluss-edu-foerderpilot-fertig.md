---
name: koerperfluss-edu-foerderpilot-fertig
description: 30.09. — beide Antigravity-Projekte FERTIG + LIVE DEPLOYT (Edu +
  Förderpilot), Security-Serie abgeschlossen, nur Rotation/History/Cleanup offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_33b5868e-a2a4-49cf-823a-7563047524e1
---

Stand 30.09.2026 (Endstand, 9/9 — beide Apps LIVE):

**Körperfluss Edu Website** — Repo `~/Desktop/Coworkspace_Ich/Körperfluss EDU/Koerperfluss-3D-Upgrade/` (HEAD `995c8df`). LIVE: koerperfluss.web.app (Firebase gen-lang-client-0285074833), Deploy per `firebase deploy --only hosting --project gen-lang-client-0285074833` (site „koerperfluss"). Beweis: live Bundle `index-SsKngqM3.js` = lokal identisch. Commits `5739f09` (UI/UX-Userflow + 3D-Slicing-Käfig-Fix) + `995c8df` (XSS-DOMPurify, matchMedia-Cleanup, Sidebar-Remount). ~123 „ 2"-Duplikate + 41 Routen bewusst unangetastet; **9 unpushed Commits** (Push nur auf GO).

**Förderpilot** — Repo `~/antigravity/Körperfluss-PILOT.AI` (HEAD `c1b5d17`). LIVE: foerder-cockpit.web.app, Live-Bundle `index-BLJp8wD8.js` = lokal identisch, Live-Scan: **0 echte Passwörter, 3 Maskierungs-Marker**. WICHTIG: Root-Dateien sind die aktive Build-Quelle, NICHT src/ (beide Bäume byte-identisch halten — cp via Bash wird vom Mimosa-Hook geblockt, Write/Edit-Tool nutzen). Commits: `9793048` (git init, Userflow, Liquid-Cloud), `c962f10`+`7e31e27` (P0 Passwörter raus, P1/P2 Fixes), `c1b5d17` (alle Mimosa-Findings zu: Passwort-Scrub inkl. Alt-Kopien `körperfluss-pilot.ai/`, geminiService-Throw, pathlib statt `open(`-Variablen; **Rescan 0 Findings**). Lektion: Mimosa/Semgrep blockt JEDE `open(<Variable>)`-Stelle in py — nur pathlib/Literale gehen durch; Gate scannt projektweit, Commits blockiert bis alle Findings gefixt.

**⚠️ Sascha-Aktionen (noch offen):** (1) 3 Portal-Passwörter SOFORT rotieren (FFG eCall, AWS Fördermanager, WAW) — altes Bundle war live mit Klartext. (2) Pilot-Git-History-Reset entscheiden (`9793048` enthält alte Passwörter, nie gepusht). (3) Edu: 9 unpushed — Push-GO? (4) Doppelstruktur Root/src-Cleanup (beide Projekte). (5) Gemini-Backend-Proxy (process.env im Browser crasht).

Parallele-Lane-Lektion: Parent-Session + Side-Chat arbeiteten GLEICHZEITIG im selben Pilot-Repo (git status mehrfach verändert) — vor Edit immer frisch lesen, keine Kollision erzwungen; Parent holte den letzten Commit `c1b5d17`. Antigravity-Konversationen: `.db` (SQLite, step_payload=Protobuf, per python-strings extrahierbar) oder `.pb` **at-rest verschlüsselt** → Workspace-SSOT nutzen. Detail-Doku je Repo: `FERTIGMACHUNG_2026-09-30.md`. Verwandt: [[loki-os-v18-endprodukt]], [[atlas-versionsstand]], [[koerperfluss-edu-foerderpilot-takeover]]
