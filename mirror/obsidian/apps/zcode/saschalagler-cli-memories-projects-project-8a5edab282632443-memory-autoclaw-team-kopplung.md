---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/autoclaw-team-kopplung.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

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
