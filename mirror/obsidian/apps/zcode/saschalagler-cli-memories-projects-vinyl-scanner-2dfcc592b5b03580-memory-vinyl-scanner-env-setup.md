---
app: zcode
quelle: "saschalagler/cli/memories/projects/vinyl-scanner-2dfcc592b5b03580/memory/vinyl-scanner-env-setup.md"
stand: 2026-09-11
tags: [spiegel, zcode]
---

---
name: vinyl-scanner-env-setup
description: Nicht offensichtliche Setup-Fakten des VinylScanner-Backends
  (requirements.txt inkonsistent, DB-Name, Gemini-Modellname)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_c2882922-5684-45c6-843f-3d2658bc6069
---

Setup-Fakten VinylScanner-Backend (Stand 12.09.2026):
- `requirements.txt` ist nicht selbst-konsistent: `emergentintegrations==0.2.0` kollidiert mit dem gepinnten litellm-Wheel. Installiertes Kern-Set: fastapi, uvicorn, motor, httpx, beautifulsoup4, python-dotenv, pydantic, pytest + pytest-xdist, dann `emergentintegrations==0.2.0` (Extra-Index `https://d33sy5i8bnduwe.cloudfront.net/simple/`).
- `backend/.env` nutzt `DB_NAME=test_database` (nicht `vinyl_scanner` wie README/Example) — Seeds/Tests müssen in die richtige DB.
- pytest.ini erzwingt `pytest-xdist` (`required_plugins`), Fix `-n 2 --dist loadscope`; Tests laufen gegen `EXPO_PUBLIC_BACKEND_URL` (lokal: `http://localhost:8001`), ursprünglich auf alte Emergent-Preview-URL gerichtet.
- `gemini-2.0-flash` und `gemini-3.6-flash` sind deaktiviert/429; verfügbares Vision-Modell: `gemini-3.5-flash` (Default in server.py, via `GEMINI_MODEL` überschreibbar).
- MongoDB via Homebrew: Tap muss vorher `brew trust mongodb/brew` werden, `mongosh` kommt mit `mongodb-community-shell`.
- OmniRoute (localhost:20128, OpenAI-kompatibel): API-Keys liegen in SQLite `~/.omniroute/storage.sqlite`, Tabelle `api_keys` (`SELECT key FROM api_keys WHERE revoked_at IS NULL AND is_active=1`). **`auto/*`-Router-Modelle scheitern mit 502** (Cloudflare-Playwright-Chromium fehlt: `~/.cache/ms-playwright/chromium_headless_shell-1234`) — festes Vision-Modell `antigravity/gemini-3.7-flash-low` funktioniert (per `OMNI_BASE_URL`/`OMNI_API_KEY`/`OMNI_VISION_MODEL` in `backend/.env`).
- Nutzer-Gemini-Key (AI Studio) hat kein Guthaben („prepayment credits depleted") — KI-Pfad läuft deshalb über OmniRoute. Teil von [[vinyl-scanner-state]].
