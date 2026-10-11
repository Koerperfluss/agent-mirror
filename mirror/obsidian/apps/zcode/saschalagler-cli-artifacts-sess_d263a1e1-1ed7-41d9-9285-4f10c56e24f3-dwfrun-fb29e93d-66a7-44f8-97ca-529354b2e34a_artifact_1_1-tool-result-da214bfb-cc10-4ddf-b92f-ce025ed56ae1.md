---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_d263a1e1-1ed7-41d9-9285-4f10c56e24f3/dwfrun-fb29e93d-66a7-44f8-97ca-529354b2e34a_artifact_1_1-tool-result-da214bfb-cc10-4ddf-b92f-ce025ed56ae1.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

# LOKI Skill-Ökosystem-Audit — Anthropic-Anpassungen vs. eigene Skills, 11.10.2026

## 1) KPI-Tabelle

| Kennzahl | Wert | Quelle / Methodik |
|---|---|---|
| Lokale Skill-Roots | 3 | `.zcode/skills`, `.agents/skills`, Plugin-Cache |
| Gescannte SKILL.md-Dateien | 690 + 142 + 379 = 1.211 | Inventare der drei Roots |
| Effektive Uniques | 205 + 138 + 295 = **638** | Dedup nach Skill-Namen |
| Anthropic-Angebote (Vergleichsset) | 276 | Vendor-Suiten-Katalog |
| gstack-Dubletten | 547 SKILL.md unter `~/gstack` (~70 % der .zcode-Dateien sind Kopien) | `find ~/gstack -name SKILL.md \| wc -l` |
| Root-Überschneidungen .zcode × .agents | 135 Namen doppelt | `comm -12 <(ls ~/.zcode/skills) <(ls ~/.agents/skills) \| wc -l` |
| Plugin-Cache-Altversionen | browser-use 8×, computer-use 5×, documents/pdf je 2× (siehe Gegenkontrolle) | Cache-Auflistung |
| Korrigierte Unique-Zahl .zcode/skills | **751** (Symlinks folgen) statt 690 | `find -L ~/.zcode/skills -name SKILL.md \| sort -u \| wc -l` — methodikabhängig |

## 2) Kernbefunde

