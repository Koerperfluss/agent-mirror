---
app: antigravity
quelle: "1cf5e412-ad9c-4f02-9f3e-93788dc7476d/LOKI_OMNI_CAPABILITIES.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# LOKI OMNI-STACK: FULL SYSTEM CAPABILITIES (V2)

Dieses Dokument ist die vollständige, konsolidierte Matrix aller Fähigkeiten, die aktuell im Antigravity-System geladen sind, erweitert um dein Google Abo und Drittsysteme.

## 1. Cloud & Infrastruktur (MCP Servers)
| Kategorie | Verfügbare MCPs & Tools |
|---|---|
| **Google Cloud (Compute)** | `cloudrun` (Deploy/Logs), `google-kubernetes-engine` |
| **Google Cloud (Data)** | `google-cloud-firestore`, `google-managed-service-for-apache-kafka` |
| **Google Cloud (Ops)** | `google-cloud-logging`, `google-cloud-monitoring`, `google-cloud-quotas` |
| **Firebase** | `firebase-mcp-server` (Auth, Hosting, Crashlytics, RTDB, Messaging) |

## 2. Code, Build & Debugging (MCPs & Skills)
| Technologie | Integrierte Tools & Skills |
|---|---|
| **Web / Browser** | `chrome-devtools-mcp`, `deploy-to-vercel`, `vercel-composition-patterns` |
| **Dart & Flutter** | `dart-mcp-server`, `flutter-apply-architecture`, `flutter-add-widget-test` |
| **Apple / iOS** | `ios-swift-development`, `apple-design`, `xcode-project-setup` |
| **Go & Backend** | `gopls-mcp-server`, `backend-development`, `bigquery-sql` |
| **Source Control** | `github-mcp-server`, `resolving-merge-conflicts` |

## 3. KI, LLMs & Wissen
| Bereich | Tools & Skills |
|---|---|
| **GenAI Frameworks** | `genkit-mcp-server`, `gemini-api-dev`, `gemini-live-api-dev` |
| **Search & Memory** | `vertex-ai-search`, `knowledge-catalog`, `cognee-memory`, `second-brain` |

## 4. Master Agent Pool (LOKI.OS & Meta)
| Typ | Agenten / Rollen |
|---|---|
| **LOKI Personas** | `P-01` bis `P-08` (Architect, Strategic, Physio, Legal, Medical, etc.) |
| **Meta-Agenten** | `jules-meta-agent`, `teamwork-preview`, `parallel-feature-development` |
| **Security & QA** | `strix-pentesting`, `qa`, `flutter_a11y_agent` |

## 5. Kognitive & Verhaltens-Skills
| Skill | Zweck |
|---|---|
| `i-have-adhd` / `caveman` | Zwingt Agenten zu extrem kurzen Antworten (BLUF, Tabellen, 0% Prosa). |
| `sequential-thinking` | MCP für schrittweise Logik bei komplexen Problemen. |

---

## 6. Google Premium / API Abo (Deine Ressourcen)
Was dein bezahltes Google-Ecosystem (GCP Billing + AI Studio/Advanced) freischaltet:

| Feature | Technischer Vorteil für dich |
|---|---|
| **2M Token Context Window** | Jules kann komplette, gigantische Repositories (100+ Dateien) auf einmal lesen, ohne zu vergessen, was in Datei 1 stand. |
| **Vertex AI / API-Zugriff** | Erlaubt dir, das System für Genkit und eigene Agenten-Backends zu nutzen (z.B. für LOKI_MASTER.py), ohne Rate-Limits wie bei Free-Usern. |
| **Cloud Run & Firebase Hosting** | Deine Agenten können Code nicht nur schreiben, sondern ihn per Knopfdruck als fertige App live ins Netz stellen. |
| **Multimodale Inferenz** | Gemini 1.5 Pro analysiert Videos (Gelenkwinkel für Physio), Audio und Screenshots nativ. |

## 7. Cross-Platform Harnesses (Das Multi-IDE Setup)
Wie sich die anderen Systeme (Cline, ZCode, etc.) in den Stack einfügen:

| Harness / Tool | Rolle in deiner Architektur |
|---|---|
| **Antigravity (IDE)** | Dein zentrales Cockpit. Stark für visuelle Tools, Artifacts und tiefe Code-Lenses. |
| **Cline (VS Code)** | Der Worker in VS Code. Teilt sich exakt dieselben 99 Skills und das Routing mit Antigravity. Ideal für hartes Coden im Editor. |
| **ZCode** | Alternative Agenten-Umgebung. Synchronisiert über `STANDARD-SKILLS.md`. |
| **Hermes** | Der unsichtbare System-Gateway/Daemon (läuft im Hintergrund, verbindet M4, Cloud und APIs). |
| **LM Studio / Ollama** | Kostenlose, lokale Modelle (Llama 3, Gemma 4). Perfekt für Datenschutz (Medical/Physio Daten) und Zero-Cost Inferenz auf dem M4-Chip. |
