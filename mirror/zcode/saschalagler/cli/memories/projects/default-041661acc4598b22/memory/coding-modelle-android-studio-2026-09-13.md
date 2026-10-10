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

**Direkte Download-Links verifiziert (13.09., letzte Nachfrage „zeig link", alle curl-200):** UD-Q2_K_XL ist **eine einzelne Datei, kein Shard-Ordner** — `tree/main/UD-Q2_K_XL` = 404. Direktlink: `https://huggingface.co/unsloth/Qwen3-Coder-Next-GGUF/blob/main/Qwen3-Coder-Next-UD-Q2_K_XL.gguf`. LM-Studio-Einbindung: Suche im Discover-Tab nach „Qwen3-Coder-Next GGUF" → UD-Q2_K_XL, oder manuell nach `C:\Users\<Name>\.lmstudio\models\unsloth\qwen3-coder-next-gguf\`. Install-Weg für Moritz dokumentiert: llama.cpp-Release-Zip (cuda) nach C:\llama ODER LM Studio von lmstudio.ai. Lektion (13.09., „wieso nicht gleich in lm studio?"): bei Install-Anleitungen immer den EINFACHSTEN Weg zuerst (in-App-Download im Discover-Tab), manuelle Links nur als Fallback — und „zeig link"-Antworten ohne Prosa, nur den Link.

**IQ3_XXS vs IQ3_S (13.09., letzte Frage):** UD-IQ3_XXS = 28,5 GB (~2,85 bpw) vs UD-IQ3_S = 29,7 GB (~2,97 bpw, ~1,2 GB größer, minimal besser). Regel für MOOLAPTOP: **IQ3_XXS = Maximum MIT laufender IDE**; IQ3_S nur ohne IDE (reiner Modell-Run). Empfehlung: bei dem kleinen Qualitätssprung lohnt das Swap-Risiko nicht — IQ3_XXS bleiben oder sicher UD-Q2_K_XL (26,8 GB, 2,2 GB Luft).

**Technik-Bug (13.09.): Subagent-Dispatch teils kaputt** — `general-purpose` und `Explore` starteten mit „No reasoning level selected [reasoning-level-missing; account:zai-start-plan/GLM-5.3-Flash]" nicht; **feature-dev:code-architect / feature-dev:code-reviewer funktionierten** (deren Plugin-Definitionen bringen eine Denkstufe mit, generische Agenten nicht). Diagnose mit Beweis: `~/.zcode/config.json` enthält KEINEN `thoughtLevel`/`reasoningLevel`-Eintrag (grep-geprüft). **Fix (Sascha noch nicht gemacht): in ZCode Settings die Reasoning/Thought-Stufe explizit setzen, nicht „Auto/leer" lassen.** Workaround: harte API-Fakten selbst per curl/Bash holen statt Subagent. Lektion: bei Agent-Launch-Fehlern direkt feature-dev:*-Agents nehmen oder selbst erledigen.

**Abschluss-Bestätigungen (13.09., letzte Messages):**
1. **LM-Studio-Screenshot vom MOOLAPTOP bestätigt die Analyse 1:1**: Download-Liste Qwen3 Coder Next, rote Warnung „wahrscheinlich zu groß" ab **UD-Q3_K_S 33,32 GB**; Haken ✓ auf **UD-Q2_K_XL 26,76 GB**; API-Zahlen decken sich (26,76/28,48/29,69 GB). Moritz klickt Q2_K_XL — LM Studios Warnung ist optimistischer als unsere 28-GB-Grenze, weil sie nicht weiß, dass Android Studio mitleuft.
2. **Unsloth-Modellkarte bestätigt offiziell**: „For best results, use any **2-bit XL quant or above** (requires >30 GB combined RAM+VRAM)" — MOOLAPTOP hat 46 GB kombiniert (40 RAM + 6 VRAM) ✅. Q4 bräuchte >45 GB kombiniert (Grenzfall, richtig verzichtet). **UD-Dynamic-2.0-Quants schlagen andere Quants** → immer „UD"-Varianten wählen. **Wichtig fürs Setup:** Feb-4-Update — alte GGUFs hatten einen Loop/Output-Bug, wurden ersetzt → nur FRISCH herunterladen (Moritz lädt jetzt = korrekte Dateien) + llama.cpp/LM Studio aktuell halten (Feb-19-Tool-calling-Fix wichtig für AS-Agent-Modus).
- Fazit: Empfehlung (UD-Q2_K_XL als Standard, UD-IQ3_XXS als Maximum) dreifach abgesichert — eigene RAM-Rechnung + LM-Studio-Warnung + Herstellerkarte.

**AS-Anbindung an Moritz dokumentiert (13.09., finale Frage):** LM Studio → Modell laden → Developer-Tab (`>_`) → „Start Server" (Status „Running on http://localhost:1234") → Android Studio (Otter 3+) → File → Settings → Tools → AI → Model Providers → „+" → Local Provider → Port 1234 → im Chat-Fenster Modell-Selektor umstellen (Agent Mode läuft mit). Schnelltest: `http://localhost:1234/v1/models` im Browser muss JSON zeigen. Troubleshooting: Modell fehlt im Selektor = Server nicht gestartet; Menüpunkt fehlt = AS zu alt; extrem langsam = RAM drücken (Emulator/Browser zu, Modell neu laden).

**Modell-Laden-Klärung (13.09., „muss ich immer Modell laden?"):** Modell muss NACH JEDEM PC-NEUSTART einmal geladen werden; innerhalb einer laufenden Session bleibt es geladen (kein erneutes Laden nötig). Automatik: LM Studio Developer-Einstellungen „Run Server at Startup" + Standard-/Auto-Load-Modell festlegen (exaktes Label variiert je nach Version — sinngemäß „Auto-load", Sascha auf präzise Formulierung gedrängt, nicht raten). Realistische Erwartung kommuniziert: 27-GB-Modell braucht nach Boot **1–3 Min. Ladezeit** (SSD-Tempo) bis zur ersten Antwort. Antwortschnitt-Feedback: meine Antwort war mitten im Satz abgeschnitten worden → Sascha re-tagged [$i-have-adhd]; ADHS-Regel = Antworthäppchen sauber abschließen, Tabellen statt Prosa.

**Autostart-Klärung (13.09., „geht das nicht automatisch?"):** EINMALIG einrichten, danach 0 Klicks. Automatisierbar: LM Studio Developer-Einstellungen **„Run Server at Startup"** + Windows-Autostart via `shell:startup`-Verknüpfung + AS **merkt sich den Provider** dauerhaft (nur Modell-Auswahl im Chat bleibt 1 Klick). Firewall-Prompt einmalig „Zulassen". **Empfehlung an Moritz: KEIN Windows-Autostart** — die 27 GB Modell-RAM wären ab Boot weg, obwohl die KI nicht immer gebraucht wird; stattdessen LM-Studio-Doppelklick + „Start Server" = 10 Sek. Manuell, RAM bleibt frei für Nicht-KI-Arbeit. Windows fragt beim Autostart evtl. einmalig Firewall-Freigabe für Port 1234.

**HF-Browser-Download → LM-Studio-Integration (13.09., letzte Frage „wir haben über hugging face geladen"):** Per Browser geladene .gguf MUSS manuell in den LM-Studio-Modellordner: `C:\Users\<Moritz>\.lmstudio\models\unsloth\Qwen3-Coder-Next-GGUF\Qwen3-Coder-Next-UD-Q2_K_XL.gguf` — **3-Ebenen-Ordnerstruktur (Publisher\Repo\Datei) zwingend**, sonst ignoriert LM Studio die Datei (echten Pfad unter Einstellungen → Models Directory nachsehen). Danach: LM Studio neu starten → My Models → Load → Developer-Tab → Start Server → AS Local Provider Port 1234; Schnelltest `http://localhost:1234/v1/models` (muss JSON zeigen). Lektion doppelt bestätigt: in-App-Download im Discover-Tab hätte Schritt 1 komplett gespart — bei Modell-Downloads IMMER den LM-Studio-Weg zuerst nennen.

**Token-Limit-Frage (13.09., „er stößt dauernd an Grenze"):** LM Studio lädt Modelle mit kleinem Default-Kontext (~4096). Fix: Modell entladen → im Lade-Dialog rechts Einstellungen → **Context Length 32768** (safe) oder 65536 + **KV-Cache q8_0** + **Flash Attention AN** → als Standard speichern → Server neu starten. Wegen Hybrid-Architektur (nur 12/48 Layer Full-Attention, ~13 KB/Token KV @ q8_0) ist mehr Kontext billig: 16K=0,2 / 32K=0,4 / 64K=0,9 / 128K=1,7 GB. Sweet Spot 32K (Prefill auf DDR4 wird sonst träge); bei langen Agent-Sessions lieber 32K + pro Aufgabe neuer Chat statt 128K aufblähen. Zweite Stellschraube bei abgebrochenen Antworten: „Max Tokens" (Ausgabe-Länge) im Chat-Parameter auf 8192+.

**Settings-Klickpfade (13.09., „WELCHE SETTINGS WO?"):** ALLE Modell-Settings hängen am **Zahnrad/Gear beim Modell in „My Models" bzw. Slider-Icon im Lade-Dialog** → Panel „Load Parameters": Context Length (Slider), GPU Offload, **Flash Attention Toggle — wichtig: erst FA an, DANN erscheint die KV-Cache-Quant-Dropdown (q8_0)**, unten „Save Preset" für Dauerhaftigkeit (pro Modell gemerkt). Server: Developer-Tab → Port 1234, „Serve on Local Network" AUS. AS: Settings → Tools → AI → Model Providers → „+" → Local Provider → 1234. Max Tokens (Ausgabelänge, bei abgebrochenen Antworten): LM-Studio-Chat rechte Seitenleiste, 8192+.

**Subagent-Fehler-Erklärung an Sascha (13.09., „wieso?"):** Ursache kommuniziert — Z.AI-Start-Plan (GLM-5.3-Flash) verlangt für generische Subagents eine explizite Denkstufe; feature-dev:*-Agents bringen sie mit, general-purpose/Explore nicht. Fix: ZCode Settings → Modell/Reasoning → Thought-Stufe explizit setzen (nicht Auto/leer); `~/.zcode/config.json` hat derzeit keinen thoughtLevel/reasoningLevel-Eintrag (grep-Beweis geliefert). Bis dahin gilt: feature-dev:*-Agents oder Direkt-Arbeit per curl.

**Zuständigkeits-Klärung AS vs LM Studio (13.09., „und android studio? nicht relevant"):** Android Studio hat KEINE Token-/Kontext-Einstellung für lokale Modelle — Kontextgröße/KV-Cache/Flash-Attention + Antwortlänge kommen 100 % aus LM Studio; AS kontrolliert nur Modellwahl (Selektor) und die einmalige Verbindung (Port 1234). Einzige tägliche AS-„Einstellung": bei langen Chat-Verläufen neuen Chat starten (Verlauf frisst den 32K-Kontext) — einmal Provider gesetzt, kann AS nie mehr Schuld sein.

**Sascha bestätigt (13.09., „das ja"):** Sein Problem ist die ANTWORTLÄNGE (Antwort bricht mitten im Code ab), nicht das Chat-Gedächtnis → Fix = „Max Tokens" in LM-Studio-Chat-Seitenleiste auf 8192+ + pro Aufgabe neuer Chat in AS. Falls es in LM-Studio-eigenem Chat NICHT abschneidet, in AS aber doch: Grenze liegt beim AS-Request → neuer Chat in AS.

**Diagnose „Modell extrem langsam und dumm" (13.09., letzter Stand, noch nicht gelöst):** Checkliste an Sascha/Moritz gegangen — LANGSAM: (1) Swap-Tod prüfen (Task-Manager: „Ausgelagert" >2–3 GB / Disk 100 % = häufigste Ursache → Programme schließen, Modell neu laden), (2) **GPU Offload muss Maximum** sein im Load-Panel (0 = CPU-only = 1–3 tok/s statt 8–15), (3) Runtime muss **CUDA** sein, nicht Vulkan/CPU (Zahnrad → Runtime). Referenz: 8–15 tok/s normal, 1–3 = Konfig-Fehler. DUMM = ehrlicher Preis von **UD-Q2_K_XL (2-Bit-Qualitätsfloor)**. Empfehlung: parallel **Qwen3.5-35B-A3B Q4 (~21 GB, 5 GB Luft, Q4>2-Bit schlauer, besseres Tool-Calling)** laden und vergleichen — realistischer Daily-Driver; Alternativ-Fix auf 80B: Wechsel auf IQ3_XXS (nur wenn Swap gelöst). Erst-Check-Ergebnis steht noch aus.

**10.10. — Report-Datei GELEERT vorgefunden + rekonstruiert:** `~/Desktop/CODING_MODELL_RESEARCH_2026-09-13.md` war zwischenzeitlich von 113 auf 0 Zeilen reduziert (vermutlich manuell geleert); nach neuem Anhang nur 17 Zeilen → **komplett rekonstruiert als verdichtete 31-Zeilen-Fassung** (alle Kernfakten aus Session-Chronik: SOTA-Stand, MOOLAPTOP-Finale, Mac-Deep-Research). Lektion: Desktop-MD-Reports kann Sascha löschen — Session-Chronik ist die eigentliche Sicherung; bei wichtigen Reports Datei-Existenz+Zeilen vor jedem Append prüfen (`wc -l`), nicht blind `>>`. Mac-Deep-Research-Details (Gemma 4, Checkpoints-Leak, 10–15 tok/s) leben jetzt in [[lm-studio-mac-gemma4-2026-10-10]].
