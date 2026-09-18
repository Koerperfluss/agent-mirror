---
app: zcode
quelle: "saschalagler/workspace/default/.zcode/plans/plan-sess_89889126-6bec-4e4b-b8ec-d30614619344.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

# fix-subagents.sh AUTOMATISCH machen — Selbstheilung ohne manuellen Klick

1. **SessionStart-Hook eintragen** in `~/.zcode/cli/config.json`: bei jedem Chat-Start läuft `fix-subagents.sh --silent` automatisch → App kann den Subagent-Fix nie wieder dauerhaft zerstören
2. **Skript härten**: still + idempotent (= nur schreiben wenn kaputt), keine Backup-Müll-Häufung
3. **Beweis**: Kaputt-Zustand simulieren → Hook läuft → Datei wieder heile (Output als Beweis)
4. Memory-Eintrag: Hook ist aktiv — kein manueller Notfall-Knopf mehr nötig
