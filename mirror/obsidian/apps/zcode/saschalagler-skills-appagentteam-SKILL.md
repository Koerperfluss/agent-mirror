---
app: zcode
quelle: "saschalagler/skills/appagentteam/SKILL.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: appagentteam
description: "Startet ein App-Dev-Agent-Team (Architekt, iOS, Android, Web/Flutter, QA-E2E, Code-Reviewer, Workflow-Optimierer) das Features entwickelt, die App per flutter-skill E2E durchtestet, Reviews macht und Workflows optimiert. Nutzen wenn der User /appagentteam aufruft oder ein App-Projekt 'vom Team entwickeln und testen' will."
---

# /appagentteam — App-Dev-Agent-Team (Sub-Agenten-Cluster)

Team-Orchestrierung fuer App-Entwicklung: bauen → E2E-testen (flutter-skill) → reviewen → Workflow optimieren. Alle Behauptungen mit Befehlsausgabe/Exit-Code belegen (Beweispflicht).

## Bezugspfade

| Item | Pfad |
| :--- | :--- |
| flutter-skill CLI | `/Users/saschalagler/.local/bin/flutter-skill` → **Symlink auf Native-Binary** `~/.flutter-skill/bin/flutter-skill-macos-arm64-v0.9.37` (live getestet 11.10.2026: `serve` + `snap` auf example.com, Exit 0) |

⚠️ **Installations-Falle (behoben, bei npm-Update erneut anwenden):** Der npm-Wrapper (`cli.js`, v0.9.36) crashet mit `spawn ENOEXEC` (Postinstall lädt 0-Byte-Binary; Node-Spawn scheitert an Gatekeeper/provenance). Fix:
```bash
curl -sL "https://github.com/ai-dashboad/flutter-skill/releases/download/v<TAG>/flutter-skill-macos-arm64" -o ~/.flutter-skill/bin/flutter-skill-macos-arm64-v<TAG> && chmod +x ~/.flutter-skill/bin/flutter-skill-macos-arm64-v<TAG>
ln -sf ~/.flutter-skill/bin/flutter-skill-macos-arm64-v<TAG> ~/.local/bin/flutter-skill
```

⚠️ **CLI-Trap:** Flags als ERSTES Argument = „Unknown command". Flags NACH dem Subcommand oder als Env: `FS_PORT=3742 flutter-skill snap`.

🔒 **MCP nur projektweise, NIE global** (253 Tools = Context-Tax in jeder Session). Im App-Projekt `.mcp.json`: `{"mcpServers":{"flutter-skill":{"command":"flutter-skill","args":["server"]}}}`. Globale `~/.mcp.json` bleibt unberührt.

⚙️ **Betriebsregeln:** max 3 PARALLEL-Subagenten (Discovery/Build/Test) · nur 2 GO-Gates (Plan-GO + Deploy-GO) · Modell-Routing: Plan/Architektur = GLM-5.3, Ausführung/Tests = GLM-5.3-Flash (`subagent_model` explizit). flutter-skill `serve` nutzt CDP 9222 = Agent-Chrome (Browser-Doppelsystem-kompatibel).
| E2E-Quell-Skill | `/Users/saschalagler/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /Skill Lsite agentic os/flutter-skill-main/skills/e2e-testing/SKILL.md` |
| E2E- integrierter Skill | `~/.zcode/skills/e2e-testing/SKILL.md` |
| Aufgaben-Verteilung | `~/.zcode/skills/skill-aware-task-distribution/SKILL.md` |
| Lean-Build | `~/.zcode/skills/lean-build/SKILL.md` |
| UI-Tester | `~/.zcode/skills/ui-ux-tester/SKILL.md` |

## Rollen (Sub-Agenten, via `spawn_agent` parallel starten)

| ID | Rolle | Aufgabe | Werkzeug-Anchor |
| :--- | :--- | :--- | :--- |
| R1 | Architect / PM | Scope zerlegen, Plan, Schnittstellen | lean-build, domain-modeling |
| R2 | iOS-Dev | Swift/SwiftUI + FlutterSkillSDK | developing-ios-apps |
| R3 | Android-Dev | Kotlin + flutter-skill-android | — |
| R4 | Web/Flutter-Dev | Flutter-Code, 2-Zeilen-Bridge in main() | e2e-testing |
| R5 | QA-E2E | Core-Loop + explore/monkey, Bug-Report | e2e-testing, ui-ux-tester |
| R6 | Code-Reviewer | Diff-Review, Konventionen, Sicherheit | code-review |
| R7 | Workflow-Optimizer | Build/Test-Zeiten, CI, Auto-Heal | better-ui, backend-development |

## Ablauf (Phasen, immer in Reihenfolge)

| Phase | Aktion | Ergebnis / Exit-Nachweis |
| :--- | :--- | :--- |
| 0 Plan | R1 zerlegt Feature-Request, legt Task-Liste an (`team_task create`) | Tasks mit Depends-On |
| 1 Build | R2/R3/R4 parallel via `spawn_agent`; Git-Commit je Feature | `git log -1` pro Modul |
| 2 E2E | R5: `flutter-skill init` → `launch` → Core-Loop → `explore --depth=3` | Screenshots + Exit-Codes, Testprotokoll |
| 3 Review | R6 prueft alle Diffs der Phase 1–2 | Diff-Befunde, keine offenen P0 |
| 4 Optimize | R7 misst Build/Test-Zeit, kuerzt Workflows | Vorher/Nachher-Zeiten |
| 5 Report | BLUF-Report + 3 naechste Schritte | GFM-Tabelle, Beweise pro Zeile |

## E2E-Testregeln (R5, verbindlich)

1. Immer `screenshot()` vor und nach jeder Aktion.
2. Zielen per semantischem `ref:` (nicht Koordinaten).
3. Nach Navigation `wait_for_element` mit Timeout; bei Timeout `get_logs()`/`get_errors()`.
4. Jeder gefundene Bug: Screenshopf + Reprodu-Schritte + Logauszug.
5. Abschluss: `flutter-skill monkey <app> --actions=100` (Crash-Suche) + `explore --depth=3`.

## Start (User-Aufruf)

```
/appagentteam <Pfad-zur-App> "<Feature oder Testziel>"
```

Ohne Argumente: aktuelles Verzeichnis als App-Pfad, Testziel vom User in einer Runde erfragen (eine Frage, Optionen: Feature bauen / E2E testen / beides).

## Stopp-Regeln

- Kein Loopen: gleicher Fehler 2x → Stopp, Befund melden.
- Keine Behauptung ohne Exit-Code/Screenshot.
- Loeschen von Projekt-Code nur mit Bestaetigung.
