---
name: coding-modelle-android-studio-2026-09-13
description: 13.09. Web-Research "beste Coding-Modelle + Android Studio" —
  Empfehlung für MOOLAPTOP (Alienware, RTX 3060 6GB VRAM/40GB RAM); Report auf
  Desktop
metadata:
  node_type: memory
  type: project
  originSessionId: sess_76c021dd-2b0c-45c9-8bb5-7c4706ca4b81
---

Recherche 13.09.2026 (Confidence 85) abgeschlossen; Report: **~/Desktop/CODING_MODELL_RESEARCH_2026-09-13.md** (Runlog-Eintrag in ~/.agents/memory/research-runlog.jsonl).

**Neue Hardware-Fakten MOOLAPTOP** (Saschas Windows-PC, Alienware m15 Ryzen Ed. R5): Ryzen 7 5800H, **40 GB RAM**, **RTX 3060 Laptop nur 6 GB VRAM** (kein 12-GB-Modell!), Win 11 Build 26200. → Lokale LLMs: nur 7B–9B komplett im VRAM; MoE-Offload ins 40-GB-RAM ist der Weg.

**Kern-Findings Sept 2026:**
- Android Studio Otter 3 (Jan 2026) hat **BYOM** (Settings → Tools → AI → Model Providers; Remote = OpenAI/Anthropic/OpenRouter-URL+Key) + eigenen Eintrag „Use a local model" (/studio/gemini/use-a-local-model). Spezialisierte Gemini-Features (UI-Gen, Logcat) bleiben Gemini-only.
- Cloud-Coding-Spitze: SWE-bench offiziell #1 Claude 4.5 Opus, Top-4 mit Gemini 3 Pro + Doubao-Seed-Code; **GLM-5.3** (Z.ai, ~91 % vendor-reported) + GLM-5.3-Flash (DeepSWE 63,4).
- Lokal-Empfehlung: **Qwen3-Coder-30B-A3B Q4 (~22 GB RAM, ~20–25 tok/s)**, North Mini Code 1.0 (30B-A3B), Qwen3.5 9B komplett im VRAM.
- Setup-Empfehlung für ihn: Gemini Agent Mode gratis (er hat 6 Gemini-API-Keys) + GLM-5.3-Flash per BYOM (Coding-Plan) + LM Studio lokal als Fallback.

Caveats: GLM-5.3-Zahlen vendor-reported; „Claude Opus 5/Mythos/Fable" nur Drittplattform-Tracker; lokale Modellnamen aus KDnuggets (24.06.2026), eigener Test nötig. Relevanter Kontext: [[zai-coding-plan-limits]], [[google-cloud-genai-credit]].

**Nutzer-Korrektur (13.09., „was machst du trottel"): Sascha wollte NUR LOKALE LLMs** — erste Antwort mit Cloud-Modellen war am Thema vorbei. Lektion: bei „beste Coding-Modelle + meine Specs" = lokale Modelle auf SEINER Hardware, Cloud höchstens als Fußnote.

**Vertiefung nur-lokal (Nachtrag im Report, 61 Zeilen):**
- 🥇 **Qwen3-Coder-30B-A3B Q4** (~22 GB, GPU+RAM-Split, ~10–20 tok/s auf 5800H/DDR4) + Nachfolger **Qwen3.5-35B-A3B** (04/2026)
- Max-Qualität: **Qwen3-Coder-Next 80B-A3B** (02/2026, Q2/Q3 ~26–35 GB knapp machbar, 42,8 % SWE-bench ≈ Sonnet-4-Niveau)
- **Gemma 26B MoE** = Googles OFFIZIELLE lokale Android-Studio-Empfehlung (AS-Doku: Settings → Tools → AI → Model Providers → „+" → **Local Provider** → Port 1234 LM Studio / 11434 Ollama; Agent Mode braucht Tool-Use-Modell)
- Schnell (komplett im 6-GB-VRAM): Qwen2.5-Coder-7B / Qwen3.5-9B; dichte 27B (Qwen3.6 MTP) = langsam per RAM
- **GLM-5/5.3 = 744–754B → Cloud-only, NICHT lokal**; kein „GLM-5-Air" gefunden
- ⚠️ DxDiag: Auslagerungsdatei 35 GB benutzt, nur 7,7 GB frei → vor Modell-Load aufräumen, sonst Swap-Tod
