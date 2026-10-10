---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/lm-studio-mac-gemma4-2026-10-10.md"
stand: 2026-10-10
tags: [spiegel, zcode]
---

---
name: lm-studio-mac-gemma4-2026-10-10
description: LM Studio auf Saschas MAC (M4 16 GB) — Gemma 4 12B QAT lief 1–10
  tok/s; DEEP-RESEARCH-Root-Cause = Context-Checkpoints-Leck (32×150 MB ≈ 4,8 GB)
  + Kontext 33k; finale Settings + korrigierte Speed-Erwartung 10–15 tok/s
  (25–35 war VETO)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_76c021dd-2b0c-45c9-8bb5-7c4706ca4b81
---

**Stand 10.10.2026 nach DEEP RESEARCH (Zweitmeinungs-Pass per feature-dev:code-reviewer, Confidence 88/100).** LM Studio auf Saschas **MAC** (Apple M4, 16 GB Unified Memory, ~12,28 GB GPU-nutzbar, macOS 27.2) — getrennt vom MOOLAPTOP (siehe [[coding-modelle-android-studio-2026-09-13]]).

**Symptom:** Gemma 4 12B QAT (Q4_0) 1–10 tok/s + „Not enough resources" (Estimated 12,28 GB).

**Die 3 echten Ursachen (verifiziert):**
1. 🎯 **Context Checkpoints 32 = ~4,8 GB Speicherleck** — dokumentierter Gemma-4-Bug (~150 MB pro Checkpoint; Quellen: koboldcpp Issue #2098, particula.tech/llama-cpp-cache-fixes.html). Der gesuchte 4,8-GB-Fehlbetrag stammt HIERHER, nicht aus dem KV-Cache. → **Checkpoints AUF 0** + LM-Studio-Runtime aktualisieren.
2. **Kontextlänge 33245 + F16-KV** → Schätzung 12,28 GB > nutzbar → Swap. → **16384**.
3. **Evaluierungs-Batch 2048** → Vocab 262.144 ≈ 2 GB Logit-Puffer → **512** (Physical 512, Max Concurrent 1).

**KV-Mathematik gegen google/gemma-4-12b-it config.json verifiziert:** 40 lokale Layer × 8 KV-Heads × 256 dim = 320 KiB/Token F16; SWA-capped (Window 1024) → KV klein; q8_0@16K ≈ 2,5 GB; Gesamt 9–11 GB < 12,28 GB ✓. **q8_0 ist optional** — F16@16K passt auch (mehr Qualität; Wahl: F16@16K ODER q8_0 + 24–32K Kontext).

**Speed-KORREKTUR (Reviewer-VETO gegen meine erste 25–35-Schätzung):** M4-Base = 120 GB/s Bandbreite ÷ 7,4 GB Gewichte ≈ 16 tok/s theoretisch, **real 10–15 tok/s Obergrenze**. 25+ nur mit MTP-Speculative, das der GGUF-Pfad in LM Studio nicht nutzt. Apr-2026-Metal-Regressions-Bug in llama.cpp dokumentiert → Engine-Update nötig.

**Finale Settings:** Kontext 16384 · K/V q8_0 (oder F16) · Eval-Batch 512 · Phys. 512 · Max Concurrent 1 · **Checkpoints 0** · GPU-Offload 48 · FA AN · Runtime updaten → „Load Anyway", rotes Banner muss weg.

**Harte Grenze:** Qwen3-Coder-Next 80B läuft auf dem 16-GB-Mac **nie** (min. ~27 GB) — Mac-Coding-Klasse = Gemma 4 12B QAT. Coder-Next bleibt MOOLAPTOP-only. Kleinere Alternative für mehr Tempo: Gemma 4 4B (~40+ tok/s).

Relates: [[mac-setup-16gb-m4]] (RAM-Constraint), [[browseros-lokale-modelle-setup]] (LM Studio Port 1234, nie parallel zu Ollama), [[coding-modelle-android-studio-2026-09-13]].
