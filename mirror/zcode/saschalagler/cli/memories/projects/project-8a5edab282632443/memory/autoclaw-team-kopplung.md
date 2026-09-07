---
name: autoclaw-team-kopplung
description: AutoClaw = native Mac-App (lokal!), Team-Kopplung ZCode↔AutoClaw
  gebaut+live bewiesen — Datei-Kanal Workspace + Chat-Kanal via computer-use
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**AUTOCLAW-TEAM-KOPPLUNG LIVE (06.09.):** AutoClaw ist eine **native Mac-App** (`com.zhipuai.autoclaw`, sichtbar via computer-use `list_apps`) — der Agent läuft **LOKAL** (UI: „Agent runs locally"), NICHT Cloud-only (frühere Cloud-Annahme war falsch). Workspace: `~/.openclaw-autoclaw/agents/full-stack-builder/workspace/`. AutoClaw hat **loki-dev als Skill geladen** („Loaded 1 skills") und erkannte aus Saschas Satz „übernimm…" selbst den TAKEOVER-Modus.

**Gebaute Kopplung (bewiesen):**
1. **Datei-Kanal:** `ZCODE_HANDOFF.md` direkt in AutoClaws Workspace geschrieben — Inhalt: verifizierter ATLAS-Stand (43/47 Tickets, KI live, Mimosa 0 Findings) + konkreter Job (T-A2 Onboarding 8→20 nach `~/ATLAS_MASTER/app/docs/UI_USERFLOW_SPEC.md`) + 4 Stopp-Regeln (kein Deploy/Push/Löschen) + D8-Gesetz (keine Vorannahmen) + Claim-Regel.
2. **Chat-Kanal:** computer-use → `get_app_state(bundle_id: com.zhipuai.autoclaw)` → `type` in Textarea „Type @ to use a skill" → Send-Button AXPress (Checkbox „Agent Cluster" muss =1 sein). Beweis: AutoClaw „Planning the Agent Cluster task and preparing workers" (17:18, Punkte-Verbrauch 8398→8390 sichtbar).

**Steuerung für spätere Sessions:** AutoClaw-Agents = Full Stack Builder / Design Expert / AutoCoder / Mac Operator. Fortschritt = Button „Agent Cluster Progress". Rückweg: AutoClaw committet laut Handoff lokal in `~/ATLAS_MASTER/app` (git) oder legt Artefakte im Workspace ab → ZCode reviewt den Diff. Erster Cluster-Durchlauf (Dienste-Tabelle via launchctl/ps aux) war schon vor der Kopplung fertig.

**Lektion:** Wenn Bash `spawn /bin/zsh ENOENT` stirbt → Off-Peak-Ticket abgelaufen ([[zcode-offpeak-ticket-ausfall]]) — computer-use + Write + Read + WebSearch laufen weiter, damit weiterarbeiten. Siehe auch [[omniroute-verkabelung]] (Team-Regeln) und [[atlas-master-app-verhaeltnis]].

## Erster echter Cluster-Lauf (06.09. Nachmittag) — Befunde

**Ablauf bewiesen:** AutoClaw (Full Stack Builder) übernahm den Handoff autonom: ZCODE_HANDOFF.md gelesen → UI_USERFLOW_SPEC.md gefunden → OnboardingHost.tsx (938 Zeilen) analysiert → wollte T-A2 claimen. Der loki-dev-TAKEOVER-Modus-Check lief von selbst.

**⚠️ ALT-KOPIE-FALLE (kritisch):** AutoClaw behauptete „~/ATLAS_MASTER existiert nicht auf dieser Platte", machte mdfind und erklärte `~/Desktop/Coworkspace_Ich/atlas + pliability /ATLAS_MASTER` (git 9b9aa82 = alter Stand!) zum kanonischen Pfad — hätte dort committet. Ursache unklar (Sandbox-Home-Sicht ODER mdfind-Fund der Alt-Kopie). **Korrektur per Chat-Nachricht** (kanonisch = /Users/saschalagler/ATLAS_MASTER/app, git 7fa7bf3+, Live atlas-v5.web.app; Flowchart liegt in `…/atlas + pliability /Atlas Cali Plan/lauri/`) wurde angenommen — er suchte danach selbstständig den Flowchart im lauri-Ordner (eigener File-Dialog!).