| # | Befund | Details |
|---|---|---|
| 1 | **DOPPELT — gstack-Replikationsblock** | 55+ Skills je 10× unter `/Users/saschalagler/gstack/` (Repo-Root + .agents/.cursor/.factory/.gbrain/.hermes/.kiro/.openclaw/.opencode/.slate), z. B. autoplan, ship, qa, spec, learn. Ca. 485 der 690 Dateien in `.zcode/skills` sind Kopien; Unique-Ratio 205/690. |
| 2 | **DOPPELT — Skills-Wurzel-Überlappung** | `.zcode/skills` und `.agents/skills` spiegeln sich (agent-browser, better-ui, caveman, cognee-memory, deja-search, loki-dev, lisa-therapeut je 2×). Beleg: `/Users/saschalagler/.zcode/skills/agent-browser/SKILL.md` und `/Users/saschalagler/.agents/skills/agent-browser/SKILL.md`. |
| 3 | **DOPPELT — Version-Müll im Plugin-Cache** | browser-use 8× (0.1.0–0.5.1: control-browser, web-gui-tester), computer-use 5×, github-Skills je 2×, diagnosing-* + zcode-configuration-guide je 3×. Alte Versionen werden mitgeladen statt nur der neuesten. *(Korrektur siehe Gegenkontrolle: documents/pdf/pptx/xlsx je nur 2 Versionen.)* |
| 4 | **ECHTES PENDANT BESSER — Anthropic Financial-Suite** | run-fpa (10 Skills) + write-research inkl. dcf-model, morning-note, rolling-forecast *(korrigiert: 17, nicht 18 Skills)* hat lokal KEIN Gegenstück auf vergleichbarem Niveau. hexin-stock/wind-docs/wind-economic-MCPs liefern nur Rohdaten, keine Modellierungs-/Report-Pipeline. |
| 5 | **ECHTES PENDANT BESSER — Desktop-Commander-Gruppe** | 6 Skills (computer-health-check, knowledge-base, obsidian-vault, terminal, ai-tools-setup) existieren lokal nur als Plugin; kein lokal gepflegtes Pendant. obsidian-second-brain überschneidet sich mit obsidian-vault ohne klare Trennung. |
| 6 | **AT-ABDECKUNG (LOKI-Stärke)** | lisa-therapeut (2×), legal-ops-omni, legal, foerderguru, pva-bankverbindung-advisor, studienchecker, physio* — plus loki-legal-ops-mcp (search_vwgh_fts5, search_ffg_programs). Kein Anthropic-Angebot deckt österreichisches Verwaltungsrecht/FFG-Förder-Workflow ab — echter LOKI-Moat. |
| 7 | **ECHTE LÜCKE — Unity** | 31 Unity-Skills, keine Game-Dev/Unity-Domäne lokal (kein Unity-, Godot- oder Engine-Skill in den drei Inventaren). |
| 8 | **ECHTE LÜCKE — Betriebs-Suiten** | Small Business (44) + Sales (36) + Operations (9) + Customer Support (5) + Box (5) fehlen komplett; run-fpa deckt nur Finanz-Modellierung, google-workspace/judicario nur Teilbereiche. |
| 9 | **ECHTE LÜCKE (schwach) — Automationen** | Zapier (4) / Synthflow (2) / Noibu (8) / Brand-voice-Tribe-AI (5) / Qodo (4): stehende Automationen, Voice-Agent-QA, eCommerce-Funnel-Analytik, Guideline-Enforcement, Cross-Repo-Index fehlen. Teilersatz: higgsfield-brandkit (visuell), coderabbit (Review), deja (Session-History, kein Repo-Index). |
| 10 | **META-BEFUND** | 276 Anthropic-Angebote vs. 690+142+379 lokale Dateien, aber nur 638 effektive Uniques. Konsolidierung (gstack-Kopien, Plugin-Altvversionen, .zcode×.agents-Spiegel) ist der größte Hebel; danach füllen die 4 Lücken (Unity, SMB/Sales/Ops/Support, Zapier/Voice/Noibu, Brand-Pipeline) die letzten Differenzen. |

## 3) Optimierungs-Empfehlungen (nach Priorität)

