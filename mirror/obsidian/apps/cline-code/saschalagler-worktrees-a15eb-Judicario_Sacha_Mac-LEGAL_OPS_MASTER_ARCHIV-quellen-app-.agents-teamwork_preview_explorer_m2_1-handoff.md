---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/quellen-app/.agents/teamwork_preview_explorer_m2_1/handoff.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Handoff Report: Milestone 2 - Frontend & Firebase Hosting Investigation

## 1. Observation
- Project path: `/Users/saschalagler/legal-ops-advisor`.
- Frontend asset: `index.html` (948 lines total, SPA format with inline CSS/JS). No external `.js` or `.css` files present in directory listing.
- Hardcoded Backend URL:
  - `index.html` line 653: `const API = 'http://localhost:7070';`
  - `desktop_app.py` lines 43 & 60: `127.0.0.1:7070` / `'http://127.0.0.1:7070'`
- Dependent endpoint invocations in `index.html`:
  - Line 669: `fetch(`${API}/health`)`
  - Line 689: `fetch(`${API}/db_stats`)`
  - Line 697: `fetch(`${API}/personas/detail`)`
  - Line 730: `fetch(`${API}/cases`)`
  - Line 772: `fetch(`${API}/upload`, ...)`
  - Line 829: `fetch(`${API}/query`, ...)`
- Response Markdown Parser: Lines 886–895 handle 3-part output:
  - `text.replace(/###\s*📄\s*SACHVERHALT/gi, '</div><div class="dashboard-card"><h3>📄 Sachverhalt</h3>');`
  - `text.replace(/###\s*⚖️\s*RECHTLICHE WÜRDIGUNG/gi, '</div><div class="dashboard-card"><h3>⚖️ Rechtliche Würdigung</h3>');`
  - `text.replace(/###\s*🎯\s*AKTIONSPLAN/gi, '</div><div class="dashboard-card"><h3>🎯 Aktionsplan (To-Dos)</h3>');`
- Project configuration status: Neither `firebase.json` nor `.firebaserc` exists in `/Users/saschalagler/legal-ops-advisor`.

## 2. Logic Chain
1. *Observation*: Line 653 of `index.html` statically assigns `const API = 'http://localhost:7070';`.
2. *Deduction*: When `index.html` is deployed to Firebase Hosting, browser fetch calls to `http://localhost:7070` will fail for remote users because `localhost` refers to the client machine, not the Cloud Run instance.
3. *Solution Step*: Replacing the static string with a dynamic URL resolver (`resolveBackendUrl()`) enables precedence fallback: URL query parameter `?backend=` -> `localStorage` -> Window global -> domain check (`*.web.app` / `*.firebaseapp.com` -> Cloud Run URL) -> `http://localhost:7070`.
4. *Feature Preservation*: Because all API calls in `index.html` (`/health`, `/db_stats`, `/personas/detail`, `/cases`, `/upload`, `/query`) consistently reference `${API}`, changing `API` dynamically changes all endpoints synchronously without requiring alterations to UI or query rendering logic.
5. *Configuration Step*: To deploy `index.html` to Firebase Hosting under GCP project `gen-lang-client-0285074833`, `.firebaserc` must declare the project ID and `firebase.json` must configure public dir `.` while ignoring non-web assets (`.py`, `.db`, `.venv`, `.git`).

## 3. Caveats
- The exact Cloud Run backend URL (e.g. `https://legal-ops-advisor-backend-ew.a.run.app`) will only be finalized once Milestone 1 / Cloud Run backend deployment completes. The dynamic fallback URL in `index.html` can be updated or passed via `?backend=` parameter during deployment testing.
- If Cloud Run requires CORS headers or authentication, the FastAPI backend on Cloud Run must have CORS Middleware (`CORSMiddleware` with `allow_origins=["*"]`) enabled.

## 4. Conclusion
The frontend investigation for Milestone 2 is complete.
1. `index.html` requires replacing `const API = 'http://localhost:7070';` with a dynamic `resolveBackendUrl()` function.
2. `firebase.json` and `.firebaserc` must be created in project root `/Users/saschalagler/legal-ops-advisor`.
3. Deployment is executed via `firebase deploy --only hosting --project gen-lang-client-0285074833`.

Full detailed findings and exact code snippets have been written to `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m2_1/analysis.md`.

## 5. Verification Method
- **File Inspection**: Verify existence and content of:
  - `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m2_1/analysis.md`
  - `/Users/saschalagler/legal-ops-advisor/.agents/teamwork_preview_explorer_m2_1/handoff.md`
- **Config JSON Validation**: Once created, validate `firebase.json` and `.firebaserc` with:
  `python3 -c "import json; json.load(open('/Users/saschalagler/legal-ops-advisor/firebase.json'))"`
- **Firebase Deploy Dry Run**: Test deployment setup:
  `firebase deploy --only hosting --project gen-lang-client-0285074833 --dry-run`
