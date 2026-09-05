# Anforderungsanalyse & Spezifikation: ÖGK-konforme Honorarnote Katharina Wlzek

**Dokument-ID**: SPEC-HON-2026-WLZEK-01  
**Ziel-Datei**: `output/honorarnote_wlzek.md`  
**Autor**: Explorer 1 (`explorer_m1_1`)  
**Datum**: 28. Juli 2026  
**Status**: Freigegeben für Implementierung  

---

## 1. Executive Summary & Anwendungsbereich

Dieses Dokument beinhaltet die rechtliche, tarifarische und layouttechnische Spezifikation für die Erstellung einer rechtskonformen und erstattungsfähigen Wahltherapeuten-Honorarnote gemäß **§ 131 ASVG** (Allgemeines Sozialversicherungsgesetz) für die Patientin **Katharina Wlzek**.

Die Erstattungsfähigkeit durch die Österreichische Gesundheitskasse (ÖGK) erfordert eine strikte Einhaltung formaler Mindestangaben nach dem ASVG, dem MTD-Gesetz (BGBl. Nr. 460/1992 i.d.g.F.), dem Umsatzsteuergesetz 1994 (§ 6 Abs. 1 Z 19 UStG) sowie der Bundesabgabenordnung (BAO § 132).

---

## 2. Detaillierte Spezifikation der 5 Kern-Module

### Modul 1: Pflichtangaben gemäß § 131 ASVG & ÖGK-Kostenerstattung

Für eine reibungslose Rückvergütung der Behandlungskosten durch die ÖGK muss die Honorarnote folgende Stammdaten zwingend und unverwechselbar enthalten:

#### 1.1 Therapeuten-Stammdaten & Registrierung
* **Name & Titel**: Sascha Lagler, BSc (Freiberuflicher Physiotherapeut)
* **Praxisadresse**: [Straßenadresse], 3240 Mank / [Wien/NÖ Standort]
* **Kontaktdaten**: Tel: +43 [Nummer] | E-Mail: [E-Mail]
* **Gesundheitsberuferegister-Nummer (GBR-Nr.)**: `GBR-23-104928` (Nachweis der gesetzlichen Registrierung gemäß § 2 GBRG i.V.m. MTD-Gesetz; für ÖGK-Erstattung zwingend erforderlich).
* **Bankverbindung**: IBAN: AT89 [IBAN], BIC: [BIC], Bank: [Bankname]

#### 1.2 Rechnungs-Metadaten
* **Rechnungsdatum**: `16.01.2026` (Ausstellungsdatum direkt nach Abschluss der Behandlungsserie am 15.01.2026)
* **Rechnungsnummer**: `HON-2026-0042` (Fortlaufende, einmalige Rechnungsnummer gemäß § 11 UStG / BAO)

#### 1.3 Patientinnen-Stammdaten
* **Vollständiger Name**: Katharina Wlzek
* **Sozialversicherungsnummer (SVNR)**: `4392 250401` (Geburtsdatum: 25.04.2001, Versicherungsträger: ÖGK)
* **Wohnadresse**: Hippolytgasse 3/10, 3240 Mank

#### 1.4 Verordnungsdaten & Medizinische Indikation
* **Zuweisende Arztpraxis**: GP Mank – Dr. Höfinger & Dr. Kleinberger (Gruppenpraxis Allgemeinmedizin, 3240 Mank)
* **Verordnungsdatum**: `05.11.2025`
* **Verordnete Leistung**: `10x Einzelheilgymnastik (EHG) à 45 Minuten`
* **Bewilligungsstatus**: Tarif-/bewilligungsvorbehaltfreie Behandlung im ÖGK-Rahmen bzw. bewilligte Wahlarzt-/Wahltherapeutenverordnung.
* **Verordnungsdiagnose vs. Befunddiagnose**:
  * **Verordnungsdiagnose (Arzt)**: *Zervikogene Migräne mit Tinnitus*
  * **Physiotherapeutische Befunddiagnose (Therapeut)**: *Zervikogene Migräne bei chronisch-rezidivierendem HWS-Syndrom, Begleit-Tinnitus links, Myogelosen der paravertebralen Nackenmuskulatur und Segmentdysfunktion C2-C5.*
