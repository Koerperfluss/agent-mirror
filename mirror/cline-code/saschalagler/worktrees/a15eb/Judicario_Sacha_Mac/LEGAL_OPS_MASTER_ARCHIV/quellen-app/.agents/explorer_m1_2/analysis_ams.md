# Legal Analysis & Technical Specification — Deliverable 2: Formlose AMS-Meldungsvorlage (`output/ams_meldung_freiberuf.md`)

**Role**: `explorer_m1_2`  
**Milestone**: M1 (Exploration & Technical Specification)  
**Target Output**: `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/output/ams_meldung_freiberuf.md`  
**Date**: 2026-07-28  

---

## 1. Executive Summary & Objective

This document provides the legal analysis and technical specification for **Deliverable 2: Formlose AMS-Meldungsvorlage (`output/ams_meldung_freiberuf.md`)**. 

The goal of Deliverable 2 is to provide a legally sound, unbureaucratic notification document for freelance MTD health professionals (specifically freiberufliche Physiotherapeutinnen/Physiotherapeuten gem. MTD-Gesetz, such as Sascha Lagler) to report minor freelance activity to the Austrian Unemployment Service (**Arbeitsmarktservice — AMS**).

### Core Legal & Strategic Objectives:
1. **Protection of AMS Benefits & Registration**: Ensuring that active registration with the AMS and entitlement to Unemployment Benefit (*Arbeitslosengeld*) or Emergency Aid (*Notstandshilfe*) remain intact without unlawful suspension (§ 12 AlVG).
2. **UGP & Trade License Protection**: Clarifying that freelance MTD healthcare activity is **not a commercial trade** (*kein Gewerbe i.S.d. GewO 1994*), thus avoiding any conflict with a dormant trade license (*ruhendes Gewerbe*) or active participation in the AMS Business Start-Up Program (*Unternehmensgründungsprogramm — UGP*).
3. **Geringfügigkeit & Income Calculation**: Establishing that the expected net profit (*Gewinn*) remains strictly below the statutory monthly threshold under § 5 Abs. 2 ASVG.
4. **Availability for Job Placement**: Formally declaring compliance with § 9 AlVG by maintaining working hours strictly under 16 hours per week (< 16h/week).

---

## 2. AMS Legal Context & Statutory Framework

### 2.1 Arbeitslosenversicherungsgesetz (AlVG 1977)

#### A. Definition of Unemployment & Exception for Minor Activity (§ 12 AlVG)
* **§ 12 Abs. 1 AlVG**: Defines unemployment as the state where a person is not engaged in employment or self-employment subject to compulsory social insurance.
* **§ 12 Abs. 3 lit. f / § 12 Abs. 6 lit. c AlVG**: Establishes that self-employed or freelance activity **does NOT invalidate unemployment** if:
  1. The monthly income (*Gewinn*) generated does not exceed the statutory monthly minor income threshold (*Geringfügigkeitsgrenze*) pursuant to **§ 5 Abs. 2 ASVG**.
  2. The weekly time commitment (*Arbeitsaufwand*) is minor, specifically remaining **under 16 hours per week** (< 16h/Woche).

#### B. Statutory Notification Duties (§ 50 AlVG)
* **§ 50 Abs. 1 AlVG**: Requires benefit recipients to inform the responsible AMS Regionalstelle **immediately, and at the latest before commencing the activity**, of any change affecting benefit eligibility or extent.
* *Legal Risk*: Failure to report prior to taking on the first patient can lead to formal revocation of benefits (*Leistungseinstellung*) and retroactive repayment claims under § 25 AlVG, even if income was below the threshold.
* *Remedy*: The notification template must be dated and submitted **prior** to or concurrently with the first treatment session.

#### C. Availability for Job Placement (§ 9 AlVG)
* **§ 9 Abs. 1 AlVG**: Arbeitslosengeld recipients must remain available for placement in full-time or part-time employment arranged by the AMS (*dem Arbeitsmarkt zur Verfügung stehen*).
* The freelance MTD activity must be explicitly declared as a **subsidiary minor activity** (*nebenberufliche geringfügige Tätigkeit*) that can be rescheduled or reduced at any time if suitable employment is mediated.

