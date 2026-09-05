---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/quellen-app/.agents/teamwork_preview_explorer_m1_1/analysis.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Milestone 1: Technical Analysis & Migration Plan for legal-ops-advisor Deployment

**Author**: `teamwork_preview_explorer_m1_1`  
**Date**: 2026-07-21  
**Project**: `legal-ops-advisor` (`/Users/saschalagler/legal-ops-advisor`)  
**Target GCP Project**: `gen-lang-client-0285074833`  
**Target Region**: `europe-west3` (Frankfurt)  
**Target Service**: `legal-ops-backend` (Cloud Run)  

---

## 1. Executive Summary

`legal-ops-advisor` is an Enterprise Legal OS backend built with FastAPI, SQLite FTS5 RAG indexing (`legal_knowledge.db`), Vertex AI Enterprise Search integration (`enterprise_rag.py`), and multi-persona prompt orchestration (`prompts/`). 

Currently, the service runs as a local macOS desktop app relying on a local **Ollama** server (`http://localhost:11434`, model `gemma4:12b`), local file watching on `/Users/saschalagler/Desktop`, and macOS-specific memory monitoring (`vm_stat`). 

This analysis details the exact architecture, required code refactoring, containerization specifications, and Cloud Run deployment steps to transition `legal-ops-advisor` to a serverless Google Cloud Run deployment using `gemini-1.5-pro` via the official `google-genai` SDK.

---

## 2. Current Codebase Analysis

### 2.1 Component Overview

| Component | File Path | Current Responsibility | Cloud Run Suitability |
|---|---|---|---|
| **FastAPI Backend** | `app.py` (25.4 KB, 607 lines) | Serves endpoints (`/health`, `/query`, `/upload`, `/ingest_paths`, `/db_stats`, `/personas`), orchestrates LLM queries, handles CORS & desktop startup hooks. | Requires refactoring: remove Ollama/macOS desktop hooks, implement `google-genai` SDK, read `PORT` env var. |
| **RAG Hybrid Engine** | `enterprise_rag.py` (3.2 KB, 77 lines) | Queries Google Cloud Vertex AI Search (`discoveryengine_v1`) as primary, falls back to `indexer.py` SQLite FTS5 search. | Highly suitable. Native GCP integration; fallback works seamlessly once `indexer.py` DB path is updated. |
| **Local Indexer** | `indexer.py` (8.0 KB, 245 lines) | Manages SQLite FTS5 database (`legal_knowledge.db`), text extraction (PDF via PyPDF2, text/md/csv), chunking, and full-text search. | Requires 1 line change: make `DB_PATH` configurable via `LEGAL_DB_PATH` env var or relative directory `./legal_knowledge.db`. |
| **RAG Knowledge Base** | `legal_knowledge.db` (2.4 MB) | SQLite database with pre-indexed legal document chunks (`files`, `chunks`, `chunks_fts`). | Bundled directly into Docker container image at `/app/legal_knowledge.db`. |
| **System Prompts** | `prompts/*.txt` (4 files) | Domain personas: `legal_ops_omni.txt`, `gdb_analyst.txt`, `vwgh_researcher.txt`, `compliance.txt`. | Bundled directly into `/app/prompts/`. |
| **Dependencies** | `requirements.txt` (9 lines) | Lists `fastapi`, `uvicorn`, `requests`, `pydantic`, `PyPDF2`, `duckduckgo_search`, `python-multipart`, `pywebview`. | Needs updates: replace `pywebview` with `google-genai` and `google-cloud-discoveryengine`. |

### 2.2 Detailed Query & RAG Workflow in `app.py`

1. **Incoming Request**: Client posts `LegalQuery(message, persona, max_tokens)` to `/query`.
2. **RAM & Desktop Checks**:
   - Executes `get_free_ram_mb()` via `subprocess.check_output(["vm_stat"])` (fails on Linux/Docker).
   - Scans `/Users/saschalagler/Desktop` for ad-hoc paths (non-existent in container).
