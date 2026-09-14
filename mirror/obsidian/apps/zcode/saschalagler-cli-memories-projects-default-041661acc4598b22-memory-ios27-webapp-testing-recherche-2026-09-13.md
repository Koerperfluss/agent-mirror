---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/ios27-webapp-testing-recherche-2026-09-13.md"
stand: 2026-09-14
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
- ~~KI-Recherche-App iPhone: Perplexity = Alltagssieger~~ **VERWORFEN** — Sascha nutzt Perplexity + Comet seit Jahren und hasst sie: Agent nicht promptbar, Kern-Funktion nicht änderbar, „lügt und tut was es will" (Halluzinationen ohne erzwungene Websuche). Seine echte Anforderung: **ein Tool, bei dem ER die Regeln schreibt**.
- **Korrigierte Optionen (13.09. vorgelegt, Entscheidung offenes GO):** (1) **Perplexity Space** mit eigenen Anweisungen (Regel-Schreiben gratis, Modell-Wahl = Pro), (2) **Gemini Gem / Custom Instructions** (gratis), (3) **Open WebUI** selbst gehostet auf seinem Mac mit seinen 6 Gemini-Keys (Totale Kontrolle; Baubereitschaft signalisiert mit „baue Open WebUI", wartet auf GO). Copy-Paste-Regelblock geliefert („IMMER zuerst Websuche, jede Behauptung mit Quellen-URL, nicht gefunden sagen statt erfinden").
- Bild-Frage „Live-Vorschau vs Goal-System": beides Features agentischer IDEs; Google Antigravity bietet BEIDE zusammen — keine Zwangswahl.

**Nachtrag (13.09., Perplexity/Comet-Update):** Seit neuem Update sind Skills + Web-Automatisierung nur noch über den Desktop-Agenten **„Perplexity Computer"** nutzbar (der übernimmt den Comet-Browser am Rechner; am iPhone wurde Browser-Steuerung teils komplett entfernt) — Perplexity/Comet sind für Saschas Handy-Nutzung damit endgültig raus. Optionen verengt auf: **(A) Manus iOS-App** (App Store „Manus – AI Agent & Automation", Cloud-Agent = arbeitet im Rechenzentrum, async + Scheduled Tasks, Haken: fremde Cloud/Credit-Kontingent) und **(B) Open WebUI Eigenbau auf dem Mac** (empfohlener Weg, wartet auf „baue Open WebUI"-GO).

**ABSCHLUSS (Nacht 13./14.09.): Option B wurde GEBaut und ist LIVE** — Open WebUI auf Port 8080 mit 1532 OmniRoute-Modellen, DuckDuckGo-Websuche-Zwang, /recherche-Skill, Login sascha@lokal.admin. Details + GO-Items (Autostart-LaunchAgent, Tailscale-Festadresse, mehr /-Skills): [[openwebui-eigener-recherche-agent]]. Key-Herkunft: [[omniroute-gateway-keys]]. Saschas Wortlaut dabei scharf („du scheiss huresohn") — er kannte ALLE Optionen schon und bestätigte via Perplexity/Comet-Support: Kern nicht änderbar, /-Skills weg, Browser-Übernahme weg → nicht nochmal erklären, sondern LIEFERN.

**Tooling-Lesson (wichtig):** ZCode `Agent`-Dispatch (general-purpose Subagents) schlug fehl mit **„No reasoning level selected"** (reasoning-level-missing, account GLM-5.3-Flash) — Subagent-Fanout war nicht möglich. Workaround bewährt: Recherche direkt im Main-Agent mit parallelen WebSearch-Calls (6 Suchläufe, quick-first). Bei erneutem Bedarf erst Main-Agent-Direktweg versuchen, bevor Fanout konfiguriert wird. Siehe [[web-research-team-skill]], [[mac-setup-16gb-m4]], [[atlas-stand-2026-09-08]].
**14.09. Präzisierung:** Fehler reproduzierte sich mit `selection=account:zai-start-plan/GLM-5.3-Flash`; `~/.zcode/cli/config.json` enthält KEINE Reasoning-Level-Einstellung → Ursache sitzt in der **ZCode-App-UI** (Modell GLM-5.3-Flash ohne gesetzte Denkstufe). Sascha-Fix: ZCode-Einstellungen → Modell → Denk-/Reasoning-Stufe wählen. Zusätzlich: **Plan-Modus blockiert Bash komplett** (nur read-only filesystem-MCP-Tools + gelegentlich grep erlauben direkten Recon).