**Quota-Abbruch:** Cluster-Lauf endete mit „We're experiencing high demand… upgrade to monthly subscription" (Z.AI-Serverlast, kein Defekt) + Deliverable „ATLAS_MASTER_FLOWCHART.html file not found" (alter falscher Pfad). Punkte-Stand 06.09.: 8.270 + **5.000 verfallen in 3 Tagen** (Inspiration Hub zeigt das).

**Steuerungs-Gefahr:** Während der Agent arbeitet, öffnet ER SELBST macOS-File-Dialoge (z. B. beim Flowchart-Suchen) — mein Escape/Klick traf dann SEINEN Dialog, nicht meinen. **Regel: während Cluster-Lauf nicht ins Fenster funken**; nur beobachten (get_app_state), danach reviewen („autoclaw fertig" von Sascha = Signal für Diff-Review in ~/ATLAS_MASTER/app). type→Send kann `target_verification_status: mismatched` liefern wenn ein Dialog Fokus kapert — erst get_app_state, Dialog via Escape schließen, neu beobachten.

## Live-Koordinations-Loop etabliert (06.09. Abend)

Sascha befahl: ZCode = KOORDINATOR, kein Übersetzen durch ihn ([[zcode-koordinator-live-austausch]]). Darauf live ausgeführt:
- AutoClaw hatte selbst einen NEUEN Chat vorbereitet: ~30 ATLAS-Docs als Anhänge (Batch 18:59: STATUS.md, DESIGN_EVOLUTION.md, UI_UX_PLAN.md, UI_AUDIT_BERICHT.md, alle PDFs …) — **aber aus der ARCHIV-Kopie** (Coworkspace-Quelle, .openclaw-attachments). Chat-Feld leer, Agent Cluster noch AUS (=0).
- Ich schaltete Agent Cluster selbst an, tippte den KOORDINATIONS-AUFTRAG (T-A2 Onboarding 8→20, NUR /Users/saschalagler/ATLAS_MASTER/app, D8, tsc+git-Commit+STATUS-Zeile als DONE-WHEN, Rückfragen als Kommentar in ZCODE_HANDOFF.md) und sendete (19:18; Session aktualisierte sich 19:09→19:23).
- ** Neue Mechanics:** (a) `state_id superseded`-Fehler, wenn AutoClaws UI sich zwischen type und Send ändert → neu get_app_state, Aktion wiederholen, nie blind retry; (b) Ein-Driver-Regel: ein fremdes „S" im Feld zeigte Doppel-Tippen (Sascha ODER ich) — wenn Sascha selbst tippen will, sagt er „STOPP", sonst steuert ZCode; (c) AutoClaw-Deliverables mit „file not found" = tote Archiv-Pfade aus alten Handoffs, korrigierbar per Chat-Nachricht mit Absolut-Pfad.

## T-A2 GELIEFERT + MERGE-SAGA (06.09. Nacht) — AutoClaw als Builder bewiesen
**AutoClaw lieferte T-A2 vollständig:** Onboarding 8→20 Stufen (21 Screens, D8-Pflicht-Gates, level optional ohne Default, Schmerz-Scan-Anker 0, Stufe 14 Gewichtskalibrierung → calibratedWeightKg gewinnt im Coach-Prompt), tsc -b + vite build grün, Commits 672e47c (feat) + f69ef60 (docs), Claim-Notiz in ZCODE_HANDOFF.md, STATUS/SPEC_CONFORMANCE aktualisiert. Selbst-Diagnose-Qualität hoch („Beweis, kein Raten"-Tabellen).

**Störungen im Lauf:** wiederholte Quota-Abbrüche „We're experiencing high demand" + einmal **„Agent Cluster mode does not support the current model"** (bei GLM-5.3-Flash-Auswahl + Cluster-Checkbox → Cluster-Modus braucht anderes Modell; modus=Auto/Chat oder Modell wechseln). Nach „SOFORT JETZT"-Aufforderung führte er die Kopie-Aktion aus.

**Pfad-Blindheit-Finale:** AutoClaw bestritt weiterhin ~/ATLAS_MASTER (mdfind+find „bewiesen", sah nur die Coworkspace-Kopie git 9b9aa82) — vermutlich Sandbox-Home-Sicht des Agenten. Nach Saschas „DOCH ICH HAB ES VERSCHOBEN" legte AutoClaw ~/ATLAS_MASTER/app als **APFS-Clone (333 MB, nicht-destruktiv)** mit SEINEN T-A2-Dateien an; meine ZCode-Commits blieben als .git-Historie erhalten, und mein nächstes `git add -A` nahm seine Dateien mit → **beide Wellen = EIN Stand ohne Konflikt** (Verifikation: git log meine Kette + grep 39 step-Blöcke/21 coachText-cases + cotChain.ts vorhanden + tsc 0 + git status leer).

**How to apply nach jeder AutoClaw-Bau-Runde:** (1) BEIDE Repos checken (git log + Feature-Marker-grep), bevor irgendwas als verloren/überschrieben gilt; (2) fremde Commits ggf. per cherry-pick/Datei-Kopie+git add -A integrieren; (3) AutoClaw-Quota-Abbruch ≠ Task tot — Reststück selbst übernehmen (P4.5 wurde so von ZCode zu Ende gebaut); (4) Cluster-Fehlermeldung „does not support the current model" = Modell-Dropdown von Auto-Fast/GLM-5.3-Flash weg von cluster-fähigem Modell drehen.

## AutoClaw „Design Expert" PARALLEL IM REPO ENTDECKT (07.09. 16:10) — Deploy-Halt-Protokoll
**Sascha ließ den AutoClaw-Design-Expert-Agent GLEICHZEITIG in ~/ATLAS_MASTER/app arbeiten** (Screenshot: Agent Cluster aktiv, „Hintergrund v2 ist im CSS. Jetzt Build-Verifikation + Native-Sync"). Das erklärte die unerklärlichen Änderungen: amber-Logo-Ableitung (BullLogo → /brand/barbulls-amber-*.png statt SVG, weißer Kreis = „Brand-Bruch auf dunkler UI"), barbulls-official.svg aus public/brand/ GELÖSCHT (von mir restauriert), Commit „fix(judge-gate)", QA-Report-Arithmetik-Korrekturen. **Erkennungsmuster für fremde Agenten: Datei-mtimes + git log mit unbekannten Commit-Messages + plötzlich andere Implementierungen als die eigenen.**
**Protokoll (Sascha: „warte bis autoclaw fertig ist ODER verbinde dich mit dem agent"):** (1) ZCODE_HANDOFF.md im Repo = Arbeitsteilung (AutoClaw: ganzheitliches Logo-Konzept/Palette/Backdrop; ZCode: nur funktionale Web-Fixes + Deploy NACH Signal), (2) Fertig-Signal = `AUTOCLOW-DONE:` ans Ende der Handoff-Datei, (3) **kein Build/Deploy/Design-Edits von ZCode solange AutoClaw läuft** — halbe Design-Stände nicht deployen. Saschas Kernaufwurf dabei: „es geht primär darum das kein app konzept ganzheitlich erstellt wurde obwohl 10x geprüft — das logo ist der anhaltspunkt mit dem alles erstellt wird, design palette und und" + „BITTE KÜMMERE DICH EINFACH MAL UM DIE WEB APP, DER REST IST VÖLLIG EGAL — wieso immer alles auf einmal?" = FOKUS-Pflicht: ein Ziel (Web-App), keine neuen Arbeitsstränge.

## ERSTER VOLLZYKLUS BEWIESEN (07.09. Abend): Handoff → Redesign → AUTOCLOW-DONE → ZCode-Deploy
Der Protokoll-Zyklus lief komplett durch: ZCODE_HANDOFF.md (Arbeitsteilung + Deploy-Halt) → AutoClaw Design Expert baute das Logo-abgeleitete Gesamt-Redesign autonom im Repo (Commits dbc4d9d Backdrop-aus-Logo-Palette, e57fb10 FUI-Holographic-Glass Amber-Monochrome mit allen 296 text-dim/139 border-line warm, f58430b **3D-Minotaurus-Medaillon = echtes 3D-Modell via SVGLoader+ExtrudeGeometry aus den 184 offiziellen SVG-Pfaden**, 95d65c6 `AUTOCLOW-DONE`) → Sascha relayte AutoClaws Deploy-Frage an ZCode → ZCode: tsc 0 → build → `firebase deploy --only hosting` → Parität `index-PJnNF4rC.js` ✓ + app/proxy 200 + Track 28 app_opens. **Rollenteilung hielt: AutoClaw = Design, ZCode = funktionale Fixes + Deploy.** AutoClaws Deploy-Frage („Willst du, dass ICH deploye?") = Nein — Deploy bleibt ZCode-Rolle laut Handoff. Kommunikationsweg war Saschas Paste (Relay) — akzeptabel, aber sauberer: AutoClaw schreibt Signal direkt in ZCODE_HANDOFF.md.
