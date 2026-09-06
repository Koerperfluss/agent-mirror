---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/loki-project-map.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: loki-project-map
description: Master-Projekt-Map (06.09.2026) — alle 9 Sascha-Projekte mit
  kanonischen Pfaden, Besitzern, Status, Tickets; lebt in ~/LOKI_PROJECT_MAP.md
metadata:
  node_type: memory
  type: project
  originSessionId: sess_6ec2db7a-ed38-4ece-8c80-35110f8e0fbc
---

**Kanonische Quelle: `~/LOKI_PROJECT_MAP.md`** (06.09. 17:30 massiv aktualisiert nach „alles und abfahrt"-Batch) — dort stehen Tickets/Details. Kern-Stand:

| Projekt | Pfad | Besitzer | Status |
|---|---|---|---|
| LOKI.OS / Agent OS | `~/agent-os/` | Sascha+ZCode | 🟢 aktiv |
| Atlas Cali Coach | `~/cali-coach-atlas-final` | **AutoClaw full-stack-builder** — TAKEOVER LÄUFT LIVE im Agent-Chat (Handoff 17:05 gesendet, Agent arbeitet ZCODE_HANDOFF.md ab) | 🟢 aktiv übergeben |
| Legal Ops + Native | `~/LegalOpsAdvisor_Sacha_Mac` + `NativeLegalOps/` | ZCode | ✅ **Diagnose fertig: Verschmelzung FUNKTIONIERT** ([[legal-ops-native-status]]); Rest: [GO] 4-App-Varianten aufräumen, e2e-Tests, Thomas-Endpunkte |
| LOKI Voice + Thomas | `~/loki-ki/loki-voice` + PETER-JUDICARIO/LokiVoiceApp | ZCode | 🟡 läuft (launchd), geht in Legal-Ops über (ein Thomas-System) |
| Körperfluss 3D | `~/Desktop/Coworkspace_Ich/FIRMEN PROJEKTE/Koerperfluss-3D-Upgrade` | ZCode | 🟡 live, 🔴 null Tests (F14/F15 offen) — nächstes großes Ticket |
| TODO App | `~/Desktop/Coworkspace_Ich/Projekt-Task-Planer` + `/Applications/TODO APP.app` | ZCode | ✅ weitgehend fertig (pnpm-Monorepo Vite7/React19/Tailwind4, Tauri2, Postgres16-Docker `kern-db`); Rest: uncommittete Änderungen, Voice braucht Gemini-Key (Regex-Fallback da) |
| Förder-Landschaft-Tool | `~/Desktop/Coworkspace_Ich/öförderrungen` | ZCode | ⚪ INIT offen (welche Quelle klonen? unklar) |
| Paraletts 3D-Hub | `~/Desktop/Coworkspace_Ich/VEREIN ; BARBULLS ; PARALETTS/3d hub paraletts verkau` | ZCode | ✅ Statuscheck: Prototyp/Recherche (3MF-CAD-Modelle + Shop-Masterplan Shopify/Etsy/Willhaben, firebase.json da), kein Code-Projekt, kein eigenes Git |
| Barbulls Website | `…Barbulls.Website update` + `~/Desktop/Dokumente/Barbulls/…/bb vereinsapp` | ZCode | ✅ Statuscheck: Wix live (859-KB-Export) + Vue3/Vuetify/Firebase-Scaffold v0.0.0; WhatsApp-Termin-Bot nur Plan-Doku; Entscheidung Wix vs. Eigenbau offen |

**Querschnitt (06.09. Abend):** Q1 ✅ ENTLASTET — Scan `~/loki-ki/services/` = 0 Plaintext-Keys, 0 .env (alter Eintrag war falsch) · Q1b 🟡 NEU — Home-Verzeichnis ist Git-Repo (1120 Dateien inkl. Desktop-Projekte quer; keine echten Secrets getrackt, 2 Treffer = Skill-Doku-Artikel; strukturell unsauber) · Q2 4× Legal-Ops-MCP-Prozesse (kill = GO) · Q3 FörderOps ohne Autostart · Q4 Gate-Live-Beweise. **AutoClaw-Chats:** Atlas→full-stack-builder ✅ (Agent arbeitet live, nicht reinfunken) + Dienste→mac-operator ✅; Rest bewusst über ZCode.

**How to apply:** Bei „was ist offen / nächstes Ticket": Map lesen (nicht neu erfragen), von oben abarbeiten; jede Aufgabe startet mit loki-dev Schnitt-0-Gate ([[loki-dev-gate-enforcement]]). Verwandt: [[active-projects-focus]] [[autoclaw-full-stack-builder]] [[legal-ops-native-status]] [[foerderops-assistent]]
