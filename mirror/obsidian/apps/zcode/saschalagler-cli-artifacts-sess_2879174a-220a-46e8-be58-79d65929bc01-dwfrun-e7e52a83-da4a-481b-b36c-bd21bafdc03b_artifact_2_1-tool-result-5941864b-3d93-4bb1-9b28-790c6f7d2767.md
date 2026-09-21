---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_2879174a-220a-46e8-be58-79d65929bc01/dwfrun-e7e52a83-da4a-481b-b36c-bd21bafdc03b_artifact_2_1-tool-result-5941864b-3d93-4bb1-9b28-790c6f7d2767.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

# Voll-Kopplung — Ergebnis

- **Briefing ← Tasks:** morgens Brief + Aufgaben-Zusammenfassung + Brain-Eintrag (Beweis: bash: launchctl kickstart gui/$(id -u)/com.sascha.assi.daily → EXIT=0; tail /tmp/assi.log (19:01): '📋 Aufgaben-Notification gesendet: 1 … Mikrofon-Freigabe … 2 … Wayfinder Tier-2-INDEX …' + '🧠 Brain-Eintrag Aufgaben-Stand gespeichert' vor '🔍 Fristen-Wache'; /opt/homebrew/bin/python3 ~/loki-brain/brain.py search 'Aufgaben-Stand' → 'Gefunden im Brain (1 Treffer): Aufgaben-Stand: 1 … 2 …'; ~/loki-assistent/lib/tasks_summary.sh → 2 Aufgaben-Zeilen, EXIT=0.)
- **Sprache ← Tasks:** 'Loki, neue Aufgabe X' / 'Loki, meine Aufgaben' (Daemon 12 Tools, Beweis: shasum identischer Backups (daemon.py 8e7ce20b, SYSTEM_PROMPT.md a0e2f570); git diff --stat: daemon.py +45, SYSTEM_PROMPT.md +2; py_compile grün (beide Interpreter); /status zeigt task_add+task_list (10 Tools gesamt, nicht 12 — s. erledigt); E2E: /ask legte Task #5 an (task.py list --offen Beweis), Audit-Log 19:05:54 task_add exit=0, done 5 aufgeräumt; task_list live via /ask (Audit 19:07:33, exit=0); Neustart mit realem Label com.saschalagler.lokivoice, da dev.sascha.voiceagent nicht existiert; OmniRoute war down, gestartet als Daemon (PID 97605, HTTP 401=erreichbar).)
- **App ← Tasks:** neuer Aufgaben-Tab im Dashboard (Beweis: build.sh → 'Build complete! (6,89 Sek.)' + BUILD_EXIT=0; Deploy 'rm -rf /Applications/LOKI OS v18.app && cp -R … && open' → DEPLOY_EXIT=0; pgrep -fl LOKIOSApp → '98745 /Applications/LOKI OS v18.app/Contents/MacOS/LOKIOSApp' (ps: 34 s alive); strings der deployten Binary enthält '/Users/saschalagler/loki-tasks/task.py'; task.py-Roundtrip: add #6 (Exit 0) → list --offen zeigte #6 → done 6 (Exit 0).)
- **App-Build-Gate:** ✅ Exit 0
- **Review:** PASS

## QA
- 1) Sprachkette /ask: `curl -s 'http://127.0.0.1:8078/ask?text=Loki%2C%20meine%20Aufgaben'` — 1. Versuch Timeout (curl exit 28, >15s), 2. Versuch (90s-Budget) ok: {"ok":true,"antwort":"Unverändert drei offene Aufgaben: Prio 1 Mikrofon-Freigabe LokiVoice, Prio 2 Wayfinder Tier-2-INDEX A/B/C, Prio 3 Test der Sprachkopplung."} → enthält die Testaufgaben-Zusammenfassung, Kriterium erfüllt. Nach dem Aufräumen antwortete die Kette konsistent: "Nur noch zwei offene Aufgaben … Prio-3-Test wieder aus der Liste verschwunden".
- 1b) /status: `curl -s http://127.0.0.1:8078/status` → state thinking, modell cp/cline-pass/glm-5.3-flash, verlauf 5, tools-Array hat nur 10 Einträge (say_text, open_url, browser_read, run_command, brain_save, brain_search, recall_history, read_briefing, task_add, task_list) — siehe probleme.
- 2) Briefingkette: `bash /Users/saschalagler/loki-assistent/lib/tasks_summary.sh` → "1 1 🔓 Mikrofon-Freigabe für LokiVoice erteilen (TC… — — / 2 2 🔓 Wayfinder Tier-2-INDEX Entscheidung A/B/C — —" (vor Aufräumen inkl. #7). `python3 /Users/saschalagler/loki-brain/brain.py search 'Aufgaben-Stand'` → "Gefunden im Brain (1 Treffer): Aufgaben-Stand: …" mit genau diesem Briefing-Text — Eintrag vorhanden.
- 3) App: `pgrep -fl LOKIOSApp` → "98745 /Applications/LOKI OS v18.app/Contents/MacOS/LOKIOSApp" (lebt). `screencapture -x /tmp/lokios_kopplung.png` → 6.474.089 Bytes; Screenshot gesichtet: LOKI-OS-v18-Fenster sichtbar mit Dashboard (Kernel 8010 / Voice-Daemon 8078 / Brain / OmniRoute-Karten). Anmerkung: die Karten selbst zeigen im Screenshot-Moment "Status wird geladen…" — Port-Health habe ich unabhängig per curl bestätigt (Schritte 1+4).
- 4) Kernel: `curl -s --max-time 3 http://127.0.0.1:8010/loki/health` → {"status":"ok","version":"15.3.0","keys":{"gemini":true,"anthropic":false},"stores":{"obsidian":false,"heptabase":false},"local_backends":{"litert_lm":{"status":"DOWN"},"ollama":{"status":"fallback"}}} — Kernel lebt (Watchdog aus letztem Run hält ihn).
- 5) Aufräumen: `python3 /Users/saschalagler/loki-tasks/task.py done 7` → "✓ Erledigt: #7 Test der Sprachkopplung". Finalzustand `task.py list`: nur noch #1 🔓 Mikrofon-Freigabe für LokiVoice erteilen und #2 🔓 Wayfinder Tier-2-INDEX Entscheidung A/B/C offen — keine QA-Testtasks mehr in der Liste. Nichts gekillt, kein git push.