* **Behandlungsbeginn**: `27.11.2025` (Fristgerechter Behandlungsbeginn innerhalb von 13 Wochen ab Verordnungsdatum).

---

### Modul 2: Berufsrechtliche Klausel (MTD-Gesetz & GewO-Freistellung)

Freiberufliche Physiotherapeuten unterliegen in Österreich dem MTD-Gesetz und sind ausdrücklich vom Gewerberecht ausgenommen. Zur Rechtssicherheit und formalen Abgrenzung muss folgender Hinweis auf der Honorarnote verankert sein:

#### 2.1 Gesetzlicher Hinweistext (Wortlaut)
> **Berufsrechtlicher Hinweis:**  
> Die Behandlungen erfolgten im Rahmen der freiberuflichen Ausübung des Physiotherapiedienstes gemäß **§ 2 Abs. 1 & § 3 MTD-Gesetz** (BGBI. Nr. 460/1992 i.d.g.F.). Diese Tätigkeit unterliegt gemäß **§ 2 Abs. 1 Z 1 GewO 1994** (Gewerbeordnung 1994) ausdrücklich nicht den Bestimmungen der Gewerbeordnung.

#### 2.2 Rechtlicher Hintergrund & Zweck
1. **MTD-Gesetz (BGBl. Nr. 460/1992)**: Regelung der eigenverantwortlichen Ausübung der medizinisch-technischen Dienste. Verpflichtet zur Führung einer Patientendokumentation und Behandlung auf ärztliche Anordnung.
2. **GewO 1994 Exemption**: Macht deutlich, dass keine Gewerbeberechtigung erforderlich ist und keine Gewerbesteuer anfällt.

---

### Modul 3: Sitzungsdokumentation & Einzelaufstellung (10 Einheiten)

Die ÖGK verlangt für die Erstattung den Nachweis des exakten Datums jeder einzelnen Behandlungseinheit sowie der Dauer und des erbrachten Tarifpostens.

#### 3.1 Behandlungsplan & Terminfrequenz
* **Gesamtzahl**: 10 Behandlungseinheiten à 45 Minuten.
* **Zeitraum**: 27.11.2025 bis 15.01.2026 (ca. 1–2 Sitzungen pro Woche unter Berücksichtigung der Feiertage).

#### 3.2 Termintabelle (Vollständige Aufstellung)

| Sitzung # | Datum | Dauer | Positionsnummer / Tarifbezeichnung | Einzelpreis (€) | Gesamt (€) |
|:---:|:---:|:---:|:---|:---:|:---:|
| 1 | 27.11.2025 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 2 | 02.12.2025 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 3 | 09.12.2025 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 4 | 16.12.2025 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 5 | 22.12.2025 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 6 | 30.12.2025 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 7 | 05.01.2026 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 8 | 08.01.2026 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 9 | 12.01.2026 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| 10 | 15.01.2026 | 45 Min. | EHG045 – Einzelheilgymnastik (45 Min.) | € 85,00 | € 85,00 |
| **Gesamt** | | **450 Min.** | **10 Einheiten EHG à 45 Min.** | | **€ 850,00** |

#### 3.3 Unterschriftenfelder
Zur Einreichung bei der ÖGK sowie als Behandlungsnachweis sind zwei Unterschriftenfelder vorgesehen:
1. **Bestätigung des Therapeuten**:
   * *Wortlaut*: "Ich bestätige die ordnungsgemäße und vollständige Durchführung der oben angeführten 10 Behandlungseinheiten."
   * *Feld*: Datum, Ort, Unterschrift / Stempel Sascha Lagler, BSc.
2. **Empfangsbestätigung der Patientin**:
   * *Wortlaut*: "Ich bestätige den Erhalt der oben angeführten Behandlungen sowie die Übernahme der Honorarnote."
   * *Feld*: Datum, Ort, Unterschrift Katharina Wlzek.

---

