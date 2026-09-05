# AUDIT-BERICHT — Legal Ops Advisor vs. Judicario (OpenLaw MCP)

**Audit-Objekt:** Wettbewerbs- & Technik-Audit „Legal Ops Advisor" vs. „Judicario / OpenLaw"
**Audit-Datum:** 28.07.2026
**Auditor:** Cline (automatisiertes Code- & Konfigurations-Audit)
**Auftrag:** Praxistest-Qualitätsbericht / Fall-Audit auf Basis des Projektprompts (Frank Scheinecker v1.4) sowie der vom Mandanten genannten Differenzierungslinie (lokales Modell / LLM-Training / Offline / Live-Abfrage / selbstlernendes Hirn / E-Government-Agentik).

---

## 0. Quellenlage & Transparenz-Vermerk (wichtig)

Der ursprünglich referenzierte Prüfbericht
`JUDICARIO_Praxistest_Qualitaetsbericht_mit_optimiertem_Projektprompt_Frank_Scheinecker_Version_1-4.pdf`
lag zum Audit-Zeitpunkt **nicht mehr vor** (WhatsApp-Container-Tmp wurde zwischenzeitlich geräumt:
`…/net.whatsapp.WhatsApp/Data/tmp/documents/FEDB7EC0-…/` existiert nicht mehr).

**Ersatz-Quellen (faktisch belastbarer als ein Fremd-PDF):** Statt des Berichts wurde das **original ausgelieferte Judicario-Installationspaket** des Mandanten selbst auditiert:

`/Users/saschalagler/Downloads/Judicario_Sacha_Mac/` mit Unterpaket `judicario/` (Plugin-Manifest, MCP-Konfiguration, 8 Workflow-Kommandos, macOS-Installationsanleitung DE, Connector-URLs, CLI-Installer).

→ Dadurch ist die **Judicario-Spalte** jeder Vergleichstabelle **evidenzbasiert verifizierbar** und nicht nur aus einem Sekundär-PDF abgeleitet. Die **Legal-Ops-Advisor-Spalte** bleibt hingegen eine **Behauptungsmenge** des Mandanten (kein Code/Artifakt eingesehen); deren Reife wird in Teil C ehrlich bewertet — incl. der Tatsache, dass der Mandant den lokalen Inferenz-Pfad selbst als *„in Arbeit"* (LLM-Training) eingestuft hat.

Bewertungsskala: ✅ verifiziert (Beleg aus Datei) · ⚠️ plausibel/teilweise · ❌ widerlegt/nicht gegeben · 🔶 behauptet (Mandantenangabe, noch ohne Beleg).

---

## 1. Executive Summary / Prüfungsurteil

1. **Judicario ist vollständig als Cloud-Middleware verifiziert.** Sämtliche Inferenz läuft beim LLM-Anbieter (Anthropic Claude, Konto Pro/Team/Max pflichtig); Judicario liefert lediglich **ferne HTTP-MCP-Connector** (`gateway.openlaw.cc`) auf OpenLaw-Korpora. Lokale/Offline-Inferenz, Kanzlei-PDF-Suche, E-Government-Einreichung und ein Evaluations-Framework sind **nicht Bestandteil** und auch nicht vorgesehen. → Die Wettbewerbs-Vergleichstabelle ist in der **Judicario-Spalte faktisch korrekt**.
2. **Die Legal-Ops-Advisor-Differenzierung ist strategisch tragfähig, aber reifemäßig unausgereift.** Die drei Last-Träger-Behauptungen — (a) lokale Inferenz/Offline, (b) selbstlernendes Hintergrund-Hirn, (c) E-Government-Agentik — sind genau die Features, die Judicario **nicht** hat und die einen echten Unique Selling Point bilden. **Aber:** der Mandant bezeichnet den lokalen Modell-Pfad selbst als *in Arbeit (LLM-Training)*. Damit ist das **Kern-Verkaufsargument „0 € laufende Kosten / 100 % Offline" heute noch nicht produktionsbewiesen** und muss zwingend per Air-Gap-Test belegt werden, bevor es vertriebswirksam eingesetzt wird.
3. **Ein echter Sicherheitsbefund im Judicario-Paket:** der persönliche OpenLaw-Zugangs-Key liegt **im Klartext in vier Dateien** unter `~/Downloads`. Das ist eine distributionsseitige Schwäche (OpenLaw) **und** eine Opsec-Notiz für den Mandanten (nicht in Git committen / nicht teilen).
4. **Konfigurations-Drift bei Judicario:** CLI-Installer registriert 8 Module, Desktop-Plugin `.mcp.json` und Web-URL-Liste führen aber nur 6 — die Module `insurance` und `steuer-de` sind **nur über die CLI** erreichbar.