| Prio | Empfehlung | Maßnahme | Beweis/Evidence |
|---|---|---|---|
| **hoch** | gstack-Replikationsblock konsolidieren (größter Hebel: 547 SKILL.md ≈ 70 % der Dateien) | VORSCHLAG (Löschen nur nach Nutzer-Bestätigung): Nicht die Kopien löschen, sondern gstack EINMALIG via Symlink/Mount einbinden; Kanonquelle `/Users/saschalagler/gstack/<skill>/SKILL.md` behalten. Vorher diff-Check, ob alle Kopien identisch sind. — *Vollständig neu formuliert durch Gegenkontrolle (siehe Abschnitt 4): Symlink existiert bereits; Maßnahme zielt jetzt auf gstack-interne 9 Tool-Roots + Test-Fixture-Leaks.* | `find /Users/saschalagler/gstack -name SKILL.md \| wc -l` = 547; `ls -d /Users/saschalagler/gstack/.agents/.cursor/.opencode` existiert; `/Users/saschalagler/gstack/autoplan/SKILL.md` vorhanden. |
| **hoch** | .zcode/skills ↔ .agents/skills Spiegelung auflösen (135 doppelte Namen) | EIN Root als Kanonquelle festlegen (Empfehlung: `.agents/skills` für LOKI-eigene Skills, da AGENTS.md dort skill-routing verankert), `.zcode/skills` per Symlink statt spiegeln. Vorher `diff -r`, wo Kopien divergieren. — *Einschränkung aus Gegenkontrolle: .zcode/skills ist bereits Symlink-Farm auf .claude/skills; echte Dubletten-Lage prüfen, nicht einfach verschieben.* | `comm -12 <(ls ~/.zcode/skills) <(ls ~/.agents/skills) \| wc -l` = 135. |
| **hoch** | Plugin-Cache: Altvversionen aufräumen | Retention-Policy im Plugin-Manager setzen (nur neueste Version cachen); Altversionen nach Nutzer-Bestätigung löschen (Cache, kein gepflegter Code). Nie genutzte Plugins (alibaba/dingtalk/wecom/tencent-meeting-cli, gitlab, example-plugin) deaktivieren statt cachen. — *Korrektur: docx/pdf/pptx/xlsx haben je nur 2 Versionen; „~84 Dateien Müll" ist unverifiziert.* | browser-use: 0.1.0, 0.2.1, 0.3.0, 0.3.1, 0.4.0, 0.4.1, 0.4.2, 0.5.1; computer-use: 5 Versionen (0.5.13–0.6.4). |
| **mittel** | gemini-skill-Dubletten auflösen: `_sources`-Archiv wird als aktive Skills geladen | `_sources` in `.agents/skills` aus dem Skill-Scan-Pfad ausschließen; die 4 `_sources__gemini-skills__skills__*`-Spiegel auf .zcode-Seite nicht als aktive Skills laden. | gemini-api-dev/-interactions-api/-live-api-dev/-omni-flash-api je 2×; `_sources/gemini-skills` existiert (verifiziert). |
| **mittel** | Anthropic Financial-Suite aktiv nutzen — lokal nichts Vergleichbares | Beide Schichten betreiben: hexin-stock/wind-* MCPs (Rohdaten) + run-fpa/write-research (Modellierung). Pilot: morgendliche Portfolio-Note (write-research:morning-note + get_stock_performance) für FFG/ATLAS-Projekte — erst bewerten, dann embedden. — *Korrektur: Pfad ist `~/.zcode/cli/plugins/cache/zcode-plugins-official/run-fpa/0.1.1/` (nicht claude-plugins-official); write-research = 17 Skills.* | run-fpa (10 Skills, 0.1.1) + write-research (17 Skills, 0.1.1) im Cache verifiziert. |
| **mittel** | Skills-Meta-Layer als Wartungs-Hub etablieren | Mit managing-skills + writing-great-skills eine Duplikat-Erkennungs-Routine bauen (find + md5-Hash über SKILL.md, Report statt Auto-Delete), Ausgabe nach `/Users/saschalagler/loki-ki/docs/SKILL_LANDKARTE.md`. Erst danach die Aufräum-Vorschläge ausführen. | Beide Skills vorhanden: `~/.zcode/skills/managing-skills/SKILL.md`, `~/.zcode/skills/writing-great-skills/SKILL.md` (je 2× über beide Roots). |
| **niedrig** | Unity-Lücke bewusst NICHT schließen (dokumentierte Nichtentscheidung) | Plugin nicht aktivieren (kein Anwendungsfall im LOKI-Kern). Bei Game-Dev-Bedarf (MASTER_TODO prüfen) nur Kern-Skills freischalten. | Kein Unity/Godot/Engine-Skill in allen 3 lokalen Inventaren. |
| **niedrig** | Betriebs-Suiten (SMB 44 / Sales 36 / Ops 9 / Support 5) gezielt pro Anwendungsfall testen, nicht en bloc | Operations/Runbook passt zum loki-os-health-Workflow (guter Test-Kandidat). CRM/Sales/Box nur bei Kundenprojekt mit Salesforce/HubSpot/Box; sonst NICHT laden (YAGNI, Ponytail-Sprosse 1). | mcporter/AutoClaw-Tools decken nur punktuelle Calls, keine Prozess-Pipelines. |
| **niedrig** | Zapier/Noibu/Synthflow/Brand-voice: nur bei konkretem Automations-Bedarf | Test-Pilot definieren: Zapier-Konnektor für loki-os-health-Alerts (Systemdiagnose → Ticket/Benachrichtigung). Ohne Pilot: nicht aktivieren. Code-Review bleibt bei coderabbit. | Lokale mcporter-Calls sind singulär, keine stehenden Automationen. |
| **niedrig** | AT-Domänen-Moat schützen: AT-Lücken als Stärke behalten | Nichts ändern — Lücken bewusst offen lassen; nur in LOKI_SYSTEM_INVENTORY.md / SKILL_LANDKARTE.md als Nicht-Ziel dokumentieren, damit künftige Scans sie nicht wieder als „Lücke" melden. | lisa-therapeut, legal-ops-omni, foerderguru, pva-bankverbindung-advisor, studienchecker vorhanden; kein Legal-Plugin im Cache. |