3. **Persona Router**:
   - Sends query to `call_gemini_cloud(router_prompt, req.message)` using raw REST API (`generativelanguage.googleapis.com/v1beta`).
   - Determines selected personas (e.g. `["legal", "gdb"]`).
4. **RAG Retrieval**:
   - Calls `enterprise_rag.hybrid_enterprise_search(search_terms, top_k=3)`.
   - Attempts Vertex AI Search; if unavailable, falls back to `indexer.search_index(search_terms, limit=3)` querying `~/.legal-ops-advisor/legal_knowledge.db`.
   - Formats matched document chunks and prepends context to `final_message`.
5. **LLM Inference**:
   - Currently attempts `call_local_llm()` posting to `http://localhost:11434/v1/chat/completions` (Ollama).
   - If input > 8000 tokens or Ollama fails, attempts legacy direct REST API `call_gemini_cloud()` (`gemini-1.5-flash`).

---

## 3. Exact Code Changes Required

### 3.1 Migration to Google GenAI SDK (`google-genai` / `gemini-1.5-pro`)

Replace local Ollama dispatch and direct REST API calls in `app.py` with the official Google GenAI SDK (`google-genai`).

#### New SDK Initialization & LLM Invocations in `app.py`:

```python
import os
import logging
from typing import Optional
from google import genai
from google.genai import types

log = logging.getLogger("LegalOps")

# Initialize Gemini Client (reads GEMINI_API_KEY or GOOGLE_API_KEY from environment, or ADC)
def get_genai_client() -> genai.Client:
    api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
    if api_key:
        return genai.Client(api_key=api_key)
    # Fallback to Google Cloud Application Default Credentials (ADC) on Cloud Run
    return genai.Client()

def call_gemini_pro(system_prompt: str, user_message: str, max_tokens: Optional[int] = 4096) -> dict:
    """
    Executes inference using Gemini 1.5 Pro via official google-genai SDK.
    """
    try:
        client = get_genai_client()
        response = client.models.generate_content(
            model="gemini-1.5-pro",
            contents=user_message,
            config=types.GenerateContentConfig(
                system_instruction=system_prompt,
                temperature=0.2,
                max_output_tokens=max_tokens or 4096,
            )
        )
        return {
            "response": response.text,
            "backend": "google-genai (gemini-1.5-pro)",
            "status": "ok"
        }
    except Exception as e:
        log.error(f"Gemini 1.5 Pro execution failed: {e}")
        return {
            "response": f"Fehler bei der KI-Generierung (Gemini 1.5 Pro): {str(e)}",
            "backend": "error",
            "status": "error"
        }
```

---

### 3.2 Output Format Enforcement ("Enterprise Legal OS" 3-Part Markdown)

To guarantee that responses strictly preserve the 3-part Markdown structure:

```markdown
### 1. Sachverhalt
### 2. Würdigung
### 3. Aktionsplan
```

We add an explicit system format mandate in `app.py` when loading prompts or building system instructions:

```python
STRICT_LEGAL_FORMAT_INSTRUCTION = """

[STRICT OUTPUT FORMAT MANDATE]
Du musst deine Antwort auf rechtliche Prüfungen und Fallanalysen IMMER in der folgenden dreiteiligen Markdown-Struktur gliedern:

### 1. Sachverhalt
[Zusammenfassung der Fakten, Ausgangslage, relevanter Dokumente und Annahmen]

### 2. Würdigung
[Rechtliche Subsumtion nach österreichischem/DACH Recht, anzuwendende Normen, Judikatur (VwGH/OGH/VfGH) und Risikobewertung]

### 3. Aktionsplan
[Konkrete, priorisierte Handlungsschritte, Fristen, erforderliche Formulare und E-Government Portal-Routing]

Verwende exakt diese drei Abschnitte mit den Überschriften '### 1. Sachverhalt', '### 2. Würdigung' und '### 3. Aktionsplan'.
"""

def load_prompt(persona: str) -> str:
    filename = PERSONAS.get(persona, "legal_ops_omni.txt")
    path = PROMPTS_DIR / filename
    base_prompt = ""
    if path.exists():
        base_prompt = path.read_text(encoding="utf-8")
    else:
        base_prompt = "Du bist ein juristischer Assistent für österreichisches und DACH Recht."
    
    return base_prompt + "\n" + STRICT_LEGAL_FORMAT_INSTRUCTION
```

