---
app: cline-code
quelle: "saschalagler/data/plugins/subagents/handoffs/conv_1786940088060_d3gybnt/lokivoice/launcher-setup.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# LokiVoice Launcher (task_0004) — erledigt

- ~/Desktop/LokiVoiceApp/start_loki.sh (+x): Direktstart des Binaries (LS-Umgehung),
  /Applications-Bundle bevorzugt, Desktop-Bundle Fallback, Doppelstart-Sperre
  (pgrep -x LokiVoiceApp + ps-Fallback), Logging nach ~/Library/Logs/lokivoice.log.
- ~/Library/LaunchAgents/com.saschalagler.lokivoice.plist (Vorlage: com.todoapp.launcher.plist),
  RunAtLoad=true, KeepAlive=false, plutil -lint OK.
- Verifikation: Skript rc=0, Log zeigt Doppelstart-Sperre, PIDs 12643/13111 unangetastet.
- Offen: launchctl load -w ~/Library/LaunchAgents/com.saschalagler.lokivoice.plist
  in der echten User-Session ausfuehren (Tool-Sandbox blockt launchctl, 141).
  Oder einfach Logout/Login — Agent laedt automatisch.
- Siehe auch: launchservices/fix-10827-diagnose.md (task_0001 blocked, braucht Root).
