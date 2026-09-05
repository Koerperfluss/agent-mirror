# KAPITEL 08b — KONKURRENZ-DEEP-DIVE: JUDICARIO (OpenLaw MCP) & CHIPSI (OpenLaw SaaS)

**Prüfdatum:** 28.07.2026 · **Auditor:** Konkurrenz-Analyst (Prüfarchiv-Team)
**Bewertungsskala:** ✅ verifiziert (Datei-Beleg mit Pfad) · ⚠️ teilweise/plausibel · ❌ widerlegt · 🔶 behauptet (unbelegt)
**Fairness-Gebot (aus TEAM_BRIEFING.md Z. 16):** Stärken der Konkurrenz werden ehrlich gewürdigt — keine Schönfärberei für das eigene Produkt.

---

## 8b.1 Quellenlage & durchgeführte Live-Tests

| Quelle / Test | Ergebnis |
|---|---|
| Original-Installationspaket `/Users/saschalagler/Downloads/Judicario_Sacha_Mac/` (Plugin-Manifest, `.mcp.json`, 8 Commands, Installer, Anleitungen DE/EN, LIESMICH) | ✅ vollständig einsehbar — primäre Beweisgrundlage |
| Live-Test `https://gateway.openlaw.cc/mcp/at/` (28.07.2026) | ✅ **HTTP 401 Unauthorized** — Endpunkt existiert, Auth erzwungen |
| Live-Test `https://chipsi.openlaw.cc` (28.07.2026) | ✅ erreichbar, geschlossene Login-Seite („Rechts- & Steuer-Assistenz") |
| Live-Test `https://openlaw.cc` (28.07.2026) | ✅ erreichbar — zeigt derzeit **kein** Judicario/Chipsi, sondern Teaser „George" (vgl. 8b.7) |
| Wayback Machine `chipsi.openlaw.cc` | ❌ HTTP 404 — kein Archiv-Snapshot |
| Vor-Audit `AUDIT_Legal_Ops_Advisor_vs_Judicario.md` (im Paket) | ⚠️ Sekundärquelle; wurde stichprobenartig nachverifiziert, **ein Befund korrigiert** (8b.6) |

---

## 8b.2 Judicario — verifizierte Sachaufnahme

### 8b.2.1 Architektur: Cloud-only, kein lokaler Pfad (✅)

- **Typ:** Headless MCP-Connector-Middleware. Sämtliche 6 Plugin-Connectoren sind `"type": "http"` auf `https://gateway.openlaw.cc/mcp/<modul>/?k=<key>` — belegt `judicario/.mcp.json` Z. 1–26. Es existiert **keine** lokale Inferenz-Komponente, kein Offline-Modus, kein mitgeliefertes Modell.
- **Inferenz:** Anthropic Claude (Cloud). Voraussetzung laut Anleitung: „Ein Claude-Konto (claude.ai) — **Pro/Team/Max** für Connectoren & Plugins" (`Anleitung_DE.html`, Abschnitt „Voraussetzungen"). Der kostenlose Claude-Tarif reicht nicht.
- **Frontends (3 Installationswege):** Claude Code CLI (`.command`-Script), Claude Desktop (lokaler Plugin-Upload des Ordners `judicario/`), Claude Web (Connectoren-URLs) — `LIESMICH.txt` Z. 4–6, `Anleitung_DE.html` Abschnitte A–C.
- **Lizenz/Tarif:** `judicario/README.md` Z. 5: „**Tarif:** enterprise · **Credits:** 100000 · **Module:** Judicario Österreich, … Deutschland, … Schweiz, … EU & Menschenrechte, … IP · Copyright & Trademark (EU), … Steuer · Abgabenrecht (AT)". Plugin-Manifest: Version 0.2.0, Autor „Judicario / OpenLaw", berger@openlaw.cc (`.claude-plugin/plugin.json` Z. 1–9). Präzisierung zum Briefing: Tarif & Credits stehen im **README**, nicht im plugin.json.
- **Kostenmodell (doppelt):** Claude-Abo (Anthropic) **plus** Credit-Verbrauch im enterprise-Tarif (OpenLaw). Kein kostenfreier Betriebspfad (Paket-Befund, deckt sich mit Vor-Audit Z. 57–58).

### 8b.2.2 Recherchebreite (✅ — echte Stärke)

