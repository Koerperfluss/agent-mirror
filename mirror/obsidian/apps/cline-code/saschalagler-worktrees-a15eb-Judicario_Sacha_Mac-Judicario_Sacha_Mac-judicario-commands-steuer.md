---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Judicario_Sacha_Mac/judicario/commands/steuer.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

---
description: Steuerrecht AT/DE: Urteile, Richtlinien, exakte Berechnung
---

Bearbeite die steuerrechtliche Frage (jurisdiction AT oder DE angeben).
- `judicario_steuer_rechtsprechung` (VwGH/BFG bzw. BFH/FG) + `judicario_steuer_richtlinie`
  (EStR/KStR bzw. EStH/UStAE/AEAO) + `judicario_steuer_norm` für Rz+Judikatur zu einem §.
- Rechnen IMMER deterministisch: `judicario_steuer_berechnung` (Tarife) bzw.
  `judicario_steuer_engine` (DE-Spezialfälle: GewSt-Hinzurechnung, AfA, §25a, Fristen …).
