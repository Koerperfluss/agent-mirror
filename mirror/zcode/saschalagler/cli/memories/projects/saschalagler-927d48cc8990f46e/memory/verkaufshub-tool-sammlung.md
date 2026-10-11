---
name: verkaufshub-tool-sammlung
description: VERKAUFS HUB = Projekt TOOL-SAMMLUNG-VERKAUF — hub.html Cockpit :3300 (Server 11.10. gestartet), 67 Tools/15 Agenten, hub-glass.html Liquid-Glass-Redesign gebaut, Detailstand im agent-mirror-Memory; 810k-Cline-Session = fehlgeschlagener ATLAS-Xcode-Abgleich (Titel irreführend)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_9bb02160-ce23-4582-a594-371c1f798aa5
---

11.10.2026 identifiziert + getestet (Cline-Screen „VERKAUFS HUB - 11 Agent monster", 810k Tokens):

- **Identität:** „VERKAUFS HUB" = Projekt **`/Users/saschalagler/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /TOOL-SAMMLUNG-VERKAUF`** (Ordnername mit trailing space quoten!). 67 Tools in `tools-v2.json` (61 bewertet, 20 „verkaufen: ja"), Cockpit `hub.html` (85 KB, Tabs Cockpit/Kanban/Top-Werte, Steuerleiste Auto-Pilot/A15-Priorisieren/Hub-aktualisieren via Backend :8055), 15 Agenten (agents.py, planer.py, autopilot.py, hub_api.py Router).
- **Detaillierter Projektstand** (66/66 bewertet, Vermarktungs-Reihenfolge Bar-Bulls→LegalOps→LokiVoice→agent-mirror→Körperfluss, Mimosa/git-blocks, storefront-Build kaputt) steht im Projekt-Memory: `~/Mirror/agent-mirror/mirror/zcode/saschalagler/cli/memories/projects/tool-sammlung-verkauf-d6893782b4cb810a/memory/verkaufshub-inventar-und-workflow.md` — bei Hub-Arbeiten ZUERST lesen.
- **11.10. Test-Pipeline-Lauf:** :3300 war TOT → `python3 -m http.server 3300 --bind 127.0.0.1` im Repo gestartet (KEIN LaunchAgent — stirbt beim Reboot). flutter-skill explore: 0 Bugs, nur favicon-404. Backend :8055 aus (Steuer-Buttons tot ohne es; Start = uvicorn main:app nur auf GO). Beweis: `~/Desktop/TEST_HUB_11-10.png`.
- **11.10. Design-Urteil Sascha:** altes hub.html = „absolut MÜLL" — Vision: **3D, modern, fluid, Liquid-Glass, Higgsfield-Vibe, reactive**. → `hub-glass.html` gebaut (Repo-Root + Kopie in storefront/out-firebase): animierte Gradient-Blobs, backdrop-blur Glass-Karten mit 3D-Tilt, live Suche + Tier/Verkaufen-Filter, Daten via `fetch('./tools-v2.json')` (funktioniert nur über HTTP :3300, nicht file://). **Alte hub.html unberührt** — Sascha-Vergleich/Verdict steht aus. Falls Verdict „glass gut": hub.html ersetzen + hub_refresh.sh-Kette prüfen (die regeneriert das alte).
- **810k-Cline-Session `1789109742185_p3730`** („VERKAUFS HUB - 11 Agent monster", inputTokens 304 M, 8,3 MB messages, FAILED) = war ursprünglich ein **ATLAS-Xcode/Web-Abgleich** („xcode app passt fast, gleiche sie mit web app ab, apk android zum verteilen") — Titel kam aus späterem Kontext. Schadlos schließbar.
- **Verwandt:** [[appagentteam-flutter-skill-live]] (Pipeline), [[atlas-versionsstand]] (ATLAS-Volltestung), [[sascha-vollzug-keine-zwischenfragen]]
