---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/.agents/explorer_m1_3/analysis_oegk.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Technical Analysis & Specification: ÖGK Patientinnen-Einreichungsleitfaden
**Deliverable**: `output/oegk_einreichungsleitfaden.md`  
**Milestone**: M1 (Exploration & Specification)  
**Author**: Explorer 3 (Milestone 1)  
**Date**: 2026-07-28  

---

## 1. Executive Summary & Objective

This specification details the structure, legal requirements, procedural workflows, and exact content requirements for **Deliverable 3: Patientinnen-Leitfaden für ÖGK-Einreichung** (`output/oegk_einreichungsleitfaden.md`).

The guide is specifically tailored for patient **Katharina Wlzek** following her 10-session physiotherapy treatment (Einzeleinheits-Heilgymnastik à 45 Min.) provided by Wahlphysiotherapeut **Sascha Lagler** (freiberuflicher Physiotherapeut gem. MTD-Gesetz). The primary goal of the document is to provide a foolproof, step-by-step instruction for Katharina Wlzek to achieve the maximum statutory reimbursement from the Austrian Health Insurance Fund (**ÖGK - Österreichische Gesundheitskasse**) and smoothly claim any residual costs from a private supplementary health insurance (*Zusatzversicherung*).

---

## 2. Baseline Data & Patient Profile

| Parameter | Specification / Exact Data |
|---|---|
| **Patientin** | Katharina Wlzek |
| **SVNR / Geburtsdatum** | 4392 250401 |
| **Wohnanschrift** | Hippolytgasse 3/10, 3240 Mank |
| **Verordnender Arzt** | GP Mank (Dr. Höfinger u. Dr. Kleinberger) |
| **Verordnungsdatum** | 05.11.2025 |
| **Verordnete Leistung** | 10x EHG à 45 min. (Einzeleinheits-Heilgymnastik) |
| **Pos. Nr. (ÖGK Tarif)** | Pos. Nr. 505.2 (Einzeleinheits-Heilgymnastik 45 Minuten) |
| **Verordnungsdiagnose** | Streckhaltung HWS u Blockwirbel C3 C4, Skoliose BWS, Spannungskopfschmerz |
| **Befund- / Therapie-Diagnose** | Zervikogene Migräne mit Tinnitus |
| **Behandlungsbeginn** | 27.11.2025 |
| **Therapeut** | Sascha Lagler (Freiberuflicher Physiotherapeut gem. MTD-Gesetz) |
| **Rechtsstatus Therapeut** | Wahltherapeut (kein ÖGK-Kassenvertrag, Abrechnung auf Wahlarzt-/Wahltherapeutenbasis gem. § 131 ASVG) |
| **USt-Status** | Umsatzsteuerfrei gemäß § 6 Abs. 1 Z 19 UStG |

---

## 3. Comprehensive Analysis of Core Requirements

### 3.1 Component 1: Step-by-Step ÖGK Reimbursement Workflow

The reimbursement process follows a strict 6-phase lifecycle:

1. **Phase 1: Ärztliche Verordnung (Medical Referral)**
   - Issued on **05.11.2025** by General Practitioners Dr. Höfinger & Dr. Kleinberger in Mank.
   - Contains explicit prescription for 10x EHG à 45 min and initial medical diagnoses.

2. **Phase 2: Chefärztliche Bewilligung (Medical Director Approval)**
   - **Legal Context**: For Wahlphysiotherapie in ÖGK Niederösterreich, medical referrals require chefärztliche Bewilligung (approval by the ÖGK chief medical officer) to guarantee cost reimbursement.
   - **Requirement**: Patient must ensure the referral bears the official ÖGK approval stamp/digital sign-off (either obtained prior to treatment or retroactively approved before submission).

3. **Phase 3: Durchführung & Protokollierung (Therapy Sessions & Attendance Log)**
   - 10 treatment sessions executed by Sascha Lagler starting **27.11.2025**.
   - After each session, the exact date, duration (45 min), and therapeutic service are logged in the attendance table (*Behandlungs-/Anwesenheitsnachweis*) and confirmed via signatures of patient and therapist.

4. **Phase 4: Rechnungsstellung & Bezahlung (Billing & Payment Confirmation)**
   - Therapist issues saldierte Honorarnote fulfilling all § 131 ASVG mandatory fields and statutory notices (§ 6 Abs. 1 Z 19 UStG, MTD-Gesetz).
   - Patient pays the full fee (e.g., via bank transfer) and retains proof of payment (*Kontoauszug / Zahlungsbestätigung*).

5. **Phase 5: Einreichung bei der ÖGK (Submission to Health Insurance)**
   - Patient gathers all 4 mandatory documents (see Checklist 3.2).
   - Patient selects preferred submission channel (ID-Austria online portal, postal mail, or physical drop-off).

