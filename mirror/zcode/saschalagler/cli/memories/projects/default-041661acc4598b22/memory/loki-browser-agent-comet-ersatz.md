---
name: loki-browser-agent-comet-ersatz
description: 14.09. Plan für Saschas Eigenbau-Comet-Ersatz „Loki-Browser-Agent"
  (Playwright-Klick-Motor + OmniRoute-Agent + iPhone-Web-Panel) — alle
  Fertigprodukte von ihm ABGELEHNT, Plan in Plan-Modus vorgelegt, wartet auf
  Freigabe
metadata:
  node_type: memory
  type: project
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

14.09.2026 (Nacht): Sascha hat ALLE 4 Fertig-Kandidaten per AskUserQuestion abgelehnt („keines."): 1 Manus iOS-App, 2 ChatGPT Work, 3 Comet/Dia am Mac, 4 nur der laufende Open-WebUI-Agent. Auf die Frage, was das Ding tun soll: **„alles davon wie comet .. mit skills settings auto tools"** = vollwertiger Comet-Ersatz: Web durchklicken + Recherche/Berichte + wiederkehrende Automatik + eigene Skills + Settings + Auto-Tools.

**Warum Eigenbau:** Comet selbst ist seit dem Sept-2026-Update hinter Desktop-„Perplexity Computer" gesperrt und am iPhone entkernt (Support bestätigte ihm: Kern nicht änderbar, /-Skills weg, Browser-Übernahme weg). Kein Fertigprodukt deckt sein Anforderungsprofil ab.

**Vorgelegter Plan (ExitPlanMode, Freigabe AUSSTEHEND — Call wurde von Plan-Modus abgelehnt, erneut einreichen wenn er zustimmt):** „Loki-Browser-Agent" unter `~/loki-browser-agent/`
- Baustein 1: **Klick-Motor** = Chromium via Playwright auf dem Mac (headful, Logins 1× manuell, Cookies persistieren)
- Baustein 2: **Agent-Gehirn** = OmniRoute-Modelle (Gateway localhost:20128, Key siehe [[omniroute-gateway-keys]]) führen Aufgaben schrittweise aus (navigieren/klicken/lesen/screenshot/berichten)
- Baustein 3: **Web-Panel** vom iPhone im Safari: Aufgabe starten, Live-Schritt-Log + Screenshots, Ergebnis-Berichte, Skills-Verwaltung (Presets), zeitgesteuerte Auto-Tasks, Settings
- Stufen S1–S5 (Skelett→Agent-Schleife→Panel→Skills/Automatik→**Prüfinstanz** reviewer+ui-ux-tester mit Vetorecht), ~2 h gesamt, Flash-first

**Grenzen ehrlich kommuniziert:** Mac muss an; iPhone = Fernbedienung im Safari; harte Anti-Bot-Seiten bremsen jeden Bot aus. Nach Abnahme: Autostart-LaunchAgent + Tailscale-Festadresse auf GO.

**Lesson:** AskUserQuestion mit konkret antippbaren Optionen hat seinen Wut-/Verständnis-Loop durchbrochen (erst „keines.", dann präzise Anforderung) — bei verwirrten/wütenden Nutzern Anforderungen per Antipp-Frage erheben statt Prosa.
