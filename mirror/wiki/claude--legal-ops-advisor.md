# legal-ops-advisor (claude)

Zuletzt gespiegelt: 2026-09-08 10:27 UTC

## SKILL

---
name: legal-ops-deploy
description: Deploy-Regel für Legal Ops Advisor — welcher Befehl für UI-Änderungen vs. Backend/Prompt-Änderungen. Verwenden, wenn eine Änderung an index.html, app.py oder Prompts live gestellt werden soll.
---

## 🚨 DEPLOY-REGEL (kritisch — nicht verwechseln!)

- **UI / `index.html` ändern → `npx firebase-tools deploy --only hosting --project gen-lang-client-0285074833`**. Die Demo-URL `web.app` = **Firebase Hosting** mit EIGENER index.html. Schnell, kein Container-Rebuild.
- **Backend / Prompts / `app.py` → Cloud Run** (`gcloud run deploy … --source .`). Cloud Run serviert `/` zwar auch, aber `web.app` NICHT — UI-Änderungen dort verifizieren ist FALSCH.

