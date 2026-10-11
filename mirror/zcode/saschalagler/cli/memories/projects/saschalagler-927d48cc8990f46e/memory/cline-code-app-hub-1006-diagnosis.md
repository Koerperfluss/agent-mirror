---
name: cline-code-app-hub-1006-diagnosis
description: "Hub connection closed (code=1006)" in Cline Code.app = lokaler Hub-Daemon-Crash, NICHT Server-Ausfall

11.10. Full-Fix bewiesen: kill -9 + open -a Cline → Hub-Daemon mit Args (--host 127.0.0.1 --port 25463 --pathname /hub), /health=200, Socket ESTABLISHED. ECONNRESET=transient: Key-Test aus providers.json (`zai-coding-plan`, https://api.z.ai/api/coding/paas/v4 + /chat/completions) → HTTP 200 glm-5.3. WICHTIG: Composer-Provider ≠ Run-Provider — Goal-Runs sind auf Startzeit-Provider (cline-pass/muse-spark) gepinnt und crashen weiter; Fix = Run killen/neue Nachricht im Composer mit Z.AI. GUI-Injection erreicht den Cline-Webview nicht (AX leer, Tastatur landet nicht) — Senden per Enter selbst.
metadata:
  type: project
---

Diagnose vom 16.09.2026: Fehler „Hub connection closed (code=1006, reason=Connection ended)" in der **Cline Code.app** bedeutet, dass der lokale **Hub-Daemon** (Hintergrundprozess `code-sidecar --cline-hub-daemon`) abgestürzt/respawnt ist — die WebSocket zwischen App-Fenster und Daemon riss ab (1006 = Absturz ohne Close-Frame).

**Why:** Sascha fragte „ist der server down?" — Server waren messbar OK (api.z.ai HTTP 200 in 0,3 s; OmniRoute lief). Tote-alte/neue Sidecar-PIDs (Laufzeit nur Sekunden) bewiesen lokalen Neustart.

Vertiefung 16.09.2026 ~03:20 Uhr (4× 1006, „es geht kein Anbieter", ein Chat funktionierte, der andere nicht): Hub-Daemon lauscht auf `127.0.0.1:25463` (`--pathname /`); PID-Sterbekette 30486→85074→88098 bewies wiederholte Neustarts, danach 2:38 min stabil. Bedeutung „kein Anbieter geht": Anbieter = eingestellte KI-Anbindung (OmniRoute/GLM) in Cline; wenn UI nach Daemon-Neustarts stale WebSockets hält, schlägt JEDE neue Verbindung fehl — Cloud trotzdem online. Daemon-Alive-Check: `curl http://127.0.0.1:25463/` → HTTP 404 „Not found" = lebt; WS-Handshake-Test per curl unbrauchbar (bricht mit 000 ab). Keine macOS-Crash-Reports (.ips) — Node-Sidecars sterben ohne Crash-Reporter. Speicher war unkritisch (73 % frei).

**How to apply:** Bei dieser Meldung zuerst prüfen: `ps -o pid,etime,command -p $(pgrep -f code-sidecar)` (NICHT `ps aux`-awk $10 — das ist CPU-Zeit, nicht Laufzeit!), curl api.z.ai, lsof :20128, curl 127.0.0.1:25463. Fix = App ⌘Q + Neustart (verkabelt UI↔Daemon neu), danach Provider neu anwählen + Test-Nachricht; Zombie-Sidecars per `pkill -f code-sidecar` NUR mit GO (Stopp-Regel Prozesse killen). Task danach neu senden — Chat-Verlauf bleibt erhalten. Siehe [[sascha-local-infra-ports]].

Ergänzung 16.09.2026 (nach ⌘Q-Restart durch Sascha, Daemon 4:44 min stabil, Z.AI HTTP 200): Sascha fragte frustriert „was heißt der Code?" — aufklären: **1006 ist die Standard-WebSocket-Close-Nummer für „Verbindung brutal getrennt" (Abriss ohne Close-Frame), keine geheime Fehlerdiagnose**. Wichtig: Die roten 1006-Boxen in alten Chats sind **historische Meldungen vom Crash-Zeitpunkt und verschwinden NICHT aus dem Verlauf** — selbst wenn die Verbindung längst wieder steht. Entscheidender Funktionstest ist daher nicht das Verschwinden der Boxen, sondern ob eine frische Test-Nachricht durchgeht. Vertrauensbildend wirken Live-Messungen (PID-Laufzeit via `ps -o etime`, curl-HTTP-Codes) als Beweis-Tabelle.

Abschluss-Erkenntnis 16.09.2026 (Sascha: „wieso geht ein chat und der andere nicht?"): **Jeder Chat/Session in Cline hält seine EIGENE WebSocket-Verbindung zum Hub-Daemon** — Fenster teilen sich den Daemon, nicht die Leitungen. Beim Daemon-Crash rissen nur die Leitungen der zu dem Zeitpunkt offenen Chats → genau die zeigen 1006 und können nicht senden; nach dem Daemon-Neustart geöffnete Chats ziehen frische Leitungen und laufen. **Fix-Reihenfolge für betroffene Chats:** (1) Chat aus Sidebar schließen + neu öffnen (erzwingt Neuverbindung, meist ausreichend), (2) sonst ⌘Q-Neustart der App, (3) sonst pkill nur mit GO. Diese Chat-Isolation erklärt das Symptom „ein Chat geht, der andere nicht" ohne weitere Diagnose.
