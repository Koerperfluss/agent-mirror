# LOKI / Agent OS: One-Shot Tool Roadmap

Live-Tracking der Agenten-Schwarm-Ausführung. Das finale Ziel ist ein System, bei dem die Eingabe "Ich möchte XY entwickeln" ausreicht, um die komplette Entwicklung autonom zu steuern.

## Phase 0: Architektur & Planung
- [x] Codebase gescannt (`survey_codebase.md`)
- [x] Desktop Commander Spec erstellt
- [x] Strix Pentesting Spec erstellt
- [x] Master-Plan (`PROJECT.md`) & Test-Infra (`TEST_INFRA.md`) generiert

## Meilenstein 1: CLI & Konsolidierung
- [x] Design-Specs für CLI Framework abgeschlossen (Explorers fertig)
- [x] Refactoring: `orchestrator.py`, `router.py`, `slicer.py` zu einem Modul verschmelzen (cli.py & bin/agentos)
- [x] Basis-Tests implementieren (77 Unit Tests)
- [x] Audit-Gate (Review/Challenger/Auditor) bestanden

## Meilenstein 2: One-Shot Build Execution Flow (Aktueller Fokus)
- [/] Pipeline Orchestration (Exploration gestartet)
- [ ] Maker/Synthesis Integration
- [ ] Test Suite Blueprints

## Meilenstein 3: Desktop Commander Core
- [ ] Schnittstelle für Background-Prozesse (Start/Stop)
- [ ] Auto-Boot für Offline-Dienste (z.B. LiteRT, n8n)
- [ ] Logging & Process-Monitoring

## Meilenstein 4: Strix Security
- [ ] Autonome Audit-Schnittstelle (`agentos audit --security`)
- [ ] Reporting-Engine für Leaks & Vulns

## Meilenstein 5: Provider-Steuerung
- [ ] Ollama Engine Integration (qwen2.5-coder)
- [ ] LM Studio Engine Integration
- [ ] Gemini Engine Integration (Cloud)

---
*Legende: `[ ]` Offen, `[/]` In Arbeit, `[x]` Erledigt.*
