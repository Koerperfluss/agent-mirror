---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/chrome-agent-browser-fix.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

---
name: chrome-agent-browser-fix
description: Chrome-136-Regel — Remote-Debugging-Port ignoriert im
  Standard-Profil; ZCode/Cline brauchen dedizierten Agent-Browser mit eigenem
  user-data-dir
metadata:
  node_type: memory
  type: project
  originSessionId: sess_5ee29b3e-cfe1-414a-8c01-02ec99f260a6
---

Stand 18.09.2026: Saschas „Chrome unbrauchbar"-Problem (Cache nicht löschbar, Versionen rendern/laden nicht, ZCode/Cline finden Browser nicht) liegt NICHT an chrome://flags. Ursache: Seit Chrome 136 ignoriert Chrome `--remote-debugging-port` im Standard-User-Data-Dir — Debugging braucht zwingend ein eigenes `--user-data-dir` (offizielle Chrome-Sicherheitsänderung, developer.chrome.com/blog/remote-debugging-port).

**Lösung:** Dedizierter Agent-Browser: `open -na "Google Chrome" --args --remote-debugging-port=9222 --user-data-dir="$HOME/.zcode/chrome-agent-profile" --no-first-run` → ZCode chrome-devtools-MCP + Cline verbinden auf `http://127.0.0.1:9222`. Cache-Probleme: Chrome komplett beenden, dann Caches löschen (laufende Instanz lockt Profil); DevTools „Disable Cache" im Network-Tab.

**Wichtigste Flags (Chrome 153):** `#devtools-protocol-monitor` → Enabled (zeigt CDP-Traffic), `#use-persistent-cache-for-code-cache` → Disabled bei Render-/Load-Problemen; alle anderen Flags auf Default lassen. Port 9222 nur auf 127.0.0.1 binden (LAN-RCE-Risiko). Plan war vorgelegt, noch nicht ausgeführt.
