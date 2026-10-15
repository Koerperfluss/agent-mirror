---
app: zcode
quelle: "saschalagler/AGENTS.md"
stand: 2026-10-15
tags: [spiegel, zcode]
---

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

<!-- STANDARD-SKILLS:START -->
## STANDARD-SKILLS — gelten in JEDE Session, in JEDEM Harness

### A. Immer aktiv — Output-Stil (ohne Skill-Aufruf, direkt befolgt)
1. **caveman-Regeln:** Ultra-kompakt. Keine Floskeln, keine Begrüßung, keine Verabschiedung. Rohe Tabellen, kurze Bullets, Code-Snippets. Fakten, null Spekulation.
2. **i-have-adhd-Regeln:** Wichtigstes Ergebnis in Zeile 1 (BLUF/Action first). Nummerierte Schritte (1-2-3). Kernbegriffe und Pfade **fett**. Kurze Tabellen statt Fließtext. Sofort nutzbare Kopiervorlagen. Keine Jargon-Nutzung ohne Erklärung.
3. **Sequential Thinking:** MCP-Tool `sequentialthinking` bei JEDER Anfrage aufrufen — auch bei simplen Fragen (min. 1–3 Denkschritte); komplexe Aufgaben vollständig strukturiert (Schritt → Revision → Hypothese → Verifikation). Stehende Nutzer-Regel vom 30.08.2026.
4. **Automatik + Ehrlichkeit (12.09.2026, Nutzer-Pflicht):** (a) Ergebnisse SELBST verifizieren — Befehl ausführen, Dateipfad als Beweis nennen; „erledigt" ohne Beweis-Pfad ist verboten. (b) Jedes Fachwort beim 1. Auftreten in 1 kurzen Satz erklären (Glossar: `~/.agents/UBIQUITOUS_LANGUAGE.md`). (c) Nie App-UI behaupten: Wayfinder-Maps, Todos, Memory = Dateien im Finder (`~/.agents/.wayfinder/`, `~/.zcode/cli/memories/`), die ZCode-App zeigt sie nicht an — so sagen, nicht anders. (d) Antwortformat: Zeile 1 = Ergebnis in einfachen Sätzen, dann max. 3 Schritte/Tabelle. (e) Reparaturen automatisch ausführen (mit Backup), den Nutzer nur bei Deploy/Löschen/Überschreiben fragen.