6. **Phase 6: Bearbeitung, Auszahlung & Zusatzversicherung (Processing, Payout & Supplementary Claim)**
   - ÖGK reviews documentation and disburses statutory refund (80% of contract tariff) directly to patient's IBAN.
   - Patient receives ÖGK *Leistungsnachweis* (statement of reimbursement) and submits residual costs to private supplementary insurance.

---

### 3.2 Component 2: Mandatory Document Checklist (*Checkliste Pflichtunterlagen*)

To prevent rejection or delays by ÖGK, all four required documents must meet strict compliance criteria:

```
[ ] 1. Chefarztlich bewilligte ärztliche Verordnung (Verordnungsschein)
    - Aussteller: GP Mank (Dr. Höfinger u. Dr. Kleinberger)
    - Ausstellungsdatum: 05.11.2025
    - Verordnungstext: 10x EHG à 45 min.
    - Bewilligungsvermerk: Stempel / Freigabe des Chefärztlichen Dienstes der ÖGK NÖ.

[ ] 2. Saldierte Original-Honorarnote des Physiotherapeuten
    - Aussteller: Sascha Lagler (Freiberuflicher Physiotherapeut, GBR-Nummer)
    - Patientin: Katharina Wlzek, SVNR: 4392 250401, Hippolytgasse 3/10, 3240 Mank
    - Diagnose: Zervikogene Migräne mit Tinnitus
    - Pflichtangaben: Rechnungsnummer, Rechnungsdatum, Leistungsaufstellung (10x EHG 45 min)
    - Gesetzliche Hinweise: § 6 Abs. 1 Z 19 UStG (USt-befreit), freiberufliche Ausübung gem. MTD-Gesetz
    - Saldierung: Formularvermerk "Betrag dankend erhalten" / "Saldiert" mit Datum & Unterschrift Therapeuten.

[ ] 3. Behandlungs- / Anwesenheitsnachweis (Therapie-Tabelle)
    - Tabelle über 10 Einzeltermine (Datum, Uhrzeit/Dauer 45 Min, Leistung Pos. 505.2)
    - Einzelunterschriften der Patientin Katharina Wlzek je Termin
    - Paraphe / Stempel des Therapeuten Sascha Lagler je Termin.

[ ] 4. Zahlungsbeleg / Kontoauszug
    - Detaillierter Banküberweisungsbeleg oder Kontoauszug der Patientin
    - Stellt den eindeutigen Abfluss des Rechnungsbetrages an Sascha Lagler dar
    - Enthält Absender-IBAN, Empfänger-IBAN, Betrag, Valutadatum & Rechnungsnummer im Verwendungszweck.
```

---

### 3.3 Component 3: Submission Channels (*Einreichwege bei der ÖGK*)

The guide must present three concrete submission options for Katharina Wlzek:

