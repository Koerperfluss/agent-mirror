---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/browser-automation-real-chrome-tabu.md"
stand: 2026-09-08
tags: [spiegel, zcode]
---

---
name: browser-automation-real-chrome-tabu
description: agent-browser-Relaunch ohne user-data-dir startet Saschas ECHTES
  Chrome-Profil — seine echten Tabs (Behörden-Login!) sind tabu; nur isolierte
  /tmp-Profile, Stop bei fremden Tabs
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

08.09.2026, zweimal passiert: CDP-Port 9225 war tot → `agent-browser` hat selbst neu gestartet **ohne `--user-data-dir`** = sein ECHTES Standard-Chrome-Profil. Mein `navigate`+`eval` landete zweimal mitten in seinem aktiven Tab: **ID-Austria-Behörden-Login** („Fehler! – Freischaltecode oder Widerrufs-Passwort falsch" — er war gerade beim Einloggen). Ein eval mit Text-Setter ging fast in ein Staatsformular. Sofort alle Browser-Automatisierung gestoppt und ihm zugesagt: Automations-Zugriff auf sein echtes Chrome bleibt tot, bis er sie wieder freigibt.

**Why:** Ein Klick/Keystroke des Agents in Login-/Behörden-/Bank-Tabs ist realer Schaden + Vertrauensbruch total. Der Relaunch-Fallback des Tools nutzt stillschweigend das Default-Profil — man sieht den Unterschied nicht am Tool-Output, nur an `location.href`/Tabs.

**How to apply:** (1) Chrome für Automation IMMER selbst starten: `--user-data-dir=/tmp/<isoliert> --remote-debugging-port=9223` + connect; wenn CDP tot ist und `agent-browser` selbst launched → sofort Profil prüfen (`localStorage` leer ≠ Beweis, besser `location.href` + offene Tabs ansehen). (2) Vor JEDEM eval/click: `location.href` gegen Erwartung prüfen; fremde/private Tabs aktiv → stoppen ohne Aktion, melden. (3) Tab-Wechsel mitten in eigenen eval-Sequenzen (Passiv zwischen zwei Calls) = Warnsignal für sein echtes Profil — abbrechen. (4) Seine Browser-Sicherheit geht VOR Test-Beweisen — Beweis alternativ per iOS-Simulator-Screens (QA-LIVE-Muster) oder curl. Verwandt: [[agent-browser-cli]], [[ios-simulator-cua-testing]]
