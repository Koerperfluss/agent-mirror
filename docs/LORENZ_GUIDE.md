# LORENZ-GUIDE: Qwen auf dem DGX Spark nutzen (via Claude auf deinem Rechner)

**Für wen:** Lorenz (oder jeder mit Zugang zum DGX Spark + einem Rechner mit Claude Code / ZCode).
**Ziel:** In 30 Minuten von null zu einem laufenden Qwen3.8-Flash-Next-Server mit Benchmark-Report.

## Was du hast / brauchst

| Rolle | Gerät | Benötigt |
| :--- | :--- | :--- |
| **Server** | NVIDIA DGX Spark (GB10, 128 GB, Linux aarch64) | ~150 GB freie Disk, Internet für Download |
| **Client** | Dein Rechner (Linux/macOS; Raspberry Pi optional) | `git`, `python3` (≥3.8), `curl`, Claude Code |
| **Netz** | Beide im selben LAN | Port 8080 erreichbar ODER SSH-Zunnel |

## Schritt 1 — Repo holen (auf beiden Geräten)

```bash
git clone https://github.com/Koerperfluss/agent-mirror.git
cd agent-mirror
git checkout cline/s4sx83cs
cd qwen-flash-spark
```

## Schritt 2 — Claude das Setup treiben lassen (auf deinem Rechner)

Öffne Claude Code im Repo-Ordner und sag:

> Lies `qwen-flash-spark/docs/SPARK_RUNBOOK.md` und `docs/SETUP_GUIDE.md`.
> Führe mich Schritt für Schritt durch die Installation auf dem DGX Spark
> (SSH-Zugang: <user>@<spark-ip>). Prüfe jeden Schritt, bevor wir weitermachen.

Claude kennt dann alle Befehle aus dem Runbook — du musst nichts auswendig lernen.

## Schritt 3 — Server bauen + starten (auf der Spark, via SSH)

```bash
# llama.cpp mit CUDA bauen (einmalig, ~20 min)
cmake -B build -DGGML_CUDA=ON && cmake --build build --config Release -j$(nproc)

# Modell laden (111 GB! UD-Q4_K_XL aus unsloth/Qwen3.8-Flash-Next-GGUF)
huggingface-cli download unsloth/Qwen3.8-Flash-Next-GGUF \
  --include "*UD-Q4_K_XL*" --local-dir ~/models/

# Server starten (empfohlene GB10-Flags sind im Skript dokumentiert)
MODEL_PATH=~/models/<erster-shard>.gguf CTX=32768 \
  EXTRA_ARGS="-ub 2048 -b 2048 --no-mmap" \
  ./scripts/spark_start.sh
```

Beweis: `curl http://localhost:8080/health` → `{"status":"ok"}`

## Schritt 4 — Benchmark + RE-Smoke (auf deinem Rechner/Pi)

```bash
bash scripts/run_bench_suite.sh --host http://<spark-ip>:8080 --runs 3
```

Ergebnis: `out/bench_report_<zeit>.md` mit echten tok/s-Werten.

Wichtig: Die Clients blocken private LAN-Adressen als SSRF-Schutz. Für die
eigene Spark im LAN einmalig freischalten:

```bash
export QFS_ALLOW_LAN=1        # oder pro Aufruf --allow-lan
```

## Schritt 5 — Traktor-RE nutzen

```bash
export QFS_ALLOW_LAN=1
python3 scripts/pi_re_client.py --host http://<spark-ip>:8080 \
  --task mapping --input ~/Dokumente/"Traktor Settings.tsi" \
  --question "Liste alle Audio- und Device-Einträge als Tabelle" \
  --output analyse.json
```

Tasks: `hid` (USB-Reports) · `mapping` (.tsi/.nml-XML) · `capture` (USB-Mitschnitt) · `format` (Hexdumps) · `codegen` (Swift/Python-Code generieren) · `rebuild` (Prüfblatt-/FEATURES.json-Analyse nach der RE-Methodik)

## Traktor-Clone entwickeln (die eigentliche Mission)

Das Repo folgt einem **Arbeitsvertrag** (`AGENTS.md` im Root) + der **RE-Methodik** (`docs/RE_METHODOLOGY.md`, aus Saschas PDFs destilliert). Claude so starten:

> Lies `AGENTS.md` und `docs/RE_METHODOLOGY.md`. Beginne mit Phase 1: Erstelle `rebuild/FEATURES.json` mit dem vollständigen Funktionsinventar von Traktor Pro 4.5 (Decks, Mixer, Effekte, Browser, Recording). Nutze `scripts/pi_re_client.py --task rebuild` für Analysen gegen den Qwen-Server auf der Spark.

Regeln, die gelten: keine Mocks als „fertig", Fortschritt in `rebuild/STATE.md`, Abschluss erst wenn das Gate in `AGENTS.md` erfüllt ist.

## Troubleshooting (kurz)

| Problem | Lösung |
| :--- | :--- |
| `unsupported architecture` | llama.cpp zu alt → neu bauen (Support seit PR #16095/#17584) |
| OOM beim Laden | UD-IQ4_XS statt UD-Q4_K_XL; CTX senken |
| Connection refused | `QFS_ALLOW_LAN=1` gesetzt? SSH-Tunnel: `ssh -N -L 8080:localhost:8080 spark` |
| Kaputtes Chat-Format | `--jinja` fehlt (steht im spark_start.sh) |

Rechtsrahmen: RE nur zur Interoperabilität (§ 40e UrhG AT / Art. 6 RL 2009/24/EG) — siehe `TRAKTOR_RE_RESEARCH.md`.
