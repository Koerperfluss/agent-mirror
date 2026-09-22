---
name: chipsi-judicario-stand-2026-09-22
description: Chipsi 22.09. GELÖST — verwalteter „amtliche Quellen"-Konnektor war der
  Störer (Key-Rotation 04:21); im Chat AUS geschaltet, eigener Key-Konnektor AN → Synthese
  baut wieder; 3 neue Judicario-Keys aktiv; Chipsi-Installationspaket neu gebaut
metadata:
  node_type: memory
  type: project
  originSessionId: sess_5b46926c-ea38-4d93-833c-ef981b842fd5
---

Stand 22.09.2026 (Diagnose „Chipsi funktioniert nicht"):

- **Chipsi** = reiner Chrome-PWA-Shortcut auf `https://chipsi.openlaw.cc/` (Info.plist: `CrAppModeShortcutURL`). Keine lokale Engine, **kein Claude/Client nötig, kein Key nötig** (Konnektoren ab Werk aktiv).
- Symptom: Recherche-Phase lief (Judicario lieferte 10 Rechtssätze · 10 Urteile), nur die **Synthese** brach ab: „Nicht gespeichert: Netzwerkproblem — die Antwort konnte nicht erstellt werden." → serverseitiges openlaw-Problem ODER Payload zu groß (15 PDFs in einem Chat-Auftrag → Timeout, als „Netzwerkproblem" gemeldet).
- Netzwerk Saschas Mac war intakt: chipsi.openlaw.cc HTTP 303 in 0,16 s, gateway.openlaw.cc HTTP 401 (lebt).
- Claude Desktop ist installiert (`/Applications/Claude.app`, `~/.local/bin/claude`) — Saschas Frage „liegt es am fehlenden Claude?" war doppelt falsch.
- **Judicario-Keys (WhatsApp von Reinhard, 22.09., 04:21): 3 NEUE PRO-Keys aktiv, ALTE ungültig.** Neu: `jud_Q9rZ8kR1KEGCZP0I0-hOWCmudz0S3WFI`, `jud_0UZGwFqnbqmsxayVXY9K800NMaUWK9LS`, `jud_vTl95qGkOIV72weV1S8qBmeEMABymImn`. Gateway: `https://gateway.openlaw.cc/mcp/<at|de|ch|eu|ip|fr|schriftsatz>/?k=KEY`. Je 5.000 Credits, kein Ablaufdatum. Reinhard will Bescheid, sobald erster Zugang läuft.
- **Gateway live verifiziert (22.09.):** Key 1 (`jud_Q9rZ…`) per MCP-initialize getestet → HTTP 200, Serverinfo „judicario-at" v1.29.0 („read-only Rechtsrecherche, Modul at"); ohne Key HTTP 401. Eintragung in Claude Desktop als benutzerdefinierter Connector mit Auth „Keine Anmeldung (Erkannt)" ist korrekt — der Key steckt in der URL (= API-Schlüssel-Auth); gelbe Warnung „jeder mit der URL kann den Connector nutzen" ist erwartet → URL geheim halten. Chipsi selbst braucht diesen Connector NICHT (nur für direkte Judicario-Recherche in Claude Desktop).
- Zwei Kopien `Chipsi.app` + `Chipsi 2.app` im Projektordner = Duplikate desselben Shortcuts (Chrome 7922 vs. 8010); `Chipsi 2.app` kann gelöscht werden (Lösch-GO steht noch aus). Keine Chipsi-Datei im Standardpfad `~/Applications/Chrome Apps.localized/`.

Nachmittag 22.09. (Claude-Desktop-Blocker behoben + Workflow-Verifikation):

- **MCP_DOCKER „Server disconnected" in Claude Desktop** — Ursache war schlicht **Docker Desktop aus** (Log `~/Library/Logs/Claude/mcp-server-MCP_DOCKER.log`: „Docker Desktop is not running"). Repariert: `open -a Docker` → Docker OK, Server-Version 29.8.0. Wirksam wird es erst nach **Claude-Desktop-Neustart** (MCP-Prozess startet mit der App; App wurde absichtlich NICHT neu gestartet, Sascha war mitten im Connector-Dialog).
- `~/Library/Application Support/Claude/claude_desktop_config.json` enthält lokale Server: `MCP_DOCKER` (`docker mcp gateway run --profile ai_coding`) + `memory` (npx `@modelcontextprotocol/server-memory`). Der Judicario-Connector ist remote (Key in URL) und liegt NICHT in dieser Datei, sondern im Account.
- **Verifikations-Workflow gestartet** (22.09., run `dwfrun-59a1ea9a-41ac-4cc5-acb0-d56eb747d118`, Skript `.zcode/workflow-drafts/Claude-Desktop-prüfen-MCP_DOCKER--Judicario.dwf.ts`): deterministische Checks (docker info, Log-Tail, Config-JSON, Gateway-initialize + tools/list mit Session-Header) + ein Subagent „Befund-Analyst"; Deliverable = Markdown-Statusbericht. Offen bei Erstellung: hat Sascha auf „Hinzufügen" geklickt; MCP_DOCKER-In-App-Reconnect ohne Neustart.

