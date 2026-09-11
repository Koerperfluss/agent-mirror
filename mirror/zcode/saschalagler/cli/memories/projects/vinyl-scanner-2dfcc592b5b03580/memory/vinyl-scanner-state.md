---
name: vinyl-scanner-state
description: VinylScanner-Projektstand (12.09.2026) — Archiv + KI live, Spotify-Playlist-Sync
  gebaut aber blockiert auf Nutzer-Spotify-Credentials; .env-Dateien waren im Git-Index (Push-Risiko)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_c2882922-5684-45c6-843f-3d2658bc6069
---

VinylScanner (`/Users/saschalagler/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /vinyl-scanner`, Expo SDK 54 + FastAPI Port 8001 + MongoDB): **fertig nutzbar**, Commits `fe83ea7` + `172fad1` + `c34343d` + `b161cc7`.

- Grafisches Archiv: `GET /api/scans/{id}/image` (JPEG + Cache-Header, Redirect zu `image_url`); History-Grid, „Zuletzt gescannt", Detail nutzen echte Cover via `getScanImageSource()` (`frontend/src/api.ts`).
- KI-Analyse live über OmniRoute (`antigravity/gemini-3.7-flash-low`); Tests **6/6 passed**, tsc clean. Echte Scans im Archiv (5 gesamt): IG DZ5MA8OyEXF (Thai-Compilation, high), Db0c5akDaro („Forged Dubs EP" — Brennan, high), DbwLDr1N53K („616 LAB", 2019, high).
- **Frontend-.env-Fix (c34343d):** `frontend/.env` zeigte noch auf die tote Emergent-Preview-URL (`playlist-bridge-app.preview.emergentagent.com`) → auf `http://localhost:8001` umgestellt und aus Git-Index entfernt. **Auch `backend/.env` war im Index** — vor `git push` History prüfen (bislang kein Remote).
- Spotify: OAuth + Playlist-Sync (`/api/spotify/login|callback|sync-playlist/{playlist_id}`) gebaut (Commit `b161cc7`, Refresh-Token in DB `app_config`), **blockiert auf Spotify-Login des Nutzers** (12.09. im In-App-Browser verifiziert: developer.spotify.com zeigt „Log in", keine Session; Cookie-Banner bereits weggeklickt, Tab als `handoff` offen gelassen). Sobald Nutzer im Tab eingeloggt ist: autonom App anlegen (`vinyl-scanner`, Redirect `http://localhost:8001/api/spotify/callback`), Credentials per `POST /api/spotify/config` speichern, `GET /api/spotify/login`, dann `POST /api/spotify/sync-playlist/4x4A8eNEaXGxpejKUA1dvL`. Nutzer hat vorher explizit „alles autonom selber tun" gefordert (siehe [[user-autonomy-preference]]).
- **Abgelehnter Wunsch (12.09.):** Nutzer wollte Download-Integration über SpotiFLAC-Next (Streaming-RIpper, gekauftes Repo unter `~/antigravity/Körperfluss-PILOT.AI/SpotiFLAC-Next`) — abgelehnt wegen Urheberrecht. Legale Alternative gebaut (Commit `eedd4c5`): Detail-Screen-Buttons öffnen Spotify-Mac-App per `spotify://` bzw. jetzt `youtube.com` statt YouTube Music (Web-Fallback).
- Laufende Prozesse (von Agent-Instanz gestartet, Nutzer hatte Port-8001-Konflikt dadurch): Backend uvicorn PID 85661 :8001, Metro/Expo :8081, OmniRoute :20128.
- DB heißt `test_database` (nicht `vinyl_scanner`!). Details: [[vinyl-scanner-env-setup]], [[vinyl-scanner-ai-blocker]].
