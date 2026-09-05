---
name: plan-mode-falle
description: Sascha aktiviert Plan-Mode und vergisst ihn — Agent blockt auf read-only, Sascha wütet "warum machst du nicht" — sofort ExitPlanMode mit MINIMAL-Plan (3 Zeilen, keine Optionen) oder ihn bitten Plan-Mode-Toggle auszuschalten
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

**Sascha aktiviert Plan-Mode (Toggle in ZCode) und vergisst ihn.** Wenn er dann "mach endlich" sagt, blockt das System alle Edit-/Bash-Tools. Der Agent produziert Pläne, Sascha lehnt sie ab ("NEIN ANDERES"), der Agent fragt nach, Eskalation.

**Warum es passiert:** Sascha nutzt Plan-Mode als "denk erst mal"-Toggle, nicht als Genehmigungs-Workflow. Er erwartet, dass der Agent danach selbstständig ausführt.

**Fix:** 1) Erkenne Plan-Mode schnell (Bash wird mit "Plan mode only allows read-only" blockiert). 2) ExitPlanMode mit MINIMAL-Plan (3 Zeilen: Was ich tue · Was ich brauche · Ergebnis) — KEINE mehrseitigen Pläne, keine Optionen, keine Fragen. 3) Wenn wieder abgelehnt: Ihm sagen "Plan-Mode ist an — bitte ausschalten oder Approve klicken". NICHT weiterplanen.

**Verwandt:** [[sascha-was-signal]] (gleiche Eskalation bei Überkomplexität) · [[sascha-wut-fehlerpaste]] (Wut = direkt handeln)
