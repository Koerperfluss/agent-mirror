---
app: zcode
quelle: "saschalagler/cli/memories/projects/draft-6633f090-806f-43b4-8b74-ab77685b6b30-d82616270d5c2be3/memory/homebrew-stack-inventory.md"
stand: 2026-10-29
tags: [spiegel, zcode]
---

---
name: homebrew-stack-inventory
description: Saschas Mac Homebrew-Cleanup 29.10.2026 EXECUTIERT — 224→150 Pakete (6 Casks
  + 22 Formeln gelöscht, 62 verwaiste Deps per autoremove). ~10 aktiv (Ollama, Obsidian,
  git, mole, hcom …). Offen: Docker/Hammerspoon/Zen (halb entkoppelt), postgresql-Entscheidung
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
- **29.10. ABEND: LÖSCHUNG EXECUTIERT (GO erteilt, per subagent-driven-development-Verifikation):** Prüf-Subagent bestätigte 27/28 Pakete sauber (0 Prozess, 0 Config, 0 Verbraucher). Flagge browseros-neo = **Namenskollision** (skillshare-Symlink zeigt auf Skill `~/.agents/skills/browseros-neo`, nicht auf die Brew-App) → trotzdem gelöscht. Gelöscht: Casks gologin (blockierende App-Rest-Datei in Caskroom musste manuell weg), maccy, neohtop, browseros-neo, remindian, caskhub + 22 Formeln (mongodb×2, pgvector, openjdk@17, cloudflared, cocoapods, m1ddc, displayplacer, mas, pyenv, exiftool, tectonic, typst, marp-cli, trufflehog, bottom, cpulimit, ios-deploy, xcbeautify, xcodegen, ffmpeg-full, hf) + 62 verwaiste Deps via `brew autoremove`. **Neuer Stand: 10 Casks, 140 Formeln, 33 Leaves.** Beweis: `brew list --cask` danach.
- CaskHub gelöscht; Sascha fragte nach „Einrichten weil sinnvoll" — Empfehlung war NEIN (Paketverwaltung läuft direkt über brew-Terminal). Reinstall: `brew install --cask caskhub`.
- **OFFEN → 29.10. SPÄT ABGESCHLOSSEN:** ①② Docker, Hammerspoon, Zen **komplett entfernt auf Saschas expliciten Befehl** (`brew uninstall --cask docker-desktop hammerspoon zen` + Reste manuell: `~/.docker`, `~/.hammerspoon`, `~/Library/Application Support/Docker Desktop` + zen-Profil, Root-Daemons `com.docker.socket`/`com.docker.vmnetd` aus `/Library/LaunchDaemons`). Beweis: alle Pfade „No such file", launchctl leer. ③ **postgresql@15 bleibt OFFEN** (PATH in `~/.zshrc:7–9`, noch nicht entschieden). **Neuer Gesamtstand: ~147 Pakete** (10 Casks minus 3 = 7: bambu-studio, browseros, flutter, font-noto-sans-cjk-sc, gcloud-cli, obsidian, ollama-app; 140 Formeln).
- Websuche zu „KI menschlicher reden" (29.10.): kein installierbares Skill/Plugin existiert — es sind Prompt-Vorlagen. **ERLEDIGT:** MENSCHI-Regel steht jetzt in `~/.zcode/AGENTS.md`. Siehe [[simple-language-feedback]].
- Lücke bleibt: zsh ohne `EXTENDED_HISTORY` → künftig `setopt EXTENDED_HISTORY` für Nutzungsdaten mit Datum. Siehe [[simple-language-feedback]].
- **29.10. ABSCHLUSSBERICHT:** Per briefmaker (via Read-Workaround, siehe [[loki-skills-location]]) PDF erzeugt: `~/Desktop/Bericht_Homebrew_Aufraeumung_2026-10-29.pdf` (2 Seiten, 148 KB — Kern-Liste, 4 Abschnitte, Screenshot 1, Vorschau via pdftoppm geprüft). Token-Vertändnis geklärt: fehlende Skills ≠ Free-300k-Quota, nur Ordner-Problem.
- **29.10. finalisierte Einteilung (sicher/unsicher):** Behalten trotz 0 History-Treffern wegen indirekter Workflow-Nutzung: ffmpeg, pandoc, qpdf (PDF/Video-Pipelines der Skills), poppler (vorsichtshalber), portaudio (Python-Audio), python@3.11/pipx/coreutils/ripgrep/jq (zshrc-Basis), postgresql@15 (PATH in `~/.zshrc:7–9` verdrahtet — löschbar nur wenn Sascha DB wirklich nie nutzt), skillshare (Skill-System), zoetrope/sqz/render = löschbar (Fremd-Taps, 1–2 Treffer). Mole-Aufräumer hat eigene clean-list unter `~/.config/mole/clean-list.txt`.
- **29.10. FRISCHE SCHLUSSPRÜFUNG (nach Saschas Sammel-Nachricht):** Stand bestätigt — **140 Formeln + 7 Casks = 147** (übrig: bambu-studio, browseros, flutter, font-noto-sans-cjk-sc, gcloud-cli, obsidian, ollama-app); Docker/Hammerspoon/Zen-Reste erneut „No such file"; loki-skills-Plugin-Datei vorhanden. CaskHub-Einrichten nochmal angefragt → Empfehlung erneut NEIN (1× gestartet, nie genutzt; Reinstall `brew install --cask caskhub`). SASCHA NUR NOCH EIN PUNKT OFFEN: postgres-Entscheidung. Bei Sammel-/Zitat-Nachrichten: erst prüfen, was schon erledigt ist — nicht doppelt ausführen.
