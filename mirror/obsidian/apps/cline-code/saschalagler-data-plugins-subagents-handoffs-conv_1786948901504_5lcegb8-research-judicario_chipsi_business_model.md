---
app: cline-code
quelle: "saschalagler/data/plugins/subagents/handoffs/conv_1786948901504_5lcegb8/research/judicario_chipsi_business_model.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Judicario & Chipsi — Business Model & Pricing Analysis

*Research extracted from primary sources (Thomas audit HTML, MCP configs, project docs). 2026-08-14.*

---

## 1. Judicario — Monetization & Access

### 1.1 MCP Gateway (primary access path)
- **Source:** `/Users/saschalagler/Desktop/Judicario_Sacha_Mac/judicario/.mcp.json` (if exists) + `judicario.py` source code
- **Access:** HTTP JSON-RPC gateway at `gateway.openlaw.cc/mcp/{modul}/?k={KEY}`
- **Key hardcoded in code:** `GATEWAY_KEY = "jud_Cpu-nyGunSlYK7TM1Nz7_g9iJQvhsiLh"` (judicario.py Zeile 31)
- **Modules available:** AT, DE, CH, EU, IP, Steuer, Insurance (aus `.mcp.json` Struktur)
- **Protocol:** `initialize → Session → initialized → tools/call` with `at_search` / `at_norm` / etc.
- ** monetization:** **Not directly monetized through loki-voice.** Judicario is a separate product with its own gateway. Access appears to be granted via key — whether this is free, paid, or enterprise is not documented in the loki-voice source.

### 1.2 Integration in loki-voice
- **Source:** `loki-voice/loki_voice/werkzeuge/judicario.py` (vollständig gelesen)
- **Binding:** Local `importlib` load of S3.3 checker module (liegt außerhalb von loki-voice)
- **MCP calls:** `faktencheck(text, modul="at", live=True)` → ruft `echte_judicario_pruefung()` auf → MCP-Handshake
- **Cost to loki-voice:** 0 € — die API-Calls laufen über den bereits beschafften Key

### 1.3 Pricing / License (from Thomas audit)
- **Source:** `THOMAS_MASTER_2026.html` Positionen zu "Preis"
- **Key finding:** "Preis: bewusst offen bis zur QA-Klärung — beratend, nicht aufdringlich"
- **Rahmendaten:**
  - **Co-Dev + Revenue-Share** = Entwicklungs-Kostenanteil + x % auf Assistenten-Feature-Abo
  - **Modul-Lizenz** = einmalig, **fünfstelliger Bereich**
- **Keine standardisierten Preise** — verhandlungsbasiert nach QA-Klärung

### 1.4 "100.000 Credits" reference
- **Source:** `THOMAS_MASTER_2026.html` Position 11515
- **Text:** "Tarif: enterprise, 100.000 Credits. Drei Einbauwege: Claude Code (Doppelklick-Script), Claude Desktop (Plugin), Claude Web (URLs eintragen)."
- **Kontext:** Dies bezieht sich auf **Claude Code/Desktop-Pläne**, **nicht** direkt auf Judicario-Funktionalität. Die 100K Credits sind Anthropics Token-Kontingent für Claude Enterprise-Use Cases.

---

## 2. Chipsi — Monetization & Access

### 2.1 Current state
- **Source:** `Desktop/Judicario_Sacha_Mac/chipsi/Chipsi.pdf` (61.276 Bytes, einziges File)
- **Format:** PDF only — keine API, kein `.mcp.json`, keine öffentlichen Endpoints
- **Inhalt:** Screenshot/Layout-Description, keine preislichen Informationen lesbar (Textextraktion ergab nur charset-codierte Streams ohne lesbare Preisangaben)

