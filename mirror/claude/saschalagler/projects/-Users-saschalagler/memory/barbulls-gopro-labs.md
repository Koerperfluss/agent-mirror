---
name: barbulls-gopro-labs
description: "GoPro Labs Setup für Barbulls Wachau (HERO11 Black, Outdoor-Calisthenics-Sportcasts) — Dateien, geprüfte Settings, Token-Fallstricke"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6fbdcc67-257f-4683-923d-59f7da7640e5
---

GoPro Labs Projekt für **Barbulls Wachau** (Calisthenics-Verein, Melk/NÖ, Obmann Sascha Lagler). Ziel: Outdoor-Sportcasts mit HERO11 Black, Labs-Firmware Build **02.32.70**. Aktuell wird **nur draußen** trainiert.

- **Dateien:** `~/Desktop/TO DO /GORPO/` (ACHTUNG: Pfad mit Leerzeichen-Ordner „TO DO " — nicht `~/Desktop/GORPO/`). Enthält `BARBULLS_LEITFADEN.md`, `UPDATE/` (Firmware: CAMFWV.bin, DATA.bin, FWUPD.TXT), Labs-ZIP, PDFs.
- **Firmware-Install:** Ordner `UPDATE` ins SD-Stammverzeichnis kopieren (Videos bleiben, KEIN Formatieren nötig), Kamera einschalten → Auto-Update.
- **QR-Steuerung:** rein optisch, kein Funk. Strings im Customizer https://gopro.github.io/labs/control/custom/ generieren. Kamera piept = akzeptiert.

**WICHTIG — User-Präferenz (NICHT überschreiben):** Sascha will **satte/vibrante Farben (`cG`), scharf (`sH`), 5,3K 16:9 (`r5`, KEIN 8:7/`r5X`), stabiles WiFi** — fertig aus der Kamera, KEIN Grading-Workflow. Flat/Log/8:7/180°-Shutter NICHT vorschlagen (hat er explizit abgelehnt). Bevorzugtes Setting:
`mVr5p30cGsHi8M1w55e2oC0oW1oS1*BITR=120*TUSB=1*WAKE=2*64BT=32000*OWNR="Barbulls Wachau"`

**Akku-Lösung:** USB-C-Powerbank mit Pass-Through (Hero 11 filmt während Laden) + Enduro-Akku + Display-aus (`oS1`). „WiFi an + nie schlafen" frisst Akku → Powerbank Pflicht für MAX-Setting.

(Frühere evidence-based Variante für Grading, falls je gewünscht: `cF`+`sL`+`i4S180`+`r5X` 8:7 — aber NUR auf Nachfrage.)

**Token-Fallstricke (HERO11-spezifisch, sonst Fehler):**
- **Shutter/180°-Regel läuft über den ISO-Token**, NICHT eigene `s`-Befehle (die sind MISSION-only): `i4S180` = ISO max 400 + 180°-Shutter.
- **GP-Log/Cinematic gibt es auf der HERO11 NICHT** (erst ab HERO12) → `cF` (Flat) verwenden, nicht `cL`/`cC`.
- **`*BITR=200` lässt die Kamera abstürzen** (Stresstests) → max. sicher **120 Mbit/s**, braucht Codec HEVC + `b1`. Fallback altes Präfix: `!MBITR=120`.
- `oC0`+`oW1`+`*WAKE=2` lösen das iPhone-Quik-WLAN-Abbruch-Problem (kostet Akku → Powerbank).
- USB-C der HERO11 → iPhone kann NICHT Start/Stop steuern (nur Dateiübertragung).

Separater Verein: [[bar-bulls-firebase]] (Shop/Hub — nichts mit GoPro zu tun).
