---
name: browseros-llm-konfig-2026-10-26
description: BrowserOS „Bring Your Own LLM" Stand 26.10.2026 (FINAL) — Ollama
  = Default (kein Token-Limit); OpenRouter-Key ist GÜLTIG aber MANAGEMENT-KEY
  (kann keine Chat-Completions, kein Secret-Minting via API) → normaler
  Inference-Key muss via openrouter.ai/keys UI erstellt werden; ClinePass
  funktioniert, aber bewusst NICHT Default (5h-Token-Limit)
metadata:
  node_type: memory
  type: project
  originSessionId: session_browseros-llm-2610
---

BrowserOS (`chrome://browseros/settings` → AI & Agents), 7 Provider (Stand 26.10.2026 final):

- **Ollama = DEFAULT** (26.10. abends umgestellt) — `qwen3.5:9b` · localhost:11434/v1. Grund: kein Token-Limit, ClinePass-Flatrate soll für Coding geschont werden (Sascha-Kritik). Vision-Modell `qwen3-vl:8b` wurde per `ollama pull` nachgezogen (Browser-Automation braucht Vision) — nach Pull Ollama-Eintrag im BrowserOS auf VL-Modell umstellen.
- **ClinePass (OpenAI Compatible)** — `cline-pass/glm-5.3-flash` · api.cline.bot. Funktioniert (curl stream:true ✅), aber BEWUSST nicht Default wegen 5h-Token-Limit (Sascha: „clinepass setting völlig dumm wegen dem token limit").
- **OpenRouter**: Der von Sascha gepostete Key `sk-or-v1-b01a…f5f` ist **GÜLTIG** (GET /api/v1/key 200) aber `is_management_key:true` → Management-Keys dürfen KEINE Chat-Completions („401 User not found" an /chat/completions ist NORMAL dafür, der Key ist NICHT tot!). Sub-Key-Erzeugung via POST /api/v1/keys klappt, aber das Secret wird NICHT im Response mitgeliefert (nur masked label) → 3 erzeugte Orphans wurden wieder gelöscht (deleted:true). **Fix nur via UI:** openrouter.ai/keys → normalen Key ohne Management-Häkchen erzeugen → an ZCode → in BrowserOS OpenRouter-Eintrag eintragen → „Set as default" (Sascha will openrouter/auto als Auto-Modellwahl).
- OmniRoute (localhost:20128) 401 ohne Key · z.ai GLM · Hermes ACP · pi ACP — vorhanden.
- Gemini: aistudio.google.com/apikey → Google-Anmelden im AgentOS-Fenster. Login durch Sascha ODER API-Key. Google AI Pro-Abo ≠ API-Key.

**Why:** Sascha-Kritik 26.10.: „key ist neu, du hast ollama nicht für browser konfiguriert, clinepass dumm wegen token limit" — alles berechtigt; Default-Kette jetzt: Ollama (lokal) → ClinePass (Flats) → OpenRouter (nach Key-Fix, dann Wunsch-Default).
**How to apply:** Erst curl-Direktests, dann UI. GET /api/v1/key unterscheidet Management- vs. Inference-Key. Master-Doku: `/Users/saschalagler/LOKI_OS_SETUP.md`.

Verwandt: [[umgebungs-blocker-zcode]] · [[loki-os-system-setup-2026-10-26]]
