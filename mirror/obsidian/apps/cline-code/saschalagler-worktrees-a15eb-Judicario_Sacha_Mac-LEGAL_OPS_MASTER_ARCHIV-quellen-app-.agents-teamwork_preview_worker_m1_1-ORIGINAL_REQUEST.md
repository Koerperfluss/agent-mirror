---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/quellen-app/.agents/teamwork_preview_worker_m1_1/ORIGINAL_REQUEST.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

## 2026-07-21T15:49:21Z

<USER_REQUEST>
You are teamwork_preview_worker executing Milestone 1 for legal-ops-advisor deployment.
Your working directory is `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_worker_m1_1`.
Target project root is `/Users/saschalagler/legal-ops-advisor`.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Objective & Requirements:
1. Modify `app.py`:
   a. Replace Ollama / local LLM invocation with Google GenAI SDK (`google-genai` package: `from google import genai`) using model `gemini-1.5-pro`.
   b. Ensure the prompt and output format strictly preserve the 3-part Markdown structure:
      ### 1. Sachverhalt
      ### 2. Würdigung
      ### 3. Aktionsplan
   c. Make desktop file watchers (`watchdog.Observer`) and macOS `vm_stat` calls safe/optional on Linux.
   d. Ensure `CORSMiddleware` allows all origins (`*`) for cross-origin frontend access.
   e. Update `uvicorn.run("app:app", host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))`.
2. Modify `indexer.py`:
   a. Update `DB_PATH` resolution to prioritize `os.environ.get("LEGAL_DB_PATH")` and local `./legal_knowledge.db` before `~/.legal-ops-advisor/legal_knowledge.db`.
3. Update `requirements.txt`:
   a. Add `google-genai`, `google-cloud-discoveryengine`, `google-cloud-storage`, `fastapi`, `uvicorn[standard]`, `pydantic`, `python-multipart`, `requests`, `PyPDF2`.
4. Create `Dockerfile`:
   a. Python 3.11 slim base image.
   b. Copy `legal_knowledge.db`, `app.py`, `indexer.py`, `enterprise_rag.py`, `prompts/`, `requirements.txt`.
   c. Install dependencies.
   d. Set `ENV PORT=8080` and `CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]`.
5. Deploy Backend to Cloud Run:
   a. Run build and deploy using `gcloud run deploy legal-ops-backend --source . --region europe-west3 --project gen-lang-client-0285074833 --allow-unauthenticated`.
   b. Obtain and verify the Cloud Run service URL.
   c. Verify that `GET <cloud_run_url>/health` returns HTTP 200 OK.

Document all changes made, build/deploy command outputs, and the verified Cloud Run URL in `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_worker_m1_1/handoff.md`.
Send a message back to the orchestrator when finished.
</USER_REQUEST>
