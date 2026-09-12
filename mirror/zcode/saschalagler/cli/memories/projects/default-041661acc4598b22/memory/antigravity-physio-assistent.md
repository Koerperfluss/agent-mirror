---
name: antigravity-physio-assistent
description: Antigravity-IDE „3d Körperfluss / Physio Assistant Workflow" —
  12.09. Crash-Diagnose (cloud-cli-execution MCP = Forbidden durch nächtlichen
  DNS-Ausfall), Kontext Physio-Gem Adelina/Simon
metadata:
  node_type: memory
  type: project
  originSessionId: sess_f82a1756-a7b8-4b62-a4f2-2773f3c818b2
---

Sascha nutzt die **Google Antigravity IDE** (Config unter `~/Library/Application Support/Antigravity/`) für den Workflow „3d Körperfluss / Physio Assistant" — ein Gemini-Gem „Physio - Assistent" zur Reha-Planung (Patientin **Adelina Sollböck** + **Simon**: Nacken/HWS > Hüfte/ISG > Fuß/Plantarfaszie; 5-stufiger Evaluierungsplan, 4-Spalten-Übungstabellen, A4-Handouts, M4-BLUF-Stil).

**12.09. Crash-Diagnose (gelöst):** „Agent execution terminated due to error" jede Runde — Root Cause: MCP-Server `cloud-cli-execution` (Homebrew Cask `gcloud-cli` 583.0.0, Konto koerperfluss@gmail.com) bekam `tools/list: Forbidden`, weil **um 03:41 DNS `oauth2.googleapis.com` nicht auflösbar** (gleiche DNS/Hotspot-Problematik wie [[zcode-hub-1006-netz-fix]]) → kein OAuth-Token → 403. Netz + `gcloud auth print-access-token` (Token-Refresh) live wieder OK → Fix = Agent-Fenster neu öffnen bzw. Retry; falls wieder Forbidden: MCP-Panel → Reconnect/Re-Auth.

Antigravity MCP-Server stecken NICHT in sichtbaren JSON-Configs auf Disk (nur protobuf state.vscdb) — Diagnose läuft über gcloud-Logs in `~/.config/gcloud/logs/`.

Verwandt: [[active-projects-focus]] (Körperfluss), [[google-cloud-genai-credit]] (gleicher Google-Account).
