---
app: zcode
quelle: "saschalagler/cli/memories/projects/thomas---chips-judicario-7b0276307052409f/memory/browseros-llm-konfig-2026-10-26.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: browseros-llm-konfig-2026-10-26
description: BrowserOS „Bring Your Own LLM" FINAL 26.10.2026 — OpenRouter
  `openrouter/free` ist DEFAULT (gratis Auto-Modellwahl, live getestet
  cost:0); Inference-Key in ~/.openrouter_browseros_key (chmod 600);
  Management-Key darf keine Chat-Completions, Secret der Sub-Keys steht auf
  TOP-Level des POST-Responses; Ollama qwen3.5:9b + qwen3-vl:8b als Backup;
  ClinePass funktioniert, aber für Coding geschont
metadata:
  node_type: memory
  type: project
  originSessionId: session_browseros-llm-2610
---

BrowserOS (`chrome://browseros/settings` → AI & Agents), FINAL-Stand 26.10.2026:

- **OpenRouter · `openrouter/free` = DEFAULT** ✅ — Gratis-Router: wählt automatisch freie Modelle, cost:0 (curl-Livetest: HTTP 200 → poolside/laguna-s-2.1:free, Antwort „Ok!"). **Inference-Key** (73 Zeichen, erzeugt via Management-API) liegt lokal in `~/.openrouter_browseros_key` (chmod 600) — nicht in Chats/Docs kopieren.
- **Management-Key-Falle (wichtig!):** Saschas Key `sk-or-v1-b01a…f5f` ist GÜLTIG, aber `is_management_key:true` → 401 „User not found" an /chat/completions ist NORMAL, der Key ist nicht tot. Sub-Key-Erzeugung per `POST /api/v1/keys` (Authorization = Management-Key): das **Secret steht auf TOP-Level des Responses (`d['key']`), NICHT in `d['data']`** — und nur dort, einmalig. Erst-löschen-dann-Secret-suchen = Secret weg (3 Orphans costeten einen Anlauf). Trailing-Slash `/keys/` → 404.
- **Ollama = Backup** — `qwen3.5:9b` + gepullt `qwen3-vl:8b` & `qwen3-vl:4b` (Vision für Browser-Screenshots). Offen: BrowserOS-Ollama-Eintrag zeigt noch qwen3.5:9b; bei Bedarf Actions → Edit → Modell qwen3-vl:8b.
- **ClinePass** — funktioniert (curl stream:true; non-stream → 500 „empty response content", BrowserOS-„Test connection" scheitert daran fälschlich). Bewusst NICHT Default (5h-Token-Limit, Sascha-Kritik) — reserviert für ZCode/Coding.
- Gemini: blockiert bis Google-Login im BrowserOS-Fenster ODER AI-Studio-API-Key. Google AI Pro-Abo ≠ API-Key.
- OmniRoute/z.ai/Hermes/pi vorhanden; „Add custom ACP agent"-Dialog = nur Info, Cancel, kein Setup ohne Auftrag.

**Why:** Sascha lieferte selbst die OpenRouter-Free-Router-Doku — Gratis-Auto-Modellwahl + ClinePass-Schonung sind jetzt beide erfüllt.
**How to apply:** Browser-Chat läuft über openrouter/free (0 €). Bei Ausfall: Ollama als Default setzen. curl-Direktests vor UI-Arbeit. Master-Doku: `/Users/saschalagler/LOKI_OS_SETUP.md`.

Verwandt: [[umgebungs-blocker-zcode]] · [[loki-os-system-setup-2026-10-26]]