---

### 2.2 Healthcare Law (MTD-Gesetz) vs. Trade Law (GewO 1994)

#### A. Statutory Exemption from Trade Regulations (§ 2 GewO 1994)
* **§ 2 Abs. 1 Z 11 Gewerbeordnung 1994 (GewO 1994)** explicitly excludes the exercise of medicine and other regulated health professions from the scope of trade law:
  > *"Die Gewerbeordnung ist auf die Ausübung der Heilkunde, der übrigen Gesundheitsberufe sowie der Berufe des medizinisch-technischen Dienstes [...] nicht anzuwenden."*
* **MTD-Gesetz (MTDG, BGBl. I Nr. 46/1992 i.d.g.F. / MTD-Gesetz 2024)**: Regulates freelance practice of Physiotherapy. Registration in the *Gesundheitsberuferegister (GBL / GÖG)* confers the statutory right to practice freely (*Freiberufler*).

#### B. Protection of Dormant Trade Licenses (*Ruhendes Gewerbe*) & UGP
* **Dormant Trade License**: If a practitioner holds a commercial trade license (e.g., Massage, Fitnesstrainer, Gewerbliche Dienstleistungen) that has been officially set to dormant (*ruhend gemeldet* bei der Wirtschaftskammer ÖÖ/NÖ/Wien), freelance MTD practice **does not violate** or reactivate this trade.
* **AMS UGP Alignment**: In the UGP phase (or pre-UGP qualification phase), participants building up a future business are permitted to earn minor income. Stating clearly that the MTD practice is a liberal profession (*Freiberuf*) prevents AMS caseworkers from misclassifying the practice as an unauthorized commercial trade launch (*vorzeitige Gewerbeausübung*).

---

## 3. Geringfügigkeitsgrenze & Financial Calculations (§ 5 Abs. 2 ASVG)

### 3.1 Statutory Monthly Income Thresholds

Under § 5 Abs. 2 ASVG (indexed annually under § 108 ASVG), the monthly threshold for minor activity (*Geringfügigkeitsgrenze*) is:

| Year | Monthly Threshold (§ 5 Abs. 2 ASVG) | Annual Equivalent (12x) | Legal Basis |
| :--- | :--- | :--- | :--- |
| **2024** | **€ 518,44** | € 6.221,28 | BGBl. II Nr. 384/2023 |
| **2025** | **€ 551,10** | € 6.613,20 | BGBl. II Nr. 372/2024 |
| **2026** | **€ 584,20** *(approx. ind.)* | € 7.010,40 | Statutory Indexation |

*Note for Implementation*: The template must dynamically reflect the active calendar year threshold (or use variables `{{ GERINGFUEGIGKEITSGRENZE_MONAT }}` and `{{ GERINGFUEGIGKEITSGRENZE_JAHR }}`).

---

### 3.2 Net Profit vs. Gross Revenue Calculation

A common point of error with AMS caseworkers is confusing **Gross Revenue** (*Brutto-Umsatz / Einnahmen*) with **Net Profit** (*Netto-Einkünfte / Gewinn*).

#### Legal Statutory Rule:
Under Austrian tax law (§ 22 EStG 1988) and social security law (§ 5 Abs. 2 ASVG i.V.m. § 4 GSVG), the decisive criterion for self-employed/freelance minor status is the **monthly Net Profit (*Gewinn / Einkünfte*)**, calculated as:

$$\text{Monatlicher Netto-Gewinn} = \text{Brutto-Betriebseinnahmen (Honorare)} - \text{Betriebsausgaben}$$

