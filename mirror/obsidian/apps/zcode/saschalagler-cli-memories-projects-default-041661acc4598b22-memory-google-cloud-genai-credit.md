---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/google-cloud-genai-credit.md"
stand: 2026-09-15
tags: [spiegel, zcode]
---

---
name: google-cloud-genai-credit
description: Sascha hat 867,15 € "Trial credit for GenAI App Builder" (läuft bis
  23.04.2027) — gilt NUR für Vertex AI Search & Conversation, NICHT für normale
  Gemini API
metadata:
  node_type: memory
  type: reference
  originSessionId: sess_ec864b92-2403-44f6-8057-fd71047cea94
---

Google Cloud Billing-Konto `015D43-AC6CDE-D17A3A`, Projekt `koerperfluss-antigravity`.

**Credit-Stand (30.08.2026):**
- **Trial credit for GenAI App Builder**: 867,15 € / 100 % verfügbar, gültig 23.04.2026–23.04.2027, Nettopreis
- Google Developer Program Monthly-Credits (je ~8,56 €): praktisch aufgebraucht (0 %)

**Kern-Erkenntnis (Name irreführend!):** Der Credit deckt NICHT die normale Gemini API (AI-Studio-Key) und nicht allgemeines Vertex AI (Gemini-Endpunkte, Veo, Imagen, Training) ab. Er gilt nur für:
- Vertex AI **Search** (eigene Suchmaschine über eigene Dokumente/Websites)
- Grounded Generation API (Gemini + RAG auf eigene Daten)
- Document AI (OCR), Ranking API

**Nutzung:** Console → Vertex AI → Search/Agent Builder → „Create App" → Data Store mit eigenen PDFs; Credit wird automatisch angerechnet.

**Chatbot-Plan (30.08.2026, von Sascha gebilligt):** Credit zahlt Bot 1 von 3 — **FörderOps-Assistent** (Vertex AI Search Chat-App, Förderantrag-PDFs als Data Store) → Perfekter Fit. Bots 2+3 laufen NICHT über den Credit, sondern gratis via Gemini API (AI Studio Free Tier): **Körperfluss Physio-Web-Bot** + **Atlas Cali Coach** (gleiche Technik, anderer System-Prompt). Reihenfolge: FörderOps zuerst (nur PDF-Upload, kein Code). Auslösersatz für Start: „Start FörderOps". API-Keys nur als Umgebungsvariable (`GEMINI_API_KEY` in ~/.zshrc), nie in Code.

**Saschas Stand (30.08.2026):** Hat es mehrfach nicht verstanden (ADHD-taugliche Erklärung nötig: „Gutschein für einen Chatbot, der NUR aus eigenen hochgeladenen PDFs antwortet"). Konkrete Nutzungsidee: Förderantrag-PDFs hochladen → Bot, der nur daraus antwortet (z. B. TIP-KI-Status-Fragen). Erkenntnis für ihn: Kredit einfach liegen lassen ist OK — kein Verfallsdruck, normale Gemini-API hat eigenes Free Tier.

Quellen: reddit.com/r/googlecloud/comments/1ldj0uf + 1h2umes, cloud.google.com/generative-ai-app-builder/pricing

Verwandt: [[mac-setup-16gb-m4]] (Saschas Projekte: Körperfluss, Förderanträge)

**⚠️ 15.09.2026 Update (KORRIGIERT nach Konsolen-Prüfung + Gutschriften-Seite live):** Konto `015D43-AC6CDE-D17A3A` ist mit **24,08 € überfällig** (unbezahlter August-Auszug 31.08.; Abbuchung 01.09. per MC 9784 abgelehnt, „Verfügungsrahmen ausgereizt"; Sept kommen 1,03 € dazu = 25,12 €) und verursacht damit die Gemini-API-„Suspended Service Tier"-Herabstufung — NICHT 1,03 € (das war nur der September-Saldo, Support-Agent „christian" hatte falsch abgelesen). 15 Projekte hängen an dem Konto. **867-€-Credit live verifiziert:** „Trial credit for GenAI App Builder — Verfügbar, 100 %, 867,15 €, 23.04.2026–23.04.2027, Nutzungsbereich: **Bestimmte Nutzung**" → kann die Cloud-Rechnung NICHT bezahlen (das war Sascha unverständlich — Erklärung: Zweck-Gutschein/Rabattgeld, kein Kontoguthaben). **NEU: zusätzlich 8,08 € „Google Developer Program premium benefit" verfügbar (94 %, monatlich ~8,5 € neu), Scope „Google Cloud gesamt + Maps"** — dieser darf reguläre Cloud-Kosten decken. Details + 7 Beweis-Screenshots: [[gcloud-billing-fall-2026-09-15]], Report `~/Desktop/GOOGLE_BILLING_NEUNTERSUCHUNG_2026-09-15.md` (Abschnitt 8 = Prüf-Lauf).
