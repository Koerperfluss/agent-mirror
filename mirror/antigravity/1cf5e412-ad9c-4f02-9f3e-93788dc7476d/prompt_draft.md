# Teamwork Project Prompt — Draft

> Status: Launched
> Goal: Craft prompt → get user approval → delegate to teamwork_preview
> Requested team: Großes, parallel arbeitendes Agenten-Team

Das bestehende Agent OS unter `/Users/saschalagler/agent-os/` scannen und physisch zu einem autonomen Fullstack Development Tool umbauen. 
Use a very large team of agents.

Working directory: /Users/saschalagler/agent-os
Integrity mode: development

## Requirements

### R1. One-Shot Execution ("Reicht und los")
Das Tool muss als zentralen Input einen simplen String akzeptieren (z.B. "Ich möchte eine React App für XY entwickeln"). Es muss daraufhin autonom den Orchestrator, Router und die Engines triggern, ohne weitere manuelle Konfiguration zu erfordern.

### R2. Modul-Konsolidierung
Die existierenden Python-Module (`orchestrator.py`, `engines.py`, `router.py`, `maker.py`, `audit.py`, `discovery.py`, `slicer.py`) zu einem zentral ausführbaren CLI-Tool zusammenführen, das alle Provider steuert.

### R3. Desktop Commander & Strix Integration
Das System muss die Fähigkeiten des Desktop Commanders (Hintergrundprozesse) nutzen, um lokale Server (z.B. LiteRT, Ollama) zu verwalten. Nach Code-Generierung muss autonom ein Strix-Pentesting-Scan getriggert werden.

## Acceptance Criteria

### Funktionalität
- [ ] Ein Aufruf wie `agentos build "Ich brauche ein FastAPI Backend"` startet erfolgreich die gesamte Pipeline.
- [ ] Das Ausführen des neuen Haupt-Orchestrators liefert einen Status-Report aller aktiven Provider.
- [ ] Ein initialer Strix-Sicherheits-Scan lässt sich direkt über das Agent OS triggern.
