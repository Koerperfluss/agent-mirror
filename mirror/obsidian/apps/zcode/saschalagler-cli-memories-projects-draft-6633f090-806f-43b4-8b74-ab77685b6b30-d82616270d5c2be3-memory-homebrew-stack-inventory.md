---
app: zcode
quelle: "saschalagler/cli/memories/projects/draft-6633f090-806f-43b4-8b74-ab77685b6b30-d82616270d5c2be3/memory/homebrew-stack-inventory.md"
stand: 2026-10-29
tags: [spiegel, zcode]
---

---
name: homebrew-stack-inventory
description: Saschas Mac hat 224 Homebrew-Pakete (Stand 29.10.2026) — Audit abgeschlossen:
  ~10 Pakete wirklich aktiv (Ollama, Obsidian, git, mole, hcom …), Rest ohne Nutzungsspuren;
  Löschvorschlag wartet auf GO
metadata:
  node_type: memory
  type: project
  originSessionId: session_e471165b9adf80eda6e42d16256949b0
---

Homebrew-Bestand auf Saschas Mac (aufgenommen 29.10.2026): **224 Pakete** = 208 Formeln (davon nur ~51 echte `brew leaves`, Rest Abhängigkeiten) + **16 Casks**.

Kern-Stack: git/gh, python@3.11 + pyenv/pipx, yarn, openjdk@17+21, dart; iOS-Build (xcodes, xcodegen, xcbeautify, ios-deploy, cocoapods); DBs (postgresql@15, pgvector, mongodb-community); KI (ollama, hf); Media/Docs (ffmpeg, pandoc, marp-cli, typst, tectonic, poppler, qpdf); Mac-Automation (hammerspoon, displayplacer, m1ddc, switchaudio-osx); Security (trufflehog); eigener Stack (hcom, deja-vu, zoetrope, sqz, skillshare).

Casks: Obsidian, Docker Desktop, Ollama-App, gcloud-cli, Flutter, Zen, Maccy, Hammerspoon, Neohtop, Bambu Studio + Löschkandidaten (browseros-neo, gologin, caskhub, remindian).

`brew autoremove --dry-run` war leer (keine verwaisten Deps), 0 Updates ausstehend. Bei Aufräumen: erst `brew uses --installed <name>` prüfen.

**29.10.2026 Agenten-Audit (3 Subagenten: Shell-History-Spuren, System-Verweise, brew-deps-Map):**
- **Wirklich aktiv (Beweis):** Ollama (Agent `com.ollama.ollama` geladen, 7,2 GB Modelle in `~/.ollama`), Obsidian (Vault in `~/Documents`), git/gh (History-Treffer + .gitconfig), mole (52 Treffer + `~/.config/mole/`), hcom (verdrahtet in Kilo+OpenCode-Plugins), deja-vu, Flutter+dart (PATH in zshrc), gcloud-cli.
- **Nie benutzt (0 Spuren):** Formeln cloudflared, cocoapods, m1ddc, mas, pyenv, qpdf, tectonic, trufflehog, mongodb (beide), openjdk@17, cpulimit, bottom, displayplacer u. a. (24 null-Treffer); Apps GoLogin, Maccy, NeoHtop (nie gestartet), browseros-neo (nur gestaged), Remindian (1× Absturz).
- **Kaputt/halb entkoppelt:** Docker (root-Daemons installiert, Docker.app-Bundle fehlt), Hammerspoon (Konfig `~/.hammerspoon/init.lua` da, kein App-Bundle), Zen (Profil 02.10. da, kein App-Bundle). Duplikate: ffmpeg+ffmpeg-full, openjdk@17+@21.
- Alle 48 geprüften Leaves haben **0 Formel-Verbraucher** (`brew uses --installed`) → technisch gefahrlos löschbar.
- **Bekannte Lücke:** zsh hat kein `EXTENDED_HISTORY` → keine Nutzungsdaten pro Befehl. Abhilfe: `setopt EXTENDED_HISTORY`.
- **29.10. CaskHub-Klärung:** CaskHub = grafischer App-Store für Homebrew-Casks (das Menu-Icon „Homebrew · Installiert 224" ist seine Ansicht). Am 05.10. einmal gestartet (`~/Library/Application Support/CaskHub` angelegt, plus Crash-Log), Ordner leer, keine dauerhafte Nutzung. Sicherer Löschkandidat, da Paketverwaltung direkt über `brew` läuft.
- Löschvorschlag liegt vor (`brew uninstall --cask gologin maccy neohtop browseros-neo remindian` + Formel-Liste), wartet auf Saschas GO — nichts gelöscht. Siehe [[simple-language-feedback]].
- **29.10. finalisierte Einteilung (sicher/unsicher):** Behalten trotz 0 History-Treffern wegen indirekter Workflow-Nutzung: ffmpeg, pandoc, qpdf (PDF/Video-Pipelines der Skills), poppler (vorsichtshalber), portaudio (Python-Audio), python@3.11/pipx/coreutils/ripgrep/jq (zshrc-Basis), postgresql@15 (PATH in `~/.zshrc:7–9` verdrahtet — löschbar nur wenn Sascha DB wirklich nie nutzt), skillshare (Skill-System), zoetrope/sqz/render = löschbar (Fremd-Taps, 1–2 Treffer). Mole-Aufräumer hat eigene clean-list unter `~/.config/mole/clean-list.txt`.
