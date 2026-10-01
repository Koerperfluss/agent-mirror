---
name: legal-ops-cockpit-reparatur
description: ADHS-Legal-Cockpit 01.10. ABSCHLUSS — Cockpit GRÜN (dwfrun-c2ded830),
  .eml-Weg TOT für Sascha (Apple Mail hat kein Gmail-Konto), echter Sendeweg = Send-Liste
  Gmail-Web-Links + PDFs reinziehen; Judicario lebt (at_search, §44 KFG live)
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

**Infra/Lektionen:** Backend 7070 läuft. Mimosa blockt Bash-Heredoc-Writes von Quelldateien → Write-Tool. Typst: jedes `@` escapen. Plan-Mode blockt Bash. DWF: „…"-Anführungszeichen brechen Strings. `ListWorkflowRuns` zeigte 0 Runs (unzuverlässig) — Status per GetWorkflowRun/Benachrichtigung. ⚠️ DWF-Drafts landen im CWD: nach `cd` in einen Projektordner schreibt `.zcode/workflow-drafts/` DORTHIN (E-Mail-Draft lag in `Fallakten_September_2026/.zcode/workflow-drafts/`) — Edit mit RELATIVEM Pfad schlägt dann fehl, absoluten Pfad suchen (find).

**Send-Status 01.10. ~09:45 (Mail-DB-Beweis, auf „sind die jetzt gesendet?"):** **KEINE der 5 Mails gesendet.** Sent-Ordner (`imap://E501B849-…/Sent%20Messages`) enthält nur alte Google-Case-Mails (letzte 01:56, Case #00303154); Strafen-.eml existiert nur im **Archive**-Ordner (importiert beim Öffnen, Bauzeit 08:20), die anderen 4 fehlen komplett in der Mail-DB. **KORREKTUR zu oben: Apple Mail HAT doch das Gmail-Konto** (IMAP E501B849; „natürlich nicht" galt der Arbeitsweise-Frage) — .eml öffnen lesbar MIT Anhang, werden aber nur importiert statt als Send-Fenster geöffnet. Sascha hatte den Gmail-Compose-Tab für Mail 1 (Strafen) im Browser offen — manueller Weg läuft. Angebot steht: Chrome/Comet-Neustart mit Debug-Port → 5 echte Gmail-Entwürfe mit Anhängen (wartet auf GO + Chrome-vs-Comet-Antwort). → [[apple-mail-db-abfrage]]

**Mail-Text-Qualität bestätigt (01.10., Sascha-Frage „der Text reicht so?"):** JA — Bewehrten-Mails sind bewusst Begleitschreiben (Rechtsinhalt steht im unterschriebenen PDF): Formel **Bezug (GZ) → Anlage benennen → konkrete Bitte**. Alle 5 enthalten GZ-Referenzen + Normzitat + Beträge/Daten; 2b hat die wichtige Bitte um **schriftliche Bestätigung** (ohne sie ist Behörden-Schweigen kein Verstoß). Bewusst NICHT im Mailtext: Rechtsvorträge, neue Tatsachenbehauptungen, Emotionen. Meine Abgabe: jetzt senden statt feilen — Fristen (Strafen ~07.10.) wiegen schwerer als Formulierungs-Nuancen.

**Normen-Belegstatus der 5 Mails (01.10., Sascha-Frage „ist das von Judicario bestätigt?"):** 2 von 4 zitierten Normen **live gateway-belegt** — § 54b VStG (`at|vstg|54b`, Abs. 1 „binnen zwei Wochen" = Mahnungs-Logik) und § 44 KFG (`at|kfg|44`) → betrifft die fristenkritischen Mails 1 + 2b. § 291a EO und § 57 AVG **nicht gateway-belegbar** (at_norms-Korpus-Lücke, siehe [[judicario-gateway-mcp-rezept]]) — Quelle bleibt Chipsi-Gutachten („amtlich abgeglichene Fundstellen") + RIS-Link; Nachzug via RIS-Direktabruf angeboten, fürs Senden aber kein Blocker. → [[judicario-gateway-mcp-rezept]]

**FINALSTAND 01.10. ~09:40 — Automatisierungsfrage ENDGÜLTIG ZU („letzte chance … mach es einfach selber"):** Alle 5 Wege zu „Anhang automatisch in Saschas Gmail" beweisbar TOT: (1) Gmail-API-Konnektor → „Permission denied" (kein Scope); (2) Chrome-CDP → Chrome 154 mit `--remote-debugging-port=9223` gestartet (Prozess bewiesen), Port bleibt LEER — [[chrome-agent-browser-fix]]-Block gilt auch für 154; Test-Chrome danach sauber beendet (0 Prozesse); (3) ZCode-IAB → file chooser/upload **explizit unsupported** (control-browser-Skill-Doku); (4) Apple Mail → .eml öffnen/importieren ja, aber kein „Als Sendefenster" und Sascha will den Weg nicht; (5) AutoClaw-mcporter → **Binary existiert nicht** (nur config in `~/.openclaw-autoclaw/workspace/config/`). Konsequenz: EINZIGER Weg = Sascha klickt selbst in Gmail-Web (Send-Liste `00_EMAILS_JETZT_SENDEN.html`, Cmd+R nicht vergessen) — mein Angebot: Live-Screenshot-Begleitung pro Karte (er schickt Screen, ich nenne das nächste Klickziel). Reihenfolge nach Fristen: 2 → 2b → 1 → 3 → 4.

**2b-Unterschrift abgehakt (Sascha, „es passt obnwohl meine unterschrift nicht die richtige ist .. aber egal"):** Er kennt die Abweichung und schickt es trotzdem — Frist wiegt schwerer. Bei Behörden-Nachfrage PDF in 2 Min. neu kompilieren (typ + unterschrift.png vorhanden). Send-Status Session-Ende: weiterhin NICHTS gesendet (Mail-DB-Beweis oben).