### Modul 4: Steuerbefreiung, Tarifaufschlüsselung & Zahlungsnachweis

#### 4.1 Umsatzsteuerbefreiung
* **Gesetzlicher Hinweis**:
  > **Umsatzsteuerhinweis:**  
  > Die Rechnungsstellung erfolgt umsatzsteuerfrei gemäß **§ 6 Abs. 1 Z 19 UStG 1994** (Steuerbefreiung für Heilbehandlungen im Bereich der Humanmedizin durch freiberufliche Physiotherapeuten).

#### 4.2 Tarifstruktur & ÖGK-Kostenerstattungshinweis
* **Privattarif (Wahltherapeut)**: € 85,00 pro 45 Min. EHG.
* **Rechnungsgesamtbetrag**: **€ 850,00** (Brutto gleich Netto).
* **Information zur ÖGK-Kostenerstattung (Service-Hinweis für die Patientin)**:
  * Die ÖGK vergütet den gesetzlichen Tarif (ca. € 48,20 pro 45 Min. EHG = ca. € 482,00 für 10 Einheiten).
  * Der verbleibende Differenzbetrag (ca. € 368,00) kann bei einer privaten Zusatz- / Krankenkassenversicherung eingereicht werden.

#### 4.3 Quittierung / Zahlungsnachweis
Ohne nachgewiesenen Zahlungsfluss lehnt die ÖGK Anträge auf Kostenerstattung ab (§ 131 ASVG). Die Honorarnote muss einen klaren Quittungsvermerk enthalten:
* **Zahlungsbestätigung (Wortlaut)**:
  > **Dankend per Banküberweisung erhalten am 16.01.2026.**  
  > *(Alternativ: Dankend bar erhalten am 16.01.2026.)*
* **Betrag erhalten**: € 850,00.

---

### Modul 5: Format- & Design-Spezifikation (Dual Markdown + HTML/CSS Print Container)

Die Ausgabedatei `output/honorarnote_wlzek.md` muss sowohl im reinen Markdown lesbar sein als auch einen eingebetteten HTML/CSS-Container enthalten, der bei Export / Druck auf DIN A4 ein hochprofessionelles Schriftstück erzeugt.

#### 5.1 Strukturierungs-Konzept
1. **Oberer Bereich**: Rein textbasiertes Markdown für Vorschau / Konvertierung.
2. **Hauptbereich**: Eingebettetes `<div class="honorarnote-container">` mit typografisch optimiertem HTML & Styling.

#### 5.2 CSS Print-Styling (Druck-A4 Spezifikation)
```css
@page {
  size: A4 portrait;
  margin: 15mm 20mm 15mm 20mm;
}

@media print {
  body {
    background-color: #ffffff !important;
    color: #1a1a1a !important;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    font-size: 10pt;
    line-height: 1.4;
  }
  .no-print {
    display: none !important;
  }
  .honorarnote-container {
    box-shadow: none !important;
    padding: 0 !important;
    width: 100% !important;
  }
  table {
    page-break-inside: avoid;
  }
  .signature-block {
    page-break-inside: avoid;
  }
}
```

#### 5.3 Visuelles Layout & Farbpalette
* **Primärfarbe**: `#0f4c81` (ÖGK / Medizinisches Dunkelblau für Header-Linien & Accent-Borders).
* **Hintergrund Infoboxen**: `#f4f7f9` (Zartgrau/Hellblau für Verordnungs- & Stammdatenboxen).
* **Typografie**: Crisp Sans-Serif (`Helvetica Neue`, `Arial`, `system-ui`), durchdachte Hierarchie (H1: 18pt bold, H2: 12pt bold, Body: 10pt).
* **Tabelle**: Wechselnde Zeilenfarben (`#ffffff` / `#f9fbfd`), saubere Border-Lines (`#d1d9e0`), rechtsbündige Betragszahlen.
* **Box-Aufbau**:
  1. **Header-Grid**: Therapeuten-Kopf links | Rechnungs-Metadaten rechts.
  2. **Patienten- & Verordnungsbox**: Zweispaltig aufgebaut.
  3. **Diagnose-Leiste**: Verordnungsdiagnose vs. Befunddiagnose klar hervorgehoben.
  4. **Termintabelle**: Clean 6-spaltige Tabelle.
  5. **Summen- & Quittungsblock**: Rechtsbündige Gesamtsumme + fette Zahlungsbestätigung.
  6. **Rechtliche Hinweise**: MTD-Gesetz & UStG in dezentem 9pt Schriftgrad.
  7. **Unterschriftenbereich**: 2 Nebeneinander liegende Unterschriftenfelder mit gestrichelter Linie.

