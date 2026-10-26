# TRAKTOR RE-RESEARCH: Native Instruments Ecosystem Analysis

## ⚡ BLUF (Bottom Line Up Front)
Traktor Pro nutzt ein hybrides System aus XML (.nml) und proprietären Binärformaten (.tsi). Moderne NI-Hardware (MK3-Serie) ist weitgehend USB-HID class-compliant, während High-End-Controller (S8/D2) komplexe Framebuffer-Protokolle für Displays nutzen. RE für Interoperabilität ist in AT gemäß § 40e UrhG zulässig.

## 1. TRAKTOR-TECHNOLOGIE: Interna & Formate
*   **.tsi (Traktor Settings Image):**
    *   **Typ:** Binär-Container.
    *   **Inhalt:** Controller-Mappings, GUI-Layouts, Effekt-Konfigurationen.
    *   **RE-Status:** Dokumentiert (Ivan Zhuravlev / DecompHub). Struktur basiert auf Chunks mit Key-Value-Paaren.
*   **.nml (Native Music Library):**
    *   **Typ:** XML.
    *   **Inhalt:** Track-Metadaten, Playlists, History.
    *   **Beatgrids:** Werden als `<TEMPO>` und `<CUE_V2>` Tags innerhalb der XML gespeichert.
*   **Stems (.stem.mp4):**
    *   **Typ:** Open Format (NI-Spec).
    *   **Struktur:** MP4-Container mit 5 Tracks (1x Stereo Mix + 4x Stereo Stems). Metadaten in JSON-Format im `udta`-Atom des MP4-Containers.

## 2. CONTROLLER-PROTOKOLLE: HID & NHL
*   **Hardware-Generationen:**
    *   **MK1/MK2:** Nutzten oft das proprietäre NHL (Native Hardware Layer). Schwerer zu RE, oft via NI Controller Editor in MIDI gewandelt.
    *   **MK3 (S2/S4/X1):** Weitgehend USB-HID class-compliant.
    *   **S8/D2/S5:** HID für Tasten/Fader. Displays nutzen Bulk-Endpoints für Framebuffer-Daten (RE-Referenz: `kontrol-s8-protocol` auf GitHub).
*   **HID Reports:** Typischerweise 12-Bit oder 14-Bit Auflösung für Fader/Pitch, um MIDI-Zipper-Noise zu vermeiden.

## 3. USB-CAPTURE TOOLCHAIN (Linux/Pi)
Um die Kommunikation zwischen Traktor und Controller zu sniffen:
*   **Kernal:** `modprobe usbmon` aktiviert die Monitoring-Schnittstelle.
*   **Sniffing:**
    *   `lsusb` -> Device ID finden.
    *   `wireshark` (Schnittstelle `usbmonX`) für Live-Analyse.
    *   `tshark -i usbmonX -Y "usb.capdata" -T fields -e usb.capdata` für reinen Datenstrom.
*   **Deskriptoren:** `hid-recorder` (aus `hid-tools`) extrahiert den Report-Deskriptor, der definiert, welches Byte zu welchem Element gehört.
*   **Skripting:** `pyusb` zur Automatisierung von Replay-Attacks oder zum Testen von LED-Output.

## 4. AUDIO-SEITE: Interfaces & ALSA
*   **Treiber:** `snd-usb-caiaq` ist der dedizierte Kernel-Treiber für Audio 2/4/8 DJ und Kore Controller.
*   **Class-Compliance:** Neuere Interfaces (Audio 6/10 MK2) nutzen Standard `usb-audio`.
*   **Problemzone:** "Direct Thru" Schaltungen bei Audio 6/10 erfordern oft spezifische Steuerbefehle via ALSA-Mixer, da sie hardwareseitig geroutet werden.

## 5. RE-METHODIK MIT LLM (Workflow)
Das lokale LLM agiert als "Differential-Analyst".

| Schritt | Aktion | LLM Aufgabe |
| :--- | :--- | :--- |
| **1. Baseline** | Capture im Leerlauf | Statisches Rauschen/Keep-Alive identifizieren. |
| **2. Trigger** | Bewege Fader A von 0 auf 100 | Identifiziere Byte-Offset und Byte-Order (Little/Big Endian). |
| **3. Delta** | Vergleiche Trigger-Capture mit Baseline | Erstelle Mapping-Tabelle (z.B. Byte 12 = Fader A). |
| **4. Scale** | Bewege Fader langsam | Bestimme Auflösung (8-Bit vs 14-Bit) und Kurve. |
| **5. Logic** | Teste Shift-Kombinationen | Analysiere Bitmasken für Modifier-Tasten. |

