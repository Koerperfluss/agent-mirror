## 2026-07-21T15:46:20Z
<USER_REQUEST>
You are teamwork_preview_explorer investigating Milestone 1 for legal-ops-advisor deployment.
Your working directory is `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m1_1`.
Target project root is `/Users/saschalagler/legal-ops-advisor`.

Objective:
1. Examine `app.py`, `indexer.py`, `enterprise_rag.py`, `requirements.txt`, and `legal_knowledge.db`.
2. Determine how `app.py` currently handles RAG queries, prompt templates, LLM calls (Ollama vs Gemini), CORS, and HTTP endpoints (`/health`, `/query`, etc.).
3. Identify exact code changes needed to:
   a. Use Google GenAI SDK (`google-genai` or `google.generativeai`) to invoke `gemini-1.5-pro` for inference instead of Ollama.
   b. Ensure the output strictly preserves the "Enterprise Legal OS" 3-part Markdown format:
      ### 1. Sachverhalt
      ### 2. Würdigung
      ### 3. Aktionsplan
   c. Ensure `legal_knowledge.db` (read-only SQLite DB containing indexed RAG chunks) is loaded and queried properly from the container filesystem.
   d. Handle PORT env var (Cloud Run sets `PORT`, default 8080 or 7070) and CORS headers (allowing `*` or Firebase Hosting origin).
4. Design the `Dockerfile` and `requirements.txt` for containerizing the FastAPI app and bundling `legal_knowledge.db`.
5. Specify the exact gcloud deployment command: `gcloud run deploy legal-ops-backend --source . --region europe-west3 --project gen-lang-client-0285074833 --allow-unauthenticated ...`.

Write your full report to `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m1_1/analysis.md` and write a soft handoff to `handoff.md` in your directory.
Send a message back to the orchestrator when finished with path to your handoff.
</USER_REQUEST>
