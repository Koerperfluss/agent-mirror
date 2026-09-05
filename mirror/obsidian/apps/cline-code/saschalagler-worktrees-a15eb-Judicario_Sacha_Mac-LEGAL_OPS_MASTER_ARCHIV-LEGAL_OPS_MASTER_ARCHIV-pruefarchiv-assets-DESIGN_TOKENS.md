---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/pruefarchiv/assets/DESIGN_TOKENS.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# DESIGN TOKENS — Legal Ops Advisor Prüfarchiv (Brand)

## Farben (Brand "Trust & Authority")
- PRIMARY / Profi-Blau:  #2563EB
- ACCENT / Deal-Grün:    #059669
- INK (Text dunkel):     #0F172A
- SLATE (Text sekundär): #475569
- BG-LIGHT:              #FFFFFF
- BG-PANEL:              #F8FAFC
- BG-DARK:               #0B1220
- LINE/Border:           #E2E8F0
- WARN (⚠️):              #B45309
- OK (✅):                #059669
- FAIL (❌):              #DC2626
- CLAIM (🔶 behauptet):   #7C3AED

## Typografie
- Headline: "EB Garamond", Georgia, serif
- Body/UI:  "Lato", "Helvetica Neue", Arial, sans-serif
- Mono (Code/Commands): "SF Mono", Menlo, monospace
- (Hinweis: Scheinecker-Original-PDF nutzt Arial; wir nutzen Arial-Fallback für Print-Treue)

## Layout (an Scheinecker v1.4 angelehnt, A4, Word-Look)
- A4, Seitenrand ~2.2cm, Kopfzeile: "LEGAL OPS ADVISOR Prüfarchiv | <Datum>" + Logo rechts
- Fußzeile: Seitenzahl + "Prüfer: <Name> | Vertraulich"
- Kapitel-Nummerierung wie Original (1., 1.1, Anhang A/B)
- Status-Badges: ✅ verifiziert · ⚠️ teilweise · ❌ widerlegt · 🔶 behauptet
- Bewertungstabellen mit farbiger Status-Spalte (OK/WARN/FAIL/CLAIM)
- Logo-Dateien: assets/legal-ops-logo.png, assets/polymath-core.png

## Druck/PDF
- HTML mit @page A4; print-CSS; separater "Drucken/PDF"-Hinweis im Kopf