## 4) Gegenkontrolle

**BLUF:** 10 von 10 Pfad-Beweisen stimmen im Kern, aber 4 Empfehlungen haben Fehlannahmen, die die Maßnahme verändern würden: gstack ist **bereits symlinked** (Vorschlag 1 zum Teil überflüssig), der Finance-Plugin-Pfad ist falsch geschrieben, die Versions-Zählung der Dokumenten-Plugins stimmt nicht, write-research hat 17 nicht 18 Skills.

### Geprüfte Befunde (nur Lesezugriff, alle Befehle im Prüf-Workflow ausgeführt)

| # | Behauptung | Urteil | Beweis |
|---|---|---|---|
| 1 | gstack: 547 SKILL.md | ✅ bestätigt | `find ~/gstack -name SKILL.md \| wc -l` → **547** |
| 1 | `.agents/.cursor/.opencode` in gstack existieren | ✅ bestätigt | `ls -d` → alle 3 vorhanden |
| 1 | `~/gstack/autoplan/SKILL.md` vorhanden | ✅ bestätigt | `ls` → vorhanden |
| 1 | „55+ Skills je 10×" | ⚠️ teilweise | Real: **54 Skills je Root × 9 Roots** (`.slate .opencode .openclaw .kiro .hermes .gbrain .factory .cursor .agents`, je 54), nicht 55+/10× |
| 1 | „claude nur 9× / .slate abweichend" | ✅ bestätigt | claude fehlt in den Hidden-Roots; `.slate` separat mit 54 SKILL.md |
| 1 | Kern-Vorschlag „gstack via Symlink einbinden" | ❌ **schon erledigt — Fehlannahme** | `~/.claude/skills/gstack -> ~/gstack` (Symlink bewiesen); `.zcode/skills` ist eine **Symlink-Farm** (200 Symlinks → `.claude/skills`, nur 5 reale Dirs). Echte Duplikation liegt **innerhalb** `~/gstack` (9 Tool-Roots) und im Leak von Test-Fixtures (`alpha -> .claude/skills/gstack/test/fixtures/context-bill/tree-a/alpha`) |
| 2 | 135 Namens-Überschneidungen .zcode × .agents | ✅ bestätigt | `comm -12 … \| wc -l` → **135** |
| 2 | „spiegeln sich" | ⚠️ mechanisch anders | `.zcode/skills` = Symlinks, `.agents/skills` = reale Dirs; Stichproben: `caveman` byte-identisch (`diff -rq`), `lisa-therapeut` in beiden, `autoplan` **nur in .zcode** |
| 3 | browser-use: 8 Versionen 0.1.0–0.5.1 | ✅ exakt bestätigt | Cache-Liste: 0.1.0, 0.2.1, 0.3.0, 0.3.1, 0.4.0, 0.4.1, 0.4.2, 0.5.1 |
| 3 | computer-use 5× | ✅ bestätigt | 0.5.13, 0.5.14, 0.6.1, 0.6.3, 0.6.4 |
| 3 | „docx/pdf 7×, pptx/xlsx 6×" | ❌ NICHT bestätigt | documents/pdf/presentations/spreadsheets haben je **2 Versionen** (0.1.7, 0.1.8) — vermutlich wurden Dateien statt Versionen gezählt |
| 3 | gitlab-Cache-Leiche, example-plugin | ✅ konsistent | `gitlab/0.1.3` + `example-plugin/0.2.0+0.2.3` im Cache (MCP-Entfernung 06.09. laut AGENTS.md, nicht neu verifizierbar) |
| 4 | `_sources/gemini-skills` + 4 Dubletten | ✅ bestätigt | `_sources/gemini-skills` existiert; 4 `_sources__gemini-skills__skills__*`-Symlinks in `.zcode/skills` — Archiv wird aktiv geladen |
| 5 | run-fpa + write-research lokal vorhanden | ⚠️ Pfad falsch, Sachverhalt richtig | Bewiesener Pfad: `~/.zcode/cli/plugins/cache/**zcode**-plugins-official/run-fpa/0.1.1` (10 Skills) + `write-research/0.1.1` (**17** Skills, nicht 18). Der genannte Pfad `claude-plugins-official/…` existiert **nicht** |
| 6–8 | Unity-/SMB-/Sales-/Zapier-Zahlen | ⚠️ nicht reproduzierbar | Keine Unity/Salesforce-Skills in der Session-Skill-Liste (konsistent), aber Zahlen 44/36/9/5 stammen aus dem Analyse-Inventar, das nicht einsehbar war: **DATENLAGE UNKLAR** |
| 9 | managing-skills + writing-great-skills vorhanden | ✅ bestätigt | 4 Pfade existieren (beide Roots) |
| 10 | AT-Domänen-Skills vorhanden, keine AT-Legal-Suite | ✅ konsistent | lisa-therapeut, legal-ops-omni, foerderguru, pva-bankverbindung-advisor, studienchecker in `.agents/skills`; kein Legal-Plugin im Plugin-Cache |
| — | „205/690 Uniques in .zcode/skills" | ❌ NICHT reproduziert | `find -L ~/.zcode/skills -name SKILL.md \| sort -u \| wc -l` → **751** (Symlinks folgen); 690 stammt aus früherer Session mit anderer Dedup-Methodik — Zahl ist methodikabhängig |

