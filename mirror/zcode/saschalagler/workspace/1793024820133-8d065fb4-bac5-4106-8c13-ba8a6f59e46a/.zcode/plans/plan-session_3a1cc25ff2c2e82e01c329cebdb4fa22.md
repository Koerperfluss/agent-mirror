# UI/UX-Test-Skills: aktualisieren, vervollständigen, verdrahten, beweisen

## Ausgangslage (verifiziert)
- Alle 3 beworbenen Skill-Sets sind bereits in `~/.claude/skills/` installiert → **keine Neu-Installation**.
- Reale Lücken: (a) `better-interface` referenziert 5 Sub-Skills, die lokal fehlen; (b) `ui-ux-pro-max` möglicherweise veraltet (Upstream heute gepusht); (c) `~/.agents/skill-routing.md` hat keine Zeilen für die UI/UX-Skills.

## Schritte

### 1. Backup (vor jedem Eingriff)
`~/.claude/skills/{ui-ux-pro-max,better-interface,better-ui,better-accessibility}` → `~/.claude/skills/_backup-uiux-2026-10-26.tar.gz`
Beweis: tar-Datei vorhanden.

### 2. ui-ux-pro-max aktualisieren
Frisches Clone von `github.com/nextlevelbuilder/ui-ux-pro-max-skill` → Dateien (SKILL.md, references/, Such-Tool) ersetzen. Beweis: diff-Statistik alt↔neu + aktualisierte Regel-Zahlen in SKILL.md.

### 3. better-* vervollständigen + aktualisieren
Aus `github.com/jakubkrehel/skills`: fehlende `better-layout`, `better-typography`, `better-colors`, `better-writing`, `interface-review` installieren; bestehende 3 (`better-interface`, `better-ui`, `better-accessibility`) auf Stand bringen (Symlink-/skillshare-Struktur beibehalten oder echte Ordner, je nachdem worauf die Symlinks zeigen — wird beim Umsetzen geprüft). Beweis: ls-Output mit allen better-* + interface-review.

### 4. Routing verdrahten
Neue Zeilen in `~/.agents/skill-routing.md` (Tabelle „Erlernte Task→Skill-Zuordnungen"):
| Signal | Skill |
|---|---|
| „UI/UX-Design-Audit", „Review Interface-Code" | ui-ux-pro-max |
| „Barrierefreiheit/WCAG prüfen" | better-accessibility |
| „gesamtes Interface reviewen" | better-interface (Orchestrator) |
| „klick-teste/durchklicke App X" | ui-ux-tester (Fallback: browser-use:web-gui-tester) |
Beweis: grep auf die neuen Zeilen.

### 5. Smoke-Test A — Design-Audit (ui-ux-pro-max)
Audit auf Verkaufs-HUB `hub-glass.html` (aktives Projekt lt. Tagesplan; Fallback: ATLAS-Web-App). Beweis: Audit-Report als Datei + Top-3-Befunde im Chat.

### 6. Smoke-Test B — Klick-Test (ui-ux-tester)
Auf HUB `:3300`, falls Server läuft (sonst starten oder auf file:///ATLAS ausweichen). Wenn chrome-devtools-MCP in der Session fehlt: browser-use:web-gui-tester als Runner nutzen (Methodik bleibt). Beweis: Screenshot-Ordner + Kurzreport (PASS/FAIL je Testpunkt).

### 7. Abschluss-Report
- Beweis-Pfade je Schritt + Exit-Codes
- Fakten-Korrektur der KI-Antwort: alles schon installiert; Sterne 140.718 (nicht 113.000); ui-ux-tester = eigenes Custom-Skill ohne GitHub-Repo
- „Was bleibt offen" (max. 3 Punkte)

## Nicht tun
Keine Deploys, keine Löschungen, keine Überschreibung ohne Backup, keine Installation zusätzlicher Skills über die genannten hinaus.

## Aufwand
~30–60 Min nach Freigabe; Credit-Risiko gering (lokale Arbeit, kein MCP-Verbrauch außer evtl. Browser-Screenshots beim Smoke-Test).