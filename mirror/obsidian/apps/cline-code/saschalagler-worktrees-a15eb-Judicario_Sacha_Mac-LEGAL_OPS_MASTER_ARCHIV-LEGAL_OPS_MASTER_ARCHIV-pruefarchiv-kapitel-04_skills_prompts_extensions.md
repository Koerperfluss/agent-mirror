---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/kapitel/04_skills_prompts_extensions.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# KAPITEL 04 — SKILLS, PROMPTS & EXTENSIONS (Commands / MCP-Tools / Personas)

**Prüfdatum:** 28.07.2026 · **Auditor:** Konkurrenz-Analyst (Prüfarchiv-Team)
**Bewertungsskala:** ✅ verifiziert (Datei-Beleg mit Pfad) · ⚠️ teilweise/plausibel · ❌ widerlegt · 🔶 behauptet (unbelegt)

---

## 4.1 Gegenstand & Quellenlage

Geprüft wird die **Befehls-/Werkzeug-Ebene** aller drei Systeme: Slash-Commands, MCP-Tools, Connectoren (Extensions) und System-Prompts/Personas. Referenzmaßstab ist der **optimierte Projekt-Prompt aus dem Scheinecker-Zwischenbericht v1.4** (Anhang, „7. Arbeitsbefehle" + „3. Drei Arbeitsmodi").

| Quelle | Pfad | Status |
|---|---|---|
| Judicario-Paket (Original-Auslieferung) | `/Users/saschalagler/Downloads/Judicario_Sacha_Mac/` | ✅ vollständig einsehbar |
| Scheinecker v1.4 (Methodik-Vorgabe) | `quellen/Scheinecker_v1.4_Zwischenbericht.txt` | ✅ einsehbar |
| Eigene App (Code-Ground-Truth) | `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/` | ✅ einsehbar |
| Chipsi | `https://chipsi.openlaw.cc` (Live-Test) + Dossier-Wissen | ⚠️ nur Login-Oberfläche live prüfbar |

---

## 4.2 Judicario: Die 8 Slash-Commands (verifiziert ✅)

Das Plugin-Verzeichnis `judicario/commands/` enthält exakt **8 Command-Dateien**. Jede Datei trägt eine Frontmatter-Beschreibung und einen kurzen Arbeitsauftrag, der die zu nutzenden MCP-Werkzeuge benennt:

