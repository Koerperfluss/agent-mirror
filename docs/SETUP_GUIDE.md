# Setup Guide: Qwen-Flash-Spark (DGX Spark + Raspberry Pi)

Dieser Guide beschreibt die Einrichtung des Qwen3-LLM Servers auf einem NVIDIA DGX Spark (aarch64) und die Nutzung via Raspberry Pi.

## 1. llama.cpp auf DGX Spark bauen

Da der Spark auf `aarch64` Linux läuft, muss `llama.cpp` mit CUDA-Support für ARM optimiert werden.

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
mkdir build && cd build

# CMake für ARM + CUDA (NVIDIA Jetson/Spark Architektur)
cmake .. -DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=87 # 87 ist typisch für Jetson Orin / Spark
cmake --build . --config Release -j$(nproc)
```

Das Binary `llama-server` sollte nun im `bin/` Ordner liegen.

## 2. Modell-Download (GGUF)

Qwen3-Modelle (z.B. Qwen2.5-Coder oder Qwen3-Preview) als GGUF von HuggingFace beziehen.

```bash
# Beispiel für 32B Modell (passt gut in 128GB RAM bei hoher Quantisierung)
huggingface-cli download Qwen/Qwen2.5-Coder-32B-Instruct-GGUF qwen2.5-coder-32b-instruct-q4_k_m.gguf --local-dir models/
```

## 3. Server-Start

Nutze das bereitgestellte Skript:

```bash
export MODEL_PATH="/Users/saschalagler/qwen-flash-spark/models/qwen3.gguf"
/Users/saschalagler/qwen-flash-spark/scripts/spark_start.sh
```

## 4. Konfigurations-Matrix (Empfehlungen)

| Modell-Größe | Quantisierung | RAM Bedarf | Kontext | Speed (Spark) |
| :--- | :--- | :--- | :--- | :--- |
| 7B | Q8_0 | ~8 GB | 128k | ~80 tok/s |
| 14B | Q6_K | ~12 GB | 64k | ~50 tok/s |
| 32B | Q4_K_M | ~20 GB | 32k | ~30 tok/s |
| 72B | Q4_K_M | ~45 GB | 16k | ~15 tok/s |

## 5. Netzwerk-Setup (Pi <-> Spark)

1. **IP-Adresse:** Finde die IP des Spark (`ip addr show`).
2. **Ping-Test:** Vom Pi aus: `ping <SPARK_IP>`.
3. **Port-Check:** `telnet <SPARK_IP> 8080`.

## 6. Autostart via systemd

Erstelle `/etc/systemd/system/qwen-spark.service`:

```ini
[Unit]
Description=Llama.cpp Server for Qwen
After=network.target

[Service]
Type=simple
User=saschalagler
Environment=MODEL_PATH=/Users/saschalagler/qwen-flash-spark/models/qwen3.gguf
ExecStart=/Users/saschalagler/qwen-flash-spark/scripts/spark_start.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

## 7. Troubleshooting

- **OOM (Out of Memory):** Reduziere `CTX` oder wähle eine höhere Quantisierung (z.B. `Q4_0`).
- **Langsames Prompt-Processing:** Stelle sicher, dass `--flash-attn` im Skript aktiv ist und alle Layer auf die GPU geladen werden (`GPU_LAYERS=999`).
- **Jinja-Fehler:** Qwen3 benötigt das `--jinja` Flag für korrektes Chat-Templating.