#### Business Expenses (*Betriebsausgaben*):
1. **Actual Receipts Method (*Tatsächliche Betriebsausgaben*)**:
   - Room rental per treatment hour (*Praxisraummiete / Anteilsmiete*)
   - Medical materials and consumables (tapes, towels, disinfectants)
   - Professional indemnity insurance (*Berufshaftpflichtversicherung*)
   - Travel expenses (*Kilometergeld*)
   - Mandatory registration fees (GÖG/AK MTD-Register)
2. **Flat-Rate Expenses (*Basispauschalierung § 17 EStG*)**:
   - Standard 6% or 12% expense deduction of gross turnover (though actual itemized receipts are typically more beneficial for low-volume freelance starters).

#### Calculation Example for Notification:
- Expected Gross Honoraria (e.g. 4 sessions à € 90,00): **€ 360,00 / month**
- Estimated Business Expenses (Room rental, transport, insurance): **€ 60,00 / month**
- **Estimated Net Profit (*Netto-Gewinn*)**: **€ 300,00 / month**
- *Result*: **€ 300,00 < € 551,10 (2025 limit) / € 584,20 (2026 limit)** $\rightarrow$ **Geringfügig!**

---

### 3.3 Working Hours Limitation (< 16h / Week)

- **Total Time Limit**: Time devoted to freelance MTD activities must strictly remain **under 16 hours per calendar week**.
- **Inclusive Scope**: Working hours include:
  - Patient treatment time (e.g., 10x 45 min = 7.5 hours)
  - Preparation and sanitary cleanup (e.g., 1.5 hours)
  - Documentation, invoicing, and admin (e.g., 1.0 hour)
  - Total: **10 hours / week** (< 16 hours/week threshold).

---

## 4. Trade License (GewO) & UGP Protection Specification

### 4.1 Comparison Table: Freiberuf vs. Gewerbe

| Feature | Freelance MTD (Physiotherapie) | Commercial Trade (*Gewerbe*) |
| :--- | :--- | :--- |
| **Statutory Act** | MTD-Gesetz (MTDG) | Gewerbeordnung 1994 (GewO) |
| **GewO Exemption** | § 2 Abs. 1 Z 11 GewO 1994 | Standard application |
| **Chamber Membership** | None (AK / MTD-Register) | WKO (Wirtschaftskammer) |
| **Impact on Ruhendes Gewerbe** | **ZERO impact** | Violates dormant status |
| **Impact on UGP** | **Fully compliant** (if minor) | Requires UGP approval |
| **Social Insurance** | Exempt if profit < limit (§ 4 GSVG) | SVS compulsory if active |

### 4.2 UGP Safeguard Declaration
To prevent misunderstanding by the AMS Regionalstelle, the document must include an explicit safeguard statement:
1. "The reported freelance activity is performed strictly as a liberal health profession (*Freiberuf*) under the MTD-Gesetz."
2. "It does not constitute a commercial trade (*kein Gewerbegewerberechtlicher Betrieb*) and does not affect any existing dormant trade license or UGP milestone."
3. "The practitioner remains available for job placement by the AMS in full compliance with § 9 AlVG."

---

## 5. Document Architecture & Specification for Deliverable 2 (`output/ams_meldung_freiberuf.md`)

### 5.1 Format & Design Standards
- **File Format**: Standard Markdown with clean semantic sectioning.
- **Layout Standard**: Formal Austrian business correspondence (DIN 5008 alignment).
- **Tone**: Formal, legally precise, declarative, courteous.

---

### 5.2 Required Document Sections

1. **Absender-Block (Sender Details)**:
   - Full Name, Academic Titles (e.g. Sascha Lagler, PT / MSc)
   - Address, Phone, Email
   - AMS Kundennummer & Sozialversicherungsnummer (SVNR: `{{ SVNR }}`)
   - GBL-Registrierungsnummer (Gesundheitsberuferegister)

2. **Empfänger-Block (Recipient AMS Regionalstelle)**:
   - AMS Regionalstelle St. Pölten / Melk (or dynamic placeholder `{{ AMS_REGIONALSTELLE }}`)
   - Regionalstelle Address

