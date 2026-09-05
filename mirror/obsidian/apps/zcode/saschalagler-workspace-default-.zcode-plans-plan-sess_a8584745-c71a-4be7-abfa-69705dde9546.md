---
app: zcode
quelle: "saschalagler/workspace/default/.zcode/plans/plan-sess_a8584745-c71a-4be7-abfa-69705dde9546.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

# Mac-Überhitzungs-Diagnose — Plan (MacBook Air M4 16 GB, passiv gekühlt)

## BLUF — Erster Befund
Dein Mac hat **38 Autostart-Einträge** (17 User-LaunchAgents + 21 System-weite). Auf einem **lüfterlosen** M4-Air erzeugen Docker-Daemon, Ollama-Dienst, PostgreSQL, 8 Adobe-Einträge, doppelte Google-Updater (Keystone) und CleanMyMac eine **Dauer-Grundlast → Chassis heizt vor → jedes zusätzliche Programm pushert in den Thermal-Throttle**. Das ist die heißeste Spur, bevor wir überhaupt die CPU-Last messen.

## Phase 1 — Live-Diagnose (nur lesend)
1. `pmset -g therm` — aktueller Thermal-Pressure-State
2. `top`/`ps aux -r` — wer zieht jetzt CPU? (Verdacht: Docker VM, Ollama, Adobe, mds/Spotlight)
3. `vm_stat` + `sysctl vm.swapusage` — 16 GB RAM voll → Swap = CPU + Hitze
4. `log show --last 2h` gefiltert auf Thermal/Throttle-Events
5. macOS-Version + offene Updates prüfen (`sw_vers`)

## Phase 2 — Altlasten-Audit (die 38 Einträge bewerten)
Tabelle mit **Behalten / Deaktivieren / Löschen** pro Eintrag. Highlights:
| Verdacht | Eintrag |
|---|---|
| Docker-Daemon läuft evtl. ständig | `com.docker.vmnetd`, `com.docker.socket` |
| Ollama-Dienst hält RAM warm | `homebrew.mxcl.ollama` |
| PostgreSQL dauerhaft? | `homebrew.mxcl.postgresql@15` |
| LOKI-Doppelung (Altlast?) | `com.loki.master` **+** `com.loki.v15` (Memory: nur v15 ist kanonisch) |
| Adobe ×8 + Google-Updater ×4 (Keystone doppelt) | Adobe ARM/CCX/GC, `com.google.keystone.*` |
| Nicht mehr genutzt? | CleanMyMac-setapp, Native Access, Oracle Java Updater, Perplexity Comet |

Jeden Eintrag per `launchctl print` prüfbar machen, PID/CPU-Last zuordnen.

## Phase 3 — Beste Prüf-Tools (Quick-Recherche fertig, wird vertieft)
Empfohlener Stack (Quellen: Apple Support, Reddit r/MacOS, AppleInsider):
| Zweck | Tool |
|---|---|
| Hardware-Fehlercheck (kostenlos, eingebaut) | **Apple Diagnostics** (Boot: Power-Taste halten → Cmd-D) |
| System-Report + Altlasten-Finder (gratis) | **EtreCheck** |
| Menübar-Monitor Temp/CPU (gratis, open source) | **Stats** (brew install stats) |
| Temperatur-Spezialist (paid) | TG Pro (~20 $) |
| SSD-Gesundheit | DriveDx |
| LaunchAgent-GUI-Verwaltung (paid) | Lingon |
→ web-research-team-Standardlauf mit Zitaten für den finalen Tool-Report.

## Phase 4 — Sicherheits-Schnellcheck (strix-Regeln: nur eigenes System, nur lesend)
- `com.sascha.*`- und `com.loki*`-Skripte kurz einsehen (Malware tarnt sich gern als LaunchAgent)
- gitleaks-Scan nur falls verdächtige Inhalte auftauchen

## Phase 5 — Report + Handlungsliste
1. **RESEARCH_REPORT.md** mit Befunden + Quellen
2. Priorisierte Fix-Liste: was deaktivieren (Befehle fertig zum Copy-Paste) — **Cleanup selbst nur nach deinem Go pro Eintrag**
3. Apple-Diagnostics-Anleitung für dich (benötigt deinen manuellen Boot-Schritt)
4. Physische Faktoren: dein Cooling-Stand-Kontext (MakerWorld 2679181 / Voronoi-Ständer) — bei fanless M4 sinnvolle Ergänzung, aber erst nach Software-Cleanup bewerten

## Was ich NICHT tue (ohne dein OK)
- Nichts deaktivieren/löschen/deinstallieren
- Keine sudo-Befehle (powermetrics bräuchte dein Passwort — Alternative: Stats-App)
- Keine Einstellungen ändern