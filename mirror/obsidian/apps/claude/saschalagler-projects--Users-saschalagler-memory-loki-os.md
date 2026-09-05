---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/loki-os.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: loki-os
description: "LOKI.OS konsolidiert (11.07.2026) — kanonische Pfade, Boot-Kette, Unified Dashboard v15.3, was archiviert wurde"
metadata: 
  node_type: memory
  type: project
  originSessionId: da129797-e19b-4419-bc3d-f7e0f250ca4c
---

# LOKI.OS — Konsolidierter Stand (2026-07-11)

**Kanonisch:** `~/loki-ki/` — Kernel `LOKI_MASTER.py` v15.3.0 (:8010).
**Boot-Kette (die EINE):** `~/Library/LaunchAgents/com.loki.v15.plist` → `LOKI_AUTOSTART.sh` → `LOKI_MASTER_BOOT.sh` (v15.3.0, idempotent: killt gesunden Kernel nicht) → Ollama(:11434) + LiteRT(:9379) + Kernel + n8n(optional) + öffnet `macos-app-v17/LOKI_OS.app`.
**Frontend (das EINE):** `~/loki-ki/macos-app-v17/LOKI_OS.app` — WKWebView auf `:8010/dashboard/`, startet/stoppt Services selbst (ServiceManager). Baut OHNE Xcode via `build_app.sh` (CommandLineTools). Kein 100-€-Abo nötig (nur für App Store).
**Dashboard v15.3 (React, `dashboard-app/`):** 3 Spalten — Sidebar (Status-Ampeln, 7 Ansichten: Board/Projekte/Dev-Team/Tasks/Automation/Skills/System, Council 7+13 einklappbar) · Mitte Ansicht · rechts **Bedienkanal** (Auto-Routing-Dropdown → `/loki/auto_route`, Aktions-Karten, Task/Dev-Team Quick-Actions, Mic via Web Speech). View-Wechsel per `window.dispatchEvent('loki:navigate')`.
**Daten:** `~/agent-os/state/capabilities_map.json` = Wahrheit: 527 Skills, 20 Personas, 31 Projekte, 7 Agents (NICHT 749/563!).
**Kernel-Routen:** /loki/health /loki/services(neu: n8n+flow+workflows) /loki/todos(+add) /loki/capabilities /loki/agentos/run /loki/auto_route /loki/orchestrate /loki/voice-triage.
**Archiviert (nichts gelöscht):** `~/loki-ki/_archive/` — alte macos-app, legacy v8-Skripte, loki_boot.sh, com.loki.master.plist, Desktop-Zweitkopie (710 MB), loki_unified_shell (+tar; Quellcode für spätere iPhone/Tailscale-Version M4).

**Why:** Monatelang parallele Versionen/Boot-Skripte → eine Wahrheit hergestellt; User will ADHS-taugliches, visuell klares UI und hat den 7-Tab-Aufbau + Bedienkanal explizit freigegeben (nach 2 Iterationen).
**How to apply:** Änderungen NUR in `~/loki-ki` + `macos-app-v17`; nach Dashboard-Änderung `npm run build` (dist wird von :8010 serviert) + `./kernel.sh restart` bei Kernel-Änderungen. UI-Änderungen IMMER erst mit User abstimmen (er will Aufbau vorher durchgehen). Skills-Zahl aus capabilities_map lesen, nie hartkodieren.

**Offen:** Voice real (whisper.cpp installieren, stt_handler.py), Gemini-Cloud-Test (Billing lt. User erledigt), Jules im Dashboard sichtbar machen, Obsidian/Heptabase-Pfade in Boot-Skript stimmen nicht (`~/Desktop/wissen` fehlt).
Verwandt: [[agent-os]]
