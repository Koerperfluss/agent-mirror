---
app: antigravity
quelle: "1cf5e412-ad9c-4f02-9f3e-93788dc7476d/learning_proposal.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# Learning Proposal: Cross-Platform Omni-Stack Integration

## Analyse
Der Import-Log zeigt: Ein anderer Agent (ZCode/Claude) hat das gesamte System auf 99 Skills und 14 MCP-Server synchronisiert. `caveman`, `i-have-adhd` und `strix-pentesting` wurden als globale Standards für alle 5 IDEs/Agents (inkl. Antigravity) gesetzt. Die zentrale Steuerung liegt nun in `~/.agents/STANDARD-SKILLS.md` und `~/.agents/skill-routing.md`.

## Klassifizierung
**Global Rule Update** (Antigravity muss sich dem neuen Master-Setup unterordnen).

## Proposed Changes

### [MODIFY] `~/.gemini/GEMINI.md`
Folgende permanenten Direktiven werden der LOKI.OS Konfiguration hinzugefügt:

```diff
+ ## ⚙️ Cross-Platform Omni-Stack (ZCode Sync)
+ *   **Master-Routing:** Konsultiere IMMER `~/.agents/STANDARD-SKILLS.md` bei komplexen Tasks.
+ *   **Memory Tool Calling:** Prüfe `~/.agents/skill-routing.md` für bewährte neue Zuordnungen vor der Skill-Wahl.
+ *   **Default Output:** `caveman` und `i-have-adhd` sind permanent aktiv. Keine Prosa, nur Tabellen/BLUF.
+ *   **Sync-Script:** Wenn neue Skills erstellt werden, führe `~/.agents/tools/sync-standard-skills.sh` aus, um sie in allen 5 Harnesses verfügbar zu machen.
```

## Aktion
Nach deiner Bestätigung trage ich diese neuen Systemregeln fest in `GEMINI.md` ein, damit sie ab der nächsten Session automatisch gelten.
