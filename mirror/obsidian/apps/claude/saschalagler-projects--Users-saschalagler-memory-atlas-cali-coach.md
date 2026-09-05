---
app: claude
quelle: "saschalagler/projects/-Users-saschalagler/memory/atlas-cali-coach.md"
stand: 2026-09-05
tags: [spiegel, claude]
---

---
name: atlas-cali-coach
description: "ATLAS Calisthenics-App — kanonischer Pfad + zwei Phantom-Ordner, die Builds folgenlos machten"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9c0e12c0-6033-43e1-ab9c-3b85c3cea87d
  modified: 2026-07-30T17:33:13.807Z
---

Calisthenics-Coaching-App (Front Lever / Planche), Ziel Marktreife als Gymnify-Äquivalent mit KI-Videoanalyse.

**Kanonisch (KORRIGIERT 05.09.2026 via mdfind-SSD-Scan):** `~/Desktop/Coworkspace_Ich/atlas + pliability /Atlas Cali Plan` — der alte Pfad `~/Desktop/Atlas Cali Plan/Atlas_Cali_Commercial_V2` existiert NICHT mehr. Zweitkopie `~/cali-coach-atlas-final` (dist/, ATLAS_KNOWLEDGE_BASE/, 147-Seiten-Report). Historisch (30.07.): einziger Ordner mit Git-Remote `Koerperfluss/atlas-cali-commercial-v2` **und** `.vercel/project.json` **und** aktuellen Commits. 6 weitere Kopien existieren (3 davon unter `.vscode/`).

**Zwei Phantom-Pfade (verifiziert 2026-07-30):**
- `cali-coach-atlas-final/` — existiert nirgends. Alle Merge-Pläne der Form „V2 → cali-coach-atlas-final" sind ungültig.
- `~/Desktop/Atlas_Cali_Commercial_V2` (Desktop-Root, ohne Zwischenordner) — existiert nicht. **Das ist die Ursache, warum `cd ~/Desktop/Atlas_Cali_Commercial_V2 && npm run build && vercel --prod` über mehrere Sessions folgenlos blieb.**

**Why:** Ein kursierendes „Master-Wissensdokument" nennt beide Pfade als real. Wer es liest, baut ins Leere und diagnostiziert dann fälschlich Code-Fehler ("App.tsx zeigt nur Demo") — `App.tsx` ist seit Commit `78ad09d` korrekt verdrahtet (`LogbookProvider` + `MainHub`).

**How to apply:** Vor jedem ATLAS-Build/Deploy `ls -d` gegen den Pfad. Nie einen Pfad aus dem Masterdokument übernehmen. Beide Deploys sind live (200): `atlas-cali-commercial-v2.vercel.app` und `gen-lang-client-0285074833.web.app` (letzteres = Antigravity-Hub-Host, siehe [[bar-bulls-firebase]]).

Volle Projekt-Note im Vault: `Projects/ATLAS Cali Coach.md`, Methodik in `Knowledge/2026-07-30 — ATLAS Trainings-Methodik.md`. Verwandt: [[gcp-billing]], [[koerperfluss-app]].
