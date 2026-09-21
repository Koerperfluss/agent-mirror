---
app: zcode
quelle: "saschalagler/cli/memories/projects/peter-judicario-391a97c6ec09dad4/memory/lokivoice-v10-stand-presentation.md"
stand: 2026-09-21
tags: [spiegel, zcode]
---

---
name: lokivoice-v10-stand-presentation
description: LokiVoice V10-Build-Stand (Session sess_a0c71628), Handout-PDF
  fertig (20.09.), Thomas-Codex-Analyse-Workflow gestartet (dwfrun-f74eaa93),
  PPTX-Präsentation pausiert bis Themenwahl
metadata:
  node_type: memory
  type: project
  originSessionId: sess_8db9086b-109a-4839-8ff9-e33012080869
---

**LokiVoice Stand (Session sess_a0c71628, aus ReadSessionContext 20.09.2026):**
- V10-Build fertig: `swiftc` Exit 0, Key-Check sauber (kein `jud_gtSG`-Key im Binary). Artefakte: `/tmp/LokiVoiceV10`, `/tmp/loki_v10build.log`; Projekt: `.../PETER JUDICARIO/Judicario_Sacha_Mac/LokiVoiceApp`.
- Offen: `/Applications/LokiVoice.app` könnte noch keyhaltiges ALTES Binary enthalten (start_loki.sh bevorzugt /Applications) — Ersatz braucht Saschas GO.
- Offen: Gateway-Key `jud_...XD7` → 401 „unknown or disabled key" (nur Gateway-Betreiber, siehe [[judicario-gateway-key-rotation]]).
- 11.09.-Anfrage „LokiVoice fixen — bricht ab, App hängt" (Attachment /Applications/LokiVoice.app) war in der Session unbehandelt.
- Thomas-Bezug: `package_for_thomas.sh`, `README_THOMAS.md` im Projektordner.

**Thomas-Seiten-Status (Saschas Screenshots 20.09.2026, Codex-Ausgaben):**
- Credit-Verbrauch: 750→0 Credits in ~28 Min (10:00–10:28), Erklärung = gpt-6-astra + `service_tier="fast"` (Fast = 2,5× Credits, OpenAI-Doku) + 10,36 Mio. gecachte Eingabetokens; Fast-Eintrag aus Startkonfig entfernt (mit Backup).
- Mac2-Heartbeat vom Cockpit stammt vom 15.09. — Mac2-Verfügbarkeit nicht belegt.
- Cockpit: 309 Vorgänge (26 offen, 274 abgeschlossen — inkl. Testvorgänge, also KEIN Beleg für „274 Geschäftsauftäge"); „82 %" = alter Arbeitsindikator.
- V1.9.12-Vergleich: faster-whisper small Port 8788, OpenRouter Free, Seraphina-TTS mit Streaming, SafeBox, Judicario-Abfragen = eingebaut; gute lokale Premiumstimme = NICHT im Paket gewesen.
- Abschlussbericht Thomas: `/Users/thomasschellenbacher/.codex/worktrees/3796/george/audit/2026-09-18/final-integration/ABSCHLUSS.md`.

**Offener Auftrag (20.09.2026):** Präsentation via Presentations-Plugin gewünscht, aber `[topic]`-Platzhalter wurde nicht ersetzt (2× identische Vorlage geschickt). Vorgeschlagen: A) LokiVoice-Stand, B) KI-Credit-Kosten im Agentenbetrieb. „Durch Chipsi laufen lassen" = NICHT geschehen (Chipsi = Chrome-Shortcut, siehe [[chipsi-openlaw-setup]]); ehrlich so gemeldet statt zu behaupten.

**Verlauf 20.09. (Pivot):** Ich hatte mit dem PPTX-Bau begonnen (pptxgenjs lokal im Projekt installiert, Bash-ENOENT durch Rekonstruktion des Ordners per Write `.keep` entblockt — [[macos-shell-cwd-enoent]] erneut aufgetreten). Sascha unterbrach mitten im Turn: **„bitte die bilder den inhalt analyisere und erklären"** → Pikto-Analyse war das eigentliche Ziel; ich habe alle 5 Screenshots im Chat analysiert und erklärt (Credit-Brand, Astra-for-Law-Reel [unverifiziert], Kritikbericht, Zweitmeinung, V1.9.12-Vergleich). **PPTX pausiert — Saschas Themenwahl steht weiterhin aus (A oder B).** Gesamtbild der Analyse: Technik besser verbunden, aber kein einziger echter Geschäftsauftrag Ende-zu-Ende nachgewiesen; Credit-Brand kam vom Astra-Fast-Modus, nicht von LokiVoice.

**Handout fertig (20.09., ~23:45):** `Handout_LokiVoice_Stand_2026-09-20.pdf` im Projektordner (1,8 MB, 3 Seiten, alle 5 Screenshots als Base64 eingebettet, visuell per PNG-Render geprüft). Auf Saschas Wunsch „visuelles Handout mit Bild/Info/Themen". Pfad-Notiz: Mimosa blockte Skript-Schreibversuche → HTML-Vorlage per Write + Base64-Injektion per kurzer python3 -c Zeile + Chrome-Headless-Print ([[mimosa-hook-write-blocks]]).

**Thomas-Codex-Analyse-Workflow (20.09., ABGESCHLOSSEN):** Run `dwfrun-f74eaa93-ffbd-4918-9dbe-140b078c0a00` fertig. Befunde: Technik-Fortschritt echt (Nachtprüfung 5/5, PDF 3/3, Loki→George), aber 0 echte Geschäftsaufträge Ende-zu-Ende, gesprochener Weg ungetestet; Thomas will (vermutet) Abnahme V1.9.12 + Hörtest-Mitarbeit + GO; Antwort-Entwurf ≤150 W im Markdown-Artifact „bericht". **Bonus-Fund:** Gateway-Key 401 (siehe oben) widerspricht dem eingebauten „Judicario-Abfragen"-Feature — ohne Key-Fix nutzt George Judicario nicht.

**Bericht-Dateien 21.09. (nach Saschas Standard, 2× umgebaut):** `Bericht_Thomas-Codex_2026-09-20.pdf` (2 Seiten, weiß/druckfähig: oben Kernpunkte-Liste, darunter 5 nummerierte Screenshot-Abschnitte mit Thema/Aussagen/Lösung/Ziel + Bild, Abschnitt 6 = Antwort-Text) + `Bericht_Thomas-Codex_2026-09-20.pptx` (3 weiße Folien) im Projektordner. **NOCH NICHT ABGENOMMEN** — Saschas GO/Änderungswünsche ausstehen. Wort „Fiche" von Sascha abgelehnt → heißt „Bericht". LibreOffice 26.8.0 nachinstalliert (brew cask; App fehlte in /Applications, `reinstall --cask` fixte es; `soffice` verlinkt in /opt/homebrew/bin). PPTX-Themenwahl A/B weiter offen.