---

### 3.3 Loading and Querying `legal_knowledge.db` from Container Filesystem

In `indexer.py`, update `DB_PATH` resolving logic so it checks `LEGAL_DB_PATH` environment variable or local project directory first, before falling back to home directory:

#### Code Change in `indexer.py`:

```python
# Before:
# DB_DIR = Path.home() / ".legal-ops-advisor"
# DB_DIR.mkdir(parents=True, exist_ok=True)
# DB_PATH = DB_DIR / "legal_knowledge.db"

# After:
ENV_DB_PATH = os.environ.get("LEGAL_DB_PATH")
if ENV_DB_PATH:
    DB_PATH = Path(ENV_DB_PATH)
elif (Path(__file__).parent / "legal_knowledge.db").exists():
    DB_PATH = Path(__file__).parent / "legal_knowledge.db"
else:
    DB_DIR = Path.home() / ".legal-ops-advisor"
    DB_DIR.mkdir(parents=True, exist_ok=True)
    DB_PATH = DB_DIR / "legal_knowledge.db"
```

#### Safe SQLite Connection Handling:
In `indexer.py`:
```python
def get_db():
    conn = sqlite3.connect(str(DB_PATH.resolve()), timeout=30.0)
    try:
        conn.execute("PRAGMA journal_mode=WAL;")
    except sqlite3.OperationalError:
        pass  # In read-only filesystems WAL mode setting is gracefully bypassed
    conn.execute("PRAGMA busy_timeout=5000;")
    conn.row_factory = sqlite3.Row
    return conn
```

---

### 3.4 Handling PORT env var, CORS, and Removing Desktop Hooks

1. **CORS Headers**: Allow all origins (or Firebase Hosting domain `https://*.web.app`):
   ```python
   app.add_middleware(
       CORSMiddleware,
       allow_origins=["*"],
       allow_credentials=True,
       allow_methods=["*"],
       allow_headers=["*"],
   )
   ```
2. **Cloud Run PORT Variable**:
   In `app.py`:
   ```python
   if __name__ == "__main__":
       import uvicorn
       port = int(os.environ.get("PORT", 8080))
       uvicorn.run("app:app", host="0.0.0.0", port=port)
   ```
3. **Remove / Bypass macOS Desktop Hooks**:
   - Conditional check in `start_watcher()`:
     ```python
     @app.on_event("startup")
     def start_watcher():
         # Bypass watchdog in container/Cloud Run environments
         if os.environ.get("K_SERVICE") or not Path("/Users/saschalagler/Desktop").exists():
             log.info("Cloud Run container environment detected. Skipping desktop file watcher.")
             return
         # ... existing desktop watcher code ...
     ```
   - Update `get_free_ram_mb()`:
     ```python
     def get_free_ram_mb() -> int:
         # Cloud Run provides container-allocated RAM; return safe standard 4096 MB
         if os.environ.get("K_SERVICE") or not os.path.exists("/usr/bin/vm_stat"):
             return 4096
         # ... fallback to vm_stat ...
     ```
4. **Health Check Endpoint (`/health`) Update**:
   ```python
   @app.get("/health")
   def health():
       return {
           "status": "ok",
           "backend": "Google Cloud Run (Gemini 1.5 Pro)",
           "engine": "google-genai",
           "model": "gemini-1.5-pro",
           "personas": list(PERSONAS.keys()),
           "db_path": str(indexer.DB_PATH)
       }
   ```

---

## 4. Containerization Design (`Dockerfile` and `requirements.txt`)

### 4.1 Production `requirements.txt`

