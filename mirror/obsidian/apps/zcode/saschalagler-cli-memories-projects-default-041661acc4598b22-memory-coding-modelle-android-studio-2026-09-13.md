---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/coding-modelle-android-studio-2026-09-13.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

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

**Finale Wahl + Download-Links (13.09., alle per curl HTTP 200 verifiziert):**
- **Das Modell: Qwen3-Coder-30B-A3B-Instruct Q4_K_M** (~19 GB)
  - Ollama: `ollama pull qwen3-coder:30b` → https://ollama.com/library/qwen3-coder
  - GGUF manuell (LM Studio): https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF (Datei Q4_K_M, ~18,6 GB)
  - LM Studio: https://lmstudio.ai → Android Studio: Model Providers → Local Provider → Port 1234
- Upgrade-Option: Qwen3-Coder-Next 80B Q2/Q3 (~26–30 GB) → https://huggingface.co/unsloth/Qwen3-Coder-Next-GGUF

**Spezialisten-Team (feature-dev code-architect + code-reviewer als Prüfinstanz) geurteilt 13.09. ~21:50: PASS** — Qwen3-Coder-30B-A3B bestätigt, 2 Korrekturen übernommen, Report jetzt 74 Zeilen:
1. ❌ **VETO auf Qwen3-Coder-Next 80B Q2_K** (Q2 zerstört Qualität, Untergrenze Q3; + Swap-Tod bei 35-GB-Pagefile) — erst nach RAM-Upgrade.
2. **Speed korrigiert: 8–15 tok/s** realistisch (3B aktiv @ DDR4 ~50 GB/s), nicht 10–20.
3. **Kontext 16K statt 32K** auf 6 GB VRAM + KV-Cache q8_0 + Flash-Attention AN.
4. **LM Studio** (GPU-Layer-Slider + KV-Quant im UI, Start ~16 Layer, Ziel ≤5,5 GB VRAM); Fortgeschritten: ik_llama.cpp mit `-ot ".ffn_.*_exps.=CPU"`.
5. **Zweitmodell Qwen2.5-Coder-7B Q4_K_M bestätigt** — wichtig: hat **FIM-Support** (Fill-in-the-Middle = Tab-Autocomplete), den Qwen3-Coder NICHT hat; 8K ctx, alle Layer GPU.
6. Fallback: 30B als IQ3_XXS (~12 GB, mehr ins VRAM) statt Wechsel auf dichtes Modell.
Regeln: nie Emulator + LLM gleichzeitig (~7 GB Puffer), RAM vorher freiräumen, keine 500-Zeilen-Dateien in den Chat, pro Aufgabe neue Session. Lektion: Sascha verlangte explizit das feature-dev-Spezialistenteam als Verifikation — bei Tech-Empfehlungen gern code-architect (Blueprint) + code-reviewer (adversär, Vetorecht) parallel dispatchen.

