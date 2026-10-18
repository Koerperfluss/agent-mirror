---
app: zcode
quelle: "saschalagler/skills/loki-dev/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: loki-dev
description: EINE Fullstack-Pipeline mit 5 Modi — INIT (neues Projekt einrichten), BUILD („baue/erstelle/mach mir X", Director Zero-Question), TAKEOVER (bestehendes Projekt übernehmen), FINISH (fertig machen/testen), MAP (Riesenprojekt → wayfinder). Modus wird automatisch erkannt. Konsolidiert die früheren Einzel-Skills (ehem. glm-init, glm-build, deve — archiviert 2026-09-08).
---

# loki-dev — Eine Fullstack-Pipeline (5 Modi)

## Modus-Detektor (immer zuerst)

| Erkennung im Satz / Ordner | Modus |
|---|---|
| „baue / erstelle / mach mir X" | **BUILD** |
| Ordner leer/neu + „neues projekt / onboarden / init" | **INIT** |
| Code vorhanden + „übernimm / projekt übernehmen" | **TAKEOVER** |
| Code vorhanden + „mach fertig / teste / fixen" | **FINISH** |
| „zu groß / mehrere Sessions / Riesenplanung" oder Schätzung = XL | **MAP** → wayfinder-Skill laden (eigenständig, 1 Ticket/Session) |

Mehrdeutig? Naheliegendste Interpretation wählen, in 1 Zeile dokumentieren — **nie fragen**.

## ⚠️ SCHNITT 0 — Orchestrierungs-Gate (PFLICHT, vor allem anderen)

Kein Modus startet, bevor das Gate gelaufen ist. Keine Ausnahme. Es macht die Arbeit sichtbar:

1. **Sequential Thinking** (MCP `sequentialthinking`): 1–3 Schritte Task-Zerlegung — Stufen, Abhängigkeiten, Parallelisierbarkeit. Ergebnis = Task-Graph.
2. **TodoWrite SOFORT** — die Stufen live in die Todo-Liste des Harness (das ist die sichtbare Checkliste während der ganzen Arbeit, Status mitführen).
3. **PLAN-Tabelle in den Chat** (das, was der Nutzer sehen will — DIREKT nach dem Satz, vor jedem Bauen):

   | # | Stufe/Task | Agent | Skill | Modell | ~Tokens | ~Zeit | Dep |
   |---|---|---|---|---|---|---|---|
   | 1 | … | direkt/Explore/… | … | flash/5.3 | …k | …min | — |

4. **PLAN.md ins Projekt** (persistent über Sessions): dieselbe Tabelle + Ziel + DONE-WHEN + Aufwandssumme (Credits/Zeit) + Fortschritts-Spalte, nach jeder Stufe aktualisiert.

Gate-Regeln: Schätzwerte sind Schätzungen (T/±50 %) — lieber rau als gar nicht. Plan nachgelagert präzisieren ist erlaubt, Gate überspringen nie. Bei Map-Modus (wayfinder) ersetzt die `.wayfinder/map.md` die PLAN.md.

## Parallelität (bedarfsberechnet, kein starrer Deckel)

- **Parallelitätsgrad = Anzahl unabhängiger Tasks im Task-Graph** (Dep-Spalte) — so viele wie nötig.
- **Budget-Default 3 gleichzeitig**, begründet mehr (z. B. 5 Research-Fächer) → kurz dokumentieren warum. Grund des Defaults: Quota-Schutz (ZAI-Weekly/5h-Caps, [1310]-Cap bei Fanout) + 16-GB-Mac.
- Subagenten sind Arbeiter ohne Urteil: Brief = Task + Akzeptanzkriterium + Dateipfade. Review bleibt beim Haupt-Agent.

## Gemeinsame Regeln (alle Modi)

- **4 Stopp-Regeln (die EINZIGEN Nachfragen):** 1. Deploy/Veröffentlichen · 2. Löschen/Überschreiben · 3. `git push` · 4. Aufwand > 5.000 Credits. Alles andere: entscheiden, dokumentieren, bauen.
- **ADHS-Output:** Zeile 1 = Ergebnis · Tabellen · max. 3 nächste Schritte · keine Floskeln · Pfade/Kernbegriffe **fett**.
- **1 Task = 1 Session.** Erst Fakten (Befehle), dann Behauptungen — nichts ohne Beweis behaupten.
- **Modell:** Standard glm-first (Flash, ⅓ Kosten) · 5.3 nur Architektur/Multi-File-Refactor/Security · OmniRoute (localhost:20128) rutscht bei 429 automatisch auf Free — nicht stoppen.
- **Parallelität:** bedarfsberechnet aus dem Task-Graph (siehe Parallelitäts-Abschnitt unten); keine fiktiven Agenten/Dienste ansprechen.
- **Qualitäts-Gates:** Syntax-Check nach jeder Datei (`ast.parse` / `node --check` / `bash -n` / JSON-parse) · Fehler → 3× Self-Healing (Fehler in nächsten Prompt) → dann ⛔ markieren + weiter · Secrets NUR Env, nie in Code/Dateien.

---

## Modus BUILD — Director (1 Satz → Ergebnis)

**Keine einzige Rückfrage** (außer den 4 Stopp-Regeln). Die 8 Schritte:

1. **Ziel-Extraktion** (5.3 denken): GOAL + DONE WHEN (messbar) + CONSTRAINTS (Tests laufen, keine Secrets). Mehrdeutig → naheliegendste Deutung, 1 Zeile dokumentieren.
2. **Aufwandsschätzung:** S = 1–3 Tasks/<50 cr/<15 min · M = 4–8/50–300/15–60 min · L = 9+/300–1000/1–3 h · XL = Multi-Service/1000–5000/3 h+. Flash = ⅓ von 5.3.
3. **Quota-Entscheidung** (auto): L/XL → `python3 ~/.agents/tools/omni-health.py` · Peak (Mo–Fr 08–12 MEZ) + groß → Flash-first seriell · Entscheidung in STATUS.md.
4. **Team-Mapping:** Architektur → feature-dev:code-architect (glm-plan) · Exploration → code-explorer/Explore (Flash) · Frontend → direkt + frontend-design-hub · Backend → direkt · Tests/QA → qa/tdd · Security → strix (nur eigene Apps) · Review → code-reviewer (glm-plan).
5. **Todo-Sync (atomar, 1 Aufruf):**
   ```
   python3 ~/.agents/tools/todo-sync.py <projekt> --goal "…" \
     --tasks '[{"t":"…","agent":"…","model":"flash|5.3","size":"S|M|L","dep":[]}]' \
     --effort '{"credits":N,"time":"…","decision":"warum"}'
   ```
   → TodoWrite-JSON sofort übernehmen + LOKI_DEV_PLAN.md + STATUS.md stehen.
6. **Ausführung:** Plan abarbeiten; Unabhängiges parallel (max 3) · Syntax-Gates · Self-Healing · Tests bis grün oder ⛔.
7. **Review:** feature-dev:code-reviewer über Diff — High-Findings fixen, Rest dokumentieren.
8. **Abschluss:** PROJECT.md (Ziel/Team/Modell-Entscheidung/IST vs SOLL/Start-Befehle) + Antwort max. 10 Zeilen (Ergebnis, Tabelle Task→Status, 1 Start-Befehl, 3 Schritte).

---

## Modus INIT — neues Projekt

1. **Existiert nicht?** → `mkdir -p`. Vorhandenes Projekt mit eigenem CLAUDE.md-Inhalt → STOPP + melden (nie überschreiben).
2. **CLAUDE.md** mit Verweis (keine Regeln duplizieren — die leben global): Ziel (1 Satz, darf FEHLT) · „Globale Regeln: `~/.agents/STANDARD-SKILLS.md`" · Kontext (Stack auto-erkennen: package.json→Node, *.xcodeproj→Swift, pyproject→Python).
3. **Repo:** `git init` falls kein .git, Branch main, Initial-Commit. KEIN Push (Stopp-Regel).
4. **Agent-Config:** `.clinerules` mit Verweis auf STANDARD-SKILLS Abschnitt D + projektspezifisch leer · `.env.example` nur Variablennamen.
5. **Infrastruktur nach Stack:** web_modern → package.json-Skripte + .gitignore · api_python → `uv run`-Pattern + /health-Vorlage · mobile_swift → Struktur + xcuserdata/DerivedData-ignore · sonst → README + .gitignore + docs/.
6. **Knowledge Base + Workflows:** STATUS.md + PROJECT.md-Skelett · docs/BEFEHLE.md (Copy-Paste: starten/testen/bauen inkl. `uv run`-Fallback).
7. **Bericht (3 Zeilen):** angelegt · erkannt · nächster Schritt („sag: baue X").

10-Minuten-Ziel — reicht nicht → Kern erst, Rest als Todos.

---

## Modus TAKEOVER — bestehendes Projekt übernehmen

### Phase 1a — VOLL-SSD-SCAN (mdfind, sekundenschnell, GANZE Platte)
```
mdfind -name "<projekt>" ; mdfind "<projekt>usatze"
mdfind "kMDItemDisplayName == '*<slug>*'c" ; mdfind "<alias>"
```
Clustern: Projektordner (auch Zweitkopien/Alt-Versionen!) · Agent-Daten (~/.cline, ~/.zcode, ~/.claude, ~/.gemini, ~/.hermes, ~/agent-os, ~/loki-ki) · Docs (Desktop/Downloads/Obsidian). Funde außerhalb des kanonischen Pfads → im Brief als Konflikt melden.

### Phase 1b — Memory-Sweep (max 3 Explore-Subagents, JEDE Quelle mit Pfad notieren)
claude-mem · `~/.zcode/cli/memories/` grep · `~/.cline/data/sessions/` (zusammenfassend!) · `~/LOKI_SESSION_CONTEXT.md` · Obsidian · `~/.agents/WAYFINDER-GLM.md` + `.wayfinder/` im Projekt.

### Phase 2 — Filesystem-Stand (direkt)
Git: `log -20 --oneline`, `status`, Branches, remote · Doku: README/PROJECT/STATUS · Manifeste → Stack · **Tests wirklich starten** (rot = messen, nicht erzählen) · TODO/FIXME-Scan.

### Phase 3 — STATE.md (immer schreiben)
Aktueller Stand (verifiziert durch Ausführung) · Blocker · Wissenslücken · Quellen-Index (Pfad je Fakt). Nicht Verifiziertes als „unbestätigt" markieren.

### Phase 4 — Plan
Groß/unklar → wayfinder-Map · Klein/klar → BUILD-Schritt 5 (todo-sync.py). Danach 1 Ticket/Task pro Session.

**Brief:** Quellen n · Tests x/y grün (verifiziert) · Stand 3 Zeilen · Blocker · Plan (Map mit N Tickets | M Tasks) · nächster Zug.

---

## Modus FINISH — fertig machen / testen

1. **Audit** (max 3 Explore/code-explorer parallel): Stack, Entry-Punkte, Tests vorhanden? TODO/FIXME-Scan.
2. **Todo-Sync** (atomar, wie BUILD Schritt 5).
3. **Tests:** vorhanden → laufen lassen (fehlender Interpreter → `uv run --with <deps>`) · fehlen → Minimum für kritischen Pfad schreiben.
4. **Fixes:** rot→grün · Syntax-Gates · 3× Self-Healing → ⛔ + Doku.
5. **Review:** code-reviewer über Diff, High-Findings fixen.
6. **Doku:** PROJECT.md + BEFEHLE.md + Obsidian-Update · Brief: 5 Zeilen BLUF + Tabelle + 1 Start-Befehl.

## Portierte Residuen (2026-09-08, Quellen: glm-build, deve — archiviert)
- Review-Alternative: statt code-reviewer darf `cavecrew-reviewer` (caveman-komprimiertes Diff-Review, ~60 % kleinere Tool-Results) eingesetzt werden.
- Antigravity-Regel: Antigravity-Agents nur verwenden, wenn real vorhanden; sonst in PLAN als „manuell" listen (kein Faken von Agent-Läufen).
