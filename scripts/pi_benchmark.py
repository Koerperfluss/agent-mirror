import json
import time
import urllib.request
import urllib.error
import argparse
import statistics
import sys

# LOKI.OS - Pi Benchmark Tool (Standard Lib Only)

def get_args():
    parser = argparse.ArgumentParser(description="llama.cpp API Benchmark für Raspberry Pi")
    parser.add_argument("--host", default="http://localhost:8080", help="API Host URL")
    parser.add_argument("--runs", type=int, default=3, help="Anzahl der Testläufe")
    parser.add_argument("--max-tokens", type=int, default=128, help="Max Completion Tokens")
    parser.add_argument("--suite", choices=["basic", "long", "traktor"], default="basic", help="Test-Suite")
    parser.add_argument("--json-out", help="Dateipfad für JSON-Output")
    return parser.parse_args()

SUITES = {
    "basic": ["Erzähle mir einen kurzen Witz über Hardware."],
    "long": ["Schreibe eine ausführliche Anleitung zur Installation von Linux auf einem Toaster."],
    "traktor": [
        "Analysiere diesen HID-Report eines DJ-Controllers: 01 7F 00 00 40 00 00. Was könnte das Byte 0x7F bedeuten?",
        "Reverse-Engineering Task: Ein USB-Capture zeigt zyklische Nachrichten alle 10ms. Erstelle eine Hypothese zum Protokollaufbau."
    ]
}

def run_benchmark(host, prompt, max_tokens):
    url = f"{host.rstrip('/')}/v1/chat/completions"
    data = {
        "model": "qwen",
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": max_tokens,
        "stream": True,
        "stream_options": {"include_usage": True}
    }
    
    headers = {"Content-Type": "application/json"}
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers)
    
    start_time = time.time()
    ttft = 0
    total_time = 0
    tokens = 0
    usage = None
    
    try:
        with urllib.request.urlopen(req) as response:
            for line in response:
                if not line.strip(): continue
                line_str = line.decode('utf-8')
                if line_str.startswith("data: "):
                    content = line_str[6:].strip()
                    if content == "[DONE]": break
                    
                    try:
                        chunk = json.loads(content)
                        if ttft == 0 and chunk.get("choices") and chunk["choices"][0].get("delta", {}).get("content"):
                            ttft = time.time() - start_time
                        
                        if chunk.get("usage"):
                            usage = chunk["usage"]
                    except json.JSONDecodeError:
                        continue
                        
        total_time = time.time() - start_time
    except Exception as e:
        print(f"❌ Fehler bei Benchmark-Lauf: {e}")
        return None

    if usage:
        comp_tokens = usage.get("completion_tokens", 0)
        prompt_tokens = usage.get("prompt_tokens", 0)
    else:
        # Fallback falls usage fehlt (grobe Schätzung)
        comp_tokens = 0 # Wir wissen es nicht genau ohne usage
        prompt_tokens = 0

    return {
        "ttft": ttft,
        "total_time": total_time,
        "completion_tokens": comp_tokens,
        "prompt_tokens": prompt_tokens,
        "tps": comp_tokens / (total_time - ttft) if (total_time - ttft) > 0 else 0,
        "pp_rate": prompt_tokens / ttft if ttft > 0 else 0
    }

def print_table(results):
    print(f"\n{'Metric':<25} | {'Min':<10} | {'Median':<10} | {'Max':<10}")
    print("-" * 65)
    metrics = ["ttft", "total_time", "completion_tokens", "tps", "pp_rate"]
    for m in metrics:
        values = [r[m] for r in results if r]
        if not values: continue
        print(f"{m:<25} | {min(values):<10.3f} | {statistics.median(values):<10.3f} | {max(values):<10.3f}")

def main():
    args = get_args()
    prompts = SUITES[args.suite]
    all_results = []

    print(f"🏁 Starte Benchmark Suite '{args.suite}' auf {args.host} ({args.runs} Läufe)")

    for i in range(args.runs):
        prompt = prompts[i % len(prompts)]
        print(f"🏃 Lauf {i+1}/{args.runs}...", end="", flush=True)
        res = run_benchmark(args.host, prompt, args.max_tokens)
        if res:
            all_results.append(res)
            print(f" OK (TTFT: {res['ttft']:.2f}s, {res['tps']:.1f} tok/s)")
        else:
            print(" FAILED")

    if all_results:
        print_table(all_results)
        if args.json_out:
            with open(args.json_out, 'w') as f:
                json.dump(all_results, f, indent=2)
            print(f"\n💾 Ergebnisse in {args.json_out} gespeichert.")

if __name__ == "__main__":
    main()
