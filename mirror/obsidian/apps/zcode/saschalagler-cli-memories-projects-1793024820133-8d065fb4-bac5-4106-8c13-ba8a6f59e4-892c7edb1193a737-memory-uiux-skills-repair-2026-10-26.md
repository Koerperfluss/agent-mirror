---
app: zcode
quelle: "saschalagler/cli/memories/projects/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e4-892c7edb1193a737/memory/uiux-skills-repair-2026-10-26.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

---
name: uiux-skills-repair-2026-10-26
description: UI/UX-Test-Skills am 26.10.2026 repariert/komplettiert (nicht neu installiert); offene Restpunkte: Skillshare-Manifest, externer Backup-Watcher, ausstehende HUB-Fixes
metadata:
  type: project
---

Am 26.10.2026 festgestellt: Alle beworbenen UI/UX-Skills waren bereits in `~/.claude/skills/` installiert, aber `ui-ux-pro-max` war nur eine nackte SKILL.md (ohne data/, references/, scripts/) und `better-*` fehlten 5 Sub-Skills. Erledigt: ui-ux-pro-max aus nextlevelbuilder/ui-ux-pro-max-skill vervollständigt (4 Laufzeit-`.py` byte-identisch; `validate_data.py` + Tests bewusst übersprungen), better-colors/-layout/-typography/-writing + interface-review aus jakubkrehel/skills installiert, 4 Routing-Zeilen in `~/.agents/skill-routing.md` (Zeilen 32–35) eingetragen. `ui-ux-tester` ist Saschas eigenes deutsches Custom-Skill — es gibt KEIN GitHub-Repo dieses Namens.

Offen (Stand 26.10.2026, nach Stufe A):
1. `_backup-uiux-2026-10-26.tar.gz` wurde ~16:10 extern neu geschrieben (vermutlich Skillshare-Watcher) und enthält jetzt den NEUEN Stand — Original-Altstand-Backup wurde ersetzt.
2. `.skillshare-manifest.json` kennt die 5 neuen better-*-Skills noch nicht (Schema unklar, nicht angefasst).
3. ~~HUB-Bugfixes~~ **ERLEDIGT 26.10. (Stufe A):** `hub-glass.html` repariert (Backup daneben: `hub-glass.html.bak-2026-10-26`, 51 Zeilen geändert). Neu: Kontrast-Tokens `--gr:#15803D`, `--yl:#B45309`, `--rd:#B91C1C`, `--muted:#6B6B62` (alle Paare neu gemessen 4,51–5,30:1 = PASS); alle Schriftgrößen ≥12px; `:focus-visible`-Ring + Karten `role="button" tabindex="0" aria-label` + Enter/Space-Handler; :8055-Polling gedrosselt (agFails-Zähler, nach 3 Fehlern 60s-Takt statt 6s, sichtbarer Hinweis „⚠️ Backend :8055 offline — Abfrage gedrosselt"). Browser-bewiesen: Fehler 77→4, Tastatur-Enter öffnet Detail-Panel, Screenshot `gui-test-screenshots/t4_nach_fix_….png`. Nutzer muss offenen Tab ggf. per Cmd+R neu laden.

Weitergehens-Staffel (26.10.):
- **Stufe A — Fix-Paket HUB**: ✅ erledigt (siehe oben), nach Saschas GO „wenn du schon tust, mach es richtig".
- **Stufe B — Kleinkram** (~25 Min): Skillshare-Manifest nachziehen + Watcher identifizieren (Punkt 1/2 oben).
- **Stufe C — Großer Ausbau**: ✅ **ERLEDIGT 26.10.** (nach Saschas GO via Zitat „Stufe C"): 2 parallele Read-only-Prüf-Agenten. **ATLAS** (`atlas + pliability /ATLAS_MASTER`, React/Tailwind-v4, Pfad hat trailing space): Farben 13/13 PASS, nur SVG-Chart-Label `StatusTab.tsx:66` fill `#71717a`→`#a1a1aa` (4,27→8,05 PASS, Backup `.bak-2026-10-27` via Write-Tool). Offen dort: 245× Schrift <12px in TSX (großer Umbau, NICHT blind gefixt). **storefront**: veraltete `hub-glass.html`-Kopie in `out-firebase/` mit reparierter Version synchronisiert (Backup `.bak-2026-10-27`); **2 Agenten-Befunde waren FEHLALARME** — Amber 35× sitzt auf `background:#422006` (6,79 PASS), Grau auf dunklem Body `#0a0e16` (7,35 PASS): Agent hatte fälschlich gegen Weiß gemessen. Berichte: `UI_AUDIT_2026-10-27.md` je Projektordner. **Vinyl-Scanner**: React-Native/Expo → kein Web-UI auditierbar. **LESSON: Prüf-Agenten-Farbbefunde immer selbst gegen den echten Hintergrund nachmessen, bevor ein Fix angetippt wird.**
- Nebenbefund: agentforce-generate (Salesforce) ist für dieses Setup irrelevant; `/workflow` existiert in ZCode nicht (wiederholt referenziert — nicht einladen).

**Why:** Diese Restpunkte sind aus dem Routing/den Dateien selbst nicht ablesbar und müssen bei der nächsten Session weiterbearbeitet werden; Code-Übertragung dabei [[mimosa-hook-skills-write-tool]]-bedingt via Write-Tool.
