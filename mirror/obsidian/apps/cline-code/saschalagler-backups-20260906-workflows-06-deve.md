---
app: cline-code
quelle: "saschalagler/backups/20260906/workflows/06-deve.md"
stand: 2026-09-06
tags: [spiegel, cline-code]
---

# Workflow 06: DEVE — Onboarding · ÜBERNEHMEN · Fertig machen

Nutze den Skill `deve` (~/.agents/skills/deve/SKILL.md — lies und folge exakt). Modus auto: Ordner leer = ONBOARDING · „übernehmen" = TAKEOVER · „fertig machen" = FINISH.

TAKEOVER (bestehendes Projekt, z. B. Atlas): 0) VOLL-SSD-SCAN via mdfind (ganze Platte, sekundenschnell): Projektname + Slug-Varianten + Aliase + Bundle-IDs → Cluster bilden (Projektordner inkl. Zweitkopien/Alt-Versionen, Agent-Daten ~/.cline ~/.zcode ~/.claude ~/.gemini ~/.antigravity ~/.hermes ~/agent-os ~/loki-ki, Docs/Desktop/Downloads/Obsidian). Kanonischen Pfad aus Projektliste bevorzugen; Zweitkopien im Brief melden. 1) MEMORY-SWEEP max 3 Explorer parallel über die gefundenen Cluster + claude-mem + ~/LOKI_SESSION_CONTEXT.md + ~/.agents/WAYFINDER-GLM.md — jede Quelle mit Pfad notieren. 2) FILESYSTEM-STAND: git log/status/branches, README/PROJECT/STATUS, Manifeste, Tests STARTEN (verifizieren statt behaupten). 3) STATE.md schreiben: Stand + Blocker + Wissenslücken + Quellen-Index; Unverifiziertes als „unbestätigt" markieren. 4) PLAN: groß → wayfinder-Map (.wayfinder/) · klein → glm-build-Todos (todo-sync.py). 5) Brief: SSD-Cluster n, Quellen n, Tests x/y, 3-Zeilen-Stand, nächster Zug.

ONBOARDING: Stack auto-detect → git init (kein push!) → .clinerules (Verweis auf globale Regeln) → .env.example (nur Namen, nie Werte) → Stack-Template → STATUS.md+PROJECT.md+BEFEHLE.md → Brief.

FINISH: 1) Audit (max 3 Explorer: Stack/Entry/Tests/TODOs) 2) todo-sync.py atomar 3) Tests laufen lassen (`uv run --with …` bei fehlenden Deps) 4) Fixes bis grün (Syntax-Gates, 3× Self-Healing, dann ⛔+Doku) 5) code-reviewer 6) PROJECT.md + 5-Zeilen-BLUF.

STOPP nur bei Deploy/Löschen/push/>5000 Credits. Modell: glm-first Standard, Plan/Schweres glm-plan. Keine Rückfragen bei klarem Ziel.
