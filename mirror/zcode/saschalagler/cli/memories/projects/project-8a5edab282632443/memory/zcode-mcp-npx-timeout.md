---
name: zcode-mcp-npx-timeout
description: ZCode-MCP "Failed to connect" bei npx-@latest-Commands — Fix ist
  npm-i-g + statischer Binary-Pfad in ~/.zcode/cli/config.json; Config-Edits
  greifen erst nach App-Neustart
metadata:
  node_type: memory
  type: project
  originSessionId: sess_16f82fae-2f37-43eb-af25-e2e10796996e
---

30.08.2026: Drei ZCode-MCPs („Failed to connect to the MCP server") in `~/.zcode/cli/config.json` (mcp.servers): **loki-voice** (Binary `/opt/homebrew/bin/loki-voice` existierte nicht → Eintrag entfernt), **desktop-commander** und **firebase** (beide `npx -y …@latest` — lädt bei JEDEM App-Start frisch aus dem Netz → ZCode-Start-Timeout). Fix: `npm i -g @wonderwhy-er/desktop-commander firebase-tools`, dann command auf `/opt/homebrew/bin/desktop-commander` (args []) bzw. `/opt/homebrew/bin/firebase` (args `["mcp"]`) — Start nun <1 s. Backup-Pattern: `config.json.backup_<TS>`.

**Why:** Sascha sieht „klappt absolut nicht" und awarded Wut — die Ursache ist fast immer Infrastruktur (toter Pfad, npx-Download-Timeout), nicht das Modell-Routing; das muss weggeräumt sein, bevor OmniRoute-Verkabelung ([[omniroute-verkabelung]]) fair beurteilt werden kann.

**How to apply:** 1) MCP tot → command prüfen: existiert Binary? `npx -y …@latest` = sofort verdächtig → global installieren + statischen Pfad eintragen. 2) ZCode-App hält Config im Speicher und schreibt sie zurück (machte Löschungen um 06:32 NICHT rückgängig, kann aber Provider-Toggles ändern) — Config-Edits greifen erst nach App-Neustart (Cmd+Q). 3) User-Toggles im Model-Settings-Panel können Z.ai-Direkt aktivieren und OmniRoute umgehen — nach Panel-Besuch des Users OmniRoute-Enable-Status verifizieren.

05.09.: **chrome-devtools-MCP "The browser is already running" Lock** — nach Browser-Chaos startet new_page/list_pages nicht mehr (stale Profile-Lock in `~/.cache/chrome-devtools-mcp/chrome-profile`). Fix: `pkill -f "chrome-devtools-mcp"` → 2 s warten → new_page funktioniert wieder. Diagnose-Regel: alle MCP-Chrome-Calls schlagen fehl, während curl die Ziel-URL als 200 OK zeigt → Infra-Problem (Lock), nicht Ziel-Problem.
