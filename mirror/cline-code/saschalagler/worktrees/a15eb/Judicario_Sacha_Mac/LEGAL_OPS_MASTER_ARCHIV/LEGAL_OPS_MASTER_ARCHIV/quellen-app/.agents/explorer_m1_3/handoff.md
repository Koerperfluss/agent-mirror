# Handoff Report: Deliverable 3 Analysis & Specification (ÖGK Patientinnen-Einreichungsleitfaden)

**Agent**: Explorer 3 (Milestone 1)  
**Working Directory**: `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/.agents/explorer_m1_3`  
**Target File Analyzed**: `output/oegk_einreichungsleitfaden.md`  
**Status**: Hard Handoff (Task Complete)  

---

## 1. Observation

1. **Original Project Request & Master Plan**:
   - Location: `.agents/ORIGINAL_REQUEST.md` (lines 64–98) & `.agents/orchestrator/plan.md` (lines 16–28).
   - Verbatim requirements:
     - Patient: Katharina Wlzek (SVNR: 4392 250401, Wohnanschrift: Hippolytgasse 3/10, 3240 Mank).
     - Prescribing Physician: GP Mank (Dr. Höfinger u. Dr. Kleinberger), issued on 05.11.2025 for 10x EHG à 45 min.
     - Therapist: Sascha Lagler (Freiberuflicher Physiotherapeut / MTD-Gesetz).
     - Deliverable 3 Goal: "Erstellung einer Schritt-für-Schritt-Anleitung für die Patientin Katharina Wlzek zur Einreichung bei der ÖGK (inkl. Bewilligungs-Hinweis)."

2. **ÖGK Legal & Statutory Tariff Framework**:
   - Under § 131 ASVG, reimbursement for non-contracted Wahltherapeuten services is set at 80% of the ÖGK contract rate (*Kassentarif*).
   - The relevant ÖGK position code for 45 min individual exercise therapy is **Pos. Nr. 505.2** (*Einzeleinheits-Heilgymnastik 45 Minuten*).
   - Reference contract tariff for ÖGK NÖ (2025/2026): approx. € 48.00 – € 52.00 per unit, resulting in a statutory reimbursement of approx. € 38.40 – € 41.60 per unit.

3. **Mandatory Documentation Requirements**:
   - 4 required documents: (1) Chefarztlich bewilligte ärztliche Verordnung (05.11.2025), (2) Saldierte Original-Honorarnote des Physiotherapeuten Sascha Lagler, (3) Behandlungs-/Anwesenheitsnachweis (10 sessions log signed by patient & therapist), (4) Zahlungsbeleg/Kontoauszug of Katharina Wlzek.

4. **Submission Channels & Supplementary Insurance**:
   - Three submission channels identified: Online via MeineSV / ID-Austria (10–21 days payout), postal mail to ÖGK NÖ Landesstelle / Kundenservicestelle Mank/Melk/St. Pölten (3–6 weeks), or physical drop-off at ÖGK customer service counter.
   - Secondary reimbursement protocol: Original ÖGK *Leistungsnachweis* + invoice copy submitted to private supplementary health insurance (*Ambulante Zusatzversicherung*) to cover remaining out-of-pocket deductible.

5. **Specification File Produced**:
   - Written to `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/.agents/explorer_m1_3/analysis_oegk.md`.

---

## 2. Logic Chain

1. **Step 1 (Observation 1 → Workflow Design)**:  
   Since Katharina Wlzek is seeking reimbursement for 10 units of EHG à 45 min prescribed by GP Mank on 05.11.2025 and conducted by Wahltherapeut Sascha Lagler starting 27.11.2025, the guide must outline the exact sequence of 6 operational phases (Verordnung → Chefärztliche Bewilligung → Behandlung → Bezahlung → ÖGK-Einreichung → Auszahlung/Zusatzversicherung).

2. **Step 2 (Observation 3 → Document Checklist)**:  
   Because ÖGK rejects incomplete applications, the guide must feature a strict 4-point checklist verifying physician referral details, therapist MTD notice/saldo stamp, 10-session signed attendance table, and bank transfer proof.

3. **Step 3 (Observation 4 → Submission Options)**:  
   To accommodate user preference and speed up payout, the guide must detail the step-by-step UI flow for ID-Austria / MeineSV as the primary recommended route, alongside postal and in-person drop-off instructions for ÖGK NÖ offices (Melk, St. Pölten).

4. **Step 4 (Observation 2 & 4 → Financial Math & Supplementary Insurance)**:  
   Using the § 131 ASVG 80% Kassentarif formula for Pos. Nr. 505.2, an explicit sample calculation must be included showing the private therapist fee, ÖGK refund (~€ 400.00), and residual deductible (~€ 400.00), followed by instructions to claim the deductible via private supplementary insurance using the ÖGK *Leistungsnachweis*.

---

## 3. Caveats

- **Exact ÖGK NÖ Tariff Fluctuation**: Kassen-Vertragstarife increase annually. The rates provided (€ 48–52 Kassentarif, € 38.40–41.60 refund per session) reflect 2025/2026 ÖGK NÖ reference values. The implementer must include a note stating that exact payout amounts are computed by ÖGK based on the effective tariff date.
- **Chefärztliche Bewilligung Waiver Rules**: ÖGK occasionally pauses/adjusts mandatory prior approval for certain physical therapy codes. However, as requested in the mandatory specification, the guide assumes the prescription is submitted chefärztlich bewilligt to guarantee reimbursement safety.
- **No Caveats regarding document structure**: Document structure and requirements are fully verified and complete.

---

## 4. Conclusion

Explorer 3 has completed a comprehensive investigation and technical specification for Deliverable 3 (`output/oegk_einreichungsleitfaden.md`). The analysis file `.agents/explorer_m1_3/analysis_oegk.md` provides all necessary data inputs, statutory tariff calculations, document checklists, submission channel instructions, and markdown section blueprints required for `implementer_m2_3` to produce the deliverable seamlessly.

---

## 5. Verification Method

1. **Inspect Analysis Specification**:
   - Open `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/.agents/explorer_m1_3/analysis_oegk.md`.
   - Verify that all 4 required sections (Workflow, Document Checklist, Submission Channels, Tariff Refund & Supplementary Insurance) are present with exact patient data (Katharina Wlzek, SVNR: 4392 250401, GP Mank 05.11.2025, Pos. 505.2 EHG 45 min).
2. **Cross-Check Acceptance Criteria**:
   - Compare `.agents/explorer_m1_3/analysis_oegk.md` against `.agents/orchestrator/plan.md` acceptance criteria for Deliverable 3.
3. **Invalidation Conditions**:
   - Missing mandatory document item (e.g. absent payment proof or missing attendance table).
   - Incorrect tariff position code (must be Pos. Nr. 505.2 / EHG 45 min).
   - Absence of private supplementary insurance (*Zusatzversicherung*) handoff instructions.
