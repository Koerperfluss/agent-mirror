---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/chipsi-judicario-live-audit-2026-10-05.md"
stand: 2026-10-05
tags: [spiegel, zcode]
---

---
name: chipsi-judicario-live-audit-2026-10-05
description: AUDIT 3 live chipsi.openlaw.cc — Synthese-Bug weg, JUD ~70%
  erfüllt, 8 offene Punkte, Auto-Memory-Root-Cause, Support fehlt komplett
metadata:
  node_type: memory
  type: project
  originSessionId: sess_c289f4fc-daa2-4f04-9693-646e08160f63
---

**05.10.2026 AUDIT 3 (Live-Testung chipsi.openlaw.cc gegen Marinus' JUD-Liste):** Bericht = `~/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/03_AUDIT3_CHIPSI_LIVE_2026-10-05.md` + .pdf.

- **Synthese-Bug (22.09.) ist WEG** — Live-Test 13:24: Antwort „Erfolg", § 8 VwGVG amtlich + 10 Rechtssätze + vollständige Synthese mit klickbaren Fundstellen.
- **JUD zu ~70 % erfüllt:** Sidebar enthalst, Benachrichtigungen-Tab raus, Konto-Merge, Personalisierung entschärft, Konnektoren ohne Zwischenschritt, Tarif heißt „Test".
- **Offen (8):** Disclaimer „Keine Rechts-/Steuerberatung" auf Signup · **kein Pro-Pricing/Upgrade/21-Tage-Ende in der App (Verkaufsblocker)** · E-Mail-Bestätigungs-Banner-Logik · Briefkopf noch Vollformular (kein Muster-Upload/An-Aus) · Deep nicht erzwungen · Land-Default „Deutschland" statt AT · Datenkontrollen alle „BALD/disabled" · Sicherheit (Passwort/2FA) alle „BALD/disabled".
- **Auto-Memory-Root-Cause („Antworten werden dumm"):** Gedächtnis-Wiki liest Notizen IM CHAT nach + Reichweite-Knopf „Überall" → Kontamination. Empfehlung: Wiki+Schreibstil AUS, Reichweite „Dieser Chat".
- **Support: JA nötig, fehlt komplett** (0 Treffer Support/Hilfe/Kontakt/Impressum im DOM).
- **E-Mail-Anbindung weit gebaut** (OAuth Google/Outlook/iCloud/GMX, SMTP/IMAP, Testmail, Versandweg) — aber „E-Mail-Empfang ist auf diesem Server nicht aktiv" (Backend-Lücke); Konnektoren: 0 verbunden.
- **Session-Korrektur:** Cline = 379 Sessions total, **189 mit Thomas/Judicario/Chipsi/LokiVoice/Prüfkopf** (Beweisliste /tmp/cline_thomas_sessions.txt) — nicht 3.
- **Infra:** agents-state.json 05.10. 13:10 gefixt (16 Omniroute-Overrides geleert, Backup ~/sicherungen/agents-state-20261005/) — Subagent-Dispatch braucht danach **ZCode-Neustart (⌘Q)**. Cline-TUI ist nur interaktiv bedienbar (headless-Versuche: exit 137/9, keine Ausgabe) — Cline-Steuerung headless geht nicht ohne echtes Terminal.
- Login der Live-App funktioniert im chrome-devtools-MCP-Browser (Session teilt Profil).

Verwandt: [[thomas-tasks-drei-recherchen]], [[feedback-pruefinstanz-pflicht]]

**Nachtrag 05.10. spät (Kollege-Arbeit + Live-Board):**
- **AUDITS 1+2 GEFUNDEN:** `THOMAS_MASTER_2026.html` („🔍 Audit Nr. 2 — Judicario & Chipsi") + `AUDIT_2_TIEFENANALYSE.md` + `ZIELE_KANBAN_2026.html` liegen im verschachtelten Ordner unter `THOMAS - CHIPS JUDICARIO /Judicario_Sacha_Mac/Audit 2 + Sprachassistent/` (inkl. PRINT-PDF + KLARTEXT + v1-Archiv).
- **LIVE-BOARD gebaut** (Sascha wollte „live Aufgabenverteilung visuell, mir egal wie"): `05_LIVE_BOARD/index.html` + `board_state.json`, Server `python3 -m http.server 8090` auf 127.0.0.1 (PID 80288, start-Command wiederholen wenn tot), Auto-Reload 15 s, 4 Spalten (Fertig/Läuft/Wartet-GO/Blocker).
- **Cline-Kollegen-Prinzip:** Sascha läuft parallel eine zweite ZCode-Session (Provider ClinePass/MiMo-V2.6-Pro) als „Kollege" — die minet Prüfkopf/WhatsApp-Bilder (`LokiVoiceApp/Sources`: PruefkopfService.swift, SafeTalkContacts.swift, WhisperSTTEngine.swift, KeySelfService.swift von Aug 14–18). **Nicht doppelt arbeiten — vor Tasks prüfen, was Parallel-Sessions schon liefern.**
- **Cline.app** existiert unter /Applications/Cline.app; Cline-TUI-CLI ist nur interaktiv (headless exit 137/9).

**Nachtrag 05.10. 14:00 (GEMEINSAME LIVE-TESTUNG + Ausgrabung, nach Sascha-Korrektur):**
- **Sascha-Korrektur (wütend):** Ziel ist NICHT Dokumenten-Mining, sondern **MIT Cline GEMEINSAM die App live testen** — zwei Prüfer parallel, ein Protokoll. Ergebnis: `08_GEMEINSAME_LIVETESTUNG.md` (Lane A = ZCode-ich ✅, Lane B = Cline-Kollege, schreibt Ergebnisse in denselben Abschnitt).
- **Runde-2-Live-Funde (13:55–14:00):** „Antwortstil wählen" = **Slash-Modi**: `/gutachten` · **`/pruefung` („Fachprüfungs-Modus: Luna plant, Fallstricke aus der Judikatur", 3–6 Min — Prüfinstanz-Persona „Luna" ist in der App!)** · `/tiefenrecherche` (1–2 Min) · `/kurz` (≤10 Sätze) · `/normen` · `/mandantenbrief`. Zweitmeinung-Button an jeder Antwort. Neues-Dokument-Menü: Leeres Word-Dokument · Datei öffnen (DOCX/PDF/Bild) · PDF öffnen · **Neue E-Mail** („Im Editor schreiben") · **WhatsApp verfassen** — „Aus Vorlage" entfernt (JUD-0 ✅). Kontextzähler 500k + tok/s im Banner.
- **AUSGRABUNG fertig:** `06_AUSGRABUNG_AUDITS12_PRUEFKOPF_2026-10-05.md` + .pdf — Audit 2 = `…/Audit 2 + Sprachassistent/_ARCHIV/AUDIT_2_TIEFENANALYSE.md` (04.08., „Judicario=Motor · Chipsi=Auto", 5 Qualitäts-Tests alle korrekt); Audit 1 nur als eingeflossener Vorgänger (Anhang B, mit Scheinecker v1.4, 5-Fragen-Test, Peter-Matrix). **Prüfkopf:** `PruefkopfService.swift` 353 Zeilen (Aussagen-Extraktion THEMA/TERMINE/ENTSCHEIDUNGEN/AUFGABEN/UNKLARHEITEN → Judicario-MCP + SafeBox-Prüfung → nur belegte Hinweise → Freigabe), 2 Kopien, live verdrahtet via `pruefenLiveStreamChunk()` aus LocalVoiceService.swift:444 + VoiceService.swift:749; gebaut 17.–18.08. von Cline (Sessions 1786933744437, 1786935387376, 1786965445943, 1787055118931).
- **Kollegen-Task:** `07_TASK_FUER_CLINE_KOLLEGEN.md` + Lane B im 08er-Protokoll (Zweitmeinung-Tiefentest, Editor-Durchgang, Konnektor-Dialog, 28-Screens-Abgleich → Ergebnis `07_EINWAENDE_ABGLEICH.md`).
- **Board läuft weiter** (Board-State 14:01 aktualisiert); Login der Live-App überlebt MCP-Browser-Restart (Cookie-Profil).
- **Verhaltens-Lektion:** Sascha will ERGEBNIS-Arbeit statt Blocker-Meldungen — Subagent-Dispatch tot = direkt selbst arbeiten („Director-Direktmodus"), nie wieder „wartet auf Neustart" als Zustand melden.

**Nachtrag 05.10. 14:09 — SASCHA HAT NEUGESTARTET, TEAM LÄUFT:**
- **Dispatch wieder aktiv** („DISPATCH OK — Neustart wirksam", 17,5 s) → Blocker-Spalte im Board GELEERT (14:10).
- **2 Hintergrund-Agents gestartet:** Agent 1 = Voll-Inventar des verschachtelten Doppel-Ordners → `03_FUNDINVENTAR_VERSCHACHTELT_2026-10-05.md`; Agent 2 = Kopiervorlage an Marinus/Reinhard (8 offene Punkte + Auto-Memory-Defaults + Support + E-Mail-Empfang) → `09_NACHRICHT_AN_MARINUS_REINHARD_2026-10-05.md`. Beide liefern Dateien in den Projektordner — bei Wiederaufnahme deren Existenz prüfen, nicht neu bauen.
- **Nächster Schritt:** Sobald Lane B (Cline) + die 2 Agents liefern → alles in EIN Übergabe-PDF für Marinus/Reinhard/Thomas ziehen (JUD-Liste vs. Live-Stand vs. Saschas Einwände).

**14:10 UPDATE:** Subagent-Dispatch nach Saschas ZCode-Neustart WIEDER DA (Test „DISPATCH OK", 17,5 s) — 2 Hintergrund-Agenten gestartet: Fundinventar verschachtelter Ordner (03_FUNDINVENTAR_VERSCHACHTELT_2026-10-05.md) + Marinus-Nachricht (09_NACHRICHT_AN_MARINUS_REINHARD_2026-10-05.md). Neu: 08_GEMEINSAME_LIVETESTUNG.md (Lane A ZCode fertig: Slash-Modi inkl. /pruefung mit Prüfinstanz-Persona „Luna", Zweitmeinung, Dokument-Editor mit E-Mail+WhatsApp, 500k-Kontext; Lane B = Cline-Kollege). Live-Board: 05_LIVE_BOARD/ + Server 127.0.0.1:8090 (PID 80288). Chronik-PDF mit Nachtrag neu gerendert.

**14:15 UPDATE — Agent 2 FERTIG:** `09_NACHRICHT_AN_MARINUS_REINHARD_2026-10-05.md` (42 Zeilen, verifiziert: Anerkennung ~70 % + 8 offene Punkte inkl. A7 Pro-Preise = Verkaufsblocker + 3 Produkt-Wünsche Auto-Memory-Defaults/Support/E-Mail-Empfang, Fachbegriffe im Klartext erklärt) — **zum 1:1-Pasten in die WhatsApp-Gruppe bereit, Sascha muss nur noch senden.** Chronik-PDF neu gerendert (254 KB, Nachtrag 05.10. drin, grep-geprüft). Memory-File mit 14:10-Update ergänzt. Offen: Agent 1 (Fundinventar) liefert noch, Cline Lane B ausstehend — danach EIN Übergabe-PDF bauen.

**14:25 UPDATE — Agent 1 FERTIG + VOLLGAS-WORKFLOW GESTARTET:**
- **Fundinventar fertig:** `03_FUNDINVENTAR_VERSCHACHTELT_2026-10-05.md` — Nest-Ordner = **20.576 Dateien / 1,41 GiB**. Top-Funde: **`Legal_Ops_Zentrale/` 894 MB AKTIV** (letzte Änderung 05.10., ~90 echte Fallakten BH/BG Melk + Exekution 141_002_E_* + AMS/SVS + legal-ops-advisor Python/Firebase + NativeLegalOps Swift) → HOCHLAUFEN · `Judicario_Sacha_Mac/` 524 MB (Kern-Archiv) · `IRIS-AI/` 79 MB vollständiges Repo · **5 MD5-Dubletten** (MODELL_KATALOG 3× identisch, e409626ff…) · `Legal_Ops_Zentrale 2/` KOMPLETT LEER · `00_PAKET_FUER_THOMAS/THOMAS_PAKET_V2/LokiVoice-Thomas-Fix.zip` (02.10.) = aktuellstes Übergabepaket · `00_BEWEIS…2.png` NICHT identisch (nicht blind löschen) · Namens-Chaos: `PETER JUDICARIO 2/` (leer) vs `PETER JUDICARIO2/`.
- **VOLLGAS-WORKFLOW dwfrun-6755b377 läuft** (CreateWorkflow, 7 Subagenten, Skript `.zcode/workflow-drafts/Vollgas-Team-Screens-Abgleich--Chronik--Prüfkopf--Checkliste.dwf.ts`): Screens-Prüfer A (52er+51(1-3)=14 Screens) + B (51(4-7)+50er=14) schreiben `10_EINWAENDE_ABGLEICH_TEIL_A/B.md`, je 1 Gegenprüfer spotcheckt URTEILE gegen Audit 3 · Chronik-Miner → `11_CLINE_SESSIONS_TABELLE.md` (aus /tmp/cline_thomas_sessions.txt) · Prüfkopf-Prüfer → `12_PRUEFKOPF_VERIFIKATION.md` · Checklisten-Schreiber → `13_QA_CHECKLISTE_JUD.md` · Gegenleser. Internes Live-Board-Artefakt „fortschritt" im Run. **Nach Abschluss: alles (Audit 3 + 06 Ausgrabung + 08 Protokoll + 09 Nachricht + 10–13) in EIN Übergabe-PDF für Marinus/Reinhard zusammenziehen.**
