# Analysis Report: Milestone 2 - Frontend & Firebase Hosting Setup

## Executive Summary
This report provides a comprehensive codebase investigation, dynamic backend URL resolution architecture, and step-by-step Firebase Hosting configuration for deploying the `legal-ops-advisor` frontend to Google Cloud Platform (Project: `gen-lang-client-0285074833`).

---

## 1. Codebase Asset & Endpoint Inspection

### Project Structure
- Project Root: `/Users/saschalagler/legal-ops-advisor`
- Frontend Entry Point: `index.html` (948 lines)
- Architecture: Single-Page Application (SPA) with inline CSS styles and embedded JavaScript. No separate external `.js` or `.css` files exist in the project root.

### Hardcoded Backend URLs Identified
Grep search across all project files confirmed:
1. `index.html` (Line 653): `const API = 'http://localhost:7070';`
2. `desktop_app.py` (Line 43 & Line 60): `127.0.0.1:7070` / `'http://127.0.0.1:7070'` (macOS PyWebView launcher)
3. `launch.log`: Uvicorn startup logs referencing `http://0.0.0.0:7070`

### Dependent Endpoints in `index.html`
All frontend functionality relies on the `API` base string:
- `fetch(`${API}/health`)` — Line 669: Backend status and model info check (poll interval: 15s).
- `fetch(`${API}/db_stats`)` — Line 689: Document and chunk statistics display (poll interval: 30s).
- `fetch(`${API}/personas/detail`)` — Line 697: Persona prompt detail loader for modal.
- `fetch(`${API}/cases`)` — Line 730: RAG document list loader.
- `fetch(`${API}/upload`, { method: "POST", body: formData })` — Line 772: File upload handler.
- `fetch(`${API}/query`, { method: 'POST', body: ... })` — Line 829: Persona query execution and deep analysis.

---

## 2. Dynamic Backend URL Architecture

To ensure seamlessly switching between local desktop execution (`localhost:7070`) and Cloud Run deployment without breaking existing workflows, a multi-tier URL resolution mechanism is designed.

### Proposed JavaScript Implementation for `index.html`

Replace line 653 (`const API = 'http://localhost:7070';`) with:

```javascript
// --- Dynamic Backend URL Resolution ---
function resolveBackendUrl() {
  // Tier 1: Query parameter override (?backend=https://... or ?api=https://...)
  const params = new URLSearchParams(window.location.search);
  const paramUrl = params.get('backend') || params.get('api');
  if (paramUrl) {
    const formatted = paramUrl.replace(/\/+$/, '');
    localStorage.setItem('LEGAL_OPS_BACKEND_URL', formatted);
    return formatted;
  }

  // Tier 2: Explicit Window global variable
  if (window.LEGAL_OPS_BACKEND_URL) {
    return window.LEGAL_OPS_BACKEND_URL.replace(/\/+$/, '');
  }

  // Tier 3: Stored preference in localStorage
  const storedUrl = localStorage.getItem('LEGAL_OPS_BACKEND_URL');
  if (storedUrl) {
    return storedUrl.replace(/\/+$/, '');
  }

  // Tier 4: Environment/Domain Fallback
  const host = window.location.hostname;
  if (host === 'localhost' || host === '127.0.0.1') {
    return 'http://localhost:7070';
  }

  // Default Cloud Run backend URL for Firebase Hosting deployment
  return 'https://legal-ops-advisor-backend-ew.a.run.app';
}

let API = resolveBackendUrl();

function updateBackendUrl(newUrl) {
  if (!newUrl) return;
  API = newUrl.replace(/\/+$/, '');
  localStorage.setItem('LEGAL_OPS_BACKEND_URL', API);
  checkHealth();
  loadDbStats();
  loadCases();
  loadPersonaDetails();
}
```

### UI Controls for Backend URL (Optional Header Control)
Adding a small settings input or modal allows users to dynamically configure or re-test the backend URL directly from the header UI.

---

## 3. Preservation of Application Features

The proposed dynamic backend change maintains full feature parity:
1. **Persona Selection**: `currentPersona` state (`legal`, `gdb`, `vwgh`, `compliance`) remains unchanged and is passed to `POST ${API}/query`.
2. **3-Part Response Formatting**: The regex-based `renderMarkdown` function (lines 886–923) parses response strings containing:
   - `### 📄 SACHVERHALT` -> Sachverhalt Card
   - `### ⚖️ RECHTLICHE WÜRDIGUNG` -> Rechtliche Würdigung Card
   - `### 🎯 AKTIONSPLAN` -> Aktionsplan Card
3. **Live Process Log & Thinking State**: Simulated pipeline status updates (lines 808–823) and async fetch remain functional.
4. **File Uploads & DB Stats**: Multipart file ingestion (`POST /upload`) and stats updates (`GET /db_stats`) remain intact.

---

## 4. Firebase Hosting Setup Configuration

Neither `firebase.json` nor `.firebaserc` currently exists in `/Users/saschalagler/legal-ops-advisor`. They must be created before running the deployment command.

### Configuration File 1: `.firebaserc`
Location: `/Users/saschalagler/legal-ops-advisor/.firebaserc`

```json
{
  "projects": {
    "default": "gen-lang-client-0285074833"
  }
}
```

### Configuration File 2: `firebase.json`
Location: `/Users/saschalagler/legal-ops-advisor/firebase.json`

```json
{
  "hosting": {
    "public": ".",
    "ignore": [
      "firebase.json",
      ".firebaserc",
      "**/.*",
      "**/node_modules/**",
      "**/*.py",
      "**/*.pyc",
      "**/*.db",
      "**/Dockerfile",
      "**/requirements.txt",
      "**/dist/**",
      "**/build/**",
      "**/*.log",
      "**/*.md",
      "**/prompts/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

*Option B (Proxying API calls through Firebase Hosting rewrite):*
If CORS or domain routing prefers relative endpoints, `firebase.json` can route `/api/**` to Cloud Run:
```json
{
  "hosting": {
    "public": ".",
    "ignore": [ ... ],
    "rewrites": [
      {
        "source": "/api/**",
        "run": {
          "serviceId": "legal-ops-advisor-backend",
          "region": "europe-west3"
        }
      },
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

---

## 5. Firebase Deployment Setup & Execution Command

### Prerequisites
1. Ensure Firebase CLI is installed (`firebase --version` or via `npx firebase-tools`).
2. Authenticate to GCP / Firebase (`gcloud auth login` or `firebase login`).

### Exact Deployment Command
Run the following command from the project root (`/Users/saschalagler/legal-ops-advisor`):

```bash
firebase deploy --only hosting --project gen-lang-client-0285074833
```

*(Alternative using npx if firebase CLI is not globally linked):*
```bash
npx firebase-tools deploy --only hosting --project gen-lang-client-0285074833
```

---

## Conclusion & Verification Plan
- **Verification 1**: Validate URL resolution logic by visiting `index.html` locally vs with `?backend=https://test-run.app`.
- **Verification 2**: Inspect `firebase.json` JSON validity using `python3 -m json.tool firebase.json`.
- **Verification 3**: Test deployment dry-run with `firebase deploy --only hosting --project gen-lang-client-0285074833`.
