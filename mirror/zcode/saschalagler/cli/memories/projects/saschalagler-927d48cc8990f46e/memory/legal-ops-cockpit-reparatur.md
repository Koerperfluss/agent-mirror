---
name: legal-ops-cockpit-reparatur
description: ADHS-Legal-Cockpit-Reparatur 01.10. — Ordner „id austria neu " mit
  TRAILING SPACE ist die Root-Cause, Judicario-MCP kaputt, Workflow
  dwfrun-20813457 läuft, 7 Rechtsfälle mit Az/Beträgen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_7851785d-5e3f-41ed-be76-b2ce090c9af5
---

Stand 01.10.2026 (Workflow gestartet, Ergebnis offen): Saschas Rechtsfälle (BH Melk / BG Melk) laufen über ein lokales ADHS-Cockpit.

**Root-Cause aller Link-Fehler:** Der Akten-Ordner heißt `/Users/saschalagler/Desktop/id austria neu ` — **mit abschließendem Leerzeichen** (36 Items, live geprüft). Ohne Leerzeichen = leer. Deshalb ERR_FILE_NOT_FOUND überall.

**Beweis-Stand (verifiziert per ls/grep):**
- Cockpit: `/Users/saschalagler/Desktop/00_ADHS_LEGAL_OPS_COCKPIT.html` — hatte 0 `file://`-Links, nur 4 Gmail-Compose-Links (verkehr.bhme / strafen.bhme / guenther.hinum / kontakt@svs.at)
- Alle 5 Schriftsatz-PDFs existieren (06:29): VORSTELLUNG_MES1-K-264-274_ME-450GA, BESCHEID_BH_MELK_22_09_2026, SAMMELANTRAG_BH_MELK_54b_VStG_ALLE_STRAFEN, ANTRAG_BG_MELK_2E2940_26b, ANTRAG_SVS_ZAHLUNGSVEREINBARUNG
- Kopien auch in `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/Fallakten_September_2026/`

**Die 7 Karten:** 1) Kfz ME-450GA, Az MES1-K-264/274, Vorstellung §57 Abs. 2 AVG · 2) Strafen-Sammelantrag §54b VStG, 3.565,30 €, 35 €/Monat · 3) Exekution GV Hinum, 141 002 E 2940/26b, 159 €, §291a EO · 4) Grawe/SDSP ERLEDIGT (60 €/Monat ab 15.10., RA Höfler, Zeichen 5261604) · 5) SVS VSNR 3692 210597, 76,86 € (2×38,43) · 6) Grover — KEIN Beweis im Ordner · 7) coeo/PAIR — KEIN Beweis im Ordner. Beweis Existenzminimum: AMS-Notstandshilfe 31,83 €/Tag.

**Infra:** Legal-Ops-Backend läuft auf **Port 7070** (PID 18132, ollama qwen2.5-coder:1.5b) — [[sascha-local-infra-ports]] ergänzen. **Judicario-MCP kaputt** (`judicario_search` → „Unbekanntes Tool"; `legal_ops_consult` → nur Boilerplate) → Ersatz = RIS-Direktabruf (ris.bka.gv.at).

**Workflow:** dwfrun-20813457-3e80-4379-a3b7-d88698b744c7 (4 Subagenten: Akten-Prüfer/Mängel-Finder/Rechts-Rechercheur parallel + Cockpit-Mechaniker persistent, Node-Gate prüft file://-Links gegen Disk + „kein Auto-Open"). Backup-Soll: `.bak-2026-10-01`. Harte Sascha-Regel daraus: **Cockpit darf NICHTS von selbst öffnen (kein Auto-Gmail/App-Open)** — er explodierte über wiederholt geöffnetes Gmail.

**DWF-Lektion:** Deutsche Anführungszeichen `„…"` mit schließendem PLAIN `"` brechen String-Literale in DWF-Scripts → Compile-Diagnostics; Fix = `"` (U+201C) oder nur innerhalb Template-Literals.
