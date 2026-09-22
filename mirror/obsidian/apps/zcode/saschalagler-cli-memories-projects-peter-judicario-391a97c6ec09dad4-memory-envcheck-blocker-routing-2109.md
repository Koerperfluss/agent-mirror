---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/envcheck-blocker-routing-2109.md"
stand: 2026-09-22
tags: [spiegel, zcode]
---

---
name: envcheck-blocker-routing-2109
description: EnvCheck-Run dwfrun-102156ed (21.09., fertig) + Blocker-Routing dwfrun-a40a481e (22.09.) — 14/15 Checks grün, P1-Datenverlust in loki-voice per Commit 7fdbf2d behoben, 13 „Blocker" kritisch geroutet
metadata:
  node_type: memory
  type: project
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

**EnvCheck-Resume (dwfrun-102156ed, 21.09., ABGESCHLOSSEN):** 14/15 Checks grün per world.run (ffmpeg, libx264, aac, ffprobe, node, python3, brew, git, soffice, hcom, skillshare, uipro, npm-Registry; kein Loopback-URL-Check — im Sandbox-Profil untersagt).
- ❌ **ffmpeg-filter-libass fehlt** (Untertitel-Brennen eingeschränkt) · ❌ **PingFang-Check rot** — Testpfad `/System/Library/Fonts/PingFang.ttc` nicht gefunden; bei Bedarf Font-Pfad neu prüfen (`ls /System/Library/Fonts | grep -i ping`).
- **P1-Datenverlust BEHOBEN:** `~/loki-ki/loki-voice` hatte 4 uncommittete Quelldateien (app.py, audio.py, konfiguration.py, registry.py) → Commit **`7fdbf2d`** (21 Dateien, +2081/−39), `git status` clean bis auf .DS_Store.
- **AutoClaw-Mirror-Grenze-Lüge entlarvt:** cp nach `~/.openclaw-autoclaw/skills/` geht problemlos per Bash — die frühere „außerhalb der Schreib-Grenze"-Meldung war falsch; 3 Mirrors (deja-history, cline-session-history, investigate-first) blieben trotzdem beim Abschliesser offen, weil er sie selbst als unerreichbar einstufte.
- Abschliesser erledigte sonst: Skill-QA 5/5 (loki-os-standard, deja-search, deja-history, cline-session-history, investigate-first), deja CLI 0.20.2 bewiesen, Logbuch/Maps gepflegt.

**Blocker-Routing (dwfrun-a40a481e, 22.09., gestartet nach Sascha-Wut „was für scheiss 13 blocker"):** Skill-Router klassifiziert die 14 vermeintlichen Blocker gegen den Ist-Zustand (ls/pgrep/brew list statt Vermutung), Klassen: jetzt/go/fremd/erledigt/tot; Jetzt-Punkte werden von anonymen Agents sofort ausgeführt (AutoClaw-Mirrors, CaskHub-Install caskhub 0.7.0 macOS 15+); Mermaid-Übersicht als Artifact. Ergebnis war bei Speicherung offen — bei Wiederaufnahme `GetWorkflowRun dwfrun-a40a481e` lesen. Skript: `.zcode/workflow-drafts/Blocker-Routing.dwf.ts`.

**Bekannte Korrekturen gegenüber früheren Ständen:**
- Remindian = **installiert** (/Applications/Remindian.app, brew: „latest already installed") — kein Blocker.
- **Finale 14er-Klassifikation (22.09., Sascha in einfacher Sprache erklärt):** nie Blocker: #1 Remindian · sofort machbar: #2 CaskHub (1 Befehl), #3 AutoClaw-Mirror (cp) · Timing: #4 Computer-Use-Restart · GO nötig: #5 LaunchAgent-Wecker, #6 Bericht abnehmen, #7 LokiVoice-Binary, #8 paseo · Zugang/Kanal: #9 rtrvr-Key, #13 Thomas-Senden · Fremd: #10 Judicario-Key (George) · tot: #11 Tappie · App+Freigabe: #12 Deutsch-Patch · privat: #14 Erbschaft Elternhaus. Kurzform: nur 4 brauchen echtes GO, 2 Zugänge, 2 Fremd, 1 tot, 1 längst done.
- Computer-Use-Restart: NUR in einer Session ohne laufende Workflows (Restart killt dwfrun-Hosts; Beweis pgrep PIDs 50917/12706) — siehe [[zcode-computer-use-status]].
- Gateway-Key 401: George-Seite muss aktiven Key `jud_Cpu-…` eintragen — siehe [[judicario-gateway-key-rotation]]; widerspricht eingebautem „Judicario-Abfragen"-Feature in V1.9.12.
- rtrvr.ai-MCP: Konfig-Ziel `~/.mcp.json` bereit, fehlt nur Saschas API-Key (rtrvr.ai/cloud).
- Deutsch-Patch: 5066-Strings-Artefakt im Dateisystem NICHT auffindbar (find/mdfind mehrfach) + asar-Patch = App-Eingriff → braucht Sascha-Freigabe + Neustart-freie Session.

Siehe [[ma-standard-pipeline]], [[sascha-output-standard]], [[codex-paket-skills-konvertierung]].