### Korrekturen für die Umsetzung

1. **Vorschlag 1 neu formuliert:** Nicht „Symlink einbinden" (existiert schon), sondern (a) gstack-interne 9 Tool-Roots klären (gstacks eigener Replikationsmechanismus — Löschung betrifft Tool-Interops) und (b) gstack-Test-Fixture-Leaks (`test/fixtures`) aus dem Skill-Scan ausschließen.
2. **Vorschlag 5:** Pfad korrigiert auf `zcode-plugins-official`; write-research = **17** Skills.
3. **Vorschlag 3:** docx/pdf/pptx/xlsx haben je **2** Versionen, nicht 6–7 — das „~84 Dateien Müll"-Total ist unverifiziert und entsprechend anzupassen.

## 5) Was NICHT geprüft wurde

Ehrliche Liste der Prüf-Lücken — diese Punkte sind weder bestätigt noch widerlegt:

| Punkt | Warum ungeprüft |
|---|---|
| „~84 Dateien Müll"-Summe im Plugin-Cache | Keine Datei-/Byte-Zählung über alle Altversionen ausgeführt; Summe unverifiziert |
| Unity (31), Small Business (44), Sales (36), Operations (9), Support (5), Box (5), Zapier (4), Noibu (8), Synthflow (2), Brand-voice (5), Qodo (4) | Zahlen stammen aus dem Analyse-Inventar der Findings; nur Sichtprüfung der Session-Skill-Liste (keine Unity/Salesforce-Skills dort), keine eigene Zählung im Anthropic-Katalog |
| Byte-Identität aller 135 `.zcode × .agents`-Namenspaare | Nur 3 Stichproben (caveman, lisa-therapeut, autoplan); keine vollständige `diff -r`-Analyse |
| Diff-Check der 54 gstack-Skills über die 9/10 Roots | Nicht ausgeführt — unbekannt, ob alle Kopien identisch sind; „claude nur 9×" mechanisch bestätigt, aber Kopien-Identität offen |
| MCP-Entfernung von gitlab am 06.09. | Basierend auf AGENTS.md-Angabe; der Cache-Eintrag `gitlab/0.1.3` als Leiche ist plausibel, aber nicht gegen die MCP-Config neu verifiziert |
| YAML-Integrität / Beschreibungs-Qualität der Skills (Folded-Scalar-Problem aus früherer Session) | Nicht Teil dieses Audits; der Scan-Bug (`desc_len=1` bei `description: >`) aus der früheren Session wurde hier nicht erneut getestet |
| `.claude/skills` als vierter Root | Wurde nur im Rahmen der Symlink-Farm-Analyse angeschnitten (200 Symlinks, 5 reale Dirs), nicht als eigenständiges Inventar gezählt |

---
*Erstellt 11.10.2026 · Zahlen in Abschnitten 1–3 stammen aus den übergebenen Audit-Findings und -Empfehlungen; Abschnitt 4 dokumentiert die Gegenkontrolle mit korrigierten Werten.*
