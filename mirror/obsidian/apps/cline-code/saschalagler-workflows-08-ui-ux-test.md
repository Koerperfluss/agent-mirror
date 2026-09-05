---
app: cline-code
quelle: "saschalagler/workflows/08-ui-ux-test.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Workflow 08: UI-UX-TEST — VOLLPROTOKOLL (erschöpfender Oberflächentest)

Lies und folge EXAKT dem Skill `ui-ux-tester` (~/.agents/skills/ui-ux-tester/SKILL.md) — alle 4 Phasen, alle Checklisten, keine Auslassungen. Trigger: „teste die UI/UX von X" oder /08.

**Phase 1 BEWERTUNG:** Server/App starten (Befehl aus Projektdoku) → Doku lesen → Feature-Liste N + je 2 Edge-Cases → 3 Personas (Neuling/Power-User/Frustrierter) → Baseline-Screenshots → Checkpoint zeigen, dann sofort weiter.

**Phase 2 INTERAKTION (alle 8 Muster je Feature:** Full-Coverage · Objektive Validierung · Gnadenloses Klicken · Szenario E2E · Edge-Pushing · Visuelle Prüfung · State-Tracking · Repro-Verifizierung): Web → chrome-devtools-MCP (navigate/snapshot/click/fill_form/evaluate/press_key/take_screenshot/list_console_messages/list_network_requests/resize 375-768-1440) · Desktop → computer-use (nur ZCode) · Missbrauch-Pflicht: leere/Falscheingaben, Sonderzeichen, Doppel-Submit, Refresh + Zurück mid-Flow. UX-Defect-Kategorien mitschreiben (Sackgassen, Labels, Feedback, Loops, Desync, Recovery).

**Phase 3 VISUAL-AUDIT (alle 11 Punkte je Screenshot):** Alignment · Leerraum ZU VIEL+ZU WENIG · Padding/Rand · Kontrast · Responsive · Typo · Overflow · Hover · Farb-Deviations · Empty-States · Error-States. Vision-MCP: ui_diff_check/image_analysis; Beweise nach `<projekt>/ui-test-evidence/NN-*.png`.

**Phase 4 BERICHT `UI_TEST_REPORT.md`:** Kennzahlen (N/M, Interaktionen, D mit P0–P3-Count, Konsolen-/Netz-Errors) · Defect-Tabelle (#·Schwere·Flow·Beschreibung·Repro·Beweis-Pfad·Fix) · Wirkungsanalyse je P0/P1 · Positive Befunde · Top-3-Fix-Reihenfolge · Liefer-Satz wörtlich ausgeben.

Modelle: Flows glm-first · Bericht glm-plan. **IMMER 2 PARALLEL-SUBAGENTEN (Standard, auch bei kleinen Apps):** Subagent A = Interaktions-Flows (Phase 2), Subagent B = Visual-Audit (Phase 3, über As Screenshots), Hauptagent = Phase 1 + zentraler Bericht. P0/P1 nicht selbst fixen (Bericht + auf Zuruf/glm-build). Desktop nur ZCode. Kein Daten-Write ohne Stopp-Regel-Prüfung.