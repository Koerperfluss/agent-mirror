---
app: zcode
quelle: "saschalagler/skills/paseo-orchestrate/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: paseo-orchestrate
description: Paseo — Open-Source-Orchestrator für Coding-Agenten (Claude Code, Codex, OpenCode) von Desktop und Mobile. Nutzen, wenn mehrere Agenten gleichzeitig gesteuert/überwacht werden sollen. App-Install braucht GO.
---

# Paseo Orchestrate

Quelle: github.com/getpaseo/paseo · paseo.sh · Apache-2.0 · ~17k Sterne. Lokaler Daemon verwaltet die Agenten; Clients: native Desktop-App, Mobile-App, Web-App, CLI.

## Wofür

- Mehrere Coding-Agenten parallel starten/überwachen/steuern — vom Mac UND vom Handy.
- Sitzungen gebündelt sehen statt viele Terminal-Tabs.

## Installation (App-Install = Sascha-GO nötig, bis dahin NICHT ausführen)

1. Download/Release von https://paseo.sh oder `github.com/getpaseo/paseo` Releases.
2. Daemon starten (siehe README des Repos), Client (Desktop/Mobile) verbinden.
3. Agenten (Claude Code, Codex, OpenCode) als Jobs registrieren.

## Nutzungsskizze

1. Daemon läuft lokal → 2. Agent-Job anlegen (Projekt-Pfad + Startbefehl) → 3. Von Desktop oder Mobile steuern/lesen → 4. Ergebnisse in die jeweilige Session zurückgeben.

## Abgrenzung

- **hcom** (`agent-hcom`-Skill): Agent-zu-Agent-Nachrichten im Terminal — leichtgewichtig, CLI-only.
- **paseo**: zentrale Orchestrierung mit Apps — schwerer, aber mit Mobile-Fernsteuerung.
- Beide ergänzen sich; nie gleichzeitig denselben Agenten von beiden steuern.