**Best Practice Prompting:** "Hier sind zwei USB-Capture-Pakete (Hex). Paket 1: Standby. Paket 2: Play-Taste gedrückt. Identifiziere das Byte, das den Tastendruck repräsentiert, und gib mir die Bitmaske."

## 6. RECHTLICHES (AT/EU)
*   **§ 40e UrhG (Österreich):** Erlaubt die Dekompilierung und das Reverse Engineering eines Programms ohne Zustimmung des Rechteinhabers, wenn dies zur Gewinnung von Informationen notwendig ist, die zur Herstellung der **Interoperabilität** eines unabhängig geschaffenen Computerprogramms mit anderen Programmen unerlässlich sind.
*   **Einschränkung:** Informationen dürfen nicht für die Entwicklung eines "im wesentlichen ähnlichen" Programms genutzt werden. Der Einsatz für Controller-Mappings oder alternative Treiber ist legal.

---
**Zusammenfassung der Ressourcen:**
- **IvanZ GitHub:** TSI-Dokumentation.
- **Mixxx GitHub:** Referenz-Mappings für fast alle NI-Geräte.
- **Linux Kernel Docs:** `hidintro.html` & `usbmon.txt`.


---

## Zielkorrektur 26.10.2026
RE-Ziel ist die Software Traktor Pro 4 (4.5.0 auf dem Mac), nicht NI-Controller-Hardware. Nachbau unter macOS mit CoreAudio/CoreMIDI/Swift. Siehe ZIEL_UND_HARDWARE.md. Vorhandene Analyse-Dateien: *.tsi in ~/Documents/Native Instruments/Traktor 4.5.0/..., collection.nml.
---

## 7. KONKRETES SETUP SASCHA (verifiziert an echten Dateien, 2026-10-26)

### Hardware-Kette
| Komponente | Rolle | Audio-Schnittstelle |
| :--- | :--- | :--- |
| **Traktor Pro 4.5.0** (macOS) | DJ-Software | nutzt macOS CoreAudio (NI-Treiber optional) |
| **Allen & Heath Xone:32** | analoger DJ-Mixer (2-Kanal) | **KEINE** — rein analog, kein USB |
| **Omnitronic BD-1380 USB** | USB-Plattenspieler (Riemenantrieb) | USB-Audio-Class-Compliant → erscheint als Standard-Gerät |

### VERIFIZIERT an `/Users/saschalagler/Documents/Native Instruments/Traktor 4.5.0/Traktor Settings.tsi`:
- **Format: Plain-XML, kein Binary!** Header: `<?xml version="1.0"?><NIXML><TraktorSettings>`
- Struktur: flache `<Entry Name="Audio.ChannelFX.1.Type" Type="1" Value="0"/>`-Paare (~64 KB)
- Default-Settings/Layout-.tsi-Dateien sind 0-Byte-Platzhalter
- `collection.nml` ebenfalls XML (Bibliothek/Playlists)
- **Konsequenz:** .tsi ist KEIN Reverse-Engineering-Ziel im Binär-Sinn — lesbar mit `xmllint`/Python `xml.etree`. RE-Aufwand verlagert sich auf: (a) Bedeutungsanalyse der Entry-Namen (Semantik), (b) HID/MIDI-Protokolle echter Controller, (c) Strokes/Transients-Binärdaten.

### Audio-Treiber-Ziel (Nutzer-Anforderung: "ALSA-Standardtreiber, der alle Soundkarten kann")
- **ALSA gilt nur unter Linux** (Pi/Spark). Traktor Pro selbst läuft auf macOS/Windows → dort CoreAudio bzw. ASIO.
- Linux-Seite (Pi als Audio-Hub oder eigener DJ-Clone): BD-1380 ist USB-Audio-Class-Compliant → läuft am Pi mit Standard-`snd-usb-audio` **ohne Spezialtreiber**. Xone:32 hängt analog am Ausgang — keine Treiber nötig.
- MIDI-Controller-Mapping: Traktor-.tsi-Mappings sind XML (siehe oben) → per `--task mapping` analysierbar und in eigene CoreMIDI/ALSA-Sequencer-Mappings übersetzbar (`--task codegen`).

### macOS-Clone-Ziel (aus pi_re_client.py SYSTEM_PROMPT)
Ziel ist ein eigener DJ-Clone unter macOS (Swift, CoreAudio, CoreMIDI): Traktor-Settings/.nml als Referenz-Schemata, Qwen generiert Swift-Code via `--task codegen`.
