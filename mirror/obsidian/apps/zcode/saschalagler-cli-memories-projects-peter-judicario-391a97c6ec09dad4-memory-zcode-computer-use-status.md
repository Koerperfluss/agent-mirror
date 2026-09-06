---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/zcode-computer-use-status.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: zcode-computer-use-status
description: ZCode Computer Use „deaktiviert" — Plugin+TCC alle ok, echter Grund
  = Server braucht permission-broker-socket vom Host; Fix = volles App-Restart
  (06.09. angestoßen, offen)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_419a8806-4350-4c0c-92da-4032328e499c
---

Diagnose 06.09.2026: Nutzer konnte Computer Use in ZCode „nicht aktivieren". Befunde (alle verifiziert): Plugin `computer-use@zcode-plugins-official` war in `~/.zcode/cli/config.json` aktiviert, macOS-TCC vollständig erteilt (kTCCServiceAccessibility + kTCCServiceScreenCapture = 2 für `dev.zcode.app` UND `dev.zcode.cua-helper`), Helper-App `~/.zcode/computer-use/ZCode Computer Use.app` v3.11.2 passend zur App 3.11.2 (Helper-Update 04.09. 23:19).

**Echte Ursache:** Der CUA-MCP-Server (Plugin-Cache 0.5.14, Start via `/Applications/ZCode.app/.../ZCode Helper … __zcode-plugin-host …/dist/mcp/server.js`) beendet sich sofort ohne `--permission-broker-socket` („Plugin host failed: requires --permission-broker-socket"). Der laufende Host (zcode-host-local/CLI-Setup) hatte nach dem Helper-Update keinen Broker hochgezogen → Tools fehlen in der Session, obwohl UI/Config „aktiviert" zeigen.

**Fix:** ZCode komplett beenden (Cmd+Q, nicht nur Fenster) + neu starten → neue Session → mit einem CUA-Tool (`request_access`) testen. Per 06.09. abends offen. Fallback ohne Computer Use: browser-use-IAB + TCC-Dialoge manuell klicken lassen. Relevanter Zusammenhang: [[chipsi-openlaw-setup]] (Gmail-/TestFlight-Prüfung).
