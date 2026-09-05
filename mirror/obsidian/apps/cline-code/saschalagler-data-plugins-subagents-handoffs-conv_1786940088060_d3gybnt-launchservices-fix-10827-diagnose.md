---
app: cline-code
quelle: "saschalagler/data/plugins/subagents/handoffs/conv_1786940088060_d3gybnt/launchservices/fix-10827-diagnose.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# LaunchServices-Diagnose (task_0001)

## Befund
- Bundles /Applications/LokiVoice.app + '/Applications/TODO APP.app' sind korrekt:
  Info.plist plutil-lint OK, CFBundleExecutable vorhanden (+x, arm64 Mach-O), adhoc-Signatur validiert (codesign --verify --deep rc=0).
- open *.app → -10827 kLSNoExecutableErr, reproduziert.
- lsregister -f <app> → "failed to scan: -10822 from spotlight".
- lsregister -dump: DB frisch initialisiert, 0 Bundles, "Seeded System Version: ?" → LS-DB komplett unseeded.
- `open -a TextEdit` schlägt ebenfalls fehl → NICHT bundle-spezifisch.
- mdutil -s /: "Spotlight server is disabled"; mdfind liefert für alles 0 Treffer.
- lsd-App-Discovery hängt an mds → ohne Spotlight-Index keine Registrierung.

## Blocker
- mdutil -i on / braucht Root; sudo im Tool-Kontext kaputt ("you do not exist in the passwd database", dscl → eServerError, launchctl kickstart → 141 Reentrancy).
- lsregister -kill existiert nicht mehr ("-kill option has been removed").

## Fix (aus echter Admin-Shell des Users)
sudo mdutil -ai on && sudo reboot   # re-aktiviert Spotlight, LS-DB wird beim Login neu geseeded
Danach: lsregister -f /Applications/LokiVoice.app && open /Applications/LokiVoice.app

## Workaround aktiv
start_loki.sh (task_0004) startet das Binary direkt, umgeht LaunchServices komplett.
Laufende Prozesse (PID 12643 .build/release, PID 13111 Desktop-Bundle) nicht killen.
