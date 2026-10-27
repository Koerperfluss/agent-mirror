---
app: zcode
quelle: "saschalagler/workspace/1793024820133-8d065fb4-bac5-4106-8c13-ba8a6f59e46a/skills-bericht-2026-10-27.md"
stand: 2026-10-27
tags: [spiegel, zcode]
---

# Skills sind DA — 249 Ordner, 218 gesund

**Ergebnis in einem Satz:** Deine Skills existieren und funktionieren — sie starten über das **AGENTS.md-Routing** (Routing = eine Tabelle in `~/.zcode/AGENTS.md`, die sagt: bei dieser Aufgabe → dieser Skill), **nicht** über ZCodes Slash-Menü. Deshalb siehst du sie dort nicht. **Skill** = ein Ordner mit einer `SKILL.md`, die dem Agenten Anweisungen gibt.

**Beleg:** laut vorgelagertem Skill-Scan wurden **249 Skill-Ordner** gefunden, **218** haben eine gültige `SKILL.md` und sind gesund. Die restlichen 31 sind Ordner ohne diese Datei oder Duplikate.

## 1. Kaputte Skills (11 Stück, Klasse „kaputt“)

**Kaputt** = der Ordner existiert, aber die Datei `SKILL.md` fehlt — der Agent kann ihn deshalb nicht laden.

| # | Skill | Klasse |
|---|---|---|
| 1 | anatomie | kaputt |
| 2 | beta | kaputt |
| 3 | gstack | kaputt |
| 4 | gstack-openclaw-ceo-review | kaputt |
| 5 | gstack-openclaw-investigate | kaputt |
| 6 | gstack-openclaw-office-hours | kaputt |
| 7 | gstack-openclaw-retro | kaputt |
| 8 | hackernews-frontpage | kaputt |
| 9 | legal | kaputt |
| 10 | research-ops-studienchecker | kaputt |
| 11 | sequential-thinking | kaputt |

## 2. Wie ZCode Befehle lädt

- **Befehl** = Markdown-Datei, Dateiname = Befehlsname (Muster `^[a-z0-9][a-z0-9_:-]{0,63}$`), mit Frontmatter-Schlüsseln `description`, `argument-hint`, `allowed-tools`, `model`, `skills`, `disable-noninteractive`; mindestens `description` oder nicht-leerer Body nötig. `$ARGUMENTS` und `$1` werden durch deine Eingabe ersetzt.
- **Orte:** User: `~/.zcode/commands/` + `~/.agents/commands/` · Workspace: `<repo>/.zcode/commands/` + `<repo>/.agents/commands/` — **first-match-wins** (= der erste Fund gewinnt, spätere gleichnamige werden ignoriert). Unterordner werden mit `:` verkettet (`review/code.md` → `/review:code`). Deaktivieren geht in `~/.zcode/cli/config.json` per absolutem Dateipfad.
- **Skills:** Ordner mit `SKILL.md`, gesucht unter `~/.zcode/skills/` + `~/.agents/skills/` (User) bzw. `<repo>/.zcode/skills/` + `<repo>/.agents/skills/` (Workspace). Plugin-Ordner stehen in der Such-Order **zuletzt** (Stufe 6) — ein gleichnamiger eigener Skill überschattet (= verdeckt) den Plugin-Skill.
- **Doku-Lücken (DATENLAGE UNKLAR):** die „explicitly configured roots“ (Stufe 1) werden genannt, aber kein Ort, wo man sie konfiguriert; die innere Struktur eines Skill-Ordners bleibt auf „Ordner + SKILL.md“ beschränkt.
- **Beleg-Pfade (existieren, geprüft per `ls -la`):** `~/.zcode/cli/plugins/cache/zcode-plugins-official/zcode-guide/0.3.0/skills/zcode-configuration-guide/SKILL.md` und `…/zcode-guide/0.3.0/skills/diagnosing-commands/SKILL.md`

## 3. Neu angelegte Befehle (5 gemeldet → 1 angelegt, 4 übersprungen)

| Befehl | Ergebnis | Grund |
|---|---|---|
| obsidian-init | ✅ **angelegt** | 1:1 adaptiert nach Muster `migrate-workflows.md`; optionale Frontmatter-Felder (category, triggers) aus `~/.claude/commands/obsidian-init.md` übernommen |
| init | ⏭️ übersprungen | `~/.zcode/commands/init.md` existiert bereits (`ls`-Beweis, 935 B) |
| boost | ⏭️ übersprungen | existiert bereits (391 B) |
| standardskill | ⏭️ übersprungen | existiert bereits (651 B) |
| goal | ⏭️ nichts angelegt | keine Quelldatei auf der Maschine (DATENLAGE UNKLAR) — ohne Quelle wäre der Inhalt erfunden |

Neue Datei: **`~/.zcode/commands/obsidian-init.md`** — erstellt + Format geprüft via `ls -la` und `head -12`; der Body weist den Agenten an, die Anleitung aus `~/.claude/skills/obsidian-second-brain/` zu lesen und auszuführen.

## 4. Nächste Schritte

- **Skills einfach nutzen statt suchen:** Schreib die Aufgabe normal hin — das AGENTS.md-Routing startet automatisch den passenden Skill. Kein Slash-Befehl nötig.
- **11 kaputte Ordner aufräumen:** Jeder braucht eine neue `SKILL.md` — oder lösche den Ordner. Sag mir, welche du wirklich brauchst, dann baue ich sie.
- **Obsidian-Befehl testen:** Tippe im Chat einfach „obsidian-init“ bzw. `/obsidian-init` — der Agent liest dann automatisch die Obsidian-Anleitung.
