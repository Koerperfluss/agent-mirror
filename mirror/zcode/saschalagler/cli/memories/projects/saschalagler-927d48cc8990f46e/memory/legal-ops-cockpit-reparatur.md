---
name: legal-ops-cockpit-reparatur
description: ADHS-Legal-Cockpit-Reparatur 01.10. — alle 4 PDFs unterschrieben
  (Sichtprüfung), Grover/coeo-PAIR nur .md-Entwürfe, Workflow amended auf
  dwfrun-aa745ebf, Ordner „id austria neu " mit TRAILING SPACE = Root-Cause
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

**Workflow:** ~~dwfrun-20813457~~ → **amended zu dwfrun-aa745ebf-5df9-4408-89b4-b667c3ca6c3e** (01.10., nach GO aus Plan-Mode). Script: `.zcode/workflow-drafts/ADHS-Legal-Cockpit-reparieren--verifizieren.dwf.ts`. 4 Subagenten (Akten-Prüfer/Mängel-Finder/Rechts-Rechercheur parallel + Cockpit-Mechaniker persistent) + Node-Gate (file://-Links gegen Disk, Gmail to/su/body, KEIN Auto-Open, localStorage, Pfeiltasten). Backup-Soll: `.bak-2026-10-01`. Harte Sascha-Regel: **Cockpit darf NICHTS von selbst öffnen (kein Auto-Gmail/App-Open)**.

**PDF-Unterschriften-Check (01.10., Plan-Mode, per Read-Seiten-Sichtprüfung):** ALLE 4 Schriftsätze UNTERSCHRIEBEN — VORSTELLUNG_ME-450GA (S.2), SAMMELANTRAG (S.2), ANTRAG_BG_MELK_2940, ANTRAG_SVS — jeweils Signaturbild „Sascha Lagler (eigenhändig)", Datum 01.10.2026. **KORREKTUREN gegenüber alten Cockpit-Daten:** Sammelantrag 35 € ERSTER Termin **15.11.2026**; GV Hinum 3×53 € ab **15.11.2026** (nicht 15.10.); SVS 15.10.+15.11. unverändert. Signatur-Asset + .typ-Quellen liegen in `Fallakten_September_2026/` (`unterschrift.png`, `unterschrift_clean.png`, VORSTELLUNG/SAMMELANTRAG/ANTRAG_BG/ANTRAG_SVS .typ). **Nur Entwürfe ohne PDF:** `GROVER_HARDSHIP_STUNDUNGSANTRAG.md` (Empfänger drin: **inkasso@rechnungen.grover.com**, cc support@grover.com; Konto bahldorfa@gmail.com, MacBook Pro 14" M4, 67,91 € offen), `COEO_RATEPAY_SAMMELEINSPRUCH.md`, `PAIR_FINANCE_BESTREITUNG.md`. Der amended Workflow lässt den Mechaniker das Grover-PDF per typst + unterschrift.png bauen (beide Ordner) und Karte 6 mit echtem Gmail-Link versehen.

**Plan-Mode-Lektion:** Bash wird dort vom Hook komplett blockiert (auch readonly) — PDF-Sichtprüfung ging über `Read`-Tool (PDF → Seiten als Bilder) und `mcp__filesystem__list_directory`. `mcp__filesystem__search_files` timeouted auf ~/Desktop (zu groß) → kleine Ordner direkt listen.

**DWF-Lektion:** Deutsche Anführungszeichen `„…"` mit schließendem PLAIN `"` brechen String-Literale in DWF-Scripts → Compile-Diagnostics; Fix = `"` (U+201C) oder nur innerhalb Template-Literals.
