---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/chipsi-openlaw-setup.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: chipsi-openlaw-setup
description: Chipsi ist Cloud-Webapp (chipsi.openlaw.cc) als
  Chrome-App-Shortcut; Judicario-Connector konfiguriert man in Chipsi mit
  MCP-URL+Key; Gmail=koerperfluss@gmail.com
metadata:
  node_type: memory
  type: project
  originSessionId: sess_419a8806-4350-4c0c-92da-4032328e499c
---

**Chipsi** (Rechts- & Steuer-Assistenz von openlaw) ist KEINE lokale App: `Chipsi.app` im Projektordner ist nur ein Chrome-App-Mode-Shortcut auf `https://chipsi.openlaw.cc/` (Login via Google). Ein "Netzwerkproblem — die Antwort konnte nicht erstellt werden" beim Antworten (Recherche→Synthese) kommt vom Connector-/Backend-Aufruf, nicht vom lokalen Netz. Mac-Seite 06.09.2026 verifiziert gesund: DNS/TLS ok, `/api/auth/methods` → 200, gateway.openlaw.cc erreichbar.

Judicario-Connector in Chipsi = MCP-URL (`https://gateway.openlaw.cc/mcp/at/`) + Zugriffsschlüssel — Vorlage mit gültigem Key: `Judicario_Sacha_Mac/tools/CHIPSI_SANDBOX_CONNECTOR.html`. Toter Key war die wahrscheinliche Fehlerursache → [[judicario-gateway-key-rotation]].

**Gmail des Nutzers: koerperfluss@gmail.com** (auch seine primäre Apple-ID → App-Store/TestFlight-Mails landen dort). **Zugriff-Funktionsweg (06.09. verifiziert): ZCode-IAB-Tab mit Nutzer-Google-Login** — Session hält im Tab `iab-tab:31cd4277-fdec-4dc9-bde6-ee709565dec4`; Vorgehen: `#search/<query>` + `getByRole("link", {name:/Betreff/}).click()`. google-workspace-MCP hat KEINEN Gmail-Scope, Gmail nicht in Apple Mail, AppleScript auf Chrome/Mail blockiert (TCC, -1712).

**Gmail-Fundstand 06.09.2026 (Judicario/Chipsi-Einladungen):** (1) **„Dein persönlicher Chipsi-Zugang"** office@openlaw.cc 21.07., MARKIERT — Chipsi-Pilotprogramm-Zugang, Einrichtungslink `https://konto.openlaw.cc/i/djEuaW52X0llb3RCbF9WTDNrMS4xNzg1ODY0MzYxLkxnVm5qZ1Q3.4c66a0c35c97c711dabf05f5cef6ea60`. (2) Judicario-Test-Zugang: Reinhard-Mail 18.08. (markiert) sagt wörtlich: „Wir stellen euch einen eigenen Test-Zugang zu Judicario aus (read-only, pseudonymisierter Test-Mandant; **den bisher verwendeten Schlüssel bitte nicht mehr benutzen**)" — erklärt die Key-Rotation als Ursache des Chipsi-Netzwerkfehlers. Die zugesagte Zugangs-Mail wurde NIE zugestellt: Tiefenprüfung 06.09. mit `in:anywhere` (Postfach+Archiv+Spam+Papierkorb) = nur 3 Reinhard-Mails (18.08. 20:54, 19.08. 00:05, 19.08. 04:57), alle im Label Chipsi/rechtsagent/lifestyle. Spam enthält 5 Mails (BodyFast, Hinge×2, 70M-Scam, G&L-Rechtsanwälte), Papierkorb 4+ (Kalender, Sennheiser, Google-Forum, GCP-Warnung) — keine Reinhard/openlaw-Mail darunter. (3) **KEINE Apple-TestFlight/App-Store-Connect-Einladung** für Judicario-/Chipsi-iOS-Apps im Postfach (nur Rechnungen, WKW.now, OmniFocus). (4) Thomas Schellenbach 02.09. „2. Meinung Einreichunterlagen" = Koerperfluss_Edu_Einreichfassung_v0.1.pdf (anderes Projekt). openlaw-Support: George george@openlaw.cc, WhatsApp +43 676 3064897. SCREEN-Automation würde vieles lösen → [[zcode-computer-use-status]].
