---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/gstack-toolkit.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: gstack-toolkit
description: ~/gstack = Garry Tans Open-Source-KI-Werkzeugkasten (v1.68.3) —
  bin/-Befehle laufen automatisch über Skills, nicht von Hand anfassen
metadata:
  node_type: memory
  type: reference
  originSessionId: session_3a1cc25ff2c2e82e01c329cebdb4fa22
---

`/Users/saschalagler/gstack` ist **„Garry's Stack"** (Garry Tan, YC) — Open-Source-KI-Engineering-Werkzeugkasten („Claude Code skills + headless browser", MIT, v1.68.3 lt. package.json). Sascha fragte 27.10.2026 irritiert über die ~80 Dateien in `bin/`.

Gruppen: `gstack-brain-*` (Agenten-Gedächtnis, Git-Sync), `gstack-gbrain-*` (Supabase-Wissensdatenbank), `gstack-timeline-/decision-/learnings-*` (Protokolle), `gstack-telemetry-/analytics/benchmark-*` (Statistik/Modellvergleich), `gstack-ios-qa-*` (iOS-App-Tests), `gstack-redact/egress/security-dashboard` (Geheimnisse/ausgehender Verkehr), `browse`/`make-pdf`/`dev-setup`/`dev-teardown`.

**Regeln:** Diese Befehle werden von Skills/Hooks automatisch aufgerufen — die gstack-/gstack-openclaw-* Einträge in `~/.claude/skills/` stammen daher; nichts manuell ausführen; sauberes Entfernen nur über `gstack-uninstall` (mit Backup). Kein Reverse-Engineering-Werkzeug — dafür siehe [[zcode-skills-landscape]] (video2code).
