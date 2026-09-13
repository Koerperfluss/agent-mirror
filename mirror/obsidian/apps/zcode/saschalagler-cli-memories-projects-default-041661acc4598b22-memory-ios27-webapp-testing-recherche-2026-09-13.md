---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/ios27-webapp-testing-recherche-2026-09-13.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

---
name: ios27-webapp-testing-recherche-2026-09-13
description: 13.09. Research „Web-App-Testing auf iOS 27 iPhone + beste
  KI-Recherche-App iOS" — Empfehlungen, Report-Pfad, und ZCode-Subagent-Blocker
  („No reasoning level selected")
metadata:
  node_type: memory
  type: project
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

13.09.2026 Recherche fertig (Report: **`~/Desktop/IOS27_WEBAPP_TEST_RESEARCH_2026-09-13.md`**, 12 belegte Fakten, Confidence 85/100; Runlog-Eintrag in `~/.agents/memory/research-runlog.jsonl` verifiziert).

**Kern-Empfehlungen:**
- Web-App-Testing iOS 27: Primärweg = Safari am Mac + Web Inspector + „Connect via Network" (iPhone: Settings → Safari → Advanced → Web Inspector ON, 1× Kabel, danach kabellos). Dev-Loop = iOS-Simulator (Xcode installiert). Automatisiert = Playwright/WebKit mit iPhone-Device-Emulation (echtes branded Safari fährt Playwright NICHT). Echte iOS-27-Fremdgeräte nur Cloud: BrowserStack hat iOS 27 Beta seit 17.06.2026.
- Safari 27 (WWDC26) WebKit-Neuerungen zum Testen: Grid Lanes, Customizable Select, HTML Model, Immersive Environments, Web Extensions.
- KI-Recherche-App iPhone: **Perplexity** = Alltagssieger (Quellen-Zitate), **Gemini** = Deep-Research-Sieger (PCMag-Test), ChatGPT nur Allrounder. **Comet** (Perplexity-KI-Browser) seit 18.03.2026 gratis auf iOS.
- Bild-Frage „Live-Vorschau vs Goal-System": beides Features agentischer IDEs; Google Antigravity bietet BEIDE zusammen — keine Zwangswahl.

**Tooling-Lesson (wichtig):** ZCode `Agent`-Dispatch (general-purpose Subagents) schlug fehl mit **„No reasoning level selected"** (reasoning-level-missing, account GLM-5.3-Flash) — Subagent-Fanout war nicht möglich. Workaround bewährt: Recherche direkt im Main-Agent mit parallelen WebSearch-Calls (6 Suchläufe, quick-first). Bei erneutem Bedarf erst Main-Agent-Direktweg versuchen, bevor Fanout konfiguriert wird. Siehe [[web-research-team-skill]], [[mac-setup-16gb-m4]], [[atlas-stand-2026-09-08]].
