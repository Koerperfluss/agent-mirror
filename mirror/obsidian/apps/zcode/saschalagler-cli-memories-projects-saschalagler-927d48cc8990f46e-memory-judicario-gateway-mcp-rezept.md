---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/judicario-gateway-mcp-rezept.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

---
name: judicario-gateway-mcp-rezept
description: Judicario/OpenLaw-Gateway DIREKT ansprechen (Rezept 01.10.2026) —
  altes Tool legal_research existiert nicht mehr; echter Weg =
  Streamable-HTTP-MCP-Handshake + at_search; fertiger Client
  judicario_mcp_client.py
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_7851785d-5e3f-41ed-be76-b2ce090c9af5
---

# Judicario-Gateway: so geht es WIRKLICH (bewiesen 01.10.2026)

**Ursache der Dauer-Störung („Unbekanntes Tool" überall, auch im loki-legal-ops-MCP):** Das Gateway kennt das alte Tool `legal_research` (aus judicario_connector.py) nicht mehr.

**Der funktionierende Weg — Streamable-HTTP-MCP-Handshake:**
1. POST `https://gateway.openlaw.cc/mcp/{module}/?k={KEY}` mit JSON-RPC `initialize` (protocolVersion 2025-03-26) → Antwort-Header **`Mcp-Session-Id`** mitnehmen
2. `notifications/initialized` mit Session-Header
3. `tools/call` mit Tool **`{module}_search`** (z. B. `at_search`), Args: `query`, `corpus`, `limit`, `gericht`, `year_from/to`

**Stolperfallen (alle live getroffen):**
- Ohne `Accept: application/json, text/event-stream` → **HTTP 406**
- Ohne `Mcp-Session-Id` → **HTTP 400 "Missing session ID"**
- Wiederverwendte JSON-RPC-Request-ID mit anderer Payload → Fehler „Dieselbe Request-ID wurde bereits … verwendet" → **IDs hochzählen**
- Antworten kommen als **SSE** (`event: message` / `data:`-Zeilen) → data-Zeilen joinen, dann JSON parsen

**Key:** rotiert 06.09.2026 → `jud_Cpu-…` (steht in `Judicario_in_Claude_Code_installieren.command` im konkurrenz-Ordner); der alte `jud_gtSG0t…` in judicario_connector.py ist veraltet. Key via `JUDICARIO_API_KEY`-Env übersteuern.

**Korpora (Modul at):** `at_norms` (Gesetze!), `at_rs` (Rechtssätze), `at_vwgh`, `at_lvwg`, `at_bvwg`, `at_vfgh`, `at_bfg`, `at_te`, `at_wk`, `at_kommentar`, `at_lehrbuch`. Module: at de ch eu ip steuer insurance steuer-de. Live bewiesen: `at|kfg|44` Volltext inkl. Abs. 3+4.

**Wichtig bei leeren Ergebnissen:** Gateway warnt selbst — aus 0 Treffern KEINE thematische Aussage ableiten.

**Fertiger Client (Dauerlösung):** `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/legal-ops-advisor/judicario_mcp_client.py` — Nutzung: `python3 judicario_mcp_client.py "Suchbegriffe" --corpus at_norms`. Mimosa-geprüft: SSRF-Schutz nötig (nur https, Host-Pinning gateway.openlaw.cc, aufgelöste IPs gegen privat/loopback/link-local prüfen, Redirects verboten) — ohne diese Checks blockt Mimosa den Write.

Verwandt: [[legal-ops-cockpit-reparatur]]
