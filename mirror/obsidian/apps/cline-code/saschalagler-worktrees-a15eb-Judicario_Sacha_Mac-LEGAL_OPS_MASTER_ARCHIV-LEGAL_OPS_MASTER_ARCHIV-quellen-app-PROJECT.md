---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/PROJECT.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Project: Legal Ops Advisor

## Architecture
The application is a standalone macOS desktop application that bundles a FastAPI backend serving as a middleware to coordinate RAG (Retrieval-Augmented Generation) and personas query analysis, coupled with a PyWebView frontend and a local/remote LLM backend.

### Key Components:
1. **Frontend (HTML/JS/CSS)**: An interactive single-page app displaying legal persona selectors, query inputs, response windows, document upload zones, and ad-hoc ingestion statuses.
2. **PyWebView Wrapper (`desktop_app.py`)**: Integrates the Python-based FastAPI backend and starts a native macOS window pointing to it. It is also responsible for verifying and launching dependencies (like FastAPI).
3. **FastAPI Backend (`app.py`)**: Defines REST endpoints (`/health`, `/personas`, `/upload`, `/ingest_paths`, `/db_stats`, `/query`). Connects to SQLite RAG storage and coordinates query routing to local/remote LLMs.
4. **SQLite RAG Engine (`indexer.py`)**: Indexes documents (PDF, txt, md, etc.) into chunks, stores them in SQLite, and exposes FTS5-based query capabilities.
5. **LLM Server (Ollama)**: Local model server executing `qwen2.5-coder:14b` (primary) and `deepseek-coder` (fallback) on port 11434. Gemini Cloud API acts as the final fallback.

## Code Layout
- `app.py`: FastAPI application server
- `desktop_app.py`: Desktop application wrapper using `webview`
- `indexer.py`: Text parser, PDF text extractor, chunker, database manager
- `index.html`: Desktop web UI
- `prompts/`: Directory containing persona system prompts (`legal_ops_omni.txt`, `gdb_analyst.txt`, `vwgh_researcher.txt`, `compliance.txt`)
- `tests/`: Directory for tests (Tiers 1-4, designed and run by E2E track)

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Automatic Startup Fix | Verify/launch FastAPI (7070) automatically from `desktop_app.py` in standalone mode | None | PLANNED |
| 2 | RAG & Persona Verification | Test and fix `/upload`, `/ingest_paths`, ad-hoc directory ingestion, search interceptor (`@web`), and persona query routing | M1 | PLANNED |
| 3 | E2E Test Suite | Implement Category-Partition / boundary testing for all features (Tiers 1-4) in a standalone test runner | None | PLANNED |
| 4 | Final Verification | Verify application correctness using the E2E test suite and run adversarial coverage tests (Tier 5) | M1, M2, M3 | PLANNED |

## Interface Contracts
### PyWebView / FastAPI Launcher ↔ FastAPI Backend (`app.py`)
- FastAPI runs on `127.0.0.1:7070`.
- Health endpoint: `GET /health` -> Returns `{"status": "ok", "backend": "...", "model": "...", "personas": [...]}`

### FastAPI Backend ↔ Ollama Model Server
- Endpoint: `POST http://localhost:11434/v1/chat/completions`
- Payload: `{"model": "qwen2.5-coder:14b", "messages": [{"role": "system", "content": "..."}, {"role": "user", "content": "..."}], "max_tokens": 1024}`
- Fallback 1: `deepseek-coder` via Ollama
- Fallback 2: Gemini Cloud API via `https://generativelanguage.googleapis.com/...`

### SQLite Schema (`indexer.py` ↔ `app.py`)
- Files table: `files(id INTEGER PRIMARY KEY, filepath TEXT UNIQUE, filename TEXT, mtime REAL, chunk_count INTEGER)`
- Chunks table: `chunks(id INTEGER PRIMARY KEY, file_id INTEGER, content TEXT, chunk_index INTEGER)`
- FTS5 table: `chunks_fts USING fts5(content, content='chunks', content_rowid='id')`