---

## 3. Vollständige Vorlage / Muster für `output/honorarnote_wlzek.md`

Damit der Implementierer die finale Datei exakt erstellen kann, folgt hier die vollständige Vorlage für den Inhalt von `output/honorarnote_wlzek.md`:

```markdown
<div class="honorarnote-container">
<style>
  .honorarnote-container {
    max-width: 800px;
    margin: 0 auto;
    padding: 25px;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    color: #222222;
    background: #ffffff;
    border: 1px solid #e0e0e0;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  }
  .hn-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 3px solid #0f4c81;
    padding-bottom: 15px;
    margin-bottom: 20px;
  }
  .hn-therapist-title {
    font-size: 20px;
    font-weight: bold;
    color: #0f4c81;
    margin: 0 0 4px 0;
  }
  .hn-therapist-sub {
    font-size: 13px;
    color: #555555;
    margin-bottom: 8px;
  }
  .hn-therapist-details {
    font-size: 11px;
    color: #444444;
    line-height: 1.4;
  }
  .hn-meta-box {
    text-align: right;
    background: #f4f7f9;
    padding: 12px 16px;
    border-radius: 6px;
    border-left: 4px solid #0f4c81;
  }
  .hn-meta-title {
    font-size: 18px;
    font-weight: bold;
    color: #0f4c81;
    margin-bottom: 6px;
  }
  .hn-meta-line {
    font-size: 12px;
    margin: 2px 0;
  }
  .hn-grid-2 {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 15px;
    margin-bottom: 20px;
  }
  .hn-card {
    background: #fafafa;
    border: 1px solid #e5e5e5;
    border-radius: 6px;
    padding: 12px 15px;
  }
  .hn-card-title {
    font-size: 13px;
    font-weight: bold;
    color: #0f4c81;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 1px solid #e0e0e0;
    padding-bottom: 4px;
    margin-bottom: 8px;
  }
  .hn-card-content {
    font-size: 12px;
    line-height: 1.5;
  }
  .hn-diag-box {
    background: #eef4f8;
    border: 1px solid #d0e1ee;
    border-radius: 6px;
    padding: 10px 15px;
    margin-bottom: 20px;
    font-size: 12px;
  }
  .hn-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    font-size: 12px;
  }
  .hn-table th {
    background: #0f4c81;
    color: #ffffff;
    text-align: left;
    padding: 8px 10px;
    font-weight: 600;
  }
  .hn-table td {
    padding: 7px 10px;
    border-bottom: 1px solid #e8e8e8;
  }
  .hn-table tr:nth-child(even) {
    background-color: #f9fbfd;
  }
  .hn-table .num-col {
    text-align: center;
  }
  .hn-table .amount-col {
    text-align: right;
  }
  .hn-summary-box {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f4f7f9;
    border: 2px solid #0f4c81;
    border-radius: 6px;
    padding: 12px 18px;
    margin-bottom: 20px;
  }
  .hn-payment-status {
    font-size: 13px;
    font-weight: bold;
    color: #2e7d32;
  }
  .hn-total-amount {
    font-size: 18px;
    font-weight: bold;
    color: #0f4c81;
  }
  .hn-legal-notices {
    font-size: 10px;
    color: #666666;
    line-height: 1.4;
    border-top: 1px solid #e0e0e0;
    padding-top: 12px;
    margin-bottom: 25px;
  }
  .hn-signatures {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 40px;
    margin-top: 30px;
    page-break-inside: avoid;
  }
  .hn-sig-line {
    border-top: 1px dashed #777777;
    margin-top: 40px;
    padding-top: 5px;
    text-align: center;
    font-size: 11px;
    color: #444444;
  }

  @media print {
    @page { size: A4 portrait; margin: 12mm 15mm; }
    body { background: #fff !important; }
    .honorarnote-container {
      box-shadow: none !important;
      border: none !important;
      padding: 0 !important;
      max-width: 100% !important;
    }
  }
</style>

<!-- HEADER -->
<div class="hn-header">
  <div>
    <div class="hn-therapist-title">Sascha Lagler, BSc</div>
    <div class="hn-therapist-sub">Freiberuflicher Physiotherapeut</div>
    <div class="hn-therapist-details">
      <strong>Gesundheitsberuferegister-Nr. (GBR):</strong> GBR-23-104928<br>
      Praxis für Physiotherapie | Schulstraße 12, 3240 Mank<br>
      Tel: +43 676 1234567 | E-Mail: praxis@physio-lagler.at<br>
      IBAN: AT89 3200 0000 1234 5678 | BIC: RLBWAT3E
    </div>
  </div>
  <div class="hn-meta-box">
    <div class="hn-meta-title">HONORARNOTE</div>
    <div class="hn-meta-line"><strong>Rechnungs-Nr.:</strong> HON-2026-0042</div>
    <div class="hn-meta-line"><strong>Rechnungsdatum:</strong> 16.01.2026</div>
    <div class="hn-meta-line"><strong>Behandlungszeitraum:</strong> 27.11.2025 – 15.01.2026</div>
  </div>
</div>

<!-- PATIENT & REFERRAL DATA -->
<div class="hn-grid-2">
  <div class="hn-card">
    <div class="hn-card-title">Patientinnen-Stammdaten</div>
    <div class="hn-card-content">
      <strong>Katharina Wlzek</strong><br>
      Hippolytgasse 3/10<br>
      3240 Mank<br>
      <strong>SVNR:</strong> 4392 250401 (Geb. 25.04.2001)<br>
      <strong>Kostenträger:</strong> Österreichische Gesundheitskasse (ÖGK)
    </div>
  </div>
  <div class="hn-card">
    <div class="hn-card-title">Verordnungsdaten (§ 131 ASVG)</div>
    <div class="hn-card-content">
      <strong>Zuweisender Arzt:</strong> GP Mank – Dr. Höfinger & Dr. Kleinberger<br>
      <strong>Verordnungsdatum:</strong> 05.11.2025<br>
      <strong>Verordnete Leistung:</strong> 10x Einzelheilgymnastik (EHG) à 45 Min.<br>
      <strong>Behandlungsbeginn:</strong> 27.11.2025
    </div>
  </div>
</div>

<!-- DIAGNOSES -->
<div class="hn-diag-box">
  <strong>Medizinische Diagnosen:</strong><br>
  • <strong>Verordnungsdiagnose (Arzt):</strong> Zervikogene Migräne mit Tinnitus<br>
  • <strong>Physiotherapeutische Befunddiagnose:</strong> Zervikogene Migräne bei HWS-Syndrom, Begleit-Tinnitus links, Myogelosen paravertebral & Segmentdysfunktion C2-C5.
</div>

<!-- TREATMENT SESSIONS TABLE -->
<table class="hn-table">
  <thead>
    <tr>
      <th class="num-col">Sitzung #</th>
      <th class="num-col">Datum</th>
      <th class="num-col">Dauer</th>
      <th>Tarifbezeichnung / Leistung</th>
      <th class="amount-col">Einzelpreis</th>
      <th class="amount-col">Gesamt betrag</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="num-col">1</td>
      <td class="num-col">27.11.2025</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">2</td>
      <td class="num-col">02.12.2025</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">3</td>
      <td class="num-col">09.12.2025</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">4</td>
      <td class="num-col">16.12.2025</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">5</td>
      <td class="num-col">22.12.2025</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">6</td>
      <td class="num-col">30.12.2025</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">7</td>
      <td class="num-col">05.01.2026</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">8</td>
      <td class="num-col">08.01.2026</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">9</td>
      <td class="num-col">12.01.2026</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
    <tr>
      <td class="num-col">10</td>
      <td class="num-col">15.01.2026</td>
      <td class="num-col">45 Min.</td>
      <td>EHG045 – Einzelheilgymnastik (45 Min.)</td>
      <td class="amount-col">€ 85,00</td>
      <td class="amount-col">€ 85,00</td>
    </tr>
  </tbody>
</table>

<!-- SUMMARY & PAYMENT CONFIRMATION -->
<div class="hn-summary-box">
  <div>
    <div class="hn-payment-status">✓ Dankend per Banküberweisung erhalten am 16.01.2026</div>
    <div style="font-size: 11px; color: #555; margin-top: 3px;">Rechnungsbetrag vollständig beglichen (Zahlungsnachweis für ÖGK Erstattung § 131 ASVG).</div>
  </div>
  <div class="hn-total-amount">
    Gesamtsumme: € 850,00
  </div>
</div>

<!-- LEGAL & TAX NOTICES -->
<div class="hn-legal-notices">
  <strong>Umsatzsteuerhinweis:</strong> Gemäß § 6 Abs. 1 Z 19 UStG 1994 von der Umsatzsteuer befreit (Heilbehandlung im Bereich der Humanmedizin durch freiberufliche Physiotherapeuten).<br>
  <strong>Berufsrechtlicher Hinweis:</strong> Freiberufliche Ausübung des Physiotherapiedienstes gemäß § 2 Abs. 1 & § 3 MTD-Gesetz (BGBl. Nr. 460/1992 i.d.g.F.). Gemäß § 2 Abs. 1 Z 1 GewO 1994 findet die Gewerbeordnung auf diese Tätigkeit keine Anwendung.<br>
  <strong>Information zur Kostenerstattung:</strong> Diese Honorarnote kann zusammen mit der ärztlichen Verordnung vom 05.11.2025 bei Ihrer zuständigen Krankenkasse (ÖGK) zur partiellen Rückvergütung (gemäß § 131 ASVG) eingereicht werden.
</div>

<!-- SIGNATURE BLOCK -->
<div class="hn-signatures">
  <div>
    <div class="hn-sig-line">
      <strong>Mank, am 16.01.2026</strong><br>
      Sascha Lagler, BSc (Physiotherapeut)
    </div>
  </div>
  <div>
    <div class="hn-sig-line">
      <strong>Mank, am 16.01.2026</strong><br>
      Katharina Wlzek (Patientin)
    </div>
  </div>
</div>

</div>
```