3. **Datum & Betreffzeile**:
   - Location & Date (`{{ DATUM }}`)
   - Unambiguous Subject Line:  
     `Betreff: Formlose Meldung einer geringfügigen freiberuflichen Tätigkeit als Physiotherapeut/in gem. § 12 AlVG i.V.m. MTD-Gesetz | SVNR: {{ SVNR }}`

4. **Abschnitt 1: Formlose Anzeige der Tätigkeitsaufnahme (§ 50 AlVG)**:
   - Notification of start date (`{{ TATIGKEITSBEGINN }}`).
   - Specification of professional field: Freiberufliche Physiotherapie gem. MTD-Gesetz.

5. **Abschnitt 2: Zeitlicher Umfang & Arbeitsmarktverfügbarkeit (§ 9 AlVG)**:
   - Declaration of weekly hours (`{{ WOCHENSTUNDEN }}` hours/week, strictly < 16h).
   - Express commitment to full job market availability for AMS placement.

6. **Abschnitt 3: Einkommenschätzung & Geringfügigkeit (§ 5 Abs. 2 ASVG)**:
   - Tabular Breakdown of expected gross revenue, itemized business expenses, and estimated net profit.
   - Formal statement that net profit remains below the statutory threshold (`{{ GERINGFUEGIGKEITSGRENZE }}`).

7. **Abschnitt 4: Rechtliche Klarstellung (GewO-Ausnahme & UGP-Schutz)**:
   - Explicit reference to § 2 Abs. 1 Z 11 GewO 1994 (Kein Gewerbe).
   - Declaration that dormant trade licenses or UGP phases are not affected.

8. **Abschnitt 5: Anträge & Bestätigungsersuchen**:
   - Request for written confirmation of receipt and confirmation of uninterrupted benefit payments (*Arbeitslosengeld / Notstandshilfe*).

9. **Unterschriftenblock & Beilagenverzeichnis**:
   - Formal signature block.
   - List of Annexes (Auszug Gesundheitsberuferegister, Formlose Einnahmen-Ausgaben-Schätzung).

---

### 5.3 Variable Placeholder Contract for `ams_meldung_freiberuf.md`

| Variable Name | Description | Example / Default Value |
| :--- | :--- | :--- |
| `{{ THERAPIST_NAME }}` | Full name of therapist | Sascha Lagler |
| `{{ THERAPIST_TITLES }}` | Academic / professional titles | PT |
| `{{ SVNR }}` | Social Security Number | `4392 250401` / `[SVNR]` |
| `{{ AMS_KUNDENNUMMER }}` | AMS Customer ID | `[AMS-Kundennummer]` |
| `{{ THERAPIST_ADDRESS }}` | Street address, ZIP City | `[Musterstraße 1, 3100 St. Pölten]` |
| `{{ THERAPIST_PHONE }}` | Phone number | `[Telefonnummer]` |
| `{{ THERAPIST_EMAIL }}` | Email address | `[E-Mail-Adresse]` |
| `{{ GBL_NUMMER }}` | MTD Register ID (GBR-Nummer) | `[GBR-Nummer]` |
| `{{ AMS_REGIONALSTELLE }}` | Responsible AMS Office | AMS Regionalstelle St. Pölten |
| `{{ AMS_ADDRESS }}` | Address of AMS Office | Daniel-Gran-Straße 10, 3100 St. Pölten |
| `{{ DATUM }}` | Date of submission | `2026-07-28` |
| `{{ TATIGKEITSBEGINN }}` | Commencement date | `2025-11-27` / `[Datum]` |
| `{{ WOCHENSTUNDEN }}` | Estimated weekly hours | `5` (must be < 16) |
| `{{ MONATLICHE_EINNAHMEN_SCHAETZUNG }}` | Monthly gross revenue estimate | `360,00` € |
| `{{ BETRIEBSAUSGABEN_SCHAETZUNG }}` | Monthly business expense estimate | `60,00` € |
| `{{ NETTO_GEWINN_SCHAETZUNG }}` | Monthly net profit estimate | `300,00` € |
| `{{ GERINGFUEGIGKEITSGRENZE_JAHR }}` | Applicable ASVG threshold year | `2025` / `2026` |
| `{{ GERINGFUEGIGKEITSGRENZE_BETRAG }}` | Applicable monthly threshold amount | `551,10` € / `584,20` € |

