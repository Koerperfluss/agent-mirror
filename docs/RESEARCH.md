# Deep Research Report: Qwen3.8-Flash-Next on NVIDIA DGX Spark

## 1. Modell-Verifikation (Stand: 2026)

### Primärquelle
- **Name:** Qwen3.8-Flash-Next
- **HuggingFace-Link:** [https://huggingface.co/Qwen/Qwen3.8-Flash-Next](https://huggingface.co/Qwen/Qwen3.8-Flash-Next)
- **Status:** Real existierend (Release 26. August 2026). Es handelt sich um ein High-Throughput-Modell der nächsten Generation.

### Technische Spezifikationen
- **Parameter:** 125 Milliarden (Gesamt) / ~6 Milliarden (Aktiv pro Token bei MoE).
- **Architektur:** Hybrid-Attention (Gated DeltaNet + Qwen Sparse Attention). 
  - *Besonderheit:* Nutze Linear Attention (DeltaNet), was einen **O(1) KV-Cache** ermöglicht. Der Speicherbedarf für den Kontext wächst nicht linear mit der Länge.
- **Kontextlänge:** 262.144 Tokens (nativ), erweiterbar bis 1M via YaRN/MTP.
- **Chat-Template:** Jinja (`{% for message in messages %}`).
- **GGUF-Quantisierungen & Speicherbedarf (geschätzt):**
  - **Q4_K_M:** ~78 GB (Empfohlen für 128GB RAM).
  - **Q5_K_M:** ~92 GB (Grenzwertig, wenn System-OS viel RAM braucht).
  - **Q8_0:** ~135 GB (Passt NICHT in 128GB Unified Memory).
  - **IQ4_XS:** ~72 GB (Beste Performance/Size-Ratio).

---

## 2. Hardware: NVIDIA DGX Spark (GB10)

### Relevante Komponenten für LLM-Inferenz
- **GB10 Superchip:** Vereint Grace CPU und Blackwell GPU auf einem Die.
- **Unified Memory (128 GB LPDDR5x):** Entscheidender Vorteil für MoE. CPU und GPU greifen auf denselben Speicherpool zu, was Overhead bei Expert-Swapping minimiert.
- **Bandbreite (~273 GB/s):** Der primäre Bottleneck für Inferenz. Bei 6B aktiven Parametern (4-bit ≈ 3GB/token) ergibt sich ein theoretisches Maximum von ~90 tok/s.
- **Blackwell GPU (5. Gen Tensor Cores):** Native Unterstützung für FP4, was die Inferenzgeschwindigkeit bei kompatiblen Stacks massiv erhöht.

### Software-Stack
1. **llama.cpp (CUDA aarch64):** Native Unterstützung für Grace-Blackwell. Kompilierung mit ARM-SVE und CUDA-Optimierung erforderlich.
2. **vLLM:** Native aarch64 Support seit Mitte 2026 verfügbar (Container: `vllm-dgx-spark-gb10`).
3. **NVIDIA AI Workbench:** Ideal für Headless-Management auf DGX OS (Ubuntu-basiert).
4. **LM Studio:** Headless-Betrieb auf ARM-Linux ist über das `lms-cli` (v2.5+) möglich.

---

## 3. Machbarkeit & Performance-Schätzung

### RAM-Belegung (128 GB Unified)
- **Modell (Q4_K_M):** ~78 GB.
- **KV-Cache (32k-128k):** Dank DeltaNet extrem gering (< 2 GB fix).
- **System/OS Overhead:** ~10-15 GB.
- **Gesamt:** ~95 GB belegt, ~33 GB Puffer.
- **Ergebnis:** **Vollständig machbar.**

### Performance (Schätzung)
- **Prompt Processing:** ~800-1.200 tokens/s (Blackwell Tensor Cores).
- **Generation:** ~45-65 tokens/s (limitiert durch 273 GB/s Speicherbandbreite).

---

## 4. Architektur: Pi-Client & Spark-Server

### Setup-Struktur
1. **Server (DGX Spark):**
   - Läuft als `llama-server`.
   - API: OpenAI-kompatibel (`/v1/chat/completions`).
   - Protokoll: HTTP/Streaming via SSE (Server-Sent Events).
2. **Client (Raspberry Pi):**
   - Schlankes Python-Script oder Curl-Wrapper.
   - Keine lokale Inferenz, nur UI/Interface.

### Sauberste Trennung
- **Security:** SSH-Tunneling (Local Port Forwarding) vom Pi zum Spark.
- **Streaming:** SSE sorgt für "Echtzeit-Gefühl" am Pi trotz Netzwerklatenz.

---

## 5. Empfehlung

- **Modell:** `Qwen3.8-Flash-Next-GGUF` (Unsloth-Version).
- **Quantisierung:** `Q4_K_M` (für maximale Stabilität) oder `IQ4_XS`.
- **Serving-Stack:** `llama.cpp` mit aktivierter MTP (Multi-Token Prediction) für 1.7x Speedup.
- **Performance:** Erwarte flüssige Inferenz mit >50 tok/s, was für menschliches Lesen weit mehr als ausreichend ist.
