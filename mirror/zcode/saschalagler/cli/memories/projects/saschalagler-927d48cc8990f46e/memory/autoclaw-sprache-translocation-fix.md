---
name: autoclaw-sprache-translocation-fix
description: 02.10. AutoClaw-Chinesisch-Fix per settings.json +
  AutoClaw2-Quarantäne entfernt; App→Config-Ordner-Zuordnung dokumentiert
metadata:
  node_type: memory
  type: project
  originSessionId: sess_676af85d-22de-45e5-bc46-645ec289e5c8
---

02.10.2026 — AutoClaw-Apps nach Update zuordnen + fixen:

| App | Version | Bundle-ID | Config-Ordner |
|---|---|---|---|
| AutoClaw.app | 1.18.5 | com.zhipuai.autoclaw | `~/Library/Application Support/autoclaw/` |
| AutoClaw2.app | 2.0.1 | com.zhipuai.autoclaw2 | `~/Library/Application Support/AutoClaw-official/` |
| ZCode.app | 3.14.4 | dev.zcode.app | `~/Library/Application Support/ZCode/` |

- **Sprache-Fix:** `"language": "zh-CN"` in `settings.json` → `appearance.language = "en-US"` (AutoClaw1 gefixt, Backup `settings.json.bak-20261002-sprache`; AutoClaw2 hatte keine settings.json → mit `{"appearance":{"language":"en-US"}}` vorbefüllt). Deutsch wird NICHT angeboten (AutoClaw2 hat 16 Locales, kein `de-DE`).
- **AppTranslocation:** AutoClaw2 lief aus Quarantäne (AppTranslocation = zufälliger Read-Only-Pfad) → `xattr -dr com.apple.quarantine /Applications/AutoClaw2.app` entfernt, Beweis: xattr zeigt nur noch `provenance`. Neustart nötig.
- ZCode läuft am z.ai Coding Plan (Beweis: Session auf `account:zai-start-plan/GLM-5.3-Flash`) — kein separater Login nötig.
- **02.10. Nachtrag (Computer-Use-Verifikation):** AutoClaw 1.18.5 gestartet → UI KOMPLETT ENGLISCH + eingeloggt als „Sascha Lagler" (270 Punkte, GLM-5.3-Flash gewählt) — Sprach-Fix bestätigt. **AutoClaw2 2.0.1 = chinesischer „official"-Kanal und verlangt Login mit chinesischer Handynummer (手机号 + SMS)** — für Sascha nicht nutzbar, das war der echte „nicht mehr möglich"-Grund; deaktiviert lassen. AppTranslocation: xattr-Entfernung + Neustart via `open /Applications/AutoClaw2.app` nötig (LaunchServices startete sonst die alte translokierte Kopie wieder — computer-use-Start respektiert den Stale-Eintrag).
- Settings-Mechanismus beider AutoClaw-Versionen: `settings.json` in Electron-userData, erscheint erst nach erster Änderung (AutoClaw2 main.cjs referenziert es).