**Gesamturteil:** Wettbewerbsposition stichhaltig & belegbar auf Judicario-Seite; auf Legal-Ops-Advisor-Seite **Proof-of-Concept-Reife** — vertriebsreif erst nach Abschluss des LLM-Trainings, eines dokumentierten Offline-Air-Gap-Tests und einer Selbstlern-/Agentik-Validierung (Teil E).

---

## 2. Teil A — Judicario: verifizierte Sachaufnahme (ausgeliefertes Paket)

### 2.1 Architektur (verifiziert ✅)
- **Typ:** Headless MCP-Connector-Middleware, **ferne HTTP-Endpunkte** (`type: http`, `gateway.openlaw.cc/mcp/<modul>/?k=<key>`), belegt in `judicario/.mcp.json` und `Connectoren_URLs.txt`.
- **Frontends:** Claude Web (claude.ai), Claude Desktop (lokales Plugin-Upload), Claude Code (CLI). Inferenz = **Anthropic Claude (Cloud)**. Ein Claude-Konto Pro/Team/Max ist **Voraussetzung** (Anleitung S. „VORAUSSETZUNGEN").
- **Plugin-Manifest** `judicario/.claude-plugin/plugin.json`: Name `judicario`, Version `0.2.0`, Autor `Judicario / OpenLaw` (berger@openlaw.cc), Tarif `enterprise`, Credits `100000`.

### 2.2 Module / Connectoren (verifiziert ✅ + Drift ⚠️)
| Kanal | registrierte Module | Quelle |
|---|---|---|
| CLI-Installer `.command` | 8: at, de, ch, eu, ip, steuer, **insurance**, **steuer-de** | `Judicario_in_Claude_Code_installieren.command` |
| Desktop-Plugin | 6: at, de, ch, eu, ip, steuer | `judicario/.mcp.json` |
| Claude Web | 6: at, de, ch, eu, ip, steuer | `Connectoren_URLs.txt` |

→ **Befund:** `insurance` (Versicherung/Deckung) und `steuer-de` (Steuer DE) werden nur per CLI installiert; Plugin- & Web-Nutzer haben sie **nicht**. Inkonsistenz zwischen Auslieferungskanälen.

### 2.3 Workflow-Kommandos / Tiles (verifiziert ✅, = 8 Stück)
`/recherche` · `/norm` · `/gutachten` · `/schriftsatz` · `/fall-triage` · `/rechtsvergleich` · `/steuer` · `/deckungscheck` (je `judicario/commands/*.md`). Werkzeuge dahinter: `judicario_urteilssuche`, `judicario_gesetz`, `judicario_dokument`, `judicario_rechtsprechung_zu_norm`, `judicario_fachliteratur`, `judicario_landkarte`, `judicario_steuer_*`, `judicario_versicherung_*`. **Öffentliches Recht/Korpora only — kein Kanzlei-PDF-Upload, kein Volltext über eigene Akten.**

### 2.4 Betriebskosten (verifiziert ✅)
Bezahlt wird **doppelt**: (1) Claude Pro/Team/Max-Abo (Anthropic) + (2) Judicario `enterprise`-Tarif mit Credit-Verbrauch (`100000` Credits im Paket). Kein lokaler, kostenfreier Betrieb.

### 2.5 Support / Vertrieb (verifiziert ✅)
Markt & Partner: Marinus Brückmann · Technik: George, george@openlaw.cc / WhatsApp +43 676 3064897.

---

## 3. Teil B — Behauptungs-Verifikation der Vergleichstabelle

Je Zeile der (im Terminal vorliegenden) Vergleichstabelle: Bewertung gegen den Datei-Befund.

| Kriterium | Tabelle: Legal Ops Advisor | Tabelle: Judicario | Audit-Befund |
|---|---|---|---|
| System-Architektur | Native Mac App (PyWebView + FastAPI :7070) | Headless MCP-Connector-Middleware | **Judicario ✅** belegt (s. 2.1). Legal Ops Advisor **🔶 behauptet** (kein Code gesehen). |
| Lokale Inferenz (Apple NPU) | ✅ Ollama/LiteRT, 100 % Offline | ❌ Cloud (Anthropic) | **Judicario ✅** belegt. Legal Ops Advisor **🔶 behauptet u. vom Mandanten als „in Arbeit" (LLM-Training) eingestuft** → heute **nicht produktionsbewiesen**. |
| Eigene Kanzlei-PDFs durchsuchen | ✅ SQLite-FTS5-Volltext | ❌ nur öffentliches Recht | **Judicario ✅** belegt (kein Upload-/Suchwerkzeug im Paket). Legal Ops Advisor **🔶 behauptet**. |
| RIS OGD API v2.6 Live-Sync | ✅ Echtzeit-Verbatim (data.bka.gv.at) | ✅ Verbatim-Connector | **Judicario ⚠️ plausibel, indirekt**: OpenLaw indiziert RIS/OGD-Quellen in seine Korpora — *kein* direkter Live-Sync durch Judicario selbst. Legal Ops Advisor **🔶 behauptet** (RIS-OGD ist eine echte BKA-API → technisch möglich, aber Live-Echtzeit-Claim muss belegt werden). |
| E-Government-Agentik (JustizOnline) | ✅ Chrome-DevTools-MCP-Agent | ❌ | **Judicario ✅** belegt (kein Browser-/Einreichungs-Werkzeug). Legal Ops Advisor **🔶 behauptet** (JustizOnline = realer österr. Gerichts-Web-Portal → Chrome-DevTools-MCP-Automatisierung plausibel). |
| 3-Modi-Prompt & 15 Commands | ✅ Scheinecker v1.4 | ⚠️ teilweise | **Judicario ✅ „teilweise" ist fair** — real sind **8** Kommandos, kein 3-Modi-Protokoll. Legal Ops Advisor **🔶 behauptet**; das Scheinecker-v1.4-Protokoll deckt sich mit dem (nicht mehr vorliegenden) PDF-Dateinamen → **indizkompatibel**, aber nicht belegt. |
| 100-Szenarien-Quality-Matrix | ✅ Peters-Eval-Framework | ❌ | **Judicario ✅** belegt (kein Eval-Framework im Paket). Legal Ops Advisor **🔶 behauptet** — dieses Framework ist **zugleich das wichtigste Werkzeug, um alle anderen 🔶-Behauptungen zu belegen** (s. Teil E). |
| Laufende Betriebskosten | 0 € lokal | Enterprise-API-Keys | **Judicario ✅** belegt (Claude-Abo + Judicario-Credits). Legal Ops Advisor **🔶 konditional**: 0 € nur, wenn *wirklich* 100 % lokal/offline läuft — sobald ein Cloud-Fallback existiert, entstehen Kosten. |

**Zwischenfazit Teil B:** Die **Judicario-Spalte der Vergleichstabelle ist faktisch korrekt und nun Datei-belegt.** Die **Legal-Ops-Advisor-Spalte ist eine konsistente Behauptungsmenge**, die inhaltlich plausibel und strategisch schlüssig ist, aber **eigenen Beleg** verlangt — gerade weil sie gegen einen belegbaren Konkurrenten antritt.

---

## 4. Teil C — Legal Ops Advisor: Differenzierungs-Audit (Mandantenbehauptungen)

Basis: Mandantenangabe vom 28.07.2026 — *„lokales Modell … in Arbeit (LLM-Training) … Offline-Möglichkeit gegeben … Live-Abfrage ebenfalls … im Hintergrund selbstlernendes Hirn / E-Government-Agentik"*.

### C.1 Lokales Modell / LLM-Training → Offline-Inferenz
- **Behauptung:** lokale Inferenz auf Apple-NPU (Ollama / LiteRT), 100 % Offline, 0 € laufende Kosten.
- **Reifestatus:** 🔶 **In Entwicklung („in Arbeit" / LLM-Training)** — per Mandanteneigenaussage. Heute **Proof-of-Concept**, nicht Production.
- **Wettbewerbswert:** **Hoch.** Genau das ist Judicarios strukturelle Lücke (Cloud-only). Zudem **datenschutzrechtlicher Vorteil**: bei echter Lokalität verlassen Mandantendaten nie die Maschine → starkes Argument ggü. anwaltlicher Verschwiegenheit (§ 9 RAO/AT) und DSGVO.
- **Risiko:** (a) „0 €" stimmt nur ohne Cloud-Fallback — jeder Fallback (auch für schlechte Fälle) erzeugt API-Kosten und **bricht das Offline-Versprechen**. (b) lokales Modell-Qualität ggü. Claude-Cloud muss im Rechtskontext bewiesen sein (Gerichtsfestigkeit!). (c) NPU-Performance/Modellgröße-Grenzen auf dem Ziel-Mac.
- **Beleg-Anforderung:** Air-Gap-Test (Netzwerk physisch aus → typische Rechtsabfrage lösen → Fundstellen aus lokaler Kanzlei-DB). Siehe Teil E, E.1.

### C.2 Live-Abfrage (RIS OGD v2.6 / JustizOnline-Echtzeit)
- **Behauptung:** Echtzeit-Verbatim-Sync mit `data.bka.gv.at` (RIS OGD).
- **Reifestatus:** 🔶 behauptet. RIS-OGD ist eine **echte, freie BKA-API** → technisch fundiert. „Echtzeit/Live" ist der Wort-für-Wort-Vorteil ggü. Judicarios *indiziertem* Korpus.
- **Wettbewerbswert:** **Mittel-Hoch** — nur wertvoll, wenn (i) der Sync wirklich live und nicht nur ein periodischer Snapshot ist und (ii) eine Kanzlei die Aktualität von Norm/RS braucht.
- **Risiko:** „Live"-Claim ohne Sync-Häufigkeits-/Latenz-Messung ist angreifbar. RIS-OGD-Ratenlimits/Verfügbarkeit müssen abgesichert sein.
- **Beleg-Anforderung:** Latenz- & Freshness-Messung (z. B. Stunden nach OGH-Veröffentlichung im RIS vs. Sichtbarkeit im Advisor).

### C.3 Selbstlernendes Hintergrund-Hirn
- **Behauptung:** „im Hintergrund selbstlernendes Hirn".
- **Reifestatus:** 🔶 behauptet, **am wenigsten spezifiziert**.
- **Wettbewerbswert:** Potenziell **hoch**, aber **nur glaubwürdig mit Nachweis der Lern-Schleife** (welche Signale, welche Speicherung, welche Re-Evaluierung?). Sonst Vertriebsrisiko („KI lernt"-Floskel).
- **Risiko:** (a) anwaltliche Verschwiegenheit/DSGVO — *lernen aus Kanzleiakten* bedeutet Mandantendaten-Persistenz/Verarbeitung; muss rechtmäßig und trennbar sein. (b) „Halluzinations-Drift" durch unkontrolliertes Lernen → gerichtsfeste Output-Gefährdung. (c) Nachweisbarkeit des Lerneffekts.
- **Beleg-Anforderung:** Definition der Lern-Architektur (Feedback-Store, Re-Train-/Retrieval-Update, Eval-Regression) + Abgrenzung, was *nicht* aus Mandantendaten gelernt wird.

### C.4 E-Government-Agentik (JustizOnline-Einreichung)
- **Behauptung:** Chrome-DevTools-MCP-Agent für JustizOnline (automatisierte Gerichts-Einreichung).
- **Reifestatus:** 🔶 behauptet. JustizOnline/ERV/webErf sind reale österr. Einreichkanäle → Browser-Automation via Chrome-DevTools-MCP ist ein **plausibles Architekturmuster**.
- **Wettbewerbswert:** **Hoch** — das ist die stärkste „Festung"-Aussage (Automatisierung, die Judicario/Chipsi nicht haben).
- **Risiko:** (a) **höchst sensibel** — falsche/verspätete Einreichung = Fristversäumnis = Haftung. (b) JustizOnline-UI-Änderungen brechen Browser-Agenten. (c) Authentifizierung/Signatur (PDA/Amtssignatur) darf nicht automatisiert umgangen werden. (d) Haftungs-/Zulassungsfrage: darf ein Agent für den Anwalt einreichen?
- **Beleg-Anforderung:** **Human-in-the-Loop-Pflicht** vor jedem Einreich-Submit + Audit-Log jeder Aktion + Rückfall auf manuelle Einreichung. Siehe E.4.

---

## 5. Teil D — Sicherheits- & Compliance-Befunde

### D.1 KRITISCH — Persönlicher OpenLaw-Key im Klartext (Judicario-Paket)
- **Befund:** Der persönliche Zugangs-Key `jud_gtSG0t_•••••••••••••••••` (redigiert) steht **im Klartext in vier Dateien** unter `~/Downloads/Judicario_Sacha_Mac/`:
  1. `Connectoren_URLs.txt` (6×, je Modul)
  2. `judicario/.mcp.json` (6×)
  3. `Judicario_in_Claude_Code_installieren.command` (1×, als Shell-Variable `KEY=`)
  4. `judicario/README.md` (im Tarif-/Connector-Block)
- Die Anleitung selbst warnt: *„Dieses Paket enthält Ihren persönlichen Zugangs-Key; bitte nicht weitergeben."* — widerspricht aber der Klartext-Auslieferung.
- **Einordnung:** (a) **Distributionsseitige Schwäche OpenLaw/Judicario** — Key als Bestandteil eines per WhatsApp/Mail verschickten Pakets im Klartext, nicht rotierbar pro Verteilung. (b) **Mandanten-Opsec:** Key liegt ungeschützt auf der Platte; bei Backup/Cloud-Sync/Git-Commit besteht Exfiltrationsrisiko und damit Missbrauch des `enterprise`-Kontos auf Mandantenkosten.
- **Maßnahmen:** Key **nicht** in irgendein Git-Repo (auch nicht das hiesige) committen; `~/Downloads` nicht in Cloud-Sync/Backup ohne Vault; Key bei OpenLaw **rotieren lassen**, falls das Paket Dritten zugänglich war; perspektivisch Key aus Umgebungsvariable/Keychain statt aus Datei lesen.

### D.2 Datenschutz / Verschwiegenheit (Legal Ops Advisor-Seite)
- **Stärke:** Echte lokale/offline Inferenz = Mandantendaten verlassen die Maschine nicht → bestmögliche Position für **anwaltliche Verschwiegenheit (§ 9 RAO/AT)** und **DSGVO Art. 5/25/32**. Das ist ein **vertriebstragfähiger Compliance-Vorteil**, den Judicario (Cloud) strukturell nicht bieten kann.
- **Voraussetzung:** Der Offline-Claim muss **wirklich** gelten — inkl. **kein Telemetrie-/Update-Call**, der Akteninhalte nach außen trägt. (Teil E.1.)
- **Selbstlernendes Hirn (C.3):** Lernen aus Kanzleiakten = Verarbeitung Mandanten-bezogener Daten → braucht Rechtsgrundlage, Trennung (kein „Auskochen" in ein geteiltes Modell) und Löschkonzept. Sonst wird der Datenschutz-Vorteil **aufgehoben**.

### D.3 Gerichtsfestigkeit / Haftung (Legal Ops Advisor-Seite)
- Rechts-Output muss **gerichtsfest** sein. Lokales (ggf. trainiertes) Modell muss im **Peters-Eval-Framework (100-Szenarien-Matrix)** ggü. Claude-Cloud-Qualität verglichen werden — ein schlechteres, aber lokales Modell ist im Rechtskontext **kein** Verkaufspunkt.
- **E-Government-Agentik (C.4):** Höchstes Haftungsrisiko (Fristversäumnis). Zwingend: Human-in-the-Loop-Gate vor Submit, vollständiges Audit-Log, Graceful-Degradation auf manuelle Einreichung, kein Automatisieren der qualifizierten Signatur.

---

## 6. Teil E — Gap-Analyse & Empfehlungen (Audit-Readiness-Roadmap)

Priorität P0 = vor Vertriebsansprache zwingend · P1 = kurzfristig · P2 = strukturell.

| ID | Maßnahme | Priorität | Hebt … |
|---|---|---|---|
| E.1 | **Air-Gap-Offline-Test:** Mac ans geschlossene Netz → typische Rechts-/Kanzlei-PDF-Abfrage laufen lassen → Fundstellen + Output validieren. Ergebnis als Video/Protokoll archivieren. | **P0** | C.1, D.2, „0 €"-Claim |
| E.2 | **Cloud-Fallback-Audit:** Prüfen, ob ein Fallback auf Cloud-LLM existiert; falls ja, Offenlegung + Kostenmodell + Opt-out, sonst Offline-Versprechen gebrochen. | **P0** | C.1, Betriebskosten |
| E.3 | **Peters-Eval (100 Szenarien) lokal vs. Claude-Cloud:** Gerichtsfestigkeit/Quote quantifizieren; Schwellwert für „gerichtsfest" definieren. | **P0** | C.1 Qualität, Tabelle Quality-Matrix |
| E.4 | **E-Gov-Agentik-Hardening:** Human-in-the-Loop-Gate, Audit-Log je Aktion, UI-Änderungs-Monitoring (JustizOnline), manueller Fallback, keine Signatur-Automatisierung. | **P0** | C.4, Haftung |
| E.5 | **Selbstlern-Architektur dokumentieren:** Lernsignale, Speicherort, Re-Eval/Regression, DSGVO-Trennung, Löschkonzept; Nachweis eines messbaren Lerneffekts. | **P1** | C.3 |
| E.6 | **RIS-Latenz/Freshness-Messung:** Zeit zw. OGH-Veröffentlichung im RIS und Sichtbarkeit im Advisor; Sync-Häufigkeit belegen („Live" verteidigen). | **P1** | C.2 |
| E.7 | **Scheinecker-v1.4-Protokoll nachweisbar machen:** 3 Modi + 15 Commands im Produkt nachvollziehbar dokumentieren (stimmt die „15" mit den realen Commands überein? ggf. korrigieren). | **P1** | Tabelle 3-Modi/15-Commands |
| E.8 | **Vergleichstabelle bereinigen:** nur ✅/🔶-zertifizierte Aussagen belassen; „0 €" mit „bei 100 % Offline" qualifizieren; „100 % Offline" erst nach E.1 in ✅ setzen. | **P1** | Vertriebssicherheit |
| E.9 | **Key-Rotation & Keychain-Migration** (Mandant): OpenLaw-Key rotieren, aus Datei → Keychain/Env, Repo-Schutz via `.gitignore`/`git-secrets`. | **P1** | D.1 |
| E.10 | **Vertriebs-/Haftungsfreigabe-Gate:** formales Go/No-Go erst wenn E.1–E.4 ✅. | **P2** | Gesamt |

**Mindest-Proof-Paket für Vertrieb:** (i) Air-Gap-Video (E.1), (ii) Peters-Eval-Ergebnis lokal vs. Cloud (E.3), (iii) E-Gov-Submit-Demo mit Human-Gate (E.4), (iv) bereinigte, belegte Vergleichstabelle (E.8).

---

## 7. Anhang — Quellen / File-Inventory (auditiert)

Paket: `/Users/saschalagler/Downloads/Judicario_Sacha_Mac/`

| Datei | Inhalt | Audit-Nutzung |
|---|---|---|
| `LIESMICH.txt` | Schnellstart + Support-Kontakte | Support-Verifizierung (2.5) |
| `Connectoren_URLs.txt` | 6 Modul-URLs (mit Klartext-Key) | Module/Drift (2.2), Key-Befund (D.1) |
| `Judicario_in_Claude_Code_installieren.command` | CLI-Installer, 8 Module, `KEY=`-Variable | Modul-Drift (2.2), Key-Befund (D.1) |
| `Anleitung_DE.html` → `/tmp/anleitung_de.txt` | macOS-Installationsanleitung DE | Architektur/Voraussetzungen (2.1, 2.4) |
| `judicario/.claude-plugin/plugin.json` | Manifest v0.2.0, enterprise, 100k Credits | Architektur/Kosten (2.1, 2.4) |
| `judicario/.mcp.json` | 6 http-Connectoren (Klartext-Key) | Architektur (2.1), Drift (2.2), Key (D.1) |
| `judicario/README.md` | Tarif/Module/8 Workflows | Kommandos (2.3), Key (D.1) |
| `judicario/commands/*.md` (8) | Slash-Kommandos + OpenLaw-Tools | Kommandos (2.3) |

**Nicht vorliegend (Transparenz):** PDF `…_Frank_Scheinecker_Version_1-4.pdf` (WhatsApp-Tmp geräumt). Dessen Inhalt — insb. das Scheinecker-v1.4-Prompt-Protokoll und die 100-Szenarien-Matrix — ist in diesem Audit als **🔶 behauptet/indizkompatibel** behandelt und unter E.3/E.7 als nachzuliefernder Beleg markiert.

---
*Audit erstellt am 28.07.2026 durch Cline. Bewertung basiert auf dem am System vorgefundenen Original-Paket; keine externen Cloud-Abfragen durchgeführt. Diese Dokument ist eine technische/strategische Audit-Grundlage und ersetzt keine Rechtsberatung.*
