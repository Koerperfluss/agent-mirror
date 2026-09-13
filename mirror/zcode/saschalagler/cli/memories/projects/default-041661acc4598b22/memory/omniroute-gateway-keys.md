---
name: omniroute-gateway-keys
description: Wie man an den OmniRoute-Gateway-Client-Key kommt (localhost:20128
  verlangt Bearer) — Key liegt in ~/.omniroute/storage.sqlite Tabelle api_keys
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

OmniRoute-Gateway (**localhost:20128**) verlangt einen Bearer-Client-Key (sonst 401 AUTH_002 „Authentication required"). Verortung + Fallstricke (14.09. live verifiziert bei Open-WebUI-Anbindung):

- **Client-Keys:** `sqlite3 ~/.omniroute/storage.sqlite` → Tabelle **`api_keys`** (`SELECT name, key FROM api_keys WHERE revoked_at IS NULL`) — aktiver Key hieß „lokal-setup" (sk-62…, L35). Kopiert nach `~/.open-webui-setup/omni_key` (chmod 600).
- **Falle:** `omniroute keys list` zeigt NUR Upstream-Provider-Keys (openrouter etc.), maskiert — nicht den Gateway-Client-Key.
- `~/.omniroute/.env` enthält nur `STORAGE_ENCRYPTION_KEY` + `REQUIRE_API_KEY`, **keinen** Client-Key.
- `GET /v1/models` mit gültigem Key = **1529 Modelle** (`auto/best-coding|reasoning|fast|vision|chat`, `auto/pro-*` …) — OpenAI-kompatibel, damit an jedes BYOK-Tool anbindbar (Open WebUI an `/openai/config/update`).
- LaunchAgent `com.sascha.omniroute` (KeepAlive) startet `/opt/homebrew/bin/omniroute`; CLI lädt Env aus `~/.omniroute/.env`.
