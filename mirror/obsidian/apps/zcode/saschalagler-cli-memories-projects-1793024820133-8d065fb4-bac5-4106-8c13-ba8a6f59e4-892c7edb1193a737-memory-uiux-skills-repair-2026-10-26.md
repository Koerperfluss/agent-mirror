---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/uiux-skills-repair-2026-10-26.md"
stand: 2026-10-26
tags: [spiegel, zcode]
---

---
name: uiux-skills-repair-2026-10-26
description: UI/UX-Test-Skills am 26.10.2026 repariert/komplettiert (nicht neu installiert); offene Restpunkte: Skillshare-Manifest, externer Backup-Watcher, ausstehende HUB-Fixes
metadata:
  type: project
---

Am 26.10.2026 festgestellt: Alle beworbenen UI/UX-Skills waren bereits in `~/.claude/skills/` installiert, aber `ui-ux-pro-max` war nur eine nackte SKILL.md (ohne data/, references/, scripts/) und `better-*` fehlten 5 Sub-Skills. Erledigt: ui-ux-pro-max aus nextlevelbuilder/ui-ux-pro-max-skill vervollständigt (4 Laufzeit-`.py` byte-identisch; `validate_data.py` + Tests bewusst übersprungen), better-colors/-layout/-typography/-writing + interface-review aus jakubkrehel/skills installiert, 4 Routing-Zeilen in `~/.agents/skill-routing.md` (Zeilen 32–35) eingetragen. `ui-ux-tester` ist Saschas eigenes deutsches Custom-Skill — es gibt KEIN GitHub-Repo dieses Namens.

Offen (Stand 26.10.2026):
1. `_backup-uiux-2026-10-26.tar.gz` wurde ~16:10 extern neu geschrieben (vermutlich Skillshare-Watcher) und enthält jetzt den NEUEN Stand — Original-Altstand-Backup wurde ersetzt.
2. `.skillshare-manifest.json` kennt die 5 neuen better-*-Skills noch nicht (Schema unklar, nicht angefasst).
3. HUB-Bugfixes (WCAG-Kontrast 4×FAIL: Badges grün 3,00/amber 2,86/rot 3,95 + Muted-Text 3,16 statt ≥4,5:1; Kleintext 9–12,5px; nur 1× :focus bei 7 klickbaren Elementen; :8055-API-Polling ohne Backoff, Backend down) sind nur dokumentiert in `~/Desktop/Coworkspace_Ich/PRIVATE PORJEKTE /TOOL-SAMMLUNG-VERKAUF/UI_AUDIT_2026-10-26.md`, noch nicht umgesetzt. Klick-Tests selbst: 5/5 PASS (Suche, Filter, Detail öffnen/schließen).

Vereinbarte Weitergehens-Staffel (26.10., Nutzerfrage „ist doch viel mehr?" — Entscheidung steht noch aus, Stichworte „Fix HUB" / „Audit alles"):
- **Stufe A — Fix-Paket HUB** (~25–45 Min, 1 Datei, 1 Agent reicht, kein Subagenten-Team): `hub-glass.html` ist Saschas LIVE-Cockpit-Datei → vorher Backup + Diff zeigen, Überschreiben nur mit GO.
- **Stufe B — Kleinkram** (~25 Min): Skillshare-Manifest nachziehen + Watcher identifizieren (Punkt 1/2 oben).
- **Stufe C — Großer Ausbau** (2–4 Std): ui-ux-Skills produktiv auf alle Projekte (ATLAS-Web, storefront, Vinyl-Scanner …) — erst grilling (Scope-Verhör), dann 3 parallele Agents (dispatching-parallel-agents / subagent-driven-development passt hier).
- Nebenbefund: agentforce-generate (Salesforce) ist für dieses Setup irrelevant; `/workflow` existiert in ZCode nicht (28.10.-Kontext wiederholt referenziert — nicht einladen).

**Why:** Diese Restpunkte sind aus dem Routing/den Dateien selbst nicht ablesbar und müssen bei der nächsten Session weiterbearbeitet werden; Code-Übertragung dabei [[mimosa-hook-skills-write-tool]]-bedingt via Write-Tool.
