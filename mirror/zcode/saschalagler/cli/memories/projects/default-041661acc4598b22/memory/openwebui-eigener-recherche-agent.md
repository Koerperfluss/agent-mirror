---
name: openwebui-eigener-recherche-agent
description: 14.09. (Nacht 13./14.) Open WebUI GEBAUT + LIVE auf Saschas Mac
  (Port 8080) — eigener Recherche-Agent mit Regel-Hoheit, /-Skills,
  DuckDuckGo-Websuche, 1532 Modelle via OmniRoute; GO-Items offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

**Open WebUI läuft seit Nacht 13./14.09.2026 auf Saschas Mac** (Bau ohne erneute Rückfrage nach seinem Frust über Perplexity/Comet — siehe [[feedback-einfache-antworten]], [[ios27-webapp-testing-recherche-2026-09-13]]).

**Zugang:**
- Mac: `http://localhost:8080` · iPhone (gleicher Hotspot/WLAN): `http://172.20.10.2:8080` — **IP wechselt je Netz** (172.20.10.x = iPhone-Hotspot-Subnetz am 13.09.)
- Login: `sascha@lokal.admin` · Passwort `Sascha-2026!` (1. Signup = Admin-Rolle; er darf/soll ändern)
- `/-Befehl "recherche"` = Websuche-Zwang + Quellen-Pflicht + „nicht gefunden statt erfinden" (ersetzt seine verlorenen Perplexity-/-Skills)

**Architektur/Fakten (alle live verifiziert nach Neustart):**
- Start: `nohup env DATA_DIR=~/.open-webui-data WEBUI_PORT=8080 uvx --python 3.11 open-webui@latest serve` (detached, überlebt Session-Ende; Log `~/.open-webui-setup/serve.log`)
- Daten/DB: **`~/.open-webui-data/webui.db`** (Config persistiert) · Secrets chmod-600 in **`~/.open-webui-setup/`** (omni_key, admin_token, keys_raw.json)
- Modelle: **1532 Stück** via OpenAI-kompatible Verbindung → OmniRoute `http://localhost:20128/v1` mit Gateway-Key (Endpoint `/openai/config/update`, Prefix „OmniRoute."); Default-Modell `OmniRoute.auto/best-chat`
- Websuche: an, Engine **duckduckgo** (ohne API-Key) — gesetzt via `POST /api/v1/retrieval/config/update` mit verschachteltem `rc["web"]["ENABLE_WEB_SEARCH"]=true, WEB_SEARCH_ENGINE="duckduckgo"`; Live-Test 3 echte Treffer
- **Kein „Browser übernehmen"** wie Comet-Desktop — Grenze ehrlich benannt

**API-Fallstricke (Version ~Sept-2026, 485 Routen):** `/openapi.json` = Routen-Wahrheit; Admin-Config-Endpunkte haben sich geändert (`/api/v1/admin/config` → 404/HTML; Verbindungen → `/openai/config/update` mit `OPENAI_API_CONFIGS` als **dict** `{"0": {...}}`; Websuche → `/api/v1/retrieval/config/update`; Prompts brauchen **`name`** statt `title`; Websuche-Test-Endpoint braucht `queries` (Liste) statt `query`; `/api/v1/models/base` ≠ `/api/v1/models`).

**Auf GO wartend (ihm angeboten):** ① LaunchAgent Autostart bei Mac-Neustart (vorsichtig — [[loki-autostarts-orphaned]]), ② feste Adresse via Tailscale (liegt schon in ~/.omniroute/tailscale), ③ mehr /-Befehle.

**⚠️ 14.09. WICHTIG: Open WebUI ist NICHT das, was er eigentlich wollte.** Er rastete („WAS LIEGT AM MAC! ICH WILL EINEN BROWSER DER FÜR MICH ARBEITET, MISTSAU") — sein Kernbedarf ist ein **Agentic-Browser/Arbeiter, der Web-Aufgaben selbst klickt/erledigt, vom iPhone aus**. Antwort des Sessions: vom iPhone geht Klick-Automatisierung technisch NICHT direkt (Apple-Sandbox: keine App steuert eine andere) → Empfehlung = **Manus iOS-App** (Cloud-Arbeiter, eigene Cloud-Browser-Session, async + Scheduled Tasks; App Store: „Manus – AI Agent & Automation", id6740909540; Reviews nocode.mba + taskade.com). Ob er Manus installiert/getestet hat: offen. **Stand 14.09. (Check):** Server noch live — HTTP 200, Uptime 12:46 h, PID 85229, ohne Zutun gelaufen. Rollen-Definition ihm gegenüber klar gemacht: **Manus = Arbeits-Browser (klickt/erledigt), Open WebUI = Kontroll-Zentrale für Quellen-Fragen** — beides parallel, kein Widerspruch. Kontext seiner Wut: Perplexity/Comet-Update (Sept 2026) sperrte Skills + Web-Automatisierung hinter den Desktop-Agenten „Perplexity Computer" und entfernte iPhone-Browser-Steuerung — sein 2-Jahres-Workflow ist tot, Support bestätigte ihm: Kern nicht änderbar, /-Skills weg. **14.09. Verifizierung:** noch immer live (HTTP 200, Uptime 12:46 h, PID 85229, ohne Zutun). Er fragte nach („was ist damit") → Antwort-Format bewährt: EINE Tabelle „Was es IST (Frage-Maschine mit Quellen-Zwang) / was es NICHT ist (Arbeits-Browser)" + dass beide parallel laufen (Manus = Arbeiter, Open WebUI = Kontroll-Zentrale). Er hat das Ding noch nicht selbst genutzt — keine Nutzungs-Bestätigung vorhanden.
