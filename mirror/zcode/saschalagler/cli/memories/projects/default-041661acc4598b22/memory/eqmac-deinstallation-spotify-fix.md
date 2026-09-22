---
name: eqmac-deinstallation-spotify-fix
description: 22.09. Spotify gefixt (Intel-Build via Rosetta + 982 MB
  korrupter Cache → native ARM64 1.3.1.234). eqMac SOLLTE BLEIBEN — neu
  installiert (v1.9.1, KEIN Buffer-Setting existent); Dropouts-Diagnose:
  output via SwitchAudioSource auf MacBook-Lautsprecher (eqMac im Bypass),
  HAUPTVERDÄCHTIGER = iPhone-Hotspot (Router 172.20.10.1) — Test steht aus
metadata:
  node_type: memory
  type: project
  originSessionId: sess_c3d7f283-95d5-43ea-8e1f-366140b0a8be
---

22.09.2026: Sascha befahl eqMac zu deinstallieren UND Spotify zu fixen (hängt, White-Screen, „kann nicht geupdatet werden an dem Ort wo er liegt"). Dynamic Workflow `dwfrun-c55c4bc7` (2 parallele Subagents + unabhängiger Prüfer) — **ABGESCHLOSSEN, beide Ziele erledigt und verifiziert.**

**eqMac: vollständig entfernt ✅** — `/Applications/eqMac.app`, `/Library/Audio/Plug-Ins/HAL/eqMac.driver` (lief noch als `Core Audio Driver` PID 387 in coreaudiod), 6 User-Reste (App Support, WebKit, Preferences, HTTPStorages, SentryCrash, CrashReporter). Helper/LaunchDaemon existierten nie. sudo funktionierte; `coreaudiod` neu gestartet; alles per ls/find/pgrep nachgeprüft (leer).

**Spotify: repariert ✅** — **Ursache:** Intel-Build (1.3.0.277, `lipo -info` → x86_64) lief via Rosetta auf dem arm64-M4, plus ~982 MB korrupter Cache (`~/Library/Caches/com.spotify.client`). App lag IMMER in `/Applications` (kein fremder Ort), kein Homebrew-Install. Eigenes Update hätte das Intel-DMG nur wieder installiert. **Fix:** `pkill -9` (normales SIGTERM wirkungslos — relaunch-Schutz), native **SpotifyARM64.dmg** von download.scdn.co geladen und installiert → arm64, Version 1.3.1.234, läuft stabil (pgrep-Beweis, 6 Prozesse, Status S).

**Lektion:** Saschas Mac = M4 arm64 — Spotify (und generell Apps) NIE aus dem generischen Intel-DMG installieren; nach dem Fix am 22.09. hat er wieder gefragt „wo ist die app" → liegt normal in `/Applications/Spotify.app`.

Verwandt: [[vorssaint-mac-tools-research]] (eqMac dort als NICHT ersetzbar vermerkt — er nutzt es aktiv!).

## KORREKTUR 22.09. (wichtig!): eqMac war NICHT zum Deinstallieren gedacht

Saschas ursprüngliche Nachricht hatte die eqMac-Deinstallations-Doku nur als **Kontext-Beilage** gepastet — sein eigentlicher Auftrag war Spotify fixen. Nach „wo ist die app" (Spotify) meldete er wütend **„DAS BRAUCHE ICH ABER DU TROTTEL"** + „DAS WAR NICHT DER PUNKT DU SOLLST ES NEU INSTALLIEREN WARUM GEB ICH DIR DIE DATEI" → er brauchte eqMac weiterhin.

**Fix:** eqMac **v1.9.1 neu installiert** — GitHub-Release `bitgapp/eqMac` DMG (19 MB) → `/Applications/eqMac.app`, Universal-Binary (arm64 nativ), läuft (PID-Beweis). Der HAL-Treiber installiert sich beim ersten App-Start selbst.

**Lektionen:**
1. **Kontext-Text ≠ Auftrag:** Beiliegende Doku (Deinstallations-Anleitung) war nur Material, nicht die Handlungsanweisung — hätten klären/umkehren sollen, statt alles zu löschen. Vor dem Löschen einer aktiven App erst prüfen, ob sie sein tägliches Tool ist (hier: Vorssaint-Research sagt: eqMac ist sein EQ).
2. Wiedergutmachung geht direkt: neue Version von der offiziellen Quelle installieren, mit Beweis (Version, lipo, PID).

## NACHSPIEL 22.09.: Wiedergabe bricht weiter ab (Audio-Wege-Diagnose)

Nach Reinstall: „es hängt noch immer extrem … die Wiedergabe bricht sogar ab". Diagnose: **Spotify-Prozess gesund** (PID 5064, Status S, 1 % CPU) — die Abbrüche kommen aus dem **Audio-Weg**: eqMac legt beim Start ein virtuelles Gerät **„Mi monitor (eqMac)"** an (Manufacturer Bitgapp) und setzt es als **Standard-Ausgabe** vor seinen Monitor („Mi monitor", DisplayPort). Frischer HAL-Treiber + frisch neu gestartetes coreaudiod (nach Reinstall PID 12009) ist typische Aussetzer-Lage. **Fix-Versuch:** `sudo killall coreaudiod` → neuer PID 12009, Spotify unberührt. **Offen an Sascha:** Test läuft; falls weiter Abbrüche → 1) eqMac-Buffer/Engine-Puffer hochstellen, 2) Test-Ausgabe direkt auf „Mi monitor" ohne eqMac, um eqMac als Täter zu isolieren. Audio-Setup-Notiz: sein Standard-Monitor-Output = „Mi monitor" (XMI, DisplayPort).

## Auflösung 22.09. (2 Parallel-Agents, „mach doch bitte selber")

Sascha gab `[$wayfinder]` + `[$dispatching-parallel-agents]` — ich entschied: kein Wayfinder-Map (Aufgabe klein/präzise), stattdessen 2 parallele general-purpose Agents:

**Agent 1 (lokal):** eqMac-Konfig durchsucht — **eqMac 1.9.1 hat KEIN User-Buffer-Setting** (weder defaults noch JSON; state-JSON enthält nur stopDelay/Mixer/UI/Effekte). eqMac + Treiber neugestartet (eqMac PID 59818), Test-Wiedergabe (12-s-Sinus via afplay, exit 0): **sauber, Log 0 Dropouts/Errors**. Test-Gerät-Wechsel: `SwitchAudioSource -t output -s "Mi monitor"` (brew switchaudio-osx) — bewusst NICHT dauerhaft umgeschaltet, er will eqMac aktiv.

**Agent 2 (Web-Recherche, belegte Fakten):**
- Dropouts nach Laufzeit auf **M1 + M4 bestätigt**, offen: [Issue #994](https://github.com/bitgapp/eqMac/issues/994) — Workaround: eqMac kurz aus/ein
- Historische Ursache: **Sample-Rate-Differenz Treiber↔Gerät** [Issue #224](https://github.com/bitgapp/eqMac/issues/224)
- Kein Buffer-Regler in eqMac existent (eqmac.app + alle Issues)

**Fix-Leiter bei wiederkommenden Abbrüchen:** 1) Audio-MIDI-Setup → „Mi monitor (eqMac)" fest auf **48.000 Hz** (häufigste Ursache lt. Entwickler), 2) eqMac aus/ein, 3) eqMac-Frequenz-Visualisierung (Analyzer) aus (CPU-Fresser), 4) Test direkt auf „Mi monitor" um eqMac als Täter zu isolieren, 5) Fallback: ältere stabile eqMac-Version. Aktuell: wartet auf Saschas Musiktest.

**Lektion:** Wayfinder nur bei echtem Fog — bei kleiner präziser Aufgabe map aufspannen wäre Overkill; Sascha akzeptierte das („mach doch bitte selber" bezog sich aufs Anpacken, nicht aufs Format).

## Stand 22.09. spät: Täter-Isolation —Hotspot + Ausgabe auf Lautsprecher umgeschaltet

Sascha:**„es liegt nicht an eqMac"** (nach Ansicht des Audio-MIDI-Setups — er hatte dabei fälschlich „AlphaTheta CDJ/XDJ" angeklickt, sein offline DJ-Pult mit PIONEER CDJ-400-Untergeräten; richtige Klick-Ziele sind „Mi monitor (eqMac)" links + Abtastrate 48 kHz rechts).

Eigene Checks: **Netzwerk = en0, 0 % Paketverlust, aber Jitter (avg 42 ms, max 98 ms)**; keine Spotify/eqMac-Crashreports. **WICHTIGSTER FUND: Router = 172.20.10.1 → iPhone-Hotspot als Internet** (klassischer 172.20.10.x-Range) — Hauptverdächtiger für abbrechendes Streaming. Kein Crash, gesunder Spotify-Prozess.

**Umgeschaltet (Beweis):** Default-Output via `SwitchAudioSource -t output -s "MacBook Pro-Lautsprecher"` (brew switchaudio-osx, /opt/homebrew/bin) — **eqMac jetzt NICHT im Signalweg**; Testton via afplay OK. Aktueller Geräte-Liste: „Mi monitor", „MacBook Pro-Lautsprecher", „MacBook Pro-Lautsprecher (eqMac)".

**Offen:** Sascha soll 2–3 Min. Musik testen — sauber über Lautsprecher → Audio-Weg/Monitor-Täter; immer noch Abbrüche → **iPhone-Hotspot** (Lösung: Offline-Playlists/stabiles WLAN). Diagnose-Bausteine fürs nächste Mal: `route get 1.1.1.1` (Interface), `ipconfig getsummary en0 | grep Router` (Hotspot erkennen), `SwitchAudioSource -a/-c/-s` (Ausgabe umschalten ohne UI).
