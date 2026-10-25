# qwen-flash-spark

**BLUF:** Lokales LLM-Setup — Qwen3.8-Flash-Next (GGUF) läuft auf dem **NVIDIA DGX Spark** (GB10, 128 GB Unified Memory) via `llama-server`; ein **Raspberry Pi** ist der schlanke Client für Benchmark + Traktor-Reverse-Engineering.

```
Raspberry Pi (Client)  --SSH-Tunnel/HTTP-->  DGX Spark (llama-server)  -->  Qwen3.8-Flash-Next GGUF
     pi_benchmark.py / pi_re_client.py              OpenAI-kompatible API, SSE-Streaming
```

## Quickstart (3 Befehle)

**1. Server auf der DGX Spark starten:**

```bash
MODEL_PATH=/pfad/zu/qwen-flash-next-q4_k_m.gguf CTX=32768 \
  ./scripts/spark_start.sh
```

**2. Benchmark vom Pi aus fahren:**

```bash
python3 scripts/pi_benchmark.py \
  --host http://<spark-ip>:8080 \
  --suite traktor --runs 3 \
  --json-out bench_traktor.json
```

**3. Traktor-RE-Analyse vom Pi aus:**

```bash
python3 scripts/pi_re_client.py \
  --host http://<spark-ip>:8080 \
  --task hid --input capture.txt \
  --question "Jog-Wheel langsam rechts gedreht; drei Samples" \
  --output hid_analyse.json
```

Alles in einem Rutsch (Health-Check → Benchmark → RE-Smoke → Report):

```bash
bash scripts/run_bench_suite.sh --host http://<spark-ip>:8080
```

## Dateilandkarte

| Pfad | Zweck |
| :--- | :--- |
| `scripts/spark_start.sh` | Server-Start auf der Spark (Checks: Binary, Modell, RAM; Flags: `--jinja`, `--flash-attn`) |
| `scripts/pi_benchmark.py` | Benchmark: TTFT, tok/s, Prompt-Processing-Rate (Std-Lib, SSE-Streaming) |
| `scripts/pi_re_client.py` | RE-Client: Task-Profile `hid`/`mapping`/`capture`/`format`, JSON-Protokoll |
| `scripts/run_bench_suite.sh` | Automation: Health → Bench → RE-Smoke → Markdown-Report |
| `tests/test_pi_tools.py` | Unit-Tests (Std-Lib `unittest`) |
| `docs/SETUP_GUIDE.md` | Schritt-für-Schritt-Setup (llama.cpp-Build, Download, systemd) |
| `docs/PROMPT_GUIDELINES.md` | Prompt-Baukasten für RE-Tasks (LM-Studio-äquivalente Einstellungen) |
| `docs/RESEARCH.md` | Modell- + Hardware-Fakten (verifiziert vs. Schätzung getrennt) |
| `docs/TRAKTOR_RE_RESEARCH.md` | Traktor/NI-Ökosystem: .tsi/.nml/Stems, HID/NHL, USB-Sniffing, § 40e UrhG |
| `docs/SPARK_RUNBOOK.md` | Hardware-Runbook: Build → Download → Server → Pi-Verbindung |
| `docs/ARCHITECTURE.md` | Mermaid-Diagramme: Deployment, Benchmark-Flow, RE-Workflow |
| `docs/VALIDATION.md` | Beweis-Log: Tests, Syntax-Checks, Integrität |

## Hardware-Fakten (Kurzform)

Details + Belege: `docs/RESEARCH.md`.

| Thema | Wert |
| :--- | :--- |
| Modell | Qwen3.8-Flash-Next — 125B gesamt / ~6B aktiv (MoE), Kontext 262k |
| Empfohlene Quant | Q4_K_M (~78 GB) oder IQ4_XS (~72 GB) — passt in 128 GB Unified |
| Erwartung Generation | ~45–65 tok/s (Bottleneck: ~273 GB/s Speicherbandbreite) — **Schätzung, auf Hardware messen** |
| Erwartung Prompt-Processing | ~800–1200 tok/s — **Schätzung, auf Hardware messen** |

## Rechtlicher Rahmen

Reverse Engineering erfolgt ausschließlich für **Interoperabilität** (§ 40e UrhG AT / Art. 6 Software-Richtlinie EU). Details: `docs/TRAKTOR_RE_RESEARCH.md` Abschnitt 6.
