# Handoff Report — legal-ops-advisor Cloud Run Deployment (Milestone 1)

**Role**: `teamwork_preview_explorer`  
**Working Directory**: `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m1_1`  
**Target Directory**: `/Users/saschalagler/legal-ops-advisor`  
**Type**: Soft Handoff  

---

## 1. Observation

Direct code observations from codebase inspection:

1. **`app.py`**:
   - Lines 25-28: `OLLAMA_URL = "http://localhost:11434/v1/chat/completions"`, `OLLAMA_PRIMARY_MODEL = "gemma4:12b"`.
   - Lines 52-76: `get_free_ram_mb()` executes `subprocess.check_output(["vm_stat"])` which relies on macOS CLI binary.
   - Lines 108-139: `@app.on_event("startup")` initializes `watchdog.Observer` watching `/Users/saschalagler/Desktop`.
   - Lines 188-209: `call_gemini_cloud()` executes direct HTTP POST requests to `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent`.
   - Lines 214-270: `call_local_llm()` primary execution sends requests to local Ollama.
   - Lines 605-606: `uvicorn.run("app:app", host="0.0.0.0", port=7070, reload=True)` hardcodes port 7070.
   - Line 83: `CORSMiddleware` configured with `allow_origins=["*"]`.

2. **`indexer.py`**:
   - Lines 7-9: `DB_DIR = Path.home() / ".legal-ops-advisor"`, `DB_PATH = DB_DIR / "legal_knowledge.db"`.
   - Lines 11-16: `get_db()` opens SQLite connection and sets `PRAGMA journal_mode=WAL;`.

3. **`enterprise_rag.py`**:
   - Lines 14-16: `GCP_PROJECT_ID = os.environ.get("GCP_PROJECT_ID", "gen-lang-client-0285074833")`, `VERTEX_DATASTORE_ID = os.environ.get("VERTEX_DATASTORE_ID", "legal-enterprise-datastore")`.
   - Lines 47-73: `hybrid_enterprise_search()` executes Vertex AI datastore search first, falling back to `indexer.search_index()`.

4. **`requirements.txt`**:
   - Contains: `fastapi`, `uvicorn[standard]`, `requests`, `pydantic`, `PyPDF2`, `duckduckgo_search`, `python-multipart`, `pywebview`.

5. **`legal_knowledge.db`**:
   - File size: 2.4 MB (2,408,448 bytes) located at project root `/Users/saschalagler/legal-ops-advisor/legal_knowledge.db`.

---

## 2. Logic Chain

1. **Ollama & Desktop Dependencies Elimination**:
   - Observation: `app.py` relies on local Ollama server, macOS `vm_stat`, and `/Users/saschalagler/Desktop` file watcher.
   - Logic: Cloud Run containers run on Linux without desktop background tasks or Ollama daemons.
   - Deduction: Remove/bypass desktop file watcher, remove `vm_stat` execution, and replace `call_local_llm()` with direct calls to `google-genai` SDK querying `gemini-1.5-pro`.

2. **Database Path & Container Bundling**:
   - Observation: `indexer.py` currently looks for `~/.legal-ops-advisor/legal_knowledge.db`.
   - Logic: When containerized, the DB file is copied into `/app/legal_knowledge.db`.
   - Deduction: Update `indexer.py` to check `os.environ.get("LEGAL_DB_PATH")` and relative path `./legal_knowledge.db` before checking home directory.

3. **3-Part Output Format Preservation**:
   - Observation: Prompts in `prompts/legal_ops_omni.txt` describe Fall A 3-part Markdown structure (`### 📄 SACHVERHALT`, `### ⚖️ RECHTLICHE WÜRDIGUNG`, `### 🎯 AKTIONSPLAN`).
   - Logic: Model behavior under Gemini 1.5 Pro must strictly conform to `### 1. Sachverhalt`, `### 2. Würdigung`, `### 3. Aktionsplan`.
   - Deduction: Inject explicit system instructions in `load_prompt()` / client configuration in `app.py` enforcing this Markdown output contract.

4. **Cloud Run Port & CORS Compatibility**:
   - Observation: `uvicorn.run(...)` hardcodes port 7070, while Cloud Run sets `PORT=8080`.
   - Logic: Cloud Run routes ingress traffic to `$PORT` (default 8080).
   - Deduction: Update `uvicorn.run()` to use `int(os.environ.get("PORT", 8080))`. Ensure CORS allows `*` or Firebase Hosting origin.

---

## 3. Caveats

- **Vertex AI Search Data Store Credentials**: In local environments, `search_vertex_ai_datastore()` falls back to local SQLite FTS5 if ADC or Vertex AI datastore permissions are not available. In Cloud Run, the Service Account must have `roles/discoveryengine.viewer` permissions to query Vertex AI Search.
- **SQLite Concurrency in Cloud Run**: Cloud Run instances can scale horizontally. Since `legal_knowledge.db` is bundled into the read-only container layer as a read-only RAG knowledge base, multi-instance read concurrency is completely safe and fast. Ad-hoc uploads via `/upload` in a multi-instance container setup will be per-instance ephemeral unless persistent storage or Cloud Storage is attached (outside Milestone 1 scope).

---

## 4. Conclusion

The `legal-ops-advisor` project is fully prepared for Cloud Run containerization and Gemini 1.5 Pro integration. All required changes—including replacing Ollama calls with `google-genai`, refactoring `indexer.py` for `LEGAL_DB_PATH`, enforcing the 3-part Markdown format, updating `requirements.txt` and `Dockerfile`, and generating the `gcloud run deploy` command—are documented in detail in `analysis.md`.

---

## 5. Verification Method

To verify the migration plan:

1. **Inspect Analysis Report**:
   - File: `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m1_1/analysis.md`

2. **Verify Code Change Specs**:
   - Check `app.py` diff specifications in `analysis.md` (Section 3.1 & 3.4).
   - Check `indexer.py` DB resolution logic (Section 3.3).
   - Check format enforcement logic (Section 3.2).

3. **Verify Container Build & Deployment Specifications**:
   - Check `requirements.txt` & `Dockerfile` specifications in `analysis.md` (Section 4).
   - Check `gcloud run deploy` command targeting project `gen-lang-client-0285074833` and region `europe-west3` (Section 5).

---

## 6. Remaining Work (Soft Handoff to Implementer)

1. Modify `app.py` to:
   - Import `google-genai` SDK.
   - Replace `call_local_llm()` and `call_gemini_cloud()` with `call_gemini_pro()`.
   - Update `load_prompt()` to include strict format mandate instructions (`### 1. Sachverhalt`, `### 2. Würdigung`, `### 3. Aktionsplan`).
   - Update `get_free_ram_mb()`, `start_watcher()`, and `uvicorn.run()` port handling (`PORT` env var).
2. Modify `indexer.py` to check `os.environ.get("LEGAL_DB_PATH")` and relative project path.
3. Update `requirements.txt` to include `google-genai` and `google-cloud-discoveryengine`.
4. Create `Dockerfile` in `/Users/saschalagler/legal-ops-advisor/Dockerfile`.
5. Run local Docker container build & test.
6. Execute `gcloud run deploy legal-ops-backend` to GCP project `gen-lang-client-0285074833` in `europe-west3`.
