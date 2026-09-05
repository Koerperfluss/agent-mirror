# Project Plan: Katharina Wlzek Honorarnote & Legal Ops Workflow

## Architecture & Goal
Produce three legal, ÖGK-compliant, and AMS-compliant Markdown/HTML deliverables in `/Users/saschalagler/LegalOpsAdvisor_Sacha_Mac/legal-ops-advisor/output/`:
1. `honorarnote_wlzek.md` — ÖGK-konforme Honorarnote (Markdown & HTML layout embedded) including all § 131 ASVG mandatory fields, MTD-Gesetz statutory notice, diagnosis details, provider details, and 10 individual treatment session dates (45 min each) table for signing.
2. `ams_meldung_freiberuf.md` — Formlose AMS-Meldungsvorlage for freelance physiotherapy activity under Geringfügigkeitsgrenze without compromising UGP status or active/inactive trade license status.
3. `oegk_einreichungsleitfaden.md` — Patientinnen-Leitfaden for ÖGK submission step-by-step instructions specifically customized for Katharina Wlzek.

## Milestones
| # | Milestone Name | Scope | Dependencies | Status |
|---|----------------|-------|--------------|--------|
| M1 | Exploration & Technical Specification | Detailed legal & format requirements analysis (ASVG § 131, MTD-Gesetz, UStG § 6 Abs. 1 Z 19, AMS Geringfügigkeit) | None | DONE |
| M2 | Document Implementation | Generation of `honorarnote_wlzek.md`, `ams_meldung_freiberuf.md`, `oegk_einreichungsleitfaden.md` in `output/` | M1 | DONE |
| M3 | Verification & Forensic Audit Gating | Independent review (Reviewers), empirical validation (Challengers), and integrity audit (Forensic Auditor) | M2 | IN_PROGRESS |

## Key Specifications & Data Inputs
- **Patient**: Katharina Wlzek, SVNR: 4392 250401, Hippolytgasse 3/10, 3240 Mank
- **Prescribing Physician**: GP Mank, Dr. Höfinger u. Dr. Kleinberger (Datum: 05.11.2025)
- **Prescription**: 10x EHG à 45 min. (Einzeleinheits-Heilgymnastik)
- **Prescription Diagnosis**: Streckhaltung HWS u Blockwirbel C3 C4, Skoliose BWS, Spannungskopfschmerz
- **Therapy Findings Diagnosis**: Zervikogene Migräne mit Tinnitus (Behandlungsbeginn: 27.11.2025)
- **Therapist**: Sascha Lagler (Freiberuflicher Physiotherapeut / MTD-Gesetz, GBR-Nummer, Anschrift, Kontaktdaten)

## Acceptance Criteria
- [x] Milestone 1 Exploration completed by 3 Explorers.
- [x] Milestone 2 Deliverables generated in `output/` by Worker.
- [ ] Deliverable 1 (`output/honorarnote_wlzek.md`): MD & HTML format, § 131 ASVG compliance, § 6 Abs 1 Z 19 UStG exemption notice, statutory MTD-Gesetz notice (freiberufliche Ausübung), 10 session dates table with signatures verified.
- [ ] Deliverable 2 (`output/ams_meldung_freiberuf.md`): Formlose AMS Meldung, UGP compliance, Geringfügigkeitsgrenze protection verified.
- [ ] Deliverable 3 (`output/oegk_einreichungsleitfaden.md`): Patient guidance for ÖGK submission, required documents checklist, approval info verified.
- [ ] Reviewers approval & Forensic Auditor CLEAN verdict.
