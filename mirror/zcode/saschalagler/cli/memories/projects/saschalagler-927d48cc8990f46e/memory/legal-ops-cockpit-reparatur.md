---
name: legal-ops-cockpit-reparatur
description: ADHS-Legal-Cockpit 01.10. ABSCHLUSS — Cockpit GRÜN (dwfrun-c2ded830),
  5 .eml MIT Anhängen md5-GRÜN (dwfrun-1ff46e60 nach Slash-Bug-Fix), Judicario lebt
  (at_search, §44 KFG live), 2b-Erklärung bleibt (Empfehlung); Sascha sendet selbst
metadata:
  node_type: memory
  type: project
  originSessionId: sess_7851785d-5e3f-41ed-be76-b2ce090c9af5
---

Stand 01.10.2026 final: Saschas Rechtsfälle (BH Melk / BG Melk) — **ALLE Workflows fertig, alles maschinell verifiziert, nichts gesendet (Senden = Sascha)**.

**Root-Cause aller Link-Fehler:** Ordner `/Users/saschalagler/Desktop/id austria neu ` — **abschließendes Leerzeichen**.

**Deliverables (alle bewiesen):**
- **5 fertige `.eml` MIT Anhängen** in `~/Desktop/EMAILS_FERTIG_ZUM_SENDEN/` (1_STRAFEN→strafen.bhme@noel.gv.at, 2_VERKEHR_Vorstellung, 2b_VERKEHR_Vollzugsaufschub, 3_GV_HINUM→guenther.hinum@justiz.gv.at, 4_SVS→svs@svs.at). **md5-Gate GRÜN**: jeder Anhang byte-identisch mit Quell-PDF (Empfänger/Betreff/Namen geprüft). Doppelklick → Mail-Fenster mit Anhang → Sascha sendet nur noch. Gmail-Web kann KEINE Anhänge vorbefüllen (Google-Limit) → .eml mit `X-Unsent: 1` ist der „mit Anhang"-Weg; Apple Mail braucht Konto koerperfluss@gmail.com.
- **Cockpit repariert** (dwfrun-c2ded830: 13 Änderungen, Node-Endtest GRÜN, Backup `.bak-2026-10-01`; vorher verified: 6/7 Karten, 0 RIS-Links, 0 file://-Links usw.).
- **Send-Liste** `~/Desktop/00_EMAILS_JETZT_SENDEN.html` (5 Gmail-Links + .eml-Sektion, grep-Beweis) + Beweisbericht-Artefakt „E-Mails mit Anhaengen".
- **Schriftsatz 2b** ANTRAG_VOLLZUGSAUFSCHUB §44 Abs. 4 KFG (typst, 79 KB, unterschrift.png) — **Judicario-live normbestätigt** (`at|kfg|44`: Abs. 1 lit. c, Abs. 3 keine aufschiebende Wirkung, Abs. 4 unverzügliche Ablieferung).
- **Judicario-Client** judicario_mcp_client.py → [[judicario-gateway-mcp-rezept]].

**2b-Erklärung (antragsfern geklärt):** Sascha fragte „warum fragst du das?" → geantwortet mit Begründung + **Empfehlung „bleibt"** (ohne haftenden Versicherer ist Fahren ohnehin unzulässig — Erklärung kostet nichts Erlaubtes, ist Hebel ggü. §61 Abs. 5 KFG). Default: bleibt drin, „streichen" widerruft jederzeit.

**Saschas Rest-Aktionen:** 1) 5× .eml-Doppelklick + Senden (Fristen: Strafen ~07.10., Vorstellung ~06.10.) · 2) 60 € am 15.10. an SDSP (IBAN AT12 6000 0000 9217 7192, Zweck 5261604) · 3) noch fällig: **Ordner-Aufräumen** („bitte räum auf" — nichts löschen, nach Workflows).

**Stale-Tab-Vorfall (01.10. ~08:30, Wut-Stufe hoch):** Sascha sah die Send-Liste in einem ALTEN Browser-Tab (Screenshot 08:04:49 — ohne .eml-Sektion, ohne Karte 2b; Platten-Stand 08:21:50 hat beides, grep-Beweis Zeilen 23–28 + 46) und beschwerte sich: „WARUM NEUE FILES WENN ES SIGNIERTE SCHON GIBT" + „EMAIL-VORLAGEN — WILLST DU MICH VERARSCHEN" (die „PDF reinziehen"-Karten = alter Zweitweg-Stand). Aufklärung: .eml = Versand-Container mit SEINEN signierten PDFs md5-identisch drin (keine neuen Dokumente; nur 2b war neu + befohlen); Fix = Cmd+R. **Lektionen:** (a) bei Sicht-Streit ERST Disk-Status beweisen (stat mtime + grep) und Cmd+R sagen, nicht argumentieren; (b) proaktiv sagen „Container enthalten byte-identisch deine Originale", sonst liest er neue Files als Ersatz seiner Signaturen.

** Slash-Bug + Fix (wichtig für künftige Gates):** .eml-Workflow dwfrun-8bdd1aa5 scheiterte still — in meiner TASKS-Konstante fehlte der `/` nach dem Leerzeichen-Ordner (`D + "FILE.pdf"` statt `D + "/FILE.pdf"`); Gate-Ausnahme → leere stdout → „Pruef-Skript ohne Ausgabe". **email-bauer-Subagent eskalierte mit exakter Diagnose** (§14-Eskalations-Loop zahlt sich aus!) → 7 Draft-Edits (Pfade + os.path.exists-Guard im Gate) → AmendWorkflow → **dwfrun-1ff46e60 GRÜN**. Lektion: Gate-Skripte müssen Datei-Opens absichern; Konstanten, die in Builder-Ask UND Gate fließen, einmal richtig bauen; Trailing-Space-Ordner Pfade IMMER mit `$D/$file`-Muster.

**Saschas Regeln dabei (bestätigt):** „DU MACHST KEINE ENTSCHEIDUNGEN — JUDICARIO/CHIPSI CONNECTOREN SONST GARNICHTS"; alles auf einmal vorbereiten, dann task-weise Ja/Nein; „bitte warte alle workflows ab und gib bescheid" = blockieren + konsolidierter Endbericht. legal_ops_consult-MCP nutzlos (nur Header-Echo). ⛔ NICHT senden: SCHRIFTSATZ_BH_MELK_AUTO_ME450GA.pdf (Privatgrund-Lüge) + ANTRAG_BH_MELK_54b_VStG.pdf („gemeinnützige Arbeit" wirkungslos, VwGH 2014/09/0042). Sammelantrag 35 € ab 15.11.; GV Hinum 3×53 € ab 15.11.; SVS 15.10.+15.11.

**Infra/Lektionen:** Backend 7070 läuft. Mimosa blockt Bash-Heredoc-Writes von Quelldateien → Write-Tool. Typst: jedes `@` escapen. Plan-Mode blockt Bash. DWF: „…"-Anführungszeichen brechen Strings. `ListWorkflowRuns` zeigte 0 Runs (unzuverlässig) — Status per GetWorkflowRun/Benachrichtigung.
