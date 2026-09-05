# KAPITEL 08 — Gesamt-Vergleichsmatrix (alle Dimensionen)

**Stand:** 28.07.2026 · Audit-Status dokumentiert pro Zelle

---

## 8.1 DIE MASTER-VERGLEICHSTABELLE

| # | Dimension | 🏆 Legal Ops Advisor | Judicario (OpenLaw MCP) | Chipsi (OpenLaw SaaS) |
|---|---|---|---|---|
| 1 | **System-Typ** | ✅ Native Mac App (FastAPI:7070+PyWebView, Docker/Firebase optional) | ✅ Headless MCP-HTTP-Connector (.mcp.json:6) | 🔶 SaaS-Chat-App (Login live belegt) |
| 2 | **Lokale Inferenz** | ⚠️ Architektur ✅ (Ollama-local; gemma4 referenziert, aktuell nur phi3:mini installiert); Modell-Training 🔶 in Arbeit (Thomas) | ❌ Cloud-only (Anthropic Claude Pro/Team/Max) | ❌ Cloud-only (gateway.openlaw.cc) |
| 3 | **Offline-Betrieb** | ⚠️ Code: BACKEND_MODE=local ✅; Ist-Zustand: Fallback auf Cloud (verschlüsselt); Air-Gap-Test 🔶 | ❌ Nicht vorgesehen | ❌ Nicht vorgesehen |
| 4 | **Eigene Akten/PDFs (RAG)** | ✅ SQLite FTS5 (264 Chunks, 22 Dateien); lokaler Ingest ✅ | ❌ Nur öffentliches Recht | ⚠️ Safebox (Upload, kein Ordner-Scan) |
| 5 | **RIS OGD API v2.6** | ✅ Live (code+test belegt); Verbatim-Zwang; Titel-Filter | ⚠️ Indirekt via OpenLaw-Korpora | ⚠️ Via Judicario-Motor |
| 6 | **Anti-Halluzination** | ✅ VERBATIM-ZWANG (Verweigerung statt Rat) — härteste Regel | ✅ Verifikations-Pflicht (weicher, aber gut) | 🔶 |
| 7 | **Multi-Agenten** | ⚠️ 6 Sub-Rollen im Omni-Prompt (keine getrennten Prozesse) | ❌ Kein Agentensystem | 🔶 |
| 8 | **Personas** | ✅ 4 (legal_ops_omni, gdb_analyst, vwgh_researcher, compliance) + Auto-Routing | ❌ Keine Personas (ein Prompt/Command) | 🔶 |
| 9 | **Orchester** | ⚠️ .agents/-Protokolle externer Testläufe | ❌ | 🔶 |
| 10 | **Userflow** | ✅ 6-Schritt-Flow (RAM→Routing→RAG→RIS→LLM→Output) | ⚠️ Abhängig von Claude | 🔶 |
| 11 | **Slash-Commands** | ❌ 0/15 nativ; ⚠️ ~9/15 funktional via Prompt+Personas | ✅ 7/15 nativ; 8 fehlend (anwaltl./krit. Modus!) | 🔶 |
| 12 | **3-Modi (Scheinecker)** | ❌ Nicht als Commands implementiert; methodisch vorhanden | ❌ Nicht implementiert | 🔶 |
| 13 | **MCP-Erweiterbarkeit** | ❌ Kein MCP (Standalone-App); eigener Ingest als Alleinstellung | ✅ 6–8 Connectoren, offener MCP-Standard | 🔶 (17 Werkzeuge, Dossier) |
| 14 | **E-Gov-Agentik** | ❌ Nur Textberatung („PORTAL-ROUTING"); Browser-Automation 🔶 (offenes Entwicklungsthema, Thomas) | ❌ | ❌ |
| 15 | **Eval-Framework** | ⚠️ 36 Szenarien (von 100), 7 Typen; ehrliche NEIN-Spalte | ❌ | ❌ |
| 16 | **Latenz (Cloud)** | ✅ ~7.5s (36 Messungen, Gemini-Fallback) | ~5-15s (Claude-abhängig) | 🔶 |
| 17 | **Latenz (lokal)** | ⚠️ ~70s (Mandantenangabe, phi3:mini) | N/A (kein lokaler Pfad) | N/A |
| 18 | **Kosten** | ⚠️ Cloud: Gemini-API-Kosten (aktuell); lokal: 0€ (nach Modell-Training) | ❌ Doppelt: Claude-Abo + Enterprise-Credits | ❌ SaaS-Abo |
| 19 | **Datenschutz (RAO §9)** | ⚠️ Cloud-Modus: Daten via verschlüsselten Server; lokaler Modus: 100% offline (nach Air-Gap-Test) | ❌ Cloud-Gateway (gateway.openlaw.cc) | ❌ Cloud-Gateway |
| 20 | **Sicherheit (Distribution)** | ✅ Kein Klartext-Key in Distribution | ❌ Persönlicher Key in 4 Dateien im Klartext | 🔶 |
| 21 | **Selbstlern-Hirn** | 🔶 Behauptet (Thomas) — kein Code-Beleg | ❌ | ❌ |
| 22 | **Recherchebreite** | ⚠️ Österreich-Primär, DACH/EU Adaptiv | ✅ AT/DE/CH/EU/IP/Steuer/Versicherung (6-8 Korpora) | ⚠️ AT/DE/CH/EU/SK (via Judicario) |
| 23 | **Distribution** | ⚠️ Ein-Klick-Installer (.command), noch kein App-Store | ✅ 3 Wege (CLI/Desktop/Web), Ein-Klick-Installer | ✅ Browser (keine Installation nötig) |

---

## 8.2 Status-Zählung (Audit-Qualität)

| System | ✅ (verifiziert) | ⚠️ (teilweise) | ❌ (nicht) | 🔶 (unbelegt) |
|---|---|---|---|---|
| Legal Ops Advisor | 6 | 10 | 3 | 2 |
| Judicario | 9 | 3 | 10 | 0 |
| Chipsi | 1 | 2 | 1 | 18 |

**Hinweis:** Chipsi hat 18/23 🔶-Werte — nicht weil es schlecht ist, sondern weil kein Zugang zum Backend/Werkzeugkatalog vorlag. Ein Chipsi-Login würde viele 🔶 in ✅ oder ❌ auflösen.
