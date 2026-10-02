---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/autoclaw-sprache-translocation-fix.md"
stand: 2026-10-02
tags: [spiegel, zcode]
---

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
- Settings-Mechanismus beider AutoClaw-Versionen: `settings.json` in Electron-userData, erscheint erst nach erster Änderung (AutoClaw2 main.cjs referenziert es).
