# Spark-Runbook: Von leeren Händen bis zum Benchmark-Report

End-to-end Checkliste für die DGX Spark. Jeder Schritt hat einen **Beweis-Befehl** — erst wenn der grün ist, weiter zum nächsten.

## Schritt 0 — Voraussetzungen prüfen

```bash
uname -m                 # erwartete Ausgabe: aarch64
nvidia-smi               # GPU muss sichtbar sein (Treiber + CUDA ok)
free -h                  # ~128 GB RAM gesamt
```

Fehlt `nvidia-smi`: NVIDIA-Treiber/CUDA-Toolkit zuerst installieren (DGX OS bringt beides mit — falls nicht: `sudo apt install nvidia-driver-xxx` gemäß NVIDIA-Doku für GB10).

## Schritt 1 — llama.cpp bauen (CUDA, aarch64)

```bash
git clone https://github.com/ggerganov/llama.cpp ~/llama.cpp
cd ~/llama.cpp
cmake -B build -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=native
cmake --build build --config Release -j$(nproc)
```

- `CMAKE_CUDA_ARCHITECTURES=native` lässt nvcc die Ziel-Architektur selbst erkennen — robuster als hardcodierte Werte.
- Beweis: `./build/bin/llama-server --version` → Versionsausgabe ohne Fehler.
- Vollständige Flags/Architektur-Fakten mit Quellen: `docs/RESEARCH.md` (Abschnitt Verifikation).

## Schritt 2 — GGUF herunterladen

Empfohlene Quant: **Q4_K_M** (~78 GB) oder **IQ4_XS** (~72 GB), Details in `RESEARCH.md`.

```bash
pip install -U "huggingface_hub[cli]"
# Repo-Name im RESEARCH.md-Verifizierungsabschnitt prüfen; Beispiel:
huggingface-cli download <UNSLOTH-GGUF-REPO> \
  <datei-q4_k_m.gguf> --local-dir ~/models/
```

Beweis: `ls -lh ~/models/*.gguf` → Dateigröße plausibel (~70–80 GB).

## Schritt 3 — Server starten

```bash
export MODEL_PATH=~/models/<datei>.gguf
export CTX=32768
export PORT=8080
export LLAMA_SERVER_BIN=~/llama.cpp/build/bin/llama-server
~/qwen-flash-spark/scripts/spark_start.sh
```

Beweis (in zweitem Terminal):

```bash
curl -s http://localhost:8080/health      # {"status":"ok"}
curl -s http://localhost:8080/v1/models   # Modellname
```

## Schritt 4 — Pi verbinden

Auf dem Pi:

```bash
ping <SPARK_IP>                                  # Netz ok
curl -s http://<SPARK_IP>:8080/health            # API direkt erreichbar?
# Sicherere Variante (Tunnel, kein offener Port):
ssh -N -L 8080:localhost:8080 user@<SPARK_IP> &
curl -s http://localhost:8080/health
```

Wenn die Direkt-Verbindung scheitert aber der Tunnel geht: Firewall auf der Spark (`sudo ufw allow 8080/tcp` oder Tunnel-only lassen — empfohlen).

## Schritt 5 — Komplett-Suite

```bash
bash scripts/run_bench_suite.sh --host http://localhost:8080 --runs 3
```

Ergebnis: `out/bench_report_<zeit>.md` mit Metriken + RE-Smoke-Status.

## Schritt 6 — Optional: systemd-Autostart

`/etc/systemd/system/qwen-spark.service` (Pfade an dein Home anpassen — Linux-Home, nicht macOS):

```ini
[Unit]
Description=Llama.cpp Qwen3.8-Flash-Next Server
After=network.target

[Service]
Type=simple
User=<linux-user>
Environment=MODEL_PATH=/home/<linux-user>/models/<datei>.gguf
Environment=LLAMA_SERVER_BIN=/home/<linux-user>/llama.cpp/build/bin/llama-server
ExecStart=/home/<linux-user>/qwen-flash-spark/scripts/spark_start.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload && sudo systemctl enable --now qwen-spark
systemctl status qwen-spark               # Beweis: active (running)
```

## Troubleshooting

| Symptom | Ursache | Fix |
| :--- | :--- | :--- |
| OOM beim Laden | Quant zu groß / CTX zu hoch | IQ4_XS statt Q5/Q8; `CTX` senken |
| `--jinja`-Template-Fehler | Chat-Template nicht geladen | `--jinja` gesetzt? GGUF enthält tokenizer_config? |
| Sehr langsames Prompt-Processing | Layer auf CPU | `GPU_LAYERS=999`, Flash-Attention an, CUDA-Build prüfen |
| Pi: Connection refused | Firewall/Tunnel | Schritt 4 wiederholen, Tunnel-Variante nutzen |
| RE-Antwort leer | max_tokens/Server überlastet | `--max-tokens` erhöhen (pi_re_client nutzt Server-Default); Server-Logs prüfen |

## Nächste Schritte nach dem ersten Report

1. Report-Werte in `docs/RESEARCH.md` Abschnitt „Messwerte (echte Hardware)" eintragen.
2. Abweichung von der Schätzung (45–65 tok/s) dokumentieren.
3. Traktor-Captures einsammeln (Workflow: `ARCHITECTURE.md` Diagramm 3) und mit `pi_re_client.py` analysieren.