| # | Command | Arbeitsauftrag (Kern) | Beleg |
|---|---|---|---|
| 1 | `/recherche` | Rechtsprechung & Leitsätze (AT/DE/CH/EU) mit exakten Fundstellen; Verifikationspflicht: „KEINE unverifizierten Zitate" | `judicario/commands/recherche.md` Z. 2, 5–8 |
| 2 | `/norm` | Gesetzestext nachschlagen + einschlägige Judikatur, Leitsätze mit Fundstellen | `judicario/commands/norm.md` Z. 2, 5–8 |
| 3 | `/gutachten` | Strukturiertes Rechtsgutachten im Gutachtenstil; Ergebnis + offene Tatfragen + Beweislast | `judicario/commands/gutachten.md` Z. 2, 5–9 |
| 4 | `/schriftsatz` | Einbringungsfertiger Schriftsatz (Klage/Berufung/Beschwerde/Antrag); Verifikation via `judicario_dokument` vorgeschrieben; Hinweis auf `docx-kanzlei`-Skill | `judicario/commands/schriftsatz.md` Z. 2, 5–9 |
| 5 | `/fall-triage` | Fall-Einordnung: Rechtsgebiet, Dringlichkeit (Fristen), 3–5 nächste Schritte | `judicario/commands/fall-triage.md` Z. 2, 5–7 |
| 6 | `/rechtsvergleich` | Grenzüberschreitender Rechtsvergleich AT/DE/CH/EU, tabellarisch mit Fundstellen | `judicario/commands/rechtsvergleich.md` Z. 2, 5–7 |
| 7 | `/steuer` | Steuerrecht AT/DE: VwGH/BFG- bzw. BFH/FG-Rechtsprechung, Richtlinien (EStR/KStR bzw. EStH/UStAE/AEAO), **deterministische Berechnung** via Tool („Rechnen IMMER deterministisch") | `judicario/commands/steuer.md` Z. 2, 5–9 |
| 8 | `/deckungscheck` | Versicherungsdeckung AT/DE: Deckung ja/nein/offen + Obliegenheiten/Ausschlüsse mit Fundstellen | `judicario/commands/deckungscheck.md` Z. 2, 5–8 |

**Audit-Feststellungen:**

- ✅ **Befund 4.2.1 — Verifikations-Disziplin ist command-seitig eingebaut.** Drei der acht Commands schreiben die Verifizierung jedes Zitats über `judicario_dokument` zwingend vor (`recherche.md` Z. 7–8: „Verifiziere jede zitierte Entscheidung … KEINE unverifizierten Zitate."; `gutachten.md` Z. 8; `schriftsatz.md` Z. 6–7: „mit `judicario_dokument` VERIFIZIEREN"). Eine echte Anti-Halluzinations-Stärke auf Prompt-Ebene.
- ✅ **Befund 4.2.2 — Deterministisches Rechnen statt LLM-Arithmetik.** `/steuer` verbietet Modell-Schätzungen: „Rechnen IMMER deterministisch: `judicario_steuer_berechnung` (Tarife) bzw. `judicario_steuer_engine` (DE-Spezialfälle: GewSt-Hinzurechnung, AfA, § 25a, Fristen …)" (`steuer.md` Z. 8–9). Architektonisch sauber — Rechenlogik liegt im Tool, nicht im Sprachmodell.
- ⚠️ **Befund 4.2.3 — Commands sind dünne Prompt-Hüllen.** Jede Command-Datei ist nur 7–9 Zeilen lang und delegiert die gesamte Substanz an die fernen MCP-Tools. Keine mehrstufige Prozess-Logik (kein Phasen-Loop, kein Prüfprotokoll, keine Abschlusskontrolle) im Command selbst — ein Unterschied zum 70-zeiligen System-Prompt der eigenen App (vgl. 4.6).
- ❌ **Befund 4.2.4 — Kein Kanzlei-Dokumenten-Command.** Keiner der 8 Commands referenziert ein Werkzeug für eigene Akten/PDFs; `/schriftsatz` verweist allenfalls auf einen `docx-kanzlei`-Skill für das Layout (`schriftsatz.md` Z. 8). Die Recherche bleibt auf öffentliche Korpora beschränkt.

---

## 4.3 Judicario: MCP-Tool-Inventar (aus den Commands belegt ✅)

Die Command-Dateien nennen **14 distincte MCP-Werkzeuge** (Namensraum `judicario_*`), gruppiert nach Domäne:

| Domäne | Werkzeuge | Beleg |
|---|---|---|
| Recherche-Kern | `judicario_urteilssuche`, `judicario_dokument`, `judicario_gesetz`, `judicario_rechtsprechung_zu_norm`, `judicario_fachliteratur`, `judicario_landkarte` | `recherche.md` Z. 6–7; `norm.md` Z. 6–7; `gutachten.md` Z. 6–8; `fall-triage.md` Z. 6 |
| Steuer | `judicario_steuer_rechtsprechung`, `judicario_steuer_richtlinie`, `judicario_steuer_norm`, `judicario_steuer_berechnung`, `judicario_steuer_engine` | `steuer.md` Z. 6–9 |
| Versicherung | `judicario_deckungspruefung`, `judicario_versicherung_norm`, `judicario_versicherung_klausel` | `deckungscheck.md` Z. 6–7 |

⚠️ **Einordnung:** Die Tool-*Namen* sind aus den Commands belegt; ihre tatsächliche Implementierung liegt serverseitig hinter `gateway.openlaw.cc` und ist aus dem Paket heraus nicht inspizierbar. Ein Live-Test des Endpunkts `https://gateway.openlaw.cc/mcp/at/` lieferte **HTTP 401 (Unauthorized)** — der Gateway ist erreichbar und erzwingt Authentifizierung (Test am 28.07.2026). Das belegt Existenz und Zugriffsschutz des Dienstes, nicht das Innenleben der 14 Werkzeuge (daher ⚠️ teilweise für die Tool-Funktionalität).

---

## 4.4 Judicario: Connectoren & der Config-Drift (verifiziert ✅ / Drift ❌)

### 4.4.1 Ausgelieferte Connectoren je Kanal

| Kanal | Module | Beleg |
|---|---|---|
| **Claude Code (CLI)** | **8**: at, de, ch, eu, ip, steuer, **insurance**, **steuer-de** | `Judicario_in_Claude_Code_installieren.command` Z. 9: `for m in at de ch eu ip steuer insurance steuer-de` |
| **Claude Desktop (Plugin)** | **6**: at, de, ch, eu, ip, steuer | `judicario/.mcp.json` Z. 1–26 |
| **Claude Web** | **6**: at, de, ch, eu, ip, steuer | `Connectoren_URLs.txt` Z. 4–15 |

Alle Connectoren sind ferne HTTP-Endpunkte (`"type": "http"`, `.mcp.json` Z. 3 u. ö.) auf `https://gateway.openlaw.cc/mcp/<modul>/?k=<key>`. **Kein einziger lokaler Connector, kein lokales Modell, kein Offline-Pfad.**

### 4.4.2 Der Drift

❌ **Befund 4.4.1 — Drei widersprechende Modul-Wahrheiten in einem Paket:**

1. Die **Anleitung** verspricht: „**Acht Module** — als getrennte Connectoren ausgeliefert", listet darunter aber nur **sechs** (at, de, ch, eu, ip, steuer) — `Anleitung_DE.html`, Abschnitt „Was freigeschaltet ist".
2. Der **CLI-Installer** registriert tatsächlich 8 (inkl. `insurance`, `steuer-de`) — `.command` Z. 9; Z. 13 meldet: „Fertig - 8 Judicario-Connectoren registriert."
3. **Plugin (.mcp.json) und Web-Liste** liefern nur 6 — `insurance` und `steuer-de` fehlen dort.

Zusätzlich behauptet die Anleitung im Desktop-Abschnitt: „Die **acht** Connectoren samt Workflow-Befehlen … stehen bereit" — für Plugin-Nutzer faktisch falsch, da deren `.mcp.json` nur 6 enthält. Konsequenz: Desktop-/Web-Nutzer erhalten `judicario-insurance` und `judicario-steuer-de` nicht; der `/deckungscheck`-Command verweist auf Versicherungs-Tools, deren Connector je nach Installationsweg fehlen kann. **Distributionsqualität: inkonsistent.** (Deckt sich mit Vor-Verifikation Nr. 2 des Lead, TEAM_BRIEFING.md Z. 36.)

---

## 4.5 DIE 15-BEFEHLS-MATRIX: Scheinecker-Soll vs. Judicario-Ist vs. Legal-Ops-Advisor-Ist

Der optimierte Projekt-Prompt in Scheinecker v1.4 definiert **15 Arbeitsbefehle** (`quellen/Scheinecker_v1.4_Zwischenbericht.txt` Z. 433–448) und **3 Arbeitsmodi** (Z. 344–374: „3.1 Neutraler Prüfmodus", „3.2 Anwaltlicher Argumentationsmodus", „3.3 Kritischer Gegenprüfungsmodus"). Gegenprobe gegen beide Produkte:

| # | Scheinecker-Befehl (Beleg Z.) | Judicario (Commands) | Legal Ops Advisor (Code) |
|---|---|---|---|
| 1 | `/norm` (Z. 434) | ✅ `commands/norm.md` | ⚠️ via Persona-Prompt + RIS-Grounding, kein Slash-Command |
| 2 | `/recherche` (Z. 435) | ✅ `commands/recherche.md` | ⚠️ via `@web`-Trigger + RAG, kein Slash-Command |
| 3 | `/gutachten` (Z. 436) | ✅ `commands/gutachten.md` | ⚠️ Persona `legal` deckt Gutachtenstil ab |
| 4 | `/schriftsatz` (Z. 437) | ✅ `commands/schriftsatz.md` | ⚠️ EXEKUTION-Block im Output-Protokoll (`prompts/legal_ops_omni.txt` Z. 58) |
| 5 | `/anwalt` (Z. 438) | ❌ nicht vorhanden | ❌ nicht vorhanden |
| 6 | `/argumente` (Z. 439) | ❌ nicht vorhanden | ❌ nicht vorhanden |
| 7 | `/widerlegung` (Z. 440) | ❌ nicht vorhanden | ❌ nicht vorhanden |
| 8 | `/gegenprüfung` (Z. 441) | ❌ nicht vorhanden | ❌ nicht vorhanden |

### Befund 4.5.1 — Der fehlende anwaltliche Modus ist die strukturelle Lücke (✅)

Scheineckers Kerndiagnose war, dass der bisherige Prompt „vor allem neutrale Prüfung, Vollständigkeit sowie die Darstellung von Risiken und Gegenargumenten" verlangte und „eine klare Trennung zwischen neutralem Prüfmodus, anwaltlichem Argumentationsmodus und kritischer Gegenprüfung" fehlte (`Scheinecker_v1.4_Zwischenbericht.txt` Z. 194–196). Judicarios Command-Set reproduziert genau diese Einseitigkeit: Es gibt `/gutachten` (neutral), aber **keinen** anwaltlichen Argumentations-Command und **keinen** Gegenprüfungs-Command. Die fehlenden 8 Befehle sind fast vollständig dem anwaltlichen/kritischen Modus zuzuordnen. → Die Diagnose „zu zurückhaltend" ist am ausgelieferten Command-Set verifizierbar.

### Befund 4.5.2 — Fairness-Korrektur: Die eigene App hat die 3 Modi ebenfalls NICHT implementiert (❌)

Ein `grep -i 'anwalt|kritisch|neutral|modus|modi'` über `app.py` **und** `index.html` liefert **null Treffer** (Test am 28.07.2026). Der Legal Ops Advisor kennt die Scheinecker-Modi weder als Slash-Commands noch als UI-Schalter; der Omni-Prompt definiert nur einen einzigen „Execution Mode: STRICT_EXECUTION" (`prompts/legal_ops_omni.txt` Z. 5). Der anwaltliche Modus existiert beim Mandanten bislang als *Praxis-Anweisung im Gespräch* (vgl. TEAM_BRIEFING.md Z. 9–12, „/anwalt-Modus"), nicht als Produkt-Feature. **Ehrliche Konsequenz:** In der Dimension „3-Modi/15 Commands" ist *keines* der drei Systeme vollständig; Judicario führt mit 7 nativen Commands, die eigene App kompensiert über Persona-Tiefe statt Befehlsbreite. Diese Zeile darf im Vertrieb nicht als Alleinstellung geführt werden.

---

## 4.6 Legal Ops Advisor: Prompts, Personas & Routing (verifiziert ✅)

### 4.6.1 Vier Personas als Prompt-Dateien

`app.py` Z. 170–175 definiert ein PERSONAS-Registry mit 4 System-Prompts aus `prompts/`:

| Schlüssel | Datei | Inhalt (Beleg) |
|---|---|---|
| `legal` | `legal_ops_omni.txt` | LEGAL-OPS-OMNI-ARCHITECT v7.0: 6 Sub-Agenten (Richter/Instanzen Z. 12–16, Volljurist Z. 18–19, Steuerberater Z. 21–22, Notar Z. 24–25, E-Gov-Spezialist Z. 27–28, Strategic Advisor Z. 30–31) |
| `gdb` | `gdb_analyst.txt` | GdB/MdE-Spezialist AT/DE mit 4-Phasen-Pflichtprozess (Z. 12–16) und ICD-10-Tabelle |
| `vwgh` | `vwgh_researcher.txt` | VwGH/VfGH/OGH-Recherche, Fristenlogik (6 Wochen ab Zustellung, Z. 12), Beschwerdeentwürfe |
| `compliance` | `compliance.txt` | MDR/DSGVO/EU-AI-Act/ISO 13485, Gap-Analyse mit Pflichttabelle (Z. 25–37) |

### 4.6.2 Der Omni-Prompt v7.0 — Substanz statt Hülle

`prompts/legal_ops_omni.txt` (70 Zeilen, 6.520 Bytes) enthält im Unterschied zu Judicarios 7–9-zeiligen Commands eine vollständige Prozess-Ordnung:

- **VERBATIM-ZWANG** (Z. 37): Beträge/Schwellenwerte/Paragraphen „MÜSSEN durch die beigefügten Web/RIS-Suchergebnisse (Live-Context) 1:1 belegt werden … Wenn der Kontext keine aktuelle Zahl liefert, VERWEIGERE die Nennung" — Funktionsäquivalent zu Judicarios „KEINE unverifizierten Zitate", aber härter formuliert (Verweigerungs-Automatismus).
- **Anti-Halluzinations-Zwang HART** (Z. 64–70): „Keine Quelle = keine Zahl"; Abbruch mit „DATENLAGE UNKLAR"; explizite Regel gegen Absatz-Verwechslung im RIS-Kontext (Z. 70).
- **4-Phasen-Loop** (Z. 39–43): Thread-of-Thought → Deep-Research-Filter → Chain-of-Verification (mit Fristenberechnung und Abbruch-Regel) → Portal-Routing (E-Gov-Klickpfad).
- **Striktes Output-Protokoll** (Z. 52–59): ⚡ ERGEBNIS (BLUF mit Erfolgschance %) → Prüfprotokoll → MASTERPLAN-Tabelle → Portal-Navigation → Advisory → EXEKUTION (Kopiervorlage) → STATUS.
- **Prompt-Evolution belegt:** `prompts/legal_ops_omni_v6_backup.txt` (3.220 Bytes, 22.07.2026) zeigt den Vorgänger v6.0 mit 5 Modulen (MODULE_A–E); v7.0 (26.07.2026) erweitert auf 6 Agenten + harten Anti-Halluzinations-Block. Prompt-Pflege mit Backup-Disziplin ist nachweisbar.

| 9 | `/fall-triage` (Z. 442) | ✅ `commands/fall-triage.md` | ⚠️ Auto-Routing ordnet Persona zu, keine Triage-Ausgabe |

### 4.6.3 Routing & Extensions der eigenen App

- ✅ **Auto-Routing über 4 Personas:** `/query` (app.py Z. 449 ff.) schickt die Anfrage zunächst an einen Router-LLM-Call (Gemini), der eine JSON-Liste der benötigten Personas zurückgibt (Router-Prompt Z. 463–473); bei Mehrfachauswahl werden die System-Prompts zu einem „ZTeam"-Merged-Prompt kombiniert (Z. 550–558). `auto_route: bool = True` (Z. 291) — Abschalten halbiert die Latenz (Kommentar Z. 291).
- ✅ **Robustes Fallback:** Scheitert das Routing, greift die Default-Persona (Z. 485: „Falling back to default").
- ✅ **Ad-hoc-Akten-Ingest per Pfad-Erkennung:** Regex auf `/Users/...`-Pfade in der Nutzernachricht triggert `indexer.ingest_path()` (Z. 489–493) — lokale Dokumente werden im Chat zur Wissensbasis. **Ein Extension-Typ, den Judicario gar nicht hat** (kein Kanzlei-PDF-Tool, vgl. Befund 4.2.4).
- ✅ **`@web`-Trigger:** explizite Websuche via DuckDuckGo (`perform_web_search`, Z. 334–342; Trigger Z. 498–499).
- ❌ **Kein MCP-Support:** Die eigene App spricht weder MCP-Server an noch exponiert sie selbst MCP-Tools (kein Treffer für `mcp` in `app.py`). Erweiterbarkeit läuft über Prompt-Dateien + Indexer, nicht über das Tool-Protokoll, das Judicario nutzt. Fairerweise: Judicarios MCP-Ökosystem ist damit integrationsfähiger (Claude-Connectoren-Standard), die eigene App dafür herstellerunabhängig.

---

## 4.7 Chipsi: Werkzeug-Ebene (Live-Beleg + Dossier-Wissen)

- ✅ **Live verifiziert (28.07.2026):** `https://chipsi.openlaw.cc` ist erreichbar und zeigt eine geschlossene SaaS-Anmeldung: „Chipsi — Anmeldung … Rechts- & Steuer-Assistenz — bitte anmelden" (E-Mail/Benutzername + Passwort, „Mit Google anmelden", „Konto anlegen"). Damit ist Chipsi als **mandantenfähige Cloud-SaaS mit eigenem Auth** (nicht nur Connector) bestätigt — architektonisch eigenständiger als Judicario.
- 🔶 **Dossier-Wissen (unbelegt, kein lokales Artefakt):** **17 Werkzeuge**, **3 Vertrauensstufen**, **granulare Aktions-Freigaben** (Immer/Fragen/Nie), **Safebox** (Dokumententresor) und **Aktenverwaltung**. Diese Punkte stammen aus dem Vergleichsdossier des Mandanten (TEAM_BRIEFING.md, Task-Vorgabe); sie liegen hinter dem Login und konnten am Stichtag weder verifiziert noch widerlegt werden. Ein Wayback-Machine-Abruf von `chipsi.openlaw.cc` lieferte HTTP 404 (kein Snapshot).

⚠️ **Audit-Hinweis:** Die Chipsi-Zeile jeder Vergleichsmatrix muss diese Quellenlage offenlegen. „17 Werkzeuge" wäre — falls zutreffend — numerisch mehr als Judicarios 14 belegte Tool-Namen und die 4 Personas der eigenen App; ohne Beleg bleibt es eine Behauptung.

---

## 4.8 Kapitel-Fazit

| Dimension | Judicario | Legal Ops Advisor | Chipsi |
|---|---|---|---|
| Befehls-System | ✅ 8 Slash-Commands, sauber dokumentiert | ⚠️ keine Slash-Commands; 4 Personas + Auto-Routing (`app.py` Z. 170–175, 449–485) | 🔶 17 Werkzeuge (Dossier) |
| Tool-Ebene | ✅ 14 MCP-Tool-Namen belegt; deterministische Steuer-Engine | ✅ RAG/FTS5 + RIS-Lookup + DDGS + Ad-hoc-Ingest (code-belegt) | 🔶 unbelegt |
| Extensions | ✅ 6–8 HTTP-Connectoren, Claude-Ökosystem; ❌ Config-Drift 8/6/6 | ❌ kein MCP; ✅ lokaler Ingest als Alleinstellung | ⚠️ SaaS-Auth live belegt |
| Anti-Halluzination auf Skill-Ebene | ✅ „KEINE unverifizierten Zitate" (Command-Pflicht) | ✅ VERBATIM-ZWANG + „Keine Quelle = keine Zahl" (härter) | 🔶 |
| Scheinecker 15 Befehle | 7/15 nativ ❌ (anwaltl./krit. Modus fehlt) | 0/15 als Commands ❌, ~9/15 funktional ⚠️ | 🔶 |
| 3 Modi (Neutral/Anwaltlich/Kritisch) | ❌ nicht implementiert | ❌ nicht implementiert (grep-Beleg) | 🔶 |

**Festgestellte Auffälligkeiten:** (1) Judicario-Config-Drift 8 vs. 6 über drei Auslieferungskanäle inkl. widersprechender Anleitung (4.4.2). (2) Beide prüfbaren Systeme ohne anwaltlichen/kritischen Modus — der strategische Modus-Vorteil des Mandanten ist derzeit **Methodik, nicht Produkt** (4.5.2). (3) Chipsi-Werkzeugliste bis zum Login-Beweis 🔶.

| 10 | `/rechtsvergleich` (Z. 443) | ✅ `commands/rechtsvergleich.md` | ❌ nur AT-Primär / DACH adaptiv (`legal_ops_omni.txt` Z. 6) |
| 11 | `/steuer` (Z. 444) | ✅ `commands/steuer.md` | ⚠️ AGENT_03 (Steuerberater) im Prompt (Z. 21–22), keine deterministische Rechen-Engine |
| 12 | `/frist` (Z. 445) | ❌ nicht vorhanden (nur Nebensatz in `fall-triage.md` Z. 7) | ⚠️ Fristenlogik im Prompt (Z. 42: Notfrist 14/28 Tage, § 1480 ABGB) + `vwgh_researcher.txt` Z. 12, 18 |
| 13 | `/strategie` (Z. 446) | ❌ nicht vorhanden | ⚠️ AGENT_06 Strategic & Litigation Advisor (Z. 30–31) |
| 14 | `/risiko` (Z. 447) | ❌ nicht vorhanden | ⚠️ „Risiken" nur implizit im Prüfprotokoll |
| 15 | `/cockpit` (Z. 448) | ❌ nicht vorhanden | ⚠️ MASTERPLAN-Tabelle (Z. 55) als annäherndes Element |

**Zählung:** Judicario deckt **7 von 15** Befehlen nativ als Slash-Commands ab; **8 fehlen**: `/anwalt`, `/argumente`, `/widerlegung`, `/gegenprüfung`, `/frist`, `/strategie`, `/risiko`, `/cockpit`. Judicario hat mit `/deckungscheck` umgekehrt einen Command, den Scheineckers Liste nicht enthält.


