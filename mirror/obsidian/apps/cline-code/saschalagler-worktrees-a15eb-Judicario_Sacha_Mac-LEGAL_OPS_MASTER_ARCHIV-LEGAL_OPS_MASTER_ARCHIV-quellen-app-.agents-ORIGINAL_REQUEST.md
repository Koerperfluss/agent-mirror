---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/.agents/ORIGINAL_REQUEST.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Original User Request

## Initial Request — 2026-07-21T17:33:43+02:00

Der Legal Ops Advisor soll als skalierbare WebApp auf Google Cloud (Frankfurt, europe-west3) unter Verwendung von Firebase Hosting, GCP Cloud Run und Vertex AI Search bereitgestellt werden, damit Tester über das Web und Mobilgeräte (PWA) auf einen Dokumentenpool von 100.000+ Rechtstexten zugreifen können.

Working directory: /Users/saschalagler/legal-ops-advisor
Integrity mode: development

## Requirements

### R1. Cloud Run Backend & Dockerization
- Bündelung des FastAPI-Backends (app.py) in einem Docker-Container für die Ausführung auf GCP Cloud Run in der Region europe-west3 (Frankfurt).
- Das Backend muss das aktive GCP-Projekt automatisch ermitteln und Vertex AI Search / Discovery Engine-Anbindungen unterstützen, um einen Datastore mit 100.000+ Dokumenten abfragen zu können.

### R2. Firebase Hosting & PWA Frontend
- Bereitstellung des Frontends (index.html, Assets) über Firebase Hosting mit PWA-Konfiguration (Service Worker, Manifest, Offline-Unterstützung), sodass die WebApp direkt auf dem iPhone als App installiert werden kann.
- Implementierung eines Web-Ordner-Pickers (HTML5 webkitdirectory) oder Drag-and-Drop Uploader in der WebApp, um Dateien direkt in den Google Cloud Storage Bucket gs://legal-ops-advisor-docs hochzuladen.

### R3. Vertex AI Search Datastore & Cloud Storage Ingestion
- Einrichtung der RAG-Pipeline: Dokumente aus dem Cloud Storage Bucket werden automatisch in den Vertex AI Search Datastore eingepflegt.

## Acceptance Criteria

### Deployment & Cloud Run
- Dockerfile vorhanden und lauffähig.
- Erfolgreiches Deployment auf GCP Cloud Run in europe-west3 (Frankfurt).

### Firebase Hosting
- firebase.json und .firebaserc konfiguriert für das aktive GCP-Projekt.
- Die WebApp ist unter https://legal-ops-advisor.web.app (oder Projekt-Subdomain) erreichbar.

### RAG & Ingestion
- Web-Dateiupload lädt Dokumente erfolgreich in den GCS Bucket hoch.
- Suchanfragen über die WebApp greifen auf den Vertex AI Search Datastore zu.

## 2026-07-21T17:45:21Z

Deploy the existing local `legal-ops-advisor` prototype (FastAPI backend + HTML/JS frontend) to Google Cloud Platform using Firebase Hosting for the frontend and Google Cloud Run for the backend.

Working directory: `/Users/saschalagler/legal-ops-advisor`
Integrity mode: demo

## Requirements

### R1. Backend Containerization & Deployment
Dockerize the FastAPI backend (`app.py`) and deploy it to Google Cloud Run (Region: europe-west3, GCP Project: `gen-lang-client-0285074833`). Since Cloud Run lacks local GPUs, modify the backend to use the Google GenAI SDK (Gemini 1.5 Pro) for inference instead of local Ollama. Ensure the strict "Enterprise Legal OS" 3-part Markdown output format is maintained.

### R2. Frontend Deployment
Deploy the `index.html` and associated frontend assets to Firebase Hosting. The frontend must be dynamically configured to send API requests to the new Cloud Run backend URL instead of hardcoded `localhost:7070`.

### R3. Database Handling
Bundle the existing `legal_knowledge.db` SQLite database (read-only) into the Docker container so the RAG (Retrieval-Augmented Generation) search functions immediately in the cloud prototype without requiring an external database setup.

## Acceptance Criteria

### Deployment Verification
- [ ] The FastAPI backend is successfully deployed to Cloud Run and returns a 200 OK from its `/health` endpoint.
- [ ] The frontend `index.html` is successfully deployed to Firebase Hosting and is accessible via a public URL.
- [ ] Submitting a query on the public Firebase URL successfully triggers the Cloud Run backend, performs a RAG search, and returns a response from Gemini in the 3-part format (Sachverhalt, Würdigung, Aktionsplan).

## 2026-07-28T11:33:41+02:00

# Teamwork Project Prompt — Katharina Wlzek Honorarnote & Legal Ops Workflow

Rechtlich und organisatorisch korrekte Abwicklung der Physiotherapie-Honorarnote für Patientin Katharina Wlzek unter Berücksichtigung der ÖGK-Rückerstattung und der AMS/UGP-Richtlinien.

Working directory: /Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor
Integrity mode: development

## Patientin & Verordnungsdaten
- **Patientin:** Katharina Wlzek (SVNR: 4392 250401, Wohnanschrift: Hippolytgasse 3/10, 3240 Mank)
- **Verordnender Arzt:** GP Mank, Dr. Höfinger u. Dr. Kleinberger (Datum: 05.11.2025)
- **Verordnung:** 10x EHG à 45 min. (Einzeleinheits-Heilgymnastik)
- **Diagnose Verordnung:** Streckhaltung HWS u Blockwirbel C3 C4, Skoliose BWS, Spannungskopfschmerz
- **Diagnose Befund:** Zervikogene Migräne mit Tinnitus (Behandlungsbeginn: 27.11.2025)
- **Therapeut:** Sascha Lagler (Freiberuflicher Physiotherapeut / MTD-Gesetz)

## Requirements

### R1. ÖGK-Konforme Honorarnote & Kassen-Rückerstattung
Erstellung einer rechtskonformen Honorarnote mit allen Pflichtangaben nach § 131 ASVG (GBR-Nummer, Diagnose, Verordnungsdatum, Einzelbehandlungsdaten, Zahlungsvermerk, USt-Befreiung nach § 6 Abs. 1 Z 19 UStG).

### R2. AMS/UGP Compliance & Status-Prüfung
Rechtliche Klärung & Vorlage für die formlose Meldung an das AMS bezüglich freiberuflicher Tätigkeit unter der Geringfügigkeitsgrenze (518,44 € / 551,10 €) ohne Verletzung des UGP-Status / ruhender Gewerbe.

### R3. Vollständigkeits-Check & Einreichungs-Leitfaden
Erstellung einer Schritt-für-Schritt-Anleitung für die Patientin Katharina Wlzek zur Einreichung bei der ÖGK (inkl. Bewilligungs-Hinweis).

## Acceptance Criteria

### Formale Kriterien
- Erstelle die vollständige Honorarnote im Markdown- & HTML-Format in `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/output/honorarnote_wlzek.md`.
- Erstelle die formlose AMS-Meldungsvorlage in `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/output/ams_meldung_freiberuf.md`.
- Erstelle den Patientinnen-Leitfaden für ÖGK-Einreichung in `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/output/oegk_einreichungsleitfaden.md`.
- Füge einen rechtskonformen Passus zur freiberuflichen Ausübung gemäß MTD-Gesetz ein (keine GewO-Pflicht).
- Füge eine Tabelle mit 10 Einzelbehandlungsterminen à 45 Min. zum Abzeichnen ein.


