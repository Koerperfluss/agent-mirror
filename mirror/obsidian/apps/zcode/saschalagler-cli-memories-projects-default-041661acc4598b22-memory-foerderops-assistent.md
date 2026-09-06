---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/foerderops-assistent.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: foerderops-assistent
description: FörderAssistent aktiv — Web-UI auf 127.0.0.1:8765, 70 Wissensdokumente,
  Vertex-AI-Backend, Konflikt-Register, Credit-Nutzung
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ec864b92-2403-44f6-8057-fd71047cea94
---

FörderOps-Assistent für Körperfluss (aktiviert 30.08.2026). Wissensbasis: `~/Desktop/DigiARK-KörperflussEDu3dWebappVerkaufsentwicklung/FOERDEROPS_WISSENSBASIS.md` (generiert) + Quelldateien `all_ssot.md`, `project_task_summary Kopie 2.md`, Angebot AN-2026-020 im selben Ordner.

Regeln beim Prüfen von Anträgen/Mails: NUR belegte Fakten aus der Basis; Konflikte (K1–K11) benennen statt raten; **„digi4KMU 50.000 €" existiert nicht** — real ist inno4KMU 20.000 € (40 %), digi4Wirtschaft ist geschlossen.

Cloud-Setup: Projekt **koerperfluss-antigravity** (Nr. 68337618626, Billing 015D43…), GCS-Bucket **koerperfluss-foerderops-kb** (europe-west3). Vertex-Data-Stores **foerderops-kb-v2** + **v3** erstellt (CONTENT_REQUIRED), aber GCS-Import aller Dokumente wiederholt fehlgeschlagen (4/4): Discovery Engine lehnt .txt/.html/.jsonl ab mit „invalid unstructured data format, please provide NDJSON or JSON Lines". Indexierung hat NICHT stattgefunden. **Lokaler Assistent ist die funktionierende Lösung** (siehe unten). **API-Quirk:** alle discoveryengine-Calls brauchen Header `x-goog-user-project: koerperfluss-antigravity` (ADC-Quota-Projekt 681255809395 ist falsch vorkonfiguriert). Siehe [[google-cloud-genai-credit]].

**Lokaler Assistent (CLI, 30.08.):** Python-Skript `~/.agents/tools/foerderops_assistent.py`, verlinkt als `/opt/homebrew/bin/foerderops`. Lädt die Wissensdokumente lokal (Keyword-Retrieval), ruft Gemini 2.5 Flash via Vertex AI (gcloud-Token, Projekt koerperfluss-antigravity) auf — API-Key-Pfad (GEMINI_API_KEY) liefert 429 (rate-limited), Vertex-Fallback mit `role: user` im Content-Body funktioniert. SSRF-gehärtet (HTTPS-only, Host-Allowlist googleapis.com, keine Redirects, keine privaten IPs). Nutzung: `foerderops "Frage"` oder interaktiv `foerderops`. Live-Test bestätigt.

**Web-UI-Status 06.09. spät: LÄUFT WIEDER** (per Agent gestartet: `nohup python3 ~/.agents/tools/foerderops_web.py`, HTTP 200 auf 127.0.0.1:8765) — aber OHNE Autostart/LaunchAgent, stirbt bei Reboot. Kopien des Tools auch unter `~/Claude/Projects/Förderops` und `~/koerperfluss-frontend-optimized/Foerder-Ops` (Drift-Gefahr).

**Web-UI (30.08., von Sascha eingefordert — „ich will eine grafische Oberfläche du trotel"):** `~/.agents/tools/foerderops_web.py` — lokale Chat-Oberfläche auf **http://127.0.0.1:8765**, öffnet Browser automatisch. Dark/Gold-Design im Körperfluss-Look, 5 Schnell-Buttons (inno4KMU, FFG Status, Website-Lücken, Offene Konflikte, Google-E-Mail). API-Endpoint /api im selben Skript. Start: `python3 ~/.agents/tools/foerderops_web.py`. **Sascha will grafische Oberflächen, KEINE Terminal-Befehle** — CLI wurde abgelehnt („was soll ich mit so einem befehl").

**Wissensbasis-Verzeichnisse (30.08., alle eingebunden — 70 Dokumente, 3,2 MB):**
1. DigiARK-Ordner (8: SSOT, Wissensbasis, Masterliste, 5 PDFs)
2. FÖDERUNG (18: Bescheide, Businesspläne, Compass-Scan, Chats, Strategie-PDFs)
3. Körperfluss-PILOT.AI (10: FFG Re-Submission V2, Literaturverzeichnis, Pilotpartner, Audit)
4. Koerperfluss-3D-Upgrade (12: Wayfinder-Map, Businessplan Cashflow, Projekt-Status)
5. Koerperfluss_OS_Export (18: Project_Status: Edu_App, Google_Startup, FFG_Projekt + Cards)
6. SECOND_BRAIN (4: FAKTEN_SSOT, KONFLIKTE, ARCHIV, TODO)
PDFs werden per `pdftotext -layout` extrahiert, MDs/TXTs direkt kopiert, alles nach `/tmp/foerderops_txt/` → vom Web-Skript geladen.

**Stand 30.08. Abend:** 3D-Website 100% live (koerperfluss.web.app). 🔴 Google-$350k-Blocker per dig bestätigt: koerperfluss.at zeigt noch auf alte Webgo-Seite (185.30.32.183, NS bei ns1–4.webgo.de) → EINE Nutzer-Aktion: Webgo-NS-Switch auf ns-cloud-e1…e4. Cap-Table kanonisch: Leon 26/Lisa 26/Sascha 25/Peter 23 (Taskliste 5.1 vertauscht = falsch). K9 (AWS AI Adoption 150k/30–50 %) und K1 (FFG Kleinprojekt 150k/90k/45–60 %) durch RESEARCH_FOERDERUNGEN_2026.md geklärt. Antigravity-Audit-Doc enthält 4 bekannte Halluzinationen (Jose Alberto, permanentes LNK, 148 %, FH-Linz-LOI) — nie als Beleg zitieren.

**Sascha hat Antigravity-Projekte unter `/Users/saschalagler/Documents/antigravity/` (agitated-rutherford, bold-hawking, happy-hertz, hopeful-oppenheimer, lively-pascal, noble-babbage, proud-bose, quirky-einstein). Sein Antigravity-Hauptprojekt heißt „3d Körperfluss" (in Antigravity Settings: Full machine, Always Proceed).**
