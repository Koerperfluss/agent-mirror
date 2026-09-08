---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-pruefinstanz-pflicht.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: feedback-pruefinstanz-pflicht
description: Sascha fordert in jedem Build-/Konsolidierungsplan eine explizite,
  unabhängige Prüfinstanz mit Vetorecht — "Wer gebaut hat, prüft nicht"
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_ecb2e5e0-e1f7-46fb-a5b9-a997d5485c8e
---

Sascha hat es 2× scharf eingefordert (07.09. „hast du prüfinstanz die logik den sinn analysieren lassen", 08.09. „wo ist die prüfinstanz? du redest nur scheisse"): Jeder mehrstufige Plan braucht eine explizite PRÜFINSTANZ als eigene Rolle — bloßes „@reviewer vor jedem Commit" reicht ihm nicht.

**Why:** Er will eine Kontroll-Ebene, die unabhängig vom Bau-Team validiert und ihm direkt berichtet — strukturelle Trennung statt Absichtserklärungen. Beweis des Nutzens: 08.09. zerriss der Reviewer-Agent den Atlas-Konsolidierungsplan v1 an 4 Punkten (Meta-Verschmelzung = Verlustrisiko, 7 tote Verweise, falsche Grill-These) — die Prüfinstanz VOR Ausführung verhinderte Fehlarbeit.

**How to apply:** In Master-Prompts/Plänen eine eigene „PRÜFINSTANZ"-Sektion: (1) unabhängig vom Implementierer („Wer gebaut hat, prüft nicht"), (2) prüft nach JEDER Stufe gegen DONE-WHEN-Kriterien, (3) PASS/FAIL mit Befund-Tabelle (Ort | Problem | Fix) + Vetorecht (FAIL = Stufe zurück, kein Weiterarbeiten bis PASS), (4) berichtet nur dem Nutzer, nicht dem Bau-Team, (5) in ZCode konkret: @reviewer (Code/Standards/Regressionen) + ui-ux-tester (visuell) + Performance-Check (Lighthouse/60 fps). Auch bei Analysen: Ergebnisse erst gegenprüfen lassen, dann ausführen. [[feedback-aufbau-vor-deploy]] [[loki-dev-gate-enforcement]] [[atlas-stand-2026-09-08]]
