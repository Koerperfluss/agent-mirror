---
name: lm-studio-mac-gemma4-2026-10-10
description: LM Studio auf Saschas MAC (M4 16 GB) — Gemma 4 12B QAT lief 1–10
  tok/s / „Not enough resources"; Ursache Kontext 33k + F16-KV; vergebene
  Settings-Korrektur (16K + q8_0 + Batch 512) → Erwartung 25–35 tok/s
metadata:
  node_type: memory
  type: project
  originSessionId: sess_76c021dd-2b0c-45c9-8bb5-7c4706ca4b81
---

**Stand 13.09.2026 (Session-Ende):** LM Studio läuft auch auf Saschas **MAC** (Apple M4, 16 GB Unified Memory, davon ~12,28 GB GPU-nutzbar laut LM-Studio-Hardware-Survey, macOS 27.2) — **getrennt vom MOOLAPTOP-Setup** (siehe [[coding-modelle-android-studio-2026-09-13]]).

**Symptom:** Gemma 4 12B QAT (Q4_0, GGUF) lief mit **1–10 tok/s** + rotes Banner „Not enough resources to load the model" (Estimated 12,28 GB = exakt an der GPU-Grenze). Ursache per Screenshot hart belegt: **Kontextlänge 33245 + KV-Cache F16** → Load spilt ins RAM-Swap.

**Vergebene Settings-Korrektur (Lade-Dialog/Load Parameters):**
- Kontextlänge 33245 → **16384** (Haupt-Hebel)
- K- UND V-Cache-Quantisierung F16 → **q8_0** (Flash Attention war schon AN = Voraussetzung; laut LM Studio experimentell — bei Problemen zurück auf F16 und stattdessen Kontext 8192)
- Evaluierungs-Batch 2048 → **512**, Physical Batch 1120 → **512**
- Max Concurrent Predictions 4 → **1**, Context Checkpoints 32 → **4**
- UNVERÄNDERT lassen: GPU Offload 48 (alle Layer), „Modell im Speicher behalten" AN, mmap AN
- Erwartung danach **~25–35 tok/s** (M4 ist bei 12B nicht der Flaschenhals)

**Harte Grenze:** Qwen3-Coder-Next 80B läuft auf dem 16-GB-Mac **nie** (min. ~27 GB) — Mac-Klasse für Coding = **Gemma 4 12B QAT** (gute Wahl, multimodal + Code-Benchmarks). Coder-Next bleibt MOOLAPTOP-only.

Relates: [[mac-setup-16gb-m4]] (RAM-Constraint), [[browseros-lokale-modelle-setup]] (LM Studio als 2. Mac-Option, Port 1234, nie parallel zu Ollama).
