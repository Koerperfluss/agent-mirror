---
app: zcode
quelle: "saschalagler/cli/memories/projects/firmen-projekte-f4511fad135ee4c4/memory/offene-aufgabe-wissensgrundlagen-update.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: offene-aufgabe-wissensgrundlagen-update
description: Wissensgrundlagen-Update Körperfluss/Förderpilot — Kernteil
  erledigt 11.10.2026, nur Körperfluss EDU (Desktop) offen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_1896791b-68d1-4fe1-be96-cacde5b2e86d
---

Auftrag vom 2026-10-11 (Prompting-Infos der Wissensgrundlagen aktualisieren/erweitern anhand der neuen Gem-Prompts): **Kern erledigt am 11.10.2026**:

1. `~/.agents/skills/foerderguru/SKILL.md` — neuer Abschnitt 6 „PROJEKT-WISSENSGRUNDLAGE KÖRPERFLUSS" (SSOT-Kernzahlen, Cap-Table, 0 Pilotpartner, Kill-Switch). Backup: `SKILL.md.bak-2026-10-11`.
2. `~/.agents/skills/agentallrounder/SKILL.md` + `allrounder/SKILL.md` — Abschnitt 9 „PROJEKT-KONTEXT-KERNEL KÖRPERFLUSS", synchron gehalten. Backups je `.bak-2026-10-11`.
3. `~/antigravity/Körperfluss-PILOT.AI/SECOND_BRAIN/13_PROMPTING_STANDARDS.md` neu angelegt + Zeile in `00_INDEX.md` ergänzt.

`~/.gemini/config/skills/` ist mit `~/.agents/skills/` verknüpft/gemountet — Edits wirken automatisch in beiden (verifiziert per Re-Read).

**Noch offen:** Körperfluss-EDU-Projekt unter `~/Desktop/Coworkspace_Ich/FIRMEN PROJEKTE/` — für ZCode TCC-blockiert (jeder Desktop-Read = „File does not exist"). Fix: Systemeinstellungen → Datenschutz & Sicherheit → Dateien und Ordner → ZCode → Desktop; danach ZCode-Neustart und EDU-Wissensgrundlagen nach demselben Muster (Projekt-SSOT-Abschnitt + Verweis auf 13_PROMPTING_STANDARDS.md) aktualisieren. Siehe [[session-umgebung-shell-defekt]] (Shell-ENOENT gilt evtl. nur für die Session vom 11.10.).
