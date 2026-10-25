#!/bin/bash
set -euo pipefail

# LOKI.OS - Qwen Flash Spark Start Script
# Optimiert für NVIDIA DGX Spark (aarch64) mit llama.cpp

# Default Konfiguration
MODEL_PATH="${MODEL_PATH:-}"
CTX="${CTX:-32768}"
PORT="${PORT:-8080}"
GPU_LAYERS="${GPU_LAYERS:-999}"
LLAMA_SERVER_BIN="${LLAMA_SERVER_BIN:-llama-server}"
EXTRA_ARGS="${EXTRA_ARGS:-}"

echo "--------------------------------------------------"
echo "🚀 LOKI.OS Qwen-Flash-Spark Initialisierung"
echo "--------------------------------------------------"

# 1. Vorab-Checks
if [[ -z "$MODEL_PATH" ]]; then
    echo "❌ FEHLER: MODEL_PATH ist nicht gesetzt."
    exit 1
fi

if ! command -v "$LLAMA_SERVER_BIN" &> /dev/null; then
    echo "❌ FEHLER: Binary '$LLAMA_SERVER_BIN' nicht gefunden."
    exit 1
fi

if [[ ! -f "$MODEL_PATH" ]]; then
    echo "❌ FEHLER: Modelldatei '$MODEL_PATH' existiert nicht."
    exit 1
fi

# Grober RAM-Check (DGX Spark hat 128GB Unified RAM)
FREE_RAM_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
FREE_RAM_GB=$((FREE_RAM_KB / 1024 / 1024))

echo "📊 System-Check:"
echo "   - Binary: $LLAMA_SERVER_BIN"
echo "   - Modell: $MODEL_PATH"
echo "   - Freier RAM: ~${FREE_RAM_GB} GB"

if [ "$FREE_RAM_GB" -lt 16 ]; then
    echo "⚠️ WARNUNG: Wenig freier RAM ($FREE_RAM_GB GB). Start könnte fehlschlagen."
fi

# 2. Start-Konfiguration anzeigen
echo "⚙️ Effektive Konfiguration:"
echo "   - Port:       $PORT"
echo "   - Kontext:    $CTX"
echo "   - GPU-Layers: $GPU_LAYERS"
echo "   - Flash-Attn: Aktiviert"
echo "   - Host:       0.0.0.0"

# 3. Server-Start
# --jinja wird für Qwen3/ChatML Templates benötigt
exec "$LLAMA_SERVER_BIN" \
    --model "$MODEL_PATH" \
    --ctx-size "$CTX" \
    --port "$PORT" \
    --n-gpu-layers "$GPU_LAYERS" \
    --flash-attn \
    --jinja \
    --host 0.0.0.0 \
    $EXTRA_ARGS
