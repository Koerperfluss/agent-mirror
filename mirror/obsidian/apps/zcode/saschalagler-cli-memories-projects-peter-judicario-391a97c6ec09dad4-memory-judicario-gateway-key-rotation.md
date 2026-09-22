---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/judicario-gateway-key-rotation.md"
stand: 2026-09-22
tags: [spiegel, zcode]
---

---
name: judicario-gateway-key-rotation
description: Judicario-Gateway-Key jud_gtSG0t… ist tot; aktiver Key jud_Cpu-…
  funktioniert auf allen 8 Modulen; Connectoren am 06.09.2026 gefixt
metadata:
  node_type: memory
  type: project
  originSessionId: sess_419a8806-4350-4c0c-92da-4032328e499c
---

Der alte Judicario-Gateway-Key `jud_gtSG0t_c8db2KMG6FGyqr4r1sMPyXED7` (Einrichtungs-Files vom 21.07.2026, openlaw-Distribution) ist **deaktiviert** (Gateway antwortet: "unknown or disabled key"). Der aktive Key lautet `jud_Cpu-nyGunSlYK7TM1Nz7_g9iJQvhsiLh` (gefunden in `Judicario_Sacha_Mac/tools/CHIPSI_SANDBOX_CONNECTOR.html`), verifiziert am 06.09.2026 auf allen 8 Modulen (at, de, ch, eu, ip, steuer, insurance, steuer-de → judicario-* v1.29.0).

Am 06.09.2026 gefixt: 30+ Konfig-Files im Projektordner (`Connectoren_URLs.txt`, `Judicario_in_Claude_Code_installieren.command`, `judicario/.mcp.json`, tools/, implementation/) umgestellt + alle 8 Claude-Code-Connectoren (user scope) neu registriert — 6/8 ✔ Connected. `insurance` + `steuer-de` verbinden, aber Tools-Liste serverseitig kaputt ("expected array, received undefined") → openlaw-Problem. Nur historische Research-MDs (Audit/_ARCHIV, LEGAL_OPS_MASTER_ARCHIV/konkurrenz) haben noch den alten Key als Doku-Referenz.

Bei erneuter Key-Rotation: Test mit MCP-Initialize-POST (`Accept: application/json, text/event-stream`) gegen `https://gateway.openlaw.cc/mcp/at/?k=KEY`. Siehe auch [[chipsi-openlaw-setup]].

**21.09.2026 (Thomas-Seite, offen):** Georges V1.9.12-System meldet weiterhin **401** auf den Gateway — dort ist noch der alte/tote Key eingetragen. George muss den aktiven Key `jud_Cpu-…` nachziehen; bis dahin ist das im V1.9.12 eingebaute Feature „Judicario-Abfragen" funktionslos (Widerspruch zum eingebauten Feature-Claim im Vergleich „über Saschas ursprünglichen Stand hinaus"). Blockiert-seitig verifiziert im EnvCheck-Resume-Run dwfrun-102156ed.
