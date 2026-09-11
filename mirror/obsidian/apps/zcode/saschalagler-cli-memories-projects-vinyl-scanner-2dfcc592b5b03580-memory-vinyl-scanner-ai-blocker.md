---
app: zcode
quelle: "saschalagler/cli/memories/projects/vinyl-scanner-2dfcc592b5b03580/memory/vinyl-scanner-ai-blocker.md"
stand: 2026-09-11
tags: [spiegel, zcode]
---

---
name: vinyl-scanner-ai-blocker
description: GELÖST (12.09.): KI läuft über OmniRoute-Router (antigravity/gemini-3.7-flash-low);
  Gemini-Key guthabenlos, Emergent-Key Free-Tier — beide nur noch Fallback
metadata:
  node_type: memory
  type: project
  originSessionId: sess_c2882922-5684-45c6-843f-3d2658bc6069
---

GELÖST am 12.09.2026: Die KI-Analyse läuft jetzt primär über den **OmniRoute-Router** (`http://localhost:20128/v1`, OpenAI-kompatibel, `OMNI_BASE_URL`/`OMNI_API_KEY`/`OMNI_VISION_MODEL` in `backend/.env`), Modell `antigravity/gemini-3.7-flash-low` (Vision verifiziert). Priorität im Code: OmniRoute → Gemini-Direct → Emergent.

Nicht offensichtliche Details:
- Router-Keys liegen in `~/.omniroute/storage.sqlite`, Tabelle `api_keys` (`SELECT key FROM api_keys WHERE revoked_at IS NULL AND is_active=1`).
- `auto/*`-Modelle am Router (z. B. `auto/best-vision`, `auto/best-free`) scheitern mit 502, weil der Cloudflare-Playground-Provider einen Playwright-Chromium braucht, der nicht installiert ist — festes Provider-Modell verwenden.
- Gemini-Key bleibt guthabenlos (429 „prepayment credits depleted"), Emergent-Key 403 FREE_USER_EXTERNAL_ACCESS_DENIED — beide nur Fallback. Bei beiden Keys gleichzeitig unbrauchbar liefert der Analyze-Endpoint sauber 503. Teil von [[vinyl-scanner-state]].
