---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/MEMORY.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

# Loki KI Projekt – Persistente Notizen

## Projektstruktur
- **Projektordner:** `~/loki-ki/`
- **Virtual Environment:** `~/loki-ki/venv/` (Python 3.11 via `/opt/homebrew/opt/python@3.11/bin/python3.11`)
- **Scraper:** `~/loki-ki/scraper_vwgh.py`
- **Ausgabe:** `~/loki-ki/data/vwgh_erkenntnisse/`

## Python-Umgebung (M4 Mac)
- pyenv aktiv: **3.13.7** (Default-Shell)
- Homebrew: python@3.11, @3.13, @3.14
- `python3.11` nicht im PATH → vollständiger Pfad nötig: `/opt/homebrew/opt/python@3.11/bin/python3.11`
- venv aktivieren: `source ~/loki-ki/venv/bin/activate`

## Installierte Pakete (loki-ki/venv)
- mlx-lm 0.30.7, mlx 0.31.0, mlx-metal 0.31.0
- transformers 5.2.0, numpy 2.4.2
- requests, beautifulsoup4, markdownify
- pip 26.0.1

## RIS-Scraper: Wichtige Erkenntnisse
- RIS.bka.gv.at nutzt ASP.NET Session-Tokens → direktes HTML-Scraping schlägt fehl
- **Offizielle OGD-API:** `https://data.bka.gv.at/ris/api/v2.6/Judikatur`
  - Parameter: `Applikation=Vwgh`, `PageSize`, `PageNumber`, `Entscheidungsart`, `EntscheidungsdatumVon`
  - Liefert JSON mit ~354.000 VwGH-Dokumenten
- Volltext: XML-URL aus `Data.Dokumentliste.ContentReference.Urls.ContentUrl[DataType=Xml]`
- HTML-Fallback über `Data.Metadaten.Allgemein.DokumentUrl`

## Scraper-Verwendung
```bash
cd ~/loki-ki
source venv/bin/activate
python scraper_vwgh.py --limit 10           # 10 neueste
python scraper_vwgh.py --typ Erkenntnis     # nur Erkenntnisse
python scraper_vwgh.py --ab 2024-01-01      # ab Datum
python scraper_vwgh.py --dry-run            # kein Schreiben
```

## User-Präferenzen
- Kommunikation: Deutsch
- Vor Terminal-Befehlen immer um Erlaubnis fragen (Ausnahme: read-only Abfragen)
- [Auto-Projektübersicht](auto-projektuebersicht.md) — beim Start ungefragt Top-Projekte zeigen (`python3 ~/.claude/tools/projects.py`), Skills/Agents ohne Rückfrage selbst wählen
- [Immer TODO-Liste](immer-todo-liste.md) — in JEDEM Chat/Projekt sofort TaskCreate, Status live pflegen, nie ungefragt weglassen
- Sequential Thinking: MCP-Tool `sequentialthinking` bei JEDER Anfrage aufrufen (Nutzer-Regel 30.08.2026, kanonisch in ~/.agents/STANDARD-SKILLS.md A.3)

## Weitere Projekte
- [LOKI.OS konsolidiert](loki-os.md) — EINE Boot-Kette (com.loki.v15→MASTER_BOOT v15.3.0), EIN Frontend (macos-app-v17, kein Xcode nötig), Dashboard v15.3 mit 7 Tabs + Bedienkanal; Wahrheit=capabilities_map (527 Skills); Redundanzen in `~/loki-ki/_archive/`
- [Gemini API Stack](gemini-api-stack.md) — 4 Skills kanonisch in `~/.agents/skills` + symlinked; Docs-MCP in 8 Configs (Antigravity nutzt `serverUrl`!); Googles Endpunkt liefert 429 → llms.txt-Fallback; Sync: `~/agent-os/gemini-stack-sync.sh`
- [LOKI Agent OS](agent-os.md) — `~/agent-os/loki "Ziel"` = Single-Prompt Multi-Agenten-Dev-Stack (R1–R5); Discovery/Routing/Slicer/Self-Healing; Engines claude→gemini→ollama; Audit in `.agents/auditor_m5/`
- [Körperfluss App](koerperfluss-app.md) — kanonisch `~/Desktop/Koerperfluss-3D-Upgrade` (GitHub 3d.-UPGRADE-); Deploy IMMER `--project gen-lang-client-0285074833` (firebase use=barbulls!); /showcase live; 3 redundante Kopien
- [BAR BULLS Firebase](bar-bulls-firebase.md) — barbulls-app=Shop-Host, gen-lang=Antigravity Hub (nie verwechseln); Rollback-Technik + Unfall-Schutz
- [Barbulls GoPro Labs](barbulls-gopro-labs.md) — HERO11 Outdoor-Sportcasts; Dateien in `~/Desktop/TO DO /GORPO/`; geprüftes Allround-Setting + Token-Fallstricke (Shutter via ISO-Token, kein GP-Log, BITR≤120)
- [GCP Billing](gcp-billing.md) — 015D43=einziges aktives Konto (867€ bis 04/2027); barbulls-app+nervenav wurden entkoppelt (re-link nötig!); lokales gcloud resettet → auth login nötig
- [Gemini Chrome + Mac](gemini-chrome-mac.md) — Nano-KI-Features gehen; volles "Frag Gemini"-Panel + Spark in AT serverseitig gesperrt; #glic-*-override/-guest-url/-disable-safety-checks = Müll aus Fake-Bericht; variations_country-Hebel nur mit US-VPN persistent
- [ATLAS Cali Coach](atlas-cali-coach.md) — kanonisch (KORRIGIERT 05.09., mdfind-beweisen): `~/Desktop/Coworkspace_Ich/atlas + pliability /Atlas Cali Plan`; Desktop-Alt-Pfad TOT; Zweitkopie `~/cali-coach-atlas-final` (Referenz/Lieferant)
- [Legal Ops Advisor](legal-ops-advisor.md) — EINE App: online (Gemini/Demo, datenfrei) + offline (Ollama QAT/privat); BACKEND_MODE-Schalter; ZTeam-Persona-Merging=„Multi-Agent"; gewonnene Fälle + Erfolgs-Muster; ~14-23GB Modell-Aufräumen offen

- [Toolchain Provider-SPOF](toolchain-provider-spof.md) — 30.08.2026 fielen Claude Code/Cline/ZCode zusammen aus: alle auf Z.ai-Kontingent + npm-Mirror blockierte Cline-CLI; Diagnose-Fallen (npm view via Mirror, nested node_modules, Logs statt Dateien)

## Skill-Routing
- [Skill-Routing-Memory](skill-routing.md) — erlernte Task→Skill-Zuordnungen; Kanonisch: ~/.agents/skill-routing.md

## Obsidian Vault Sync
- Quelle: /Users/saschalagler/Documents/Obsidian Vault/_CLAUDE.md
- Letzter Sync: 2026-08-31
