---
name: loki-kernel-v17-start-8010-fix
description: LOKI-Kernel startet NUR via macos-app-v17/LOKI_MASTER.py
  (Root-Datei gelöscht); 8010-Bind auf 127.0.0.1 gefixt; LegalOps=Native-App auf
  7070; Dienste starten nicht selbst nach Reboot
metadata:
  node_type: memory
  type: project
  originSessionId: sess_5316e7f8-0549-49d6-9200-73141a1d1f83
---

Stand 20.09.2026, alle Checks verifiziert (status_check CHECKPOINT: CONTINUE, 18 grün, 0 Critical):

1. **LOKI_MASTER.py existiert NICHT mehr im Root `~/loki-ki/`** — Kernel-Start nur via `~/loki-ki/macos-app-v17/LOKI_MASTER.py` (mtime 28.07.). Beide Boot-Skripte (`loki_boot.command`, `LOKI_MASTER_BOOT.sh`) verweisen noch auf den toten Root-Pfad → Startversuch stirbt mit „No such file". Startbefehl: `cd ~/loki-ki && nohup ./.venv_new/bin/python3 macos-app-v17/LOKI_MASTER.py >> logs/fastapi.log 2>&1 &`
2. **8010-Bind gefixt** (Tagesplan-CRITICAL behoben): uvicorn-Zeile 894 in v17-LOKI_MASTER.py von `host="0.0.0.0"` → `host="127.0.0.1"`. Kernel war vorher vom LAN erreichbar ohne Auth.
3. **Dienste überleben Reboot NICHT** (Autostarts 25.08. entfernt, com.loki.legalops.mcp.plist bewusst .disabled seit 07.08.) — nach Neustart manuell: Kernel (s.o.) + `open -a "Native Legal Ops"` (= der 7070-Dienst, NICHT die Plist reaktivieren) + `nohup kanban --host 127.0.0.1 --port 3484 --no-open &`. OmniRoute läuft als LaunchAgent selbst.
4. **Symlink-Rückläufer**: `~/.zcode/skills` füllt sich bei Installer-Nutzung erneut mit Dubletten-Symlinks (20.09.: 20 Stück) → Soll-Zustand: Ordner LEER (Laden läuft via ~/.agents/skills). Fix: nach `~/.zcode/skills.bak-20260920/` verschoben.
5. **config-health.py Zeile 24**: Prüfmuster „Orchestrierungs-Gate" → „STANDARD-SKILLS:START" (der Widerruf vom 18.09. hatte dauerhaften Fehlalarm erzeugt). Alt-Zeile dokumentiert, Backup-cp wurde von Mimosa-Hook geblockt (Bash-Schreibverbot, siehe [[projectlisten-hook-projects-py]]).
6. Git-Repo-Root im Home existiert nicht mehr (Tagesplan N.1 erledigt), Disk 72 GB frei (vorher 42).
7. **20.09. System-Inventur (nachmittags):** Ports UP: 8010 Kernel · 20128 OmniRoute · 11434 Ollama · 3484 Kanban. DOWN-OK laut Audit-Soll: 1234 LM Studio · 9379 LiteRT · 8081 Hub · 5678 n8n · 5173 Flow. ⚠️ **LegalOps-App stirbt nach Minuten** (7070 zweimal binnen 30 Min verschwunden, App-Prozess weg) — Dauerlösung (loki-up.command/Autostart) auf Sascha-Entscheid wartend.
8. Kernel `/api/vault` funktioniert (liest loki_vault Daily_Notes) — der tote Brain-Vault-Pfad (`Desktop/Local AI /loki-ki/Brain`) steht nur in der veralteten CODEX-PAKET-Doku, nicht im Kernel.
9. `dev.mirror.sync` LaunchAgent = sein eigenes agent-mirror-Projekt (mirror-sync.sh alle 600s) — gewollt, dokumentieren. **MongoDB brew-LaunchAgent auf :27017 (PID 845) = Fremdling**, nie Teil des LOKI-Soll — Disable (reversibel) wartet auf Verhör-GO.
10. `~/.env.loki`: nur GEMINI_API_KEY gesetzt; ANTHROPIC/PPLX/DEEPSEEK/MINIMAX fehlen — nur Sascha kann Keys besorgen.
11. **Doku-Alter** (Konsolidierung Ziel): LOKI_SESSION_CONTEXT 20.09 ✓ · SYSTEM_HANDBUCH 01.09 · **LOKI_MASTER_STATUS 08.07 (älteste!)** · SKILL_LANDKARTE + MASTER_TODO 31.08 · LOKI_SYSTEM_INVENTORY 30.07.
12. **Auftrag 20.09:** CODEX-PAKET von Sascha „vergessen" („nur ein Teil des Systems") → Ziel = System-Verhör BATCH + Doku-Konsolidierung (1 Quelle der Wahrheit) + Fix/Test automatisch. Verhör-Runde 1 mit Q1–Q7 gestellt (Q1 loki-up.command Autostart · Q2 LiteRT abhaken · Q3 Mongo disablen · Q4 Atlas-Ingest #5 + Task-Bridge #6 · Q5 qwen2.5-coder:7b statt 14b (16-GB-RAM!) · Q6 Keys abhaken/holen · Q7 alle 3 kanonischen Doku-Dateien auf 20.09) — **Saschas Antworten noch offen**, danach Fix+Test-Zyklen + Doku-Update.

13. **20.09. System-Selbstprüfung als Dynamic-Workflow** gestartet (Sascha via `/workflow` mit 5 Skill-Tags wayfinder/loki-dev/loki-os-health/loki-memory-sync/pruef-team, „prüfe dich selbst"): Run `dwfrun-1359c3bc`, Script `.zcode/workflow-drafts/LOKI.OS-Selbstprüfung.dwf.ts`. Topologie: 5 Parallel-Explorer (Dienste/Clients+Skills/Doku+Memory/Automations+Hooks/Wissen+Kernel) → unabhängiger Prüfer (pruef-team, VETO) → world.run-Gate status_check.sh → Markdown-Bericht (artifact id `system-audit`) mit Q1–Q7 als wayfinder-Tickets.
14. **Workflow-ERGEBNIS (20.09. abgeschlossen, alle 7 Findings von der Prüfinstanz BESTÄTIGT, kein VETO):** 39 Checks, 7 Auffälligkeiten, Gate = CHECKPOINT **ACTION_NEEDED** (LegalOps-DOWN). Neu/über die Inventur hinaus: (a) **OmniRoute :20128 lauscht auf `*`** — derselbe Bind-Bug wie der Kernel vorher, Fix = Bind 127.0.0.1 in der OmniRoute-Config, aber Neustart kann andere Agent-Sessions stören → wartet auf Sascha-GO; (b) **2 tote LaunchAgents**: `com.sascha.omni-check.daily` Exit 2, `com.sascha.toolhub-watchdog` Exit 126 (fehlendes Binary) — Empfehlung disable (reversibel). Bestätigt: LegalOps 7070 wieder DOWN, MASTER_STATUS 74 Tage alt, Mongo nur localhost gebunden, Task-Bridge nur 2 Test-Tasks, Atlas-Ingest fehlt. Nicht geprüft: Claude-Desktop-Gateway (GUI-LevelDB), ZCode-Cron-Automations (App-Scheduler). Sascha wartet auf den einfachen Sprach-Report + „mach alles"-GO; letzte Nachfrage war „erkläre in Menschen-Sprache was du tust" → einfache Alltagsbilder statt Fachwort-Tabellen (siehe [[feedback-einfache-antworten]]).

15. **01.10. Git-Drift in `~/loki-ki`** (Tages-Routine-Risiko-Scan): ⚠️ P1 — Submodul-Pointer `loki-voice` im Parent NICHT verankert (Sicherungs-Commit `7fdbf2d` nur im Submodul, Parent porcelain ` M loki-voice`) → Fix „GO pointer-fix": `git add loki-voice && git commit` im Parent (wartet auf Sascha-GO); ℹ️ P2: `.wayfinder/map.md` uncommittet · **`macos-app-v18/LOKI OS v18.app/…/LOKIOSApp`** (kompiliertes v18-Binary) uncommittet — v18-Build nie ins Git. Details: [[zcode-adhs-automationen]] (Lauf 26).

Verwandt: [[loki-autostarts-orphaned]], [[pruef-team-und-config-health]]
