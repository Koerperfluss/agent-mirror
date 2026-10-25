# Architektur: qwen-flash-spark

Drei Sichten auf das System. Alle Diagramme in Mermaid (renderbar in GitHub/Obsidian/VS Code).

## 1. Deployment: Pi ↔ Spark

```mermaid
flowchart LR
    subgraph PI["Raspberry Pi (Client)"]
        BM["pi_benchmark.py<br/>TTFT · tok/s · PP-Rate"]
        RE["pi_re_client.py<br/>Task: hid · mapping · capture · format"]
        SUITE["run_bench_suite.sh<br/>Orchestrierung"]
    end

    subgraph TUNNEL["Netz"]
        SSH["SSH-Tunnel (optional)<br/>ssh -L 8080:localhost:8080 spark"]
        LAN["LAN / HTTP :8080"]
    end

    subgraph SPARK["NVIDIA DGX Spark (GB10, aarch64)"]
        LS["llama-server<br/>--jinja --flash-attn -ngl 999<br/>OpenAI-kompatibel, SSE"]
        GGUF[("Qwen3.8-Flash-Next<br/>Q4_K_M · ~78 GB")]
        UM["128 GB Unified Memory<br/>CPU+GPU gemeinsamer Pool"]
    end

    SUITE --> BM
    SUITE --> RE
    BM --> LAN
    RE --> LAN
    LAN -.-> SSH
    SSH --> LS
    LAN --> LS
    LS --> GGUF
    GGUF --> UM
```

**Punkte:** Der Pi führt **keine Inferenz** aus — er baut nur Prompts, parst SSE-Streams und schreibt Reports. Der SSH-Tunnel ist die sichere Variante (lokal weitergereichter Port statt offenem 0.0.0.0).

## 2. Benchmark-Flow

```mermaid
flowchart TD
    A["run_bench_suite.sh --host ..."] --> B{"GET /health<br/>Server erreichbar?"}
    B -- nein --> X["❌ Abbruch mit Hinweis"]
    B -- ja --> C["Benchmark-Suiten<br/>basic · long · traktor<br/>(--runs pro Suite)"]
    C --> D["POST /v1/chat/completions<br/>stream=true · include_usage"]
    D --> E["SSE-Stream parsen:<br/>1. Chunk mit content → TTFT<br/>usage-Chunk → Tokens"]
    E --> F["pi_benchmark.py<br/>TTFT · tok/s · PP-Rate → JSON"]
    F --> G["RE-Smoke-Test:<br/>hid + format mit Beispieldaten"]
    G --> H["Report: out/bench_report.md<br/>(Metriken + RE-Antwort-Checks)"]
```

**Metrik-Definitionen:**
- **TTFT** (Time To First Token): Zeit vom Request bis zum ersten Content-Chunk.
- **tok/s** (Generation): `completion_tokens / (total_time - ttft)`.
- **PP-Rate** (Prompt Processing): `prompt_tokens / ttft` — Näherung; exakte Prefill-Zeit liefert llama-servers Usage-Feld nicht, daher als Schätzung kennzeichnen.

## 3. RE-Differential-Workflow (Traktor)

```mermaid
flowchart LR
    subgraph HARDWARE["Traktor-Kontrolle am Pi/PC"]
        H1["1. Baseline<br/>Leerlauf-Capture"]
        H2["2. Trigger<br/>Fader/Btn bewegen"]
        H3["3. Delta<br/>Trigger vs. Baseline"]
        H4["4. Scale<br/>Langsame Bewegung"]
        H5["5. Logic<br/>Shift-Kombis"]
    end

    subgraph LLM["Qwen auf der Spark (Differential-Analyst)"]
        L1["BEOBACHTUNG<br/>neutrale Daten-Zusammenfassung"]
        L2["HYPOTHESE<br/>Byte-Offset · Bitmaske · Endianness"]
        L3["VERIFIKATION<br/>nächster Test-Schritt"]
    end

    MAP["Mapping-Tabelle<br/>Control-ID → HID-Event"]

    H1 --> L1
    H2 --> L1
    L1 --> L2
    L2 -->|"Hypothese"| H3
    H3 --> L1
    H4 --> L2
    L2 -->|"Auflösung/Kurve"| MAP
    H5 --> L2
    L3 --> MAP
```

**Loop-Prinzip:** Jede LLM-Hypothese erzeugt den nächsten physischen Test am Gerät (Capture → Prompt → Hypothese → Capture …). Der Client erzwingt die Struktur BEOBACHTUNG/HYPOTHESE/VERIFIKATION über den System-Prompt in `pi_re_client.py`; Unsicherheiten sind mit `[UNSICHER]` zu markieren. Rechtsrahmen: § 40e UrhG (Interoperabilität) — siehe `TRAKTOR_RE_RESEARCH.md` Abschnitt 6.