Die freigeschalteten Korpora decken **AT, DE, CH, EU & Menschenrechte (EGMR), IP/Trademark (EU) sowie Steuer-Abgabenrecht (AT)** ab (`README.md` Z. 5, `plugin.json` Z. 3, `.mcp.json`). Die CLI erweitert um `insurance` und `steuer-de` (Installer Z. 9). Die Commands benennen zusätzlich Spezialkorpora: Steuer-Richtlinien EStR/KStR (AT) bzw. EStH/UStAE/AEAO (DE) (`steuer.md` Z. 6–7) und Versicherungsrecht VersVG↔VVG inkl. AVB-Klauseln (`deckungscheck.md` Z. 7). **Vergleichsmaßstab:** Der Legal Ops Advisor ist österreich-zentriert (Jurisdiktion „ÖSTERREICH (Primär) / EU & DACH (Adaptiv)", `prompts/legal_ops_omni.txt` Z. 6) und hat kein CH-Korpus, kein IP-Korpus und keine Versicherungs-Klauseldatenbank. In der Breite der gepflegten Korpora ist Judicario dem eigenen Produkt **klar voraus**.


### 8b.2.3 Verbatim-/Verifikationsansatz (✅)

Judicario institutionalisiert Zitier-Disziplin auf Command-Ebene: „Verifiziere jede zitierte Entscheidung mit `judicario_dokument` (RS-Nr/ECLI/CELEX/GZ) … KEINE unverifizierten Zitate" (`recherche.md` Z. 7–8); „mit `judicario_dokument` VERIFIZIEREN" (`schriftsatz.md` Z. 6–7); Fundstellen-Pflicht je Treffer (Gericht, GZ/CELEX, Datum, Kernaussage, `recherche.md` Z. 8). Hinzu kommt die deterministische Steuer-Engine (Befund 4.2.2, Kapitel 04). Ob die Verifikation serverseitig tatsächlich gegen Volltexte läuft, ist aus dem Paket nicht prüfbar — die *Anweisung* ist jedoch verbindlich formuliert (⚠️ Implementierung, ✅ Prompt-Design).

---

## 8b.3 Judicario — Stärken (faire Würdigung)

1. ✅ **Recherchebreite als Kernasset:** 6–8 kuratierte Rechtskorpora über vier Rechtsordnungen plus Steuer/Versicherung (8b.2.2). Kein österreichisches Solo-Produkt erreicht das derzeit ohne vergleichbare Infrastruktur.
2. ✅ **Mehrkanal-Distribution:** Ein Paket, drei Installationswege (CLI/Desktop/Web) — die Integrationsarbeit beim Nutzer ist minimal (Ein-Klick-Installer, `.command` Z. 1–14; Anleitung mit konkreten Beispiel-Eingaben).
3. ✅ **Verifikations-Kultur im Produkttext:** Anti-Halluzinations-Anweisungen sind nicht Marketing, sondern stehen in den ausgelieferten Commands (8b.2.3).
4. ✅ **Deterministisches Rechnen:** Auslagerung von Tarif-/Steuerberechnungen in dedizierte Tools statt LLM-Arithmetik (`steuer.md` Z. 8–9) — methodisch vorbildlich.
5. ✅ **Erreichbarkeit & Betrieb:** Gateway live mit erzwungener Auth (HTTP-401-Test 8b.1); Support-Wege mit Namen, Mail und WhatsApp dokumentiert (`LIESMICH.txt` Z. 8; Anleitung „Support").
6. ✅ **Praxisbewährt:** Der Scheinecker-Praxistest (22.07.2026) dokumentiert reale Erfolge mit Judicario — u. a. „vollständige Formulierung einer fünfseitigen finanzgerichtlichen Klage" und „strukturierte Ausarbeitung einer siebenseitigen Stellungnahme" (`quellen/Scheinecker_v1.4_Zwischenbericht.txt` Z. 50–53), Selbstkorrektur nach Formular-Fehlgriff „offen erklärt, nachvollziehbar korrigiert" (Z. 68–69). Gesamturteil dort: „sehr hilfreiche und praxisnahe Unterstützung" (Z. 47).

---

## 8b.4 Judicario — Schwächen & Lücken (befundbasiert)

| # | Befund | Status | Beleg |
|---|---|---|---|
| 1 | **Cloud-only / kein Offline:** Sämtliche Inferenz bei Anthropic; Connectoren sind ferne HTTP-Endpunkte. Für RAO-§-9-Verschwiegenheit und Offline-Betrieb strukturell ungeeignet | ✅ | `.mcp.json` Z. 1–26; Anleitung „Voraussetzungen" |
| 2 | **Kein Kanzlei-Dokumenten-Zugriff:** kein Upload-/Index-Tool für eigene Akten/PDFs; Recherche nur in öffentlichen Korpora | ✅ | `commands/*.md` (kein entsprechendes Tool); Vor-Audit Z. 55 |
| 3 | **Kein E-Government-Agentik:** kein FinanzOnline/JustizOnline/ERV-Bezug in Commands, README oder Anleitung | ✅ | Paket-weite Suche, 0 Treffer |
| 4 | **Kein Eval-Framework:** keine Test-Szenarien, keine Qualitäts-Matrix, keine Latenz-/Treffer-Messung im Paket | ✅ | Paket-Inventar (vollständige Dateiliste 8b.1) |
| 5 | **Config-Drift 8/6/6 + widersprechende Anleitung** („Acht Module" vs. sechs gelistete) | ❌ (Mangel) | Kapitel 04, Befund 4.4.1 |
| 6 | **Command-Lücke im anwaltlichen/kritischen Modus:** 8 von 15 Scheinecker-Befehlen fehlen | ❌ (Mangel) | Kapitel 04, Matrix 4.5 |
| 7 | **Doppeltes Kostenmodell** (Claude-Abo + Credits), kein kostenfreier Pfad | ✅ | `README.md` Z. 5; Anleitung „Voraussetzungen" |
| 8 | **Klartext-Key in der Distribution** | ❌ (Sicherheitsmangel) | 8b.6 |
| 9 | **Hersteller-Lock-in:** funktioniert nur innerhalb des Claude-Ökosystems (Pro/Team/Max); kein Standalone-Produkt | ✅ | Anleitung „Voraussetzungen" |

⚠️ **Fairness-Einordnung zu (1):** Cloud-only ist eine legitime Produktentscheidung (Modellqualität Claude, kein lokaler Ressourcenhunger) und für viele Kanzlei-Anwendungsfälle ausreichend — der Nachteil greift erst bei Mandantendaten unter Verschwiegenheit, Air-Gap-Anforderungen oder Kosten-Sensitivität. Er ist kein Qualitätsurteil über die Recherche selbst.
