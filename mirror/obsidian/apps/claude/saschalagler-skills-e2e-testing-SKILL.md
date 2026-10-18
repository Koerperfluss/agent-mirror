---
app: claude
quelle: "saschalagler/skills/e2e-testing/SKILL.md"
stand: 2026-10-18
tags: [spiegel, claude]
---

---
name: e2e-testing
description: "AI-powered E2E-Testing fuer jede App (Flutter, React Native, iOS Swift, Android Kotlin, Electron, Tauri, Web) ueber flutter-skill MCP. Agent sieht Bildschirm, tippt, scrollt, inspiziert UI-Baum, verifiziert State — null Testcode. Nutzen wenn der User eine App UI end-to-end testen, Smoke-Tests, Formular-Flows oder Navigation pruefen will, cross-platform."
---

# E2E-Testing — 8 Plattformen, null Testcode (lokal integriert)

`flutter-skill` (npm v0.9.36, global installiert unter `/Users/saschalagler/.local/bin/flutter-skill`) ist ein MCP-Server + CLI, der AI-Agenten mit laufenden Apps verbindet: Screenshots, Taps, Texteingabe, Scroll, UI-Inspektion, Logs — per Naturallanguage.

Quelle (Primärquellen, Stand 2026-10-11):
- Lokal: `/Users/saschalagler/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /Skill Lsite agentic os/flutter-skill-main/skills/e2e-testing/SKILL.md`
- Repo: https://github.com/ai-dashboad/flutter-skill (npm `flutter-skill`, pub.dev `flutter_skill`)
- Nachweis Install: `which flutter-skill` → `/Users/saschalagler/.local/bin/flutter-skill`, `--version` → `0.9.36`, Exit 0
- Nativer Binary (ohne Flutter-SDK): `/Users/saschalagler/.flutter-skill/bin/flutter-skill-macos-arm64-v0.9.37` (Mach-O arm64, `--version` → 0.9.37, Exit 0; als v0.9.36-Filename kopiert, damit der npm-Wrapper ihn findet — Flutter-SDK fehlt auf diesem Mac, Dart-Runtime-Fallback schlaegt fehl)
- Live-Smoke-Test 2026-10-11: `flutter-skill serve https://example.com` + `tools` (Exit 0, Tool-Liste u. a. `tap`, `type_text`, `screenshot`, `snapshot`) + `snap` (Exit 0, echter Seiteninhalt)

## Plattformen

| Plattform | Setup |
|-----------|-------|
| Flutter (iOS/Android/Web) | `flutter pub add flutter_skill` + 2 Zeilen in `main()` |
| React Native | `npm install flutter-skill-react-native` |
| iOS (Swift/UIKit) | SPM: `FlutterSkillSDK` |
| Android (Kotlin) | Gradle: `flutter-skill-android` |
| Electron / Tauri / KMP / MAUI | npm / cargo / Gradle / NuGet |
| Web (beliebige Seite) | kein SDK noetig: `flutter-skill serve <url>` |

## MCP-Konfig (in die MCP-Config des Hosts eintragen)

```json
{
  "mcpServers": {
    "flutter-skill": {
      "command": "flutter-skill",
      "args": ["server"]
    }
  }
}
```

## CLI (ohne MCP, fuer Skripte/CI)

```bash
flutter-skill init            # Projekt-Patch: Testing-Bridge einbauen
flutter-skill launch .        # App starten, VM-Service-URI ablesen
flutter-skill serve <url>     # bestehende Website/App per HTTP ausliefern
flutter-skill snap            # Accessibility-Tree (~200 Tokens statt ~4000)
flutter-skill screenshot /tmp/ss.jpg
flutter-skill tap "Login"
flutter-skill type "hello@example.com"
flutter-skill explore <url> --depth=3      # autonome Bug-Suche
flutter-skill monkey <url> --actions=100   # Fuzzing, Crash-Detection
```

## Core-Loop (immer in dieser Reihenfolge)

```
screenshot() → inspect_interactive() → tap(ref)/enter_text(ref) → screenshot() → wait_for_element()
```

- Nach `screenshot()`: erwarteten Screen bestaetigen, Aktion erst dann.
- Nach `tap`/`enter_text`: `screenshot()` auf UI-Reaktion.
- Nach Navigation: `wait_for_element(key: "...", timeout: 5000)`. Timeout → `screenshot()` + `get_logs()`/`get_errors()`.
- `inspect_interactive()` leer → Screen-Load pruefen, `get_logs()`, kurz neu versuchen.

## Semantische Refs (zielrobust gegen UI-Aenderungen)

```
button:Login   input:Email   toggle:Dark Mode   button:Submit[1]
Format: {role}:{content}[{index}]   Rollen: button, input, toggle, slider, select, link, item
```

Ziel-Prioritaet: `ref:` > `key:` > `text:` > Koordinaten (letzter Weg).

## Validierungs-Checkpoints (Beweispflicht)

| Aktion | Nachweis-Pflicht |
| :--- | :--- |
| `launch_app()` | VM-Service-URI im Output, sonst: Framework vorhanden? kompiliert App? |
| `inspect_interactive()` | >0 Elemente, sonst screenshot + retry |
| Tap/Text | screenshot mit erwartetem State |
| Navigation | `wait_for_element` Erfolg; bei Timeout logs/errors |