**SOTA-Einordnung (13.09., auf Nachfrage „was ist state of the art?")** — offizieller swebench.com-Leaderboard: **#1 Claude 4.5 Opus (high)**, dann **Gemini 3 Flash (high)**, **MiniMax M2.5 (high)**; ~95 % Drittplattform-Werte („Fable 5"/„Mythos") unbestätigt. Fortschritt: Claude 3.5 Sonnet 2024 = 49 %. 3 Stufen: Cloud-SOTA (Claude 4.5 Opus) / Preis-Leistungs (Gemini 3 Flash, MiniMax M2.5, GLM-5.3) / Lokal-SOTA (Qwen3-Coder-Next 42,8 % ≈ Sonnet-4-Niveau, auf MOOLAPTOP pragmatisch = Qwen3-Coder-30B-A3B Q4). Pragmatische Empfehlung an Sascha: Hybrid — lokal 30B-A3B für Alltag, Cloud-Spitze (Gemini gratis-Tier / GLM-5.3-Flash aus Coding-Plan) bei harten Problemen.

**Korrektur nach Saschas eigenem Fund (ModelFit-Rangliste 12.06.2026, Report jetzt 84 Zeilen):** **Qwen3.6 27B (dicht, 17 GB) = 77,2 % SWE-bench Verified** (vendor-reported) = Qualitätskönig seiner RAM-Klasse; auf 6-GB-VRAM aber ~4–8 tok/s. Devstral Small 2 (24B, 68,0 %, 384K ctx) = Speed-Falle (2–4 tok/s). Qwen3-Coder-30B MoE hat KEINEN publizierten SWE-bench-Score. Unaufgelöster Widerspruch markiert: 27B=77,2 % vs. 80B-Coder-Next=42,8 % (beides vendor-self-reported). **Finale Hybrid-Empfehlung:** `ollama pull qwen3-coder:30b` (Agent-Alltag, schnell) + `ollama pull qwen3.6:27b` (harte Aufgaben) + `ollama pull qwen2.5-coder:1.5b` (Autocomplete, continue.dev-Offiziell; keine Reasoning-Modelle für Autocomplete). **Ollama-Falle: Default-Kontext 2K, wird lautlos abgeschnitten → immer `OLLAMA_CONTEXT_LENGTH=32768 ollama serve`.** Angebot offen (auf GO): Windows-`.bat`/`.ps1` für Ollama-Autostart mit richtigem Kontext-Limit.

**Korrektur 2 (13.09., „er hat keinen GLM plan du trottel"): Der MOOLAPTOP hat KEINEN Z.AI/GLM-Plan** → finale Empfehlung 100 % kostenlos ohne Bezahlplan, alle GLM/Coding-Plan-Verweise gestrichen. Als einzige Cloud-Option nur der Gemini-Gratis-Tier in Android Studio (nur Google-Konto, ~1.000 Anfragen/Tag). Lektion: Empfehlungen nie an Saschas eigene Pläne/Ressourcen koppeln, wenn der Ziel-Rechner jemand anderem gehört — „er" im Prompt = Dritter.

**Korrektur 3 (13.09., „KEIN OLLAMA du bimbo — wir haben 13.09.2026"): Sascha lehnt Ollama als Runner AB** und verlangt frische (nicht Juni-Guide-)Recherche zur Coder-Next-Leistungsklasse. Lektion: Tool-Wahl (Ollama vs. LM Studio/llama.cpp) ist für ihn keine Selbstverständlichkeit — explizit nachfragen bzw. den Profi-Weg (llama.cpp direkt) anbieten; Guides nie als „aktuell" verkaufen, wenn sie Monate alt sind.

**Frische Sept-2026-Recherche zur Coder-Next-Klasse (Report jetzt 105 Zeilen):**
- **Qwen3-Coder-Next 80B-A3B**: Q4 braucht ~46 GB → auf 40-GB-RAM nur **Q3/IQ3 (~30–33 GB, knapp)**, ~10 tok/s (llama.cpp `-ot ".ffn_.*_exps.=CPU"`: Experten ins RAM, Attention auf GPU).
- **Qwen3.5-35B-A3B** (Q4 ~21 GB): Community (HN + Reddit + NVIDIA-Forum) sagt **besseres Tool-Calling/Reasoning als Coder-Next** → meine Empfehlung für seine Hardware (10 GB RAM-Luft statt 2 GB).
- **Qwen3.7 27.8B dense** (neu 14.08.2026, Apache 2.0): 61,7 % SWE-bench Pro, Klassenbest dense, ~17 GB aber langsam.
- **Qwen3.8 27B-MLX** (08/2026, „bester lokaler Agentic-Coder" r/LocalLLaMA) = **Mac-only (MLX)**, läuft nicht auf Windows/NVIDIA.
- Open-Weights-Weltspitze (Kimi K2.6 / MiniMax M2.5 je 80,2 % SWE-bench Verified, DeepSeek V4) = 600B+ → nur Cloud.
- GLM-4.7-Flash = open weights (kein Plan nötig), „bester praktischer lokaler Web-Dev".
- Runner OHNE Ollama: **LM Studio** (offizieller AS-Support, Port 1234) oder **llama.cpp direkt**: `llama-server -hf unsloth/Qwen3-Coder-Next-GGUF:UD-Q3_K_XL --fit on --jinja -ot ".ffn_.*_exps.=CPU" --ctx-size 16384 --port 8080` → AS Local Provider Port 8080.
- Quellen: qwen.ai/blog (Coder-Next), unsloth.ai/docs/models/qwen3-coder-next, loftllc.dev-Benchmark (IQ4-Hybrid 59–85 tok/s auf stärkerer HW), reddit 1pi7ig7 + 1rdnxe6, HN 47249959, codingfleet.com (Qwen3.7).

**Nutzer-Profil: MORITZ = Besitzer des MOOLAPTOP** (13.09. geklärt — „er" im Prompt = Moritz, nicht Sascha). Moritz hat Plan von App-Programmierung und generellem Coding, weist „sehr genau an was er will und wie". 13.09. beraten: Bei präziser Vorgabe sinkt der Bedarf an Modell-Thinking deutlich (Anforderungs-Raten entfällt) — **Standard = schnelles MoE (Qwen3.5-35B-A3B), Thinking-Reserve (Coder-Next Q3 / Qwen3.6 27B) nur für harte Bug-Jagd/Root-Cause**; Thinking-Modi für Autocomplete sind sogar schädlich (Millisekunden nötig, siehe continue.dev-Warnung). Analogie, die Sascha akzeptierte: Moritz = Senior mit schnellem Junior (diktiert Architektur, Modell tippt), für harte Fälle den erfahrenen Kollegen dazuholen.

**Max-Leistungs-Config „Standalone Coding" (13.09., Report jetzt 113 Zeilen):** Sascha wollte Max-Leistung fürs reine Coden → **Qwen3-Coder-Next 80B-A3B**, NICHT Q3_K_XL (VETO: 44-GB-Bedarf = Swap-Tod). RAM-Rechnung 40 GB: OS ~4 + AS/Gradle ~5 + Modell ~27 + KV q8_0@16K ~2 = ~38 GB (~2 GB Luft!) → Emulator/Browser ZU, eiserne Regel. Erwartung ~8–12 tok/s. Trade-off: unter Q3-Qualitätsgrenze — bei Querelen zurück auf **Qwen3.5-35B-A3B Q4** (21 GB).

**FINALE API-verifizierte Version (13.09., „WAS REDEST DU ALTER" → karpathy-guidelines + harte Zahlen statt Schätzungen):**
- feature-dev code-architect (First Principles): Limit = **28 GB Modellgröße** (40 − 4 Win − 5 IDE − 2 Puffer − 1 Runtime). VRAM: nur ~3B Non-Expert-Params + KV ≈ 4 GB auf GPU → passt in 6 GB.
- **Echte GGUF-Größen per HF-API verifiziert** (`https://huggingface.co/api/models/unsloth/Qwen3-Coder-Next-GGUF/tree/main?recursive=true`, curl + python): **UD-Q2_K_XL = 26,8 GB (Standard, sicher)**, **UD-IQ3_XXS = 28,5 GB (absolute Obergrenze)**; UD-IQ3_S 29,7 / Q3_K_S 34,6 / Q4_K_M 48,5 = NEIN. Frühere „Q2_K ~26–30 GB"-Schätzungen stimmten grob; Vanilla-Q2_K = 29,2 GB, UD-Dynamic-Quants sind kleiner UND qualitativ besser.
- Finaler Befehl: `llama-server -hf unsloth/Qwen3-Coder-Next-GGUF:UD-Q2_K_XL --fit on --jinja -ot ".ffn_.*_exps.=CPU" --ctx-size 16384 --port 8080` → AS Local Provider Port 8080 (I3Q3_XXS-Variante = letzter Quent). Karpathy-Ehrlichkeit: tok/s nicht auf der exakten Maschine gemessen, erste Messung nach Setup dokumentieren.

**Technik-Bug (13.09.): Subagent-Dispatch teils kaputt** — `general-purpose` und `Explore` starteten mit „No reasoning level selected [reasoning-level-missing; account:zai-start-plan/GLM-5.3-Flash]" nicht; **feature-dev:code-architect / feature-dev:code-reviewer funktionierten** (deren Plugin-Definitionen bringen eine Denkstufe mit, generische Agenten nicht). Diagnose mit Beweis: `~/.zcode/config.json` enthält KEINEN `thoughtLevel`/`reasoningLevel`-Eintrag (grep-geprüft). **Fix (Sascha noch nicht gemacht): in ZCode Settings die Reasoning/Thought-Stufe explizit setzen, nicht „Auto/leer" lassen.** Workaround: harte API-Fakten selbst per curl/Bash holen statt Subagent. Lektion: bei Agent-Launch-Fehlern direkt feature-dev:*-Agents nehmen oder selbst erledigen.