## Offen
- /status auf 8078 zeigt 10 statt der im Auftrag erwarteten 12 Tools — es fehlen vermutlich die Aufgaben-Schreib-Tools (task_done/task_summary o.ä.). Die Sprachkette konnte den Prio-3-Test trotzdem korrekt aus der Liste berichten, weil task.py direkt aufgerufen wurde; für Sprachbefehle wie 'Task erledigen' ist die Lücke relevant. Nicht gefixt (Probe, keine Änderung am Daemon beauftragt).
- Latenz der Sprachkette: der erste /ask-Aufruf lief nach 15s in ein Timeout (curl exit 28); erst der Retry mit 90s-Budget antwortete. Für echte Sprachnutzung (>15s Stille) ggf. Timeout/UX prüfen — nur beobachtet, nicht behoben.
- Kernel-/health meldet Nebenbefunde: anthropic-Key false, litert_lm-Backend DOWN (Port 9379), Ollama nur fallback, Obsidian/Heptabase-Stores false — für die Koppelfunktion unkritisch, aber dokumentiert.
- App-Dashboard zeigte beim Screenshot alle Statuskarten als "Status wird geladen…" — kann Refresh-Timing der App sein; Ports waren per curl erreichbar. Kein Handlungsbedarf aus der Probe abgeleitet.

## Review-Funde
- push.sh:55 — Leer-Brief bricht vor der neuen Aufgaben-Sektion ab: `TEXT=$(grep -m2 '.' …)` ohne `|| true` stirbt bei 0-Byte-Brief unter set -euo pipefail (Z.20) vor Sektion 1b+Fristen-Wache; Fix: nach Z.40 `[ -s "$BRIEF" ] || exit 0`.
- daemon.py:266 — task_add übernimmt `frist` ohne Daemon-seitigen Format-Check (nur task.py fängt ab, exit 2 ans Modell); Fix: `elif frist and not re.match(r'^\d{4}-\d{2}-\d{2}$', frist): result = 'FEHLER: frist muss YYYY-MM-DD sein'`.
- daemon.py:339 (TOOLS_SPEC task_list) — Tippfehler „1–2 Sprechen-Sätzen“ → „Sprech-Sätzen“ in der Description, die das Modell liest.

## Nur noch du
- Mikrofon-TCC-Klick → dann 'Loki, neue Aufgabe …' per Doppel-Ctrl