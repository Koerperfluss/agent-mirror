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
