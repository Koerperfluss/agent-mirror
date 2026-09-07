---
name: atlas-firestore-telemetry-setup
description: ATLAS /api/track-Telemetrie live — Firestore-Fallen im Projekt gen-lang-client-0285074833: Error 5 NOT_FOUND = DB fehlt (firebase databases:create), Error 7 PERMISSION_DENIED = roles/datastore.user für die Functions-Service-Account fehlt (gcloud add-iam-policy-binding, ~2min Propagation)
metadata:
  node_type: memory
  type: project
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

ATLAS-Testversand-Tracking seit 07.09. LIVE bewiesen: `POST https://atlas-v5.web.app/api/track` → `{"ok":true}`, Zahlen-Beweis via `GET /api/track?summary=1` → `{"events":{app_open:N,…}}`. Client: `src/telemetry.ts` (anonym — nur localStorage `atlas_sid` = crypto.randomUUID, sendBeacon via `apiUrl()` wegen Capacitor, window.onerror+unhandledrejection → track('error')), `init()`+`app_open` in main.tsx; QR-Download-Hub `public/download/index.html` (inline-SVG-QR, kein CDN).

**Firestore-Falle im Projekt gen-lang-client-0285074833 (2 Stufen, beide selbst durchlaufen):**
1. **Error 5 NOT_FOUND (mit LEERER Meldung!)** = das Projekt hatte GAR KEINE Firestore-Datenbank (war nur als Gemini-Key-Projekt angelegt). Fix: `npx firebase firestore:databases:create "(default)" --location us-central1 --project gen-lang-client-0285074833` (Named-DB „atlas-telemetry" existiert zusätzlich; die Function nutzt Default via `getFirestore(fbApp)` — Admin umgeht Rules).
2. **Danach Error 7 PERMISSION_DENIED: Missing or insufficient permissions** = die Gen2-Functions-Service-Account darf nicht in Firestore. Fix: `gcloud projects add-iam-policy-binding gen-lang-client-0285074833 --member "serviceAccount:709873485696-compute@developer.gserviceaccount.com" --role "roles/datastore.user"` — **IAM-Propagation ~2 min abwarten** bevor Retest.

**Gotchas:** functions/package.json bekam `firebase-admin ^12` → IMMER `npm install` in functions/ vor Deploy; firebase.json-Rewrite `/api/track` MUSS VOR `/api/**` stehen (Reihenfolge entscheidet); GCP-Log-Ingestion hinkt Minuten hinterher → Fehlerursache per Logs erst nach Minuten sichtbar, live-curl ist die schnellere Wahrheit; in-memory Rate-Limit 1 Event/2s je session+event (2. POST sofort = 429, kein Bug); Agent-2-Bericht-Warnung: Deploy-Reihenfolge functions vor hosting.

Verwandt: [[atlas-master-app-verhaeltnis]]