```text
fastapi==0.110.0
uvicorn[standard]==0.28.0
requests==2.31.0
pydantic==2.6.4
PyPDF2==3.0.1
duckduckgo_search==5.0
python-multipart==0.0.9
google-genai>=0.1.1
google-cloud-discoveryengine>=0.11.0
```

### 4.2 Production `Dockerfile`

```dockerfile
# Use official python 3.11 slim image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8080 \
    LEGAL_DB_PATH=/app/legal_knowledge.db \
    RESOURCEPATH=/app

WORKDIR /app

# Install system utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app.py indexer.py enterprise_rag.py ./
COPY prompts/ ./prompts/
COPY index.html ./
COPY legal_knowledge.db ./legal_knowledge.db

# Expose target port
EXPOSE 8080

# Launch server via Uvicorn
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port ${PORT:-8080}"]
```

---

## 5. Exact `gcloud` Deployment Command

Execute from project root `/Users/saschalagler/legal-ops-advisor`:

```bash
gcloud run deploy legal-ops-backend \
  --source . \
  --region europe-west3 \
  --project gen-lang-client-0285074833 \
  --allow-unauthenticated \
  --set-env-vars "GCP_PROJECT_ID=gen-lang-client-0285074833,GCP_LOCATION=global,VERTEX_DATASTORE_ID=legal-enterprise-datastore,LEGAL_DB_PATH=/app/legal_knowledge.db" \
  --set-secrets "GEMINI_API_KEY=GEMINI_API_KEY:latest" \
  --memory 2Gi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10 \
  --timeout 300
```

*Note*: If `GEMINI_API_KEY` is passed directly as environment variable (without Secret Manager):
```bash
gcloud run deploy legal-ops-backend \
  --source . \
  --region europe-west3 \
  --project gen-lang-client-0285074833 \
  --allow-unauthenticated \
  --set-env-vars "GEMINI_API_KEY=<YOUR_GEMINI_API_KEY>,GCP_PROJECT_ID=gen-lang-client-0285074833,LEGAL_DB_PATH=/app/legal_knowledge.db" \
  --memory 2Gi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10 \
  --timeout 300
```

---

## 6. Summary of Target State Architecture

```
[ Frontend / Client (Firebase / Web UI / API) ]
                      │
                      ▼ HTTPS (CORS Allowed: *)
[ Cloud Run: legal-ops-backend (europe-west3) ]
  ├── PORT: 8080 (uvicorn app:app)
  ├── Environment: LEGAL_DB_PATH=/app/legal_knowledge.db
  ├── RAG Layer:
  │    ├── 1. Vertex AI Enterprise Search (discoveryengine_v1)
  │    └── 2. Local SQLite FTS5 Fallback (/app/legal_knowledge.db)
  └── LLM Inference Layer:
       └── Google GenAI SDK -> gemini-1.5-pro
            └── Enforced Format:
                 ### 1. Sachverhalt
                 ### 2. Würdigung
                 ### 3. Aktionsplan
```

---

## 7. Verification Method

1. **Local Docker Container Verification**:
   ```bash
   docker build -t legal-ops-backend .
   docker run -p 8080:8080 -e GEMINI_API_KEY="$GEMINI_API_KEY" legal-ops-backend
   ```
2. **Health Check Verification**:
   ```bash
   curl -s http://localhost:8080/health | jq .
   ```
3. **Query & Format Verification**:
   ```bash
   curl -X POST http://localhost:8080/query \
     -H "Content-Type: application/json" \
     -d '{"message": "Wie ist ein Dienstdienstverhältnis nach § 1151 ABGB zu kündigen?", "persona": "legal"}'
   ```
   Verify response contains `### 1. Sachverhalt`, `### 2. Würdigung`, and `### 3. Aktionsplan`.

4. **Cloud Run Deployment Verification**:
   Run `gcloud run deploy ...` command, obtain Service URL (e.g. `https://legal-ops-backend-xxxx-ew.a.run.app`), and test `/health` and `/query`.
