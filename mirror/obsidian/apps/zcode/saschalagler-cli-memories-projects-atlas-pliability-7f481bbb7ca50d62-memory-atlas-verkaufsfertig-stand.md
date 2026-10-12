---
app: zcode
quelle: "saschalagler/cli/memories/projects/atlas-pliability-7f481bbb7ca50d62/memory/atlas-verkaufsfertig-stand.md"
stand: 2026-10-12
tags: [spiegel, zcode]
---

---
name: atlas-verkaufsfertig-stand
description: ATLAS-Verkaufsstand 12.10.2026 — Cline starb mit +378/−37
  unkommittiert; Test-Batterie + Voll-Testprotokoll liegen in ATLAS_MASTER/app;
  Schritt 0 = git-Rettung
metadata:
  node_type: memory
  type: project
  originSessionId: sess_a348175d-0af0-40df-bd42-9b7f174f5aa0
---

Stand der ATLAS-Verkaufsfertig-Machung (12.10.2026, Session-Ende):

- **Kritisch:** Die abgestürzte Cline-Session („ATLAS - Cali App", 240M Tokens, `Hub connection closed code=1006`) hinterließ **+378/−37 unkommittete Änderungen** im Repo `ATLAS_MASTER/app` (Git-HEAD `4f8a459`). Vermutlich Android-Fix #28 + Video-Upload + BarBulls-Logo. **Jede Weiterarbeit beginnt mit Schritt 0: `git status` + WIP-Commit sichern.**
- Erstellt in der Session (bewiesen per Pfad, nicht ausgeführt — Shell tot, [[shell-enoent-in-atlas-sessions]]): `scripts/verify.mjs` + `scripts/logic-tests.ts` (npm-Script `verify`, 6 Stufen, keine neuen Deps), `TESTPROTOKOLL.md` (45 Cases × Web/iOS/Android, Team-Rollen R1–R7 nach appagentteam-Skill), `STATUS.md` im Repo.
- **Live-Test-Instrument:** flutter-skill (`~/.local/bin/flutter-skill`, CDP 9222, serve/snap/explore/monkey) laut appagentteam-SKILL; Kill-Switch-Logik liegt in `SessionRunner.tsx:26` + `NeuralWatch.tsx:21` (Empfehlung D10, kein Hard-Lock).
- Verbleibende Verkaufsblocker: Phase 4 Vision→Plan-Adaption, UI-Refresh, README/LICENSE/DSGVO, Bundle-Verify. Verkaufskontext (45–80k Asset-Deal) siehe [[atlas-workspace-trailing-space]].

**How to apply:** Session-Start → STATUS.md + `git status` lesen, Schritt 0, dann `npm run verify`; erst nach grün die Testprotokoll-Matrix fahren. Kein Deploy/push ohne User-GO.
