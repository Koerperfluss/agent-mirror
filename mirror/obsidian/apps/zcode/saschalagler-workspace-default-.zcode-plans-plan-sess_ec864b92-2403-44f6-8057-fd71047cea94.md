---
app: zcode
quelle: "saschalagler/workspace/default/.zcode/plans/plan-sess_ec864b92-2403-44f6-8057-fd71047cea94.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

Regel „Sequential Thinking bei ALLEN Anfragen" in dein bestehendes Standard-System einbauen:

1. **`~/.agents/STANDARD-SKILLS.md`, Sektion A** („Immer aktiv — Output-Stil"): neuen Punkt 3 ergänzen:
   „3. **Sequential Thinking:** MCP-Tool `sequentialthinking` bei JEDER Anfrage aufrufen — auch bei simplen Fragen (min. 1–3 Denkschritte); komplexe Aufgaben vollständig strukturiert (Schritt → Revision → Hypothese → Verifikation)."
2. **`~/.agents/skill-routing.md`**: neue Zeile in der Zuordnungs-Tabelle:
   „| Jede Anfrage (stehende Regel, kein Trigger nötig) | sequential-thinking MCP vor der Antwort | 30.08.2026 |"
3. **Sync ausführen:** `bash ~/.agents/tools/sync-standard-skills.sh` → verteilt den Block nach `~/.cline/CLAUDE.md`, `~/.gemini/GEMINI.md`, `~/.hermes/SOUL.md` (idempotent).
4. **ZCode/Claude-Memory:** im ZCode-Memory-Ordner `sequential-thinking-always.md` (type: feedback) anlegen + Index-Zeile in MEMORY.md; analog eine Zeile unter `## User-Präferenzen` in `~/.claude/projects/-Users-saschalagler/memory/MEMORY.md`.
5. **Verifizieren:** `grep -c "Sequential Thinking"` in allen 4 Zieldateien + `python3 ~/.claude/tools/projects.py --hook` (Test, ob der Block im Session-Start-Kontext landet).

Ergebnis: Ab der nächsten Nachricht gilt die Regel in allen 5 Harnesses automatisch — ohne dass du sie wiederholen musst.