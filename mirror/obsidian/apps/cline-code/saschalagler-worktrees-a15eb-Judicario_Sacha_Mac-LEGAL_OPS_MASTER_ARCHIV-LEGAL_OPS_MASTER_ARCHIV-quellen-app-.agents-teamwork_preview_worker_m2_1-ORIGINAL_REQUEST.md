---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/.agents/teamwork_preview_worker_m2_1/ORIGINAL_REQUEST.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

## 2026-07-21T16:01:48Z
<USER_REQUEST>
You are teamwork_preview_worker executing Milestone 2 for legal-ops-advisor deployment.
Your working directory is `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_worker_m2_1`.
Target project root is `/Users/saschalagler/legal-ops-advisor`.

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Objective & Requirements:
1. Deployed Cloud Run Backend URL: `https://legal-ops-backend-709873485696.europe-west3.run.app`
2. Update `index.html`:
   a. Implement dynamic backend URL resolution function `resolveBackendUrl()` in `index.html` (replacing hardcoded `const API = 'http://localhost:7070';`).
   b. Priority resolution:
      1. Query param `?backend=` (e.g. `?backend=https://...`)
      2. LocalStorage `localStorage.getItem('backend_url')`
      3. Default Cloud Run backend URL `https://legal-ops-backend-709873485696.europe-west3.run.app` when served on web/Firebase (`location.hostname !== 'localhost' && location.hostname !== '127.0.0.1'`)
      4. Fallback `http://localhost:7070` when running locally.
   c. Preserve all existing features (persona selector, query input, document upload, RAG stats, and rendering of the 3-part Markdown response).
3. Create Firebase Hosting configuration files:
   a. `.firebaserc` pointing to project `gen-lang-client-0285074833`.
   b. `firebase.json` with hosting config for single-page app (hosting public dir: `.`, rewrites to `index.html`, ignores `.git`, `.agents`, `venv`, `*.db`, `*.py`).
4. Deploy to Firebase Hosting:
   a. Execute `firebase deploy --only hosting --project gen-lang-client-0285074833` (or `npx firebase-tools deploy --only hosting --project gen-lang-client-0285074833`).
   b. Obtain and verify the live Firebase Hosting URL (e.g. `https://gen-lang-client-0285074833.web.app` or `https://legal-ops-advisor.web.app`).
   c. Perform a HTTP GET to the live Firebase URL and confirm HTTP 200 OK.

Document all changes made, deployment command outputs, and the verified public Firebase Hosting URL in `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_worker_m2_1/handoff.md`.
Send a message back to the orchestrator when finished.
</USER_REQUEST>
