---
app: zcode
quelle: "saschalagler/cli/memories/projects/thomas---chips-judicario-7b0276307052409f/memory/browseros-llm-konfig-2026-10-26.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: browseros-llm-konfig-2026-10-26
description: BrowserOS „Bring Your Own LLM" Stand 26.10.2026 (AKTUALISIERT) —
  ClinePass glm-5.3-flash ist DEFAULT (curl-live getestet); OpenRouter-Key
  TOT (401 User not found) → Provider bis Neuanlage nicht wählen; Ollama
  qwen3.5:9b ok; Gemini blockiert (Google-Login nötig)
metadata:
  node_type: memory
  type: project
  originSessionId: session_browseros-llm-2610
---

BrowserOS (`chrome://browseros/settings` → AI & Agents), 7 Provider (Stand 26.10.2026, abends korrigiert):

- **ClinePass (OpenAI Compatible) = DEFAULT** (umgestellt, weil OpenRouter tot war) — `cline-pass/glm-5.3-flash` · `https://api.cline.bot/api/v1`. **Curl-Direktest: stream:true → antwortet ✅.** Falle: `stream:false` → HTTP 500 „empty response content"; BrowserOS-„Test connection" nutzt vermutlich non-stream und zeigt falschen Fehler.
- **OpenRouter · `openrouter/auto`: Key TOT (HTTP 401 „User not found")** — der im Chat gepostete Key ist ungültig/gelöscht. Default wurde auf ClinePass zurückgenommen. Sobald Sascha einen neuen Key von openrouter.ai/keys liefert: Provider OpenRouter → Edit → Key eintragen → wieder „Set as default" (Sascha will die Auto-Modellwahl).
- Ollama qwen3.5:9b · localhost:11434/v1 — läuft (curl /api/tags ok).
- OmniRoute (localhost:20128) 401 ohne Key · z.ai GLM · Hermes ACP · pi ACP — vorhanden.

**Offen:**
1. Gemini/Google: aistudio.google.com/apikey → Google-Anmelden im AgentOS-Fenster. Braucht Login durch Sascha ODER Gemini-API-Key. Google AI Pro-Abo gilt NICHT für API-Keys.
2. Neu-Key von Sascha für OpenRouter (Auto-Modellwahl ist sein Wunsch).

**Why:** „Keiner funktioniert"-Meldung am 26.10. war der tote OpenRouter-Key, keine Konfig-Fehler. Vermutlich weitere Sessions betroffen.
**How to apply:** Bei LLM-Problemen IMMER erst curl-Direktest (Authorization-Header), dann Browser-UI. Master-Doku: `/Users/saschalagler/LOKI_OS_SETUP.md`.

Verwandt: [[umgebungs-blocker-zcode]] · [[loki-os-system-setup-2026-10-26]]