### 2.2 Known constraints
- **Source:** Audit T4-Blocker (#1070): "Chipsi T4 blockiert — keine Chipsi-Instanz-Zugang, nur statischer PDF-Screenshot"
- **Thomas-Zugang:** Muss Login geben für T1–T7-Testprotokoll
- **Integration status:** **VOLLSTANDIG BLOCKIERT** — kein technischer Weg, daran andocken ohne Login-Daten

### 2.3 Go-to-market (aus Audit-Thesen)
- **Positionierung:** "lokal, aus Datenschutzgründen (RAO §9 + DSGVO), 0 € laufende Kosten, Echtzeit möglich, läuft auf Mac M-Serie und ließe sich in Chipsi einbauen" (Audit-Thesis A4a)
- **Ziel:** Integrierte Lösung für Kanzleien, die Daten lokal halten wollen
- **Status:** Produktidee / Konzepteinrichtung — **noch kein am Marktrechtes Produkt** (kein Access, kein API)

### 2.4 Monetization model (aus Thesen)
- **Laufende Kosten:** **0 €** (laut Audit: "0 € laufende Kosten (keine Minuten-Abos)")
- **Einmalig:** Entwicklungs-Kostenanteil (im Co-Dev + Revenue-Share Modell enthalten)
- **Vertrieb:** Thomas + Sacha Co-Development + Revenue-Share auf Assistenten-Abo
- **Preis-Struktur:** "Bewusst offen bis zur QA-Klärung" — gleiche Like-for-Judicario-Struktur

---

## 3. Combined Model — How They Work Together (or Don't)

| Aspekt | Judicario | Chipsi |
|---|---|---|
| **Verfügbarkeit** | ✅ MCP-Gateway, funktioniert (Key vorhanden) | ❌ Nur PDF, kein Zugang |
| **Laufende Kosten** | Unklar (verhandlungsbasiert) | 0 € (laut Konzept, aber nicht verfügbar) |
| **In loki-voice integriert** | ✅ Ja (Schritt 3 der Pipeline) | ❌ Nein (T4-Blocker) |
| **Preismodell** | Co-Dev + Revenue-Share + Modul-Lizenz (fünfstellig) | Ähnlich — aber "abhängig von Chipsi-Release" (Audit) |
| **Next Step** | Keiner — läuft schon | 🔑 Thomas Login beschaffen → Connector bauen |

---

## 4. Revenue-Share / Co-Dev Structure (aus Audit)

### 4.1 "Co-Development + Revenue-Share"
- **Source:** `THOMAS_MASTER_2026.html` Positionen 626, 630, 640, 644, 647, 667
- **Concept:** "Wir bauen gemeinsam + ich bekomme einen Prozentanteil der Abo-Einnahmen"
- **Rein:** "Prozentanteil der Abo-Einnahmen aus dem Assistenten"
- **Komplexität:** "Benötigt Vertrauen"
- **Einmal-Lizenz:** "Konzept/Architektur einmal verkaufen", "klarer Preis, einmalig", "keine laufenden Einnahmen"

### 4.2 Fünfstelliger Bereich
- **Source:** `THOMAS_MASTER_2026.html` Position 62077
- **Text:** "Modul-Lizenz = einmalig, fünfstelliger Bereich"
- **Kontext:** Gemeint für die Modulentwicklung, nicht für laufende User-Kosten

### 4.3 QA Gate
- **Source:** `THOMAS_MASTER_2026.html` Position 654
- **Text:** "Erst QA beantworten, dann Preis — beratend, nicht aufdringlich."
- **Ablauf:** QA-Fragen klären → dann Preisverhandlung → beratend, nicht aufdringlich

---

## 5. Summary — What This Means for loki-voice

| Frage | Antwort |
|---|---|
| **Hat Judicario ein sichtbares Preismodell?** | Nein — "bewusst offen bis QA-Klärung". MCP-Key existiert, ob kostenpflichtig nicht aus loki-voice-Sicht ersichtlich. |
| **Hat Chipsi ein Preismodell?** | Konzeptuell: 0 € laufende Kosten. Technisch: Nicht verfügbar (kein Access). |
| **Was verkauft man hier?** | **Zusammenbau:** 1. Judicario-Faktencheck (fertig, MCP-Zugriff da) 2. Chipsi-Gedächtnis (Blockiert — Zugangsproblem) 3. Zusammengehend: "Kanzlei-Assistent mit Second Brain und juristischer Verifikation" |
| **Wie monetarisiert man?** | Co-Dev + Revenue-Share auf Claude-Enterprise-Abo + einmalige Modul-Lizenz (fünfstellig), "Preis nach QA-Klärung" |
| **Was fehlt für Veröffentlichung?** | Chipsi-Zugang (Thomas Login). Ohne das: Judicario allein funktioniert, Chipsi nicht. |

---

## 6. Recommendations for loki-voice Pricing

Based on the above analysis, here's what makes sense for the loki-voice business model:

1. **Base model:** Claude Enterprise $35/User/Monat (inkludierte Token-Mengen)
2. **Add-on modules:**
   - Judicario-Faktencheck: In Basis inbegriffen (MCP-Zugriff vorhanden)
   - Chipsi-Gedächtnis: Erst nach Zugangs-Beschaffung durch Thomas verfügbar
3. **Pricing tiers:**
   - **Solo/Small (10 Users):** ~$350/Monat (Claude Lizenz) + optionale Modul-Lizenz (einmalig fünfstellig)
   - **Medium (50 Users):** ~$1.750/Monat + gleiche Modul-Lizenz
   - **Enterprise (100+):** Individuelle Verhandlung — Co-Dev + Revenue-Share + Modul-Lizenz
4. **Transparentity:** "Preis nach QA-Klärung" — wie im Audit empfohlen. Erst die Funationalität (insb. Chipsi-Integration) klären, dann über Preis sprechen.

---

*Research completed from primary sources only. No secondary write-ups relied upon.*