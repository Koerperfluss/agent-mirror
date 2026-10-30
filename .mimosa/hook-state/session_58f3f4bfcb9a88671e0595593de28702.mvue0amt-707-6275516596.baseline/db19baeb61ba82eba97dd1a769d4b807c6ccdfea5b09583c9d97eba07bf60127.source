#!/bin/bash
set -euo pipefail

# LOKI.OS - Benchmark-Suite-Orchestrator (Pi oder Spark ausführbar)
# Health-Check -> Benchmark-Suiten -> RE-Smoke -> Markdown-Report
# Benötigt: bash, curl, python3 (Std-Lib only)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="http://localhost:8080"
RUNS=2
OUT_DIR="$SCRIPT_DIR/../out"
DRY_RUN=0
SKIP_RE=0

usage() {
    cat <<'EOF'
Verwendung: run_bench_suite.sh [--host URL] [--runs N] [--out-dir DIR] [--skip-re] [--dry-run]
  --host URL    llama-server Basis-URL (Standard: http://localhost:8080)
  --runs N      Läufe pro Benchmark-Suite (Standard: 2)
  --out-dir DIR Zielordner für JSON + Report (Standard: ../out)
  --skip-re     RE-Smoke-Test überspringen
  --dry-run     Nur anzeigen, was laufen würde (keine Netzwerk-Calls)
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --host)    HOST="$2"; shift 2 ;;
        --runs)    RUNS="$2"; shift 2 ;;
        --out-dir) OUT_DIR="$2"; shift 2 ;;
        --skip-re) SKIP_RE=1; shift ;;
        --dry-run) DRY_RUN=1; shift ;;
        -h|--help) usage ;;
        *) echo "Unbekanntes Argument: $1"; usage ;;
    esac
done

TS="$(date +%Y%m%d_%H%M%S)"
BENCH_JSON="$OUT_DIR/bench_${TS}.json"
RE_JSON="$OUT_DIR/re_smoke_${TS}.json"
REPORT_MD="$OUT_DIR/bench_report_${TS}.md"
SAMPLE_HEX="$OUT_DIR/sample_capture_${TS}.txt"

mkdir -p "$OUT_DIR"

echo "=============================================="
echo "🧪 LOKI.OS Benchmark-Suite"
echo "   Host:     $HOST"
echo "   Runs:     $RUNS"
echo "   Out-Dir:  $OUT_DIR"
echo "=============================================="

# --- 1. Abhängigkeiten ---
for bin in curl python3; do
    if ! command -v "$bin" &> /dev/null; then
        echo "❌ FEHLER: '$bin' nicht gefunden."
        exit 1
    fi
done
for py in "$SCRIPT_DIR/pi_benchmark.py" "$SCRIPT_DIR/pi_re_client.py"; do
    if [[ ! -f "$py" ]]; then
        echo "❌ FEHLER: $py fehlt."
        exit 1
    fi
done

# --- 2. Health-Check ---
health_cmd=(curl -sf --max-time 10 "${HOST%/}/health")
if [[ $DRY_RUN -eq 1 ]]; then
    echo "[DRY-RUN] Würde Health-Check ausführen: ${health_cmd[*]}"
    echo "[DRY-RUN] Würde Benchmark starten: python3 $SCRIPT_DIR/pi_benchmark.py --host $HOST --runs $RUNS --suite basic/long/traktor --json-out $BENCH_JSON"
    [[ $SKIP_RE -eq 0 ]] && echo "[DRY-RUN] Würde RE-Smoke starten: --task hid + --task format -> $RE_JSON"
    echo "[DRY-RUN] Würde Report schreiben: $REPORT_MD"
    echo "✅ DRY-RUN beendet (nichts ausgeführt)."
    exit 0
fi

echo "🩺 Health-Check ${HOST%/}/health ..."
if ! curl -sf --max-time 10 "${HOST%/}/health" > /dev/null 2>&1; then
    # Fallback: /v1/models (ältere llama-server-Versionen ohne /health)
    if ! curl -sf --max-time 10 "${HOST%/}/v1/models" > /dev/null 2>&1; then
        echo "❌ Server unter $HOST nicht erreichbar (Health + Models gefehlt)."
        echo "   Prüfe: läuft llama-server? SSH-Tunnel auf? Port 8080 offen?"
        exit 2
    fi
    echo "⚠️  /health fehlte, aber /v1/models antwortet — fahre fort."