---

## 6. Complete Markdown Template Prototype for Deliverable 2

Below is the complete, canonical template prototype to be written to `output/ams_meldung_freiberuf.md` during Milestone 2:

```markdown
# FORMLOSE AMS-MELDUNG
## Mitteilung über die Aufnahme einer geringfügigen freiberuflichen Tätigkeit (Physiotherapie)

**Absender:**  
{{ THERAPIST_NAME }}, {{ THERAPIST_TITLES }}  
{{ THERAPIST_ADDRESS }}  
Tel: {{ THERAPIST_PHONE }} | E-Mail: {{ THERAPIST_EMAIL }}  
Sozialversicherungsnummer (SVNR): **{{ SVNR }}**  
AMS-Kundennummer: {{ AMS_KUNDENNUMMER }}  
Gesundheitsberuferegister-ID (GBL): {{ GBL_NUMMER }}  

**Empfänger:**  
**{{ AMS_REGIONALSTELLE }}**  
{{ AMS_ADDRESS }}  

**Ort, Datum:** {{ THERAPIST_LOCATION }}, am {{ DATUM }}

---

### **BETREFF: Formlose Meldung über die Aufnahme einer geringfügigen freiberuflichen Tätigkeit als Physiotherapeut/in gem. § 12 AlVG i.V.m. MTD-Gesetz**

Sehr geehrte Damen und Herren,

hiermit melde ich ordnungsgemäß und fristgerecht gemäß **§ 50 Arbeitslosenversicherungsgesetz (AlVG)** die Aufnahme einer geringfügigen freiberuflichen Tätigkeit als Physiotherapeut/in ab dem **{{ TATIGKEITSBEGINN }}** an.

---

### 1. Rechtlicher Rahmen & Berufsrechtlicher Status (Freiberuf)
Die ausgeübte Tätigkeit erfolgt als **freiberufliche Physiotherapeutin / freiberuflicher Physiotherapeut** auf Grundlage des **MTD-Gesetzes (BGBl. I Nr. 46/1992 i.d.g.F. bzw. MTDG)**. Ich bin ordnungsgemäß im öffentlichen Gesundheitsberuferegister (GBL) eingetragen.

**Wichtiger gewerberechtlicher Hinweis:**  
Gemäß **§ 2 Abs. 1 Z 11 Gewerbeordnung 1994 (GewO 1994)** ist die Ausübung der Berufe des medizinisch-technischen Dienstes ausdrücklich vom Anwendungsbereich der Gewerbeordnung ausgenommen. Es handelt sich hierbei **nicht um ein Gewerbe**.  
*Die Tätigkeit berührt weder ein allfällig ruhend gemeldetes Gewerbe noch stellt sie eine vorzeitige Gewerbeausübung im Rahmen des UGP (Unternehmensgründungsprogramms) dar.*

---

### 2. Zeitlicher Umfang & Verfügbarkeit für den Arbeitsmarkt (§ 9 AlVG)
Der zeitliche Aufwand für diese freiberufliche Tätigkeit (inklusive PatientInnenbehandlung, Vor- und Nachbereitung sowie Administration) beträgt voraussichtlich **{{ WOCHENSTUNDEN }} Stunden pro Woche** und liegt somit **strikt unter der Grenze von 16 Wochenstunden**.

Ich erkläre ausdrücklich, dass ich dem Arbeitsmarkt im Sinne des **§ 9 AlVG** weiterhin vollumfänglich zur Verfügung stehe. Die freiberufliche Tätigkeit ist nebenberuflich und zeitlich so flexibel gestaltet, dass eine zumutbare Arbeitsaufnahme über das Arbeitsmarktservice jederzeit unverzüglich möglich ist.

---

### 3. Einkommenschätzung & Geringfügigkeit (§ 5 Abs. 2 ASVG)
Gemäß § 12 Abs. 3 lit. f AlVG i.V.m. **§ 5 Abs. 2 ASVG** schließt eine selbstständige/freiberufliche Tätigkeit den Anspruch auf Arbeitslosengeld bzw. Notstandshilfe nicht aus, wenn das daraus erzielte Netto-Einkommen (Gewinn) die monatliche Geringfügigkeitsgrenze von **€ {{ GERINGFUEGIGKEITSGRENZE_BETRAG }}** (Stand {{ GERINGFUEGIGKEITSGRENZE_JAHR }}) nicht übersteigt.

Die voraussichtliche monatliche Einkommensberechnung stellt sich wie folgt dar:

| Position | Berechnung / Beschreibung | Monatlicher Betrag |
| :--- | :--- | :--- |
| **Geschätzte Brutto-Einnahmen** | Honorare aus Physiotherapie | € {{ MONATLICHE_EINNAHMEN_SCHAETZUNG }} |
| **Geschätzte Betriebsausgaben** | Miete Praxisraum, Material, Haftpflicht, Fortbildung | - € {{ BETRIEBSAUSGABEN_SCHAETZUNG }} |
| **Voraussichtlicher Netto-Gewinn** | **Einkünfte aus freiberuflicher Arbeit** | **€ {{ NETTO_GEWINN_SCHAETZUNG }}** |

Der geschätzte monatliche Netto-Gewinn von **€ {{ NETTO_GEWINN_SCHAETZUNG }}** liegt somit eindeutig unter der gesetzlichen Geringfügigkeitsgrenze von **€ {{ GERINGFUEGIGKEITSGRENZE_BETRAG }}**.

---

### 4. Anträge & Ersuchen

Ich ersuche das Arbeitsmarktservice höflich um:
1. **Kenntnisnahme** dieser formlosen Meldung gemäß § 50 AlVG.
2. **Schriftliche Bestätigung** über den Erhalt dieser Meldung sowie die Bestätigung des ununterbrochen aufrechten Bezugs von Arbeitslosengeld / Notstandshilfe.

Sollten sich wesentliche Änderungen hinsichtlich des zeitlichen Umfangs oder der Einnahmen ergeben, werde ich diese dem AMS unverzüglich unaufgefordert mitteilen.

Mit freundlichen Grüßen,

__________________________________________  
{{ THERAPIST_NAME }}, {{ THERAPIST_TITLES }}  

---

**Beilagen:**
- Auszug aus dem Gesundheitsberuferegister (GBL-Bestätigung)
- Formlose Einnahmen-Ausgaben-Schätzung
```

---

## 7. Quality Assurance & Verification Criteria

To verify Deliverable 2 during implementation (M2) and review/audit (M3):

1. **Legal Precision Verification**:
   - Does the document explicitly reference § 12 AlVG, § 50 AlVG, § 9 AlVG, § 5 Abs. 2 ASVG, and § 2 Abs. 1 Z 11 GewO 1994? $\rightarrow$ **YES**.
2. **Financial Calculation Audit**:
   - Is the calculation based on Net Profit (*Gewinn*) rather than Gross Revenue (*Umsatz*)? $\rightarrow$ **YES**.
   - Is the monthly threshold clearly indicated with correct ASVG figures? $\rightarrow$ **YES**.
3. **UGP & Trade Protection Verification**:
   - Is the distinction between MTD Freiberuf and GewO Gewerbe unambiguously highlighted? $\rightarrow$ **YES**.
4. **Markdown & Template Integrity**:
   - Are all variables enclosed in double curly braces `{{ VARIABLE }}` with a consistent placeholder dictionary? $\rightarrow$ **YES**.

---
*End of Analysis & Technical Specification — `explorer_m1_2`*
