## 2026-07-21T16:07:35Z
<USER_REQUEST>
You are teamwork_preview_auditor performing forensic integrity verification for legal-ops-advisor cloud deployment.
Your working directory is `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_auditor_m3_1`.
Target project root is `/Users/saschalagler/legal-ops-advisor`.

Objective:
1. Conduct forensic integrity audit of all code changes (`app.py`, `indexer.py`, `requirements.txt`, `Dockerfile`, `index.html`, `.firebaserc`, `firebase.json`).
2. Verify that there are NO integrity violations or cheating:
   - Check that LLM responses are genuinely produced by Google GenAI SDK (`gemini-1.5-pro`) and NOT hardcoded or mocked.
   - Check that RAG search queries SQLite database `legal_knowledge.db` genuinely.
   - Check that Cloud Run backend `https://legal-ops-backend-709873485696.europe-west3.run.app` and Firebase Hosting `https://gen-lang-client-0285074833.web.app` are real, live, and functional.
3. Formulate a final verdict: CLEAN or INTEGRITY VIOLATION.

Write your forensic audit report to `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_auditor_m3_1/audit.md` and handoff report to `handoff.md`.
Send a message back to the orchestrator with your final verdict.
</USER_REQUEST>