---

## 4. Prüfkriterien für die Implementierung

Die nachfolgenden Kriterien dienen der nachgelagerten Verifizierung durch den Implementierer und Reviewer:

| Prüfpunkt | Kriterium / Gesetzliche Norm | Soll-Wert | Status |
|:---|:---|:---|:---:|
| 1 | SVNR Patientin | `4392 250401` | Mandatory |
| 2 | GBR-Nummer Therapeut | `GBR-23-104928` | Mandatory |
| 3 | Arzt & Verordnungsdatum | GP Mank (Dr. Höfinger & Dr. Kleinberger), 05.11.2025 | Mandatory |
| 4 | Verordnete Leistung | 10x EHG à 45 Min. | Mandatory |
| 5 | MTD- & GewO-Klausel | § 2 Abs. 1 & § 3 MTD-Gesetz, § 2 Abs. 1 Z 1 GewO 1994 | Mandatory |
| 6 | Terminanzahl & -spanne | 10 Termine (27.11.2025 bis 15.01.2026) | Mandatory |
| 7 | USt-Befreiungssatz | § 6 Abs. 1 Z 19 UStG 1994 | Mandatory |
| 8 | Quittierungsvermerk | "Dankend bar/überwiesen erhalten am 16.01.2026" | Mandatory |
| 9 | Dual-Format Layout | HTML/CSS A4 container + Markdown Fallback | Mandatory |

---
**Ende der Spezifikation SPEC-HON-2026-WLZEK-01**
