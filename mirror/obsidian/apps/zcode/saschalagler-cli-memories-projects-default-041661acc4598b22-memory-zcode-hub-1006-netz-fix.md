---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/zcode-hub-1006-netz-fix.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: zcode-hub-1006-netz-fix
description: ZCode-Hub 1006-Verbindungsabbrüche 08.09. behoben — Ursache
  9,7-GB-Session-Rollout (archiviert), Wi-Fi DNS/IPv6 neu konfiguriert;
  OmniRoute 20128 als Fallback-Provider
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

„Hub connection closed (code=1006, reason=Connection ended)" im ZCode-Chat-Tab — Diagnose + Fix 08.09.2026 (Explorer-Diagnose, dann ausgeführt):

- **Root Cause war NICHT Z.AI** (api.z.ai/api/anthropic = 200 OK, 133 ms TLS) sondern die **Session-Rollout-Datei von sess_d4dc6589: 9,7 GB** (model-io jsonl) — I/O-Last brachte den lokalen Hub (zcode-host-local) zum Event-Loop-Stall → WS-Drop ohne Close-Handshake = exakt 1006. Symptom: ZCode-Renderer bei 27 % CPU. Lehrstück: **riesige Session-Rollouts killen den Hub — Session-Log-Größe checken (`find ~/.zcode -name "model-io-*.jsonl" -size +1G`), alte Monster-Sessions nie weiternutzen, neue Session starten.**
- Fix ausgeführt: Rollout-Datei nach `~/.zcode/cli/log/archive/` verschoben (Checksum in CHECKSUMS.txt, gzip lief detached).
- **Netz konfiguriert (08.09.):** Wi-Fi DNS hart auf `1.1.1.1 8.8.8.8` (z.ai-Auflösungschaos: Aliyun-CDN lief nur AAAA/v6), **IPv6 auf Wi-Fi OFF** (`networksetup -setv6off Wi-Fi`) — danach api.z.ai 200 OK. www.z.ai löst trotzdem nicht (Marketing-Host, irrelevant).
- **Sascha surft über iPhone-Personal-Hotspot** (CGNAT, 172.20.10.x) — CGNAT reißt lange SSE/WebSocket-Streams ab. Offener Nutzerschritt am iPhone: Einstellungen → Persönlicher Hotspot → **„Maximale Kompatibilität" AN** (zwingt IPv4-freundlichen Modus).
- **OmniRoute v16.3.1 läuft lokal auf Port 20128** (LaunchAgent) — als ZCode-Provider „OmniRoute Gateway" umgeht er Hotspot/CDN-Pfad-Probleme bei langen Streams; empfohlener Provider im Atlas-Tab.
- Nutzer-Ritual nach dem Fix: ZCode ⌘Q-Neustart → Atlas-Tab NEUE Session (nie die 9,7-GB-Session weiternutzen) → Provider OmniRoute → Vollautomatik-Prompt (siehe [[atlas-stand-2026-09-08]]). Beta-Netz-Hintergrund: [[macos-27-beta-status]].
