---
name: ios-webdev-stack-2026
description: iOS-27-Web-App-Testing + KI-Recherche-Apps + Dev-IDE-Wahl + Open-WebUI-Agent (13.–15.09.2026)
metadata:
  type: project
---

Stand 15.09.2026 (Session iOS27/KI-Recherche):

1. **Web-App-Test auf iOS 27:** Safari am Mac + Web Inspector „Connect via Network" (gratis, kabellos) = Primärweg; iOS-Simulator + Playwright/WebKit-Emulation ergänzend; BrowserStack hat iOS 27 Beta seit 17.06.2026. Bericht: `~/Desktop/IOS27_WEBAPP_TEST_RESEARCH_2026-09-13.md`.
2. **KI-Recherche iPhone:** Gemini = beste Antworttendenz, Perplexity für Sascha TOT (Kern nicht promptbar, /-Skills weg, Browser-Steuerung iPhone entfernt — Desktop-Produkt „Perplexity Computer"). ChatGPT-Agent-Modus 08/2026 eingestellt → „ChatGPT Work". Bericht: `~/Desktop/KI_ANTWORTEN_UND_WEBDEV_SETUP_RECHERCHE_2026-09-14.md`.
3. **Dev-IDE:** Antigravity = Gesamtsieger (XDA 1-Monats-Test; Live-Vorschau + Goal-System); Cursor nur Riesen-Repos; Lovable nur Prototyping.
4. **Eigener Agent (14.09. gebaut):** Open WebUI auf dem Mac, Port 8080, Admin `sascha@lokal.admin` (PW in `~/.open-webui-setup/`), 1532 Modelle via OmniRoute (Key `~/.open-webui-setup/omni_key`), Websuche duckduckgo AN, `/recherche`-Befehl mit Quellen-Zwang. iPhone: `http://<mac-lan-ip>:8080`. HINWEIS: kein Autostart (nohup) — nach Mac-Neustart neu starten; Open-Session-Login = Login-Daten oben.
5. Subagent-Fix 15.09.: siehe [[subagent-dispatch-implementer-workaround]] (ZCode-Seite).