#### Option A: Online Submission via MeineSV / ID-Austria (Recommended)
- **Portal**: [www.meinesv.at](https://www.meinesv.at) or ÖGK Web Portal / *MeineÖGK App*.
- **Authentication**: Login with **ID-Austria** (Handysignatur).
- **Navigation**: `Kostenerstattung beantragen` → `Wahltherapeut / Physiotherapie`.
- **Upload format**: Scans/PDFs/High-res photographs of all 4 mandatory documents.
- **IBAN Verification**: Confirm payout bank account (IBAN of Katharina Wlzek).
- **Processing Time**: **10 to 21 business days** (2–3 weeks). Highest processing speed & real-time tracking.

#### Option B: Postal Mail Submission (*Postweg*)
- **Mailing Address**:  
  Österreichische Gesundheitskasse (ÖGK)  
  Landesstelle Niederösterreich  
  Kundenservicestelle Mank / Melk / St. Pölten  
  *(e.g., ÖGK Landesstelle NÖ, Krumpöckstraße 20, 3100 St. Pölten)*
- **Requirements**: Send high-quality copies or originals with a brief covering letter including SVNR 4392 250401, contact info, and IBAN for refund.
- **Processing Time**: **3 to 6 weeks**. (Advise patient to retain copies of all documents).

#### Option C: In-Person Drop-off (*Persönliche Abgabe*)
- **Nearest ÖGK Customer Service Offices**:
  - **ÖGK Servicestelle Melk**: Dorfnerstraße 36, 3390 Melk
  - **ÖGK Servicestelle St. Pölten**: Krumpöckstraße 20, 3100 St. Pölten
  - *(or regional ÖGK Sprechtag in Mank)*
- **Procedure**: Direct submission at service counter or via official drop-box (*Posteinwurfkasten*). Immediate check of document completeness by staff available.

---

### 3.4 Component 4: Tariff Refund Calculation, Timeline & Supplementary Insurance

#### 1. Statutory Tariff Calculation (§ 131 ASVG)
- **Legal Principle**: Under Austrian social security law (§ 131 ASVG), patients receiving treatment from non-contracted *Wahltherapeuten* (private therapists) receive a statutory refund equal to **80% of the ÖGK contract rate** (*Kassentarif*) for the specific item code.
- **Position Code**: **Pos. Nr. 505.2** — *Einzeleinheits-Heilgymnastik 45 Minuten* (EHG 45 Min).
- **Tariff Breakdown (ÖGK NÖ 2025/2026 Reference Rates)**:
  - ÖGK Contract Rate (*Kassentarif* 100%): approx. **€ 48.00 – € 52.00** per 45 min session.
  - Statutory Refund (80% of Kassentarif): approx. **€ 38.40 – € 41.60** per 45 min session.
  - Total ÖGK Reimbursement for 10 sessions: approx. **€ 384.00 – € 416.00**.

- **Sample Financial Calculation**:
  ```
  Honorarnote Wahltherapeut (10x EHG 45 min à € 80,00):  € 800,00
  ./. ÖGK-Kostenerstattung (10x 80% Kassentarif à € 40,00): € 400,00
  ==================================================================
  Verbleibender Selbstbehalt / Eigenanteil Patientin:     € 400,00
  ```

#### 2. Timeline & Payout Process
- **Online (ID-Austria)**: 2 to 3 weeks.
- **Post / Desk Drop-off**: 3 to 6 weeks.
- Payout is wired directly to Katharina Wlzek's designated IBAN, accompanied by an official ÖGK statement (*Leistungsnachweis / Abrechnungsblatt*).

#### 3. Submitting Residual Costs to Private Supplementary Insurance (*Zusatzversicherung*)
- **Eligibility**: Outpatient medical expenses insurance (*Ambulante Privatkrankenversicherung / Heilbehelfstarif*) through providers such as Uniqa, Generali, Wiener Städtische, Allianz, Merkur.
- **Step-by-Step Procedure for Residual Cost Payout**:
  1. Wait for completion of ÖGK reimbursement.
  2. Obtain the official **ÖGK Leistungsnachweis / Abrechnungsbeleg** showing the exact amount reimbursed by public health insurance.
  3. Submit to private insurer:
     - Copy of Saldierte Honorarnote Sascha Lagler
     - Copy of Ärztliche Verordnung
     - **Original ÖGK Leistungsnachweis**
  4. The private insurance reimburses up to 100% of the remaining deductible (€ 400.00 in example), resulting in **zero out-of-pocket costs** for Katharina Wlzek (subject to individual policy limits).

---

## 4. Required Document Structure for `output/oegk_einreichungsleitfaden.md`

When `implementer_m2_3` builds `output/oegk_einreichungsleitfaden.md`, the output file must follow this exact section structure:

```markdown
# Patientinnen-Leitfaden: ÖGK-Rückerstattung Physiotherapie
**Patientin**: Katharina Wlzek | **SVNR**: 4392 250401
**Therapeut**: Sascha Lagler (Freiberuflicher Physiotherapeut)

---

## 1. Übersicht & Zielsetzung
[Kurze Erklärung der Kassen-Rückerstattung für Wahlphysiotherapie]

## 2. Der 6-Schritte-Einreichprozess für Katharina Wlzek
[Detaillierter Ablauf von Ärztlicher Verordnung bis Geldeingang]

## 3. Vollständigkeits-Checkliste der Einreichunterlagen
[Tabelle & Checkboxen mit allen 4 Pflichtdokumenten & Prüfkriterien]

## 4. Einreichwege & Schritt-für-Schritt-Anleitung
### Option A: Online via MeineSV / ID-Austria (Empfohlen)
### Option B: Postalische Einreichung
### Option C: Persönliche Abgabe vor Ort

## 5. Tarif-Berechnung & Rückerstattungshöhe (Pos. Nr. 505.2)
[Kassentarif, 80%-Regel, Rechenbeispiel Selbstbehalt]

## 6. Restkosten-Einreichung bei der privaten Zusatzversicherung
[Schritt-für-Schritt Anleitung zur Einreichung des Differenzbetrags]

## 7. Wichtige Kontakte & Fristen
[ÖGK Kundenservicestellen Mank/Melk/St. Pölten, Verjährungsfrist 3 Jahre]
```

---

## 5. Verification & Acceptance Criteria for Deliverable 3

To pass Milestone M3 auditing, Deliverable 3 must satisfy:
1. **Patient Data Accuracy**: SVNR 4392 250401, address Hippolytgasse 3/10, 3240 Mank, referral date 05.11.2025, GP Mank (Dr. Höfinger & Dr. Kleinberger).
2. **Legal & Regulatory Correctness**: Accurate citation of § 131 ASVG (80% contract rate refund), MTD-Gesetz, and UStG § 6 Abs. 1 Z 19 context.
3. **Completeness**: All 4 mandatory documents explicitly specified with required fields.
4. **Tariff Code Specificity**: Pos. Nr. 505.2 (EHG 45 min) included with clear sample math for total invoice vs. ÖGK refund vs. residual private insurance claim.
5. **Actionability**: Clear ID-Austria portal clicks and ÖGK Niederösterreich contact details.

---
*End of Analysis & Technical Specification for Deliverable 3.*
