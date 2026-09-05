---
app: cline-code
quelle: "saschalagler/workflows/05-glm-build.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Workflow 05: GLM-BUILD — Director (1 Satz → fertiges Feature)

Vollautomatische Entwicklung OHNE Rückfragen. Nutze den Skill `glm-build` (liegt in ~/.agents/skills/glm-build/SKILL.md — lies ihn und folge ihm exakt).

Kurzfassung des Ablaufs:
1. Ziel aus User-Satz extrahieren (GOAL/DONE WHEN — bei Klarheit NIE nachfragen)
2. Aufwand schätzen (S/M/L/XL + Credits, Flash=⅓ von 5.3)
3. Quota-Entscheidung: Peak (Mo–Fr 08–12 MEZ) → Flash-first; Off-Peak → 5.3 erlaubt. Dokumentieren, nicht fragen.
4. Team-Mapping: Architektur→code-architect(glm-plan) · Frontend/Backend→direkt(glm-first) · Tests→qa · Review→code-reviewer(glm-plan)
5. Todo-Sync atomar: `python3 ~/.agents/tools/todo-sync.py . --goal "…" --tasks '[…]' --effort '{…}'` → Todo-Liste übernehmen
6. Bauen: Syntax-Gate je Datei (ast.parse/node --check), 3× Self-Healing, Tests bis grün (fehlende Deps via `uv run --with …`)
7. Review (code-reviewer), High-Findings fixen
8. PROJECT.md + Bericht (5 Zeilen BLUF + Tabelle + 1 Start-Befehl)

STOPP nur bei: Deploy · Löschen · git push · >5000 Credits (je 1 Bestätigungszeile).
Modell-Hinweis: Standard glm-first; bei 429 NICHT stoppen (OmniRoute rutscht automatisch).
