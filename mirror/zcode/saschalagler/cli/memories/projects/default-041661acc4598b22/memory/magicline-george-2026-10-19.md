---
name: magicline-george-2026-10-19
description: Magicline→George (Thomas' Codex auf Windows) — Anleitung, PDF,
  gespeicherter Workflow, Briefing fertig; blockiert nur auf Key-Mail von Thomas
metadata:
  node_type: memory
  type: project
  originSessionId: sess_83697431-c946-417e-b8f1-22a2e256eba6
---

19.10. Magicline-Anbindung an Thomas' Codex-Agent George — PAKET KOMPLETT, wartet nur auf Sport-Alliance-Key-Mail (nur Thomas/Studio-Inhaber kann beantragen):

- **Entscheidung:** Weg B = direkt am Rechner (REST, Codex macht HTTPS-Calls). Weg A (Make.com) nur Schnellstart/Test. KEIN VPN/Netzwerk/Website-Anschluss nötig — Magicline ist Cloud-API.
- **Artefakte:** ✅ **ALLES-IN-EINEM-PDF `~/Desktop/MAGICLINE_GEORGE_ALLES_IN_EINEM_2026-10-19.pdf` (363 KB) = das Master-Dokument** (4 Teile: Todo-Liste 5 Stufen · E-Mail-Vorlage · Anleitung · George-Briefing) · PDF `~/Desktop/ANLEITUNG_MAGICLINE_GEORGE_2026-10-19.pdf` (265 KB, älter) · George-Briefing-Dokument `out/GEORGE_MAGICLINE_BRIEFING.md` (15 KB) · wiederverwendbarer Workflow global `~/.zcode/workflows/magicline-george-anleitung.dwf.ts` (Run dwfrun-7449257a destilliert, 3 URLs als args).
- **API-Fakten (verifiziert):** Auth = Header **`x-api-key`** (NICHT Authorization/Bearer — belegte 401-Ursache). Basis-URL `https://<studio-name>.open-api.magicline.com/v1` (steht in Aktivierungs-E-Mail, muss zum Key passen). Endpoints: `GET /v1/customers` (Slices 50–500, Status MEMBER/PROSPECT/FORMER_MEMBER), `GET /v1/customers/{id}/activities/checkins` (max 365 Tage), `/contracts`, einziger Studiowert `GET /v1/studios/getutilization`. **KEIN studioweiter Zähl-/Statistics-Endpoint** (Sitemap + Postman verifiziert) — George zählt clientseitig. Rate-Limit 1.000 Req/Min. Demo-Tenant `open-api-demo.open-api.magicline.com` (ohne eigenen Key: DATENLAGE UNKLAR). openapi.json als Datei = 404.
- **Kontakte Sport Alliance (belegt):** **apisupport@sportalliance.com** (technisch) · partnership@sportalliance.com (Partnerschaft). Aktivierung im Magicline Marketplace („Activate Integration") → Aktivierungs-E-Mail mit Key + Basis-URL kommt automatisch.
- **Browser-Use-Live-Check (19.10., Seite live geöffnet & verifiziert):** Es gibt eine **ZWEITE API — „Developer Portal API" (v1)**: Auth = **OAuth2ClientCredentials → `Authorization: Bearer`**, Server Production `https://developer.sportalliance.com/api/` + Sandbox `developer.sandbox.sportalliance.com/api/` + Mock. **`GET /v1/integrations` liefert pro Integration `apiKey` (= Open-API-Key!), `webhookApiKey`, `tenantName`, `studioName`, `status` (ACTIVE/DEACTIVATED/PARTNER_CONFIRMATION_REQUIRED/…), `brand: MAGICLINE`** — George kann Key + Tenant-Name nach Portal-Registrierung programmatisch selbst abholen. Portal-OpenAPI-Spec IS downloadbar (`developerportalapi.json`/`.yaml`, Link auf der Seite — der frühere 404 galt nur für die Magicline-Spec). Vorher aber: Partner-Registrierung + Integration aktivieren, sonst 401.
- **Offen (hängt an Sport Alliance):** Gebührenmodell, Sandbox-Fähigkeit ohne Produktiv-Antrag, Demo-Tenant-Voraussetzungen, Contract-Scopes/Checkin-Body-Details — alles in der Key-Mail mitzufragen (Vorlage deckt das ab).
- **NEXT:** Thomas schickt E-Mail an apisupport@sportalliance.com (Vorlage im Master-PDF, TEIL 2) → Key per `setx MAGICLINE_API_KEY`/`MAGICLINE_BASE_URL` auf Windows-PC (PowerShell NEU öffnen) → George Briefing als Kontext geben → „Teste die Magicline-API" / Mitglieder-/Checkin-Fragen.

**Feedback (scharf, 2× im Chat):** „DU SOLLST KEINEN VERFICKTEN SKILL BAUEN" — Übergaben für Fremd-Agenten (George) sind **normale Dokumente**, KEINE Skill-Dateien, kein Installieren in ~/.codex/skills/. Erstes Briefing-Run wurde deshalb per AmendWorkflow von GEORGE_MAGICLINE_SKILL.md → GEORGE_MAGICLINE_BRIEFING.md umgebaut. Siehe [[thomas-tasks-drei-recherchen]], [[feedback-entscheidungshoheit]].
