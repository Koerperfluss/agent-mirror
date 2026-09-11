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
- MongoDB via Homebrew: Tap muss vorher `brew trust mongodb/brew` werden, `mongosh` kommt mit `mongodb-community-shell`. Teil von [[vinyl-scanner-state]].
