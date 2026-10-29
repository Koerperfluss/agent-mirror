---
name: homebrew-stack-inventory
description: Saschas Mac hat 224 Homebrew-Pakete (Stand 29.10.2026) — 51 echte
  "leaves" + 16 Cask-Apps; brew autoremove leer
metadata:
  node_type: memory
  type: project
  originSessionId: session_e471165b9adf80eda6e42d16256949b0
---

Homebrew-Bestand auf Saschas Mac (aufgenommen 29.10.2026): **224 Pakete** = 208 Formeln (davon nur ~51 echte `brew leaves`, Rest Abhängigkeiten) + **16 Casks**.

Kern-Stack: git/gh, python@3.11 + pyenv/pipx, yarn, openjdk@17+21, dart; iOS-Build (xcodes, xcodegen, xcbeautify, ios-deploy, cocoapods); DBs (postgresql@15, pgvector, mongodb-community); KI (ollama, hf); Media/Docs (ffmpeg, pandoc, marp-cli, typst, tectonic, poppler, qpdf); Mac-Automation (hammerspoon, displayplacer, m1ddc, switchaudio-osx); Security (trufflehog); eigener Stack (hcom, deja-vu, zoetrope, sqz, skillshare).

Casks: Obsidian, Docker Desktop, Ollama-App, gcloud-cli, Flutter, Zen, Maccy, Hammerspoon, Neohtop, Bambu Studio + Löschkandidaten (browseros-neo, gologin, caskhub, remindian).

`brew autoremove --dry-run` war leer (keine verwaisten Deps), 0 Updates ausstehend. Bei Aufräumen: erst `brew uses --installed <name>` prüfen.

**29.10.2026 Verifizierung:** `brew services list` = leer, keine Ollama/Postgres/Mongo/cloudflared/Docker-Prozesse aktiv — **lief zum Stichtag NICHTS als Hintergrunddienst**. Sascha sagte, er nutze keines der Pakete aktiv. Sichere Löschkandidaten (noch nicht ausgeführt, nur vorgeschlagen): `brew uninstall --cask browseros-neo gologin caskhub` + `uninstall ffmpeg ffmpeg-full && brew install ffmpeg` (Duplikat bereinigen) + `openjdk@17` (doppelt zu @21) + `mongodb-community-shell`. Siehe [[simple-language-feedback]].