Abend 22.09. (Integration-Pakete — SSD-weite Suche + Neubau):

- **SSD-Suche nach Chipsi-Einbindung:** Ein Chipsi-Installationspaket existierte NIRGENDS (nur das Judicario-Paket, PDFs, alter `CHIPSI_SANDBOX_CONNECTOR.html` mit Alt-Key, Mini-Chipsi). Referenzstruktur des Judicario-Pakets: `…/Judicario_Sacha_Mac/Judicario_Sacha_Mac/judicario/` (Anleitung_DE.html, commands/, Connectoren_URLs.txt, `Judicario_in_Claude_Code_installieren.command`, mcp_config.py, README.md, Mac/Win-Zips). Judicario = 8 Module als GETRENNTE Connectoren (at, de, ch, eu, ip, steuer, fr, schriftsatz).
- **Chipsi-Paket NEU gebaut:** `…/Judicario_Sacha_Mac/Judicario_Sacha_Mac/chipsi/` — `Chipsi_installieren.command` (Chrome-App-Fenster auf chipsi.openlaw.cc, kein Key), `Mini_Chipsi_starten.command` (lokal 8085), `Connectoren_URLs.txt`, `README.md`. chmod +x, bash -n grün. Support-Kontakte dokumentiert: Marinus Brückmann (Markt/Partner), George (technik: george@openlaw.cc, WhatsApp +43 676 3064897).
- **Backend:** Sascha meldete ~15:35 „das Backend läuft"; Live-Test übersprungen (er arbeitete selbst im Chrome). Mini-Chipsi `{"ok":true}` (PID 16377). Details/Computer-Use-Lessons: [[chipsi-synthesis-error-diagnosis]].

Verwandt: [[umgebungs-blocker-zcode]], [[chipsi-synthesis-error-diagnosis]]

ABSCHLUSS 22.09. (~15:50) — Chipsi.app wiederhergestellt & verifiziert:

- **Chipsi.app neu in `~/Applications/Chrome Apps.localized/`** — Chrome hat sie um 15:38 selbst neu registriert (Bundle-ID `com.google.Chrome.app.ihodfbdaigcgkojbhcdgojhjjphpcdnh`, URL chipsi.openlaw.cc, `app_mode_loader` vorhanden). Start getestet: App-Fenster öffnet (eigener PID, Prozessname „Chipsi"), **eingeloggt** („Guten Tag, Sascha", alle Akten + Chatverlauf da).
- **Wichtig für künftige App-Verluste:** Die PWA-Shortcut-.app taucht nach Logout/Login der Web-Session im Chrome-Apps-Ordner neu auf — nicht manuell kopieren, einfach chipsi.openlaw.cc im eingeloggten Chrome öffnen, Chrome registriert den Shortcut selbst.
- Konfigurationshinweis an Sascha: Im frischen Chat sind **beide** Konnektoren-Checkboxen wieder AN (Standard). Solange openlaws verwaltetes Backend Störungen zeigt (⚠ Fehler), Haken bei „Judicario · amtliche Quellen" raus → läuft über den eigenen Key-Konnektor. Sascha hat eine Bescheid-Frage (Tiefenrecherche) bereit im Eingabefeld.

Spätnachmittag 22.09. (~15:45) — Login + Key-Validierung:

- **Chipsi-Session fällt wiederholt raus** (15:00 drin, ~15:40 wieder `/login`) — Session-Instabilität ist Teil des Serverproblems.
- **Google-Login blockiert:** „Mit Google anmelden" mit koerperfluss@gmail.com → Chipsi-Antwort: „Für diese E-Mail gibt es bereits ein Passwort-Konto" — Konto ist E-Mail+Passwort, Passwort nirgends gespeichert. Einziger Weg: Sascha tippt Passwort (offenes Fenster) oder macht „Passwort vergessen?"-Reset. Danach übernimmt der Agent die komplette Neukonfiguration.
- **Alle 3 Keys validiert (initialize je HTTP 200)**; `GET https://gateway.openlaw.cc/whoami` mit `Authorization: Bearer KEY` liefert tier/credits/module (Key #2 jud_0UZG…: tier pro, 5000 Credits, alle Module). Alters-Key jud_Cpu-… ebenfalls noch gültig.
- **Neukonfigurations-Plan (Saschas Auftrag):** mit Key #2 Konnektor „Judicario" frisch anlegen (Trennen → Konnektor hinzufügen → URL+Key), Werkzeuge auf „Immer", Endtest. Details: [[chipsi-synthesis-error-diagnosis]].