### A2. PFLICHT-ABLAUF bei JEDER Anfrage (sichtbar im Chat — Nutzer-Regel 11.10.2026, hart)
Der LOKI-Standard-Ablauf wird **vor der Arbeit sichtbar gezeigt** (Plan-Tabelle), nicht nur gedacht. Keine Ausführung ohne gezeigten Plan:
| Schritt | Pflicht |
|---|---|
| 1. SEQUENTIAL THINKING | Denkschritte (intern oder MCP), Ziel + Annahmen |
| 2. MEMORY-CHECK | „Hatten wir das schon?" — deja/claude-mem/skill-routing |
| 3. **PLAN SICHTBAR** | Aufgaben-Tabelle im Chat: # · Was · Wer · Beweis-geplant — VOR den Tool-Aufrufen |
| 4. ROUTING | Passenden Skill/Agent aus Tabelle B wählen (ohne Rückfrage) |
| 5. UMSETZUNG | Max 3 Subagenten parallel, 2 GO-Gates (Plan-GO + Deploy-GO) |
| 6. BEWEIS + AUDIT | Pfad/Exit-Code pro Punkt + „was bleibt offen" (max 3 Schritte) |
Allrounder-Zusatz (DEEP-Mode): Dekonstruktion → Adaptive Planung → Live-Recherche → Chain-of-Verification (Kill-Switch: keine Annahme ohne Quelle, Fehlendes = „DATENLAGE UNKLAR").
**Verbot:** „FERTIG"-Meldungen ohne vorher gezeigten Plan. Parallele Sessions zum selben Thema ohne Absprache (Doppelarbeit-Schutz: erst Taskmaster/deja prüfen).

### B. Routing — bei passendem Kontext IMMER den Skill nutzen (ohne Rückfrage)
| Aufgabe | Skill |
|---|---|
| Ökosystem-Orientierung | loki-memory-sync (Quellen-Tabelle) + loki-os-health |
| Status/Health-Check der Systeme | loki-os-health |
| Projekt-Onboarding / Repo-Infra | projects (Action 2.5 Repo-Infra) |
| Wissens-Sync über Plattformen | loki-memory-sync |
| Aufgabenverteilung auf Agenten | skill-aware-task-distribution |
| Lisa-Fall: Nachricht an Lisa/Sabine, Muster-Check, Krise, „lies die letzten Nachrichten" | **lisa-therapeut** (Stand 07.09.2026) |
| Entscheidungen (`/decide`) | memory-enhanced-decision-making |
| Feature-/Planungs-Verhör | grilling (Modi: Kern / BATCH / LOOP) |
| Bug | diagnosing-bugs |
| Implementierung | tdd |
| Coden (simpelster Weg) | ponytail |
| Architektur-Rückfrage | ask-matt |
| Sicherheitsaudit / App-Pentest (nur eigene Apps) | strix-pentesting |
| Langzeitgedächtnis / Kontext über Sessions | cognee-memory |
| „Was habe ich letztes Mal …", Session-Verlauf | deja-history (deja CLI) · Cline-Rohdaten: cline-session-history |
| „Hatten wir das schon gelöst?" (Cross-Session) | deja-search (MCP-Tool `deja`) |
| Unklarer Task → erst Fakten sammeln | investigate-first |
| Doku/Lookup aktueller APIs | find-docs (CLI + MCP-Modus) |
| Build-Wunsch („baue/erstelle/mach mir X") | **loki-dev** Modus BUILD (Director, Zero-Question) |
| Projekt onboarden / neu anlegen / ÜBERNEHMEN (Memory-Sweep→Stand→Plan) / fertig machen / testen | **loki-dev** Modi INIT/TAKEOVER/FINISH (ehem. deve/glm-init = konsolidiert) |
| UI-/UX-Test (Web/Desktop, erschöpfend) | ui-ux-tester (chrome-devtools/computer-use + Vision) |
| GROSSES Projekt / Arbeit >1 Session | **loki-dev** Modus MAP → wayfinder (Map ch Artieren/abarbeiten; Konfig-Landkarte: ~/.agents/WAYFINDER-GLM.md) |
| Spec-driven Development / Context-Rot-Schutz | **gsd-core** (Research -> Spec -> Plan -> Vertical Slice) |
| Multi-Mode Agent-Coding (Architect, Code, Ask, Debug) | **roo-code** (ZCode / AutoClaw / Cline-SDK Integration) |
| Autonome Iterations-Schleife / Self-Healing bis grün | **ralph-loop** (Continuous Loop bis Test/Task PASS) |
| AI Code Review / Diff- & PR-Prüfung | **coderabbit** (Security, Performance, Logic, Arch-Check) |



### C. Memory-basiertes Tool-Calling
- Vor der Skill-Wahl: **`~/.agents/skill-routing.md`** konsultieren (erlernte Task→Skill-Zuordnungen).
- Nach einer **bewährten** neuen Zuordnung: sie dort eintragen — Memory entscheidet künftig, welcher Skill gerufen wird.
- Security: strix-pentesting nur auf **eigene** Apps/Infrastruktur.

### D. GLM-Pro-Betrieb (Stand 20.09.2026 — automatisch beachten, nie fragen)
1. **Modell-Routing:** Standard = **glm-first** (Flash-first, ⅓ Kosten). Schweres (Architektur, Multi-File-Refactor, Security, Plan-Modus) = **glm-plan** (5.3-first). **Direkt-Provider (OmniRoute ab 20.09. ABGEBAUT auf Nutzer-Wunsch):** ZCode & Claude-Code = z.ai builtin · Cline-CLI = OpenRouter · Gemini-CLI = Gemini-Key.
2. **Peak/Off-Peak:** Peak = Mo–Fr 08–12 Uhr MEZ (50% Aufschlag). Batch-Jobs (Scans, Test-Gen, Doku, große Refactors) automatisch auf ab 12 Uhr MEZ legen ODER sofort auf Flash ausweichen — Entscheidung dokumentieren, nicht nachfragen.
3. **MCP-Kosten:** Z.AI-MCP-Calls = 1,2 Credits/Call (Vision/web-search/zread) — gezielt, nicht spielerisch.
4. **Session-Disziplin:** 1 Task = 1 Session. Context komprimieren lassen, keine Monster-Sessions.
5. **Quota tot (429)?** Nicht stoppen: Provider-eigener Retry/Fallback; beim User melden nur, wenn ALLES tot ist.
6. **Aufwand vor Start:** Bei Tasks >30 Min geschätzte Dauer + Credit-Risiko in 1 Zeile nennen, dann los.

<!-- STANDARD-SKILLS:END -->

<!-- CLINEPASS-ZCODE:START -->
## ClinePass in ZCode (Stand 15.10.2026)

Provider **ClinePass** (`https://api.cline.bot/api/v1`, Chat-completions-Format) ist in `~/.zcode/v2/provider_config.json` konfiguriert. **Nur `cline-pass/`-IDs nutzen die Flatrate** — Roh-IDs (`z-ai/…`, `moonshotai/…`) buchen Pay-as-you-go ab und scheitern mit „Insufficient balance".

### Modell-Routing (12 Modelle, Flatrate 9,99 USD/5h-Limit)
| Aufgabe | Modell |
|---|---|
| Standard-Coding, schnelle Fixes | `cline-pass/glm-5.3-flash` |
| Komplexe Long-Horizon-Reasoning | `cline-pass/glm-5.3` |
| Frontend/UI/Visuell (Image+Video+PDF) | `cline-pass/kimi-k3`, `cline-pass/qwen3.8-max` |
| Große Refactorings / Architektur | `cline-pass/deepseek-v4-pro` |
| Viele wiederholte Tool-Calls (durchsatzstark) | `cline-pass/deepseek-v4.1-flash` |
| Multimodal (Screenshots, Video) | `cline-pass/minimax-m3` |
| Routine / ausgewogen | `cline-pass/qwen3.7-plus` |
| Doku/Open-Source-Beiträge | `cline-pass/muse-spark-1.3-contributor` |

### Setup-Falle: unendlicher Lade-Spinner
Der Test-Spinner („Testing ClinePass…") in den Einstellungen hängt, weil ZCode dort ohne SSE testet (`stream: false`). **Ignorieren** — im echten Chat mit `stream: true` funktioniert es sofort. Terminal-Gegenprobe:
`curl -N -X POST https://api.cline.bot/api/v1/chat/completions -H "Authorization: Bearer KEY" -H "Content-Type: application/json" -d '{"model":"cline-pass/glm-5.3-flash","messages":[{"role":"user","content":"hi"}],"stream":true}'`

### 4 Kontext-Operatoren im Chat
- `@` → Datei/Ordner referenzieren (`@src/index.ts`), verhindert Repo-weites Suchen
- `#` → früheren Chat verknüpfen (`#123`), Kontext wiederverwenden
- `/` → gespeicherte Custom-Workflows/Prompts ausführen
- `$` → Skills/Sub-Routinen einbinden

### Thought Level & Execution Mode
| Parameter | Wert | Wann |
|---|---|---|
| Thought Level | Low | Syntax-Fixes, kurze Edits |
| Thought Level | High | Standard-Coding (Default) |
| Thought Level | Max | Architektur, hartnäckige Bugs |
| Execution Mode | Plan Mode | Analysieren ohne Ändern |
| Execution Mode | Confirm Before Changes | jede Änderung manuell freigeben |
| Execution Mode | Auto Edits | Edits direkt, Terminalbefehle mit Freigabe |
| Execution Mode | Goal Mode | langlaufende iterative Aufgaben |

### 4-Pfeiler-Prompt-Vorlage
`Ziel: … · Kontext: @dateien · Einschränkungen: was NICHT ändern · Verifikation: welcher Befehl beweist Erfolg (z. B. npm test)`
Beispiel: „Implementiere in @src/services/user.ts updateUserProfile. Interfaces liegen in @src/types/user.ts. Keine bestehenden Exporte ändern. Danach npm test ausführen und Fehler selbst beheben."
<!-- CLINEPASS-ZCODE:END -->


<!-- TEAM-PROTOCOL:START -->
## Team-Protokoll — Cline × ZCode × Antigravity (via hcom, Stand 15.10.2026)

**Bus:** hcom v0.7.25 (installiert, Hooks aktiv: Claude/Gemini/Antigravity/Cursor/OpenCode/Kilo/Pi, 7 Agenten live). ZCode = Manual-Modus: im ZCode-Terminal `hcom start` ausführen, dann per `send a message to …` erreichbar.

**Rollen (verbindlich):**
| Agent | Rolle | Rechte |
|---|---|---|
| **Cline (Director + Reviewer)** | plant, verteilt Tasks, 4D-Review mit **Veto** ("wer baut, prüft nicht") | GO/NO-GO |
| **ZCode (Builder)** | baut Slices (10 Subagent-Def.s in ~/.zcode/agents), Modelle: z.ai GLM-5.3-Flash / ClinePass | Edits ≤2 Dateien/Slice |
| **Antigravity (Orchestration + Vision)** | `hcom agy`, Gemini-Agenten, UI-/Screenshot-Reviews | Browser-/Bild-Checks |

**Regeln:** ① Kanban :3484 = einziges Task-Board (kein Doppelleben) ② max.3 Worker parallel ③ Botschaften mit `--thread <task>` (Isolation) ④ Ergebnisse → Mission-Log + STATUS.md, nie nur im Chat ⑤ bei Quota-429: Modell wechseln (Flash-first), nicht stoppen.
<!-- TEAM-PROTOCOL:END -->