fi
echo "✅ Server erreichbar."

# --- 3. Benchmark-Suiten ---
BENCH_ARGS=(--host "$HOST" --runs "$RUNS" --json-out "$BENCH_JSON")
echo "🏁 Benchmark: basic"
python3 "$SCRIPT_DIR/pi_benchmark.py" "${BENCH_ARGS[@]}" --suite basic
echo "🏁 Benchmark: long"
python3 "$SCRIPT_DIR/pi_benchmark.py" "${BENCH_ARGS[@]}" --suite long
echo "🏁 Benchmark: traktor"
python3 "$SCRIPT_DIR/pi_benchmark.py" "${BENCH_ARGS[@]}" --suite traktor

# --- 4. RE-Smoke ---
RE_STATUS="übersprungen"
if [[ $SKIP_RE -eq 0 ]]; then
    echo "🔎 RE-Smoke (hid + format) ..."
    cat > "$SAMPLE_HEX" <<'EOF'
01 7F 00 00 40 00 00
01 00 00 00 00 00 00
01 7F 00 00 3F 00 00
EOF
    python3 "$SCRIPT_DIR/pi_re_client.py" \
        --host "$HOST" \
        --task hid \
        --input "$SAMPLE_HEX" \
        --question "Drei Reports: Zeile 2 ist Baseline (Leerlauf). Welche Bytes kodieren den Zustand in Zeile 1 und 3? Nenne Offset + Bitmaske." \
        --output "$RE_JSON" > /dev/null
    if python3 -c "
import json,sys
d=json.load(open('$RE_JSON'))
sys.exit(0 if d.get('response') else 1)
"; then
        RE_STATUS="OK ($(wc -c < "$RE_JSON") Bytes)"
        echo "✅ RE-Smoke OK."
    else
        RE_STATUS="FEHLER (leere/ungültige Antwort)"
        echo "❌ RE-Smoke fehlgeschlagen — Details in $RE_JSON"
    fi
fi

# --- 5. Report ---
python3 - "$BENCH_JSON" "$REPORT_MD" "$HOST" "$RUNS" "$RE_STATUS" <<'PYEOF'
import json, sys, datetime
bench_path, report_path, host, runs, re_status = sys.argv[1:6]
rows = json.load(open(bench_path))
def fmt(v): return f"{v:.3f}" if isinstance(v, (int, float)) else str(v)
lines = [
    "# Benchmark-Report",
    f"",
    f"- **Zeit:** {datetime.datetime.now().isoformat(timespec='seconds')}",
    f"- **Host:** {host}",
    f"- **RE-Smoke:** {re_status}",
    f"",
    "| # | TTFT (s) | Gesamt (s) | Comp-Tokens | Prompt-Tokens | tok/s | PP tok/s |",
    "|---|---|---|---|---|---|---|",
]
for i, r in enumerate(rows, 1):
    lines.append("| {} | {} | {} | {} | {} | {} | {} |".format(
        i, fmt(r["ttft"]), fmt(r["total_time"]), r["completion_tokens"],
        r["prompt_tokens"], fmt(r["tps"]), fmt(r["pp_rate"])))
comp = [r["tps"] for r in rows if r["tps"] > 0]
pp = [r["pp_rate"] for r in rows if r["pp_rate"] > 0]
if comp: lines.append(f"\n**Generation:** Median {sorted(comp)[len(comp)//2]:.1f} tok/s")
if pp:   lines.append(f"\n**Prompt-Processing (Näherung):** Median {sorted(pp)[len(pp)//2]:.0f} tok/s")
lines.append("\n> Hinweis: PP-Rate ist eine Näherung (prompt_tokens / TTFT). Alle Werte von echter Hardware — keine Schätzung.")
open(report_path, "w").write("\n".join(lines) + "\n")
print(f"📝 Report geschrieben: {report_path}")
PYEOF

echo "=============================================="
echo "✅ Suite fertig."
echo "   Benchmark-JSON: $BENCH_JSON"
echo "   Report:         $REPORT_MD"
[[ $SKIP_RE -eq 0 ]] && echo "   RE-Smoke-JSON:  $RE_JSON"
echo "=============================================="
