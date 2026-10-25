# Prompt Guidelines: Qwen3 für Reverse Engineering

Für präzise Ergebnisse beim Reverse Engineering (RE) von Traktor-Hardware sind folgende Richtlinien zu beachten.

## 1. Qwen3 Chat-Template

Qwen3 nutzt das ChatML-Format. Das System-Prompt ist entscheidend für die Analyse-Logik.

**Struktur:**
- **System:** Definiert die Experten-Rolle (RE-Profi) und das Ausgabeformat.
- **User:** Enthält die Rohdaten (Hexdump) und den Kontext (z.B. "Ich habe den Jogwheel gedreht").

## 2. Reasoning-Disziplin

RE-Aufgaben sind oft "Zero-Shot" schwierig. Fordere das Modell auf, in Schritten zu denken:
1. Identifikation bekannter Konstanten (z.B. USB-Header).
2. Analyse von Delta-Werten (was ändert sich beim Tastendruck?).
3. Ausschlussverfahren für Checksummen.

## 3. Umgang mit langen Hexdumps (Chunking)

Große USB-Captures können den Kontext fluten.
- **Strategie:** Übermittle nur relevante "Slices" (z.B. 10 Reports vor/nach einem Event).
- **Formatierung:** Nutze Code-Blöcke mit `hex` Syntax-Highlighting für bessere Lesbarkeit.

## 4. Parameter-Empfehlungen für RE

| Parameter | Wert | Grund |
| :--- | :--- | :--- |
| Temperature | 0.1 - 0.2 | Hohe Deterministik für logische Analyse erforderlich. |
| Top_P | 0.9 | Begrenzt Wortwahl auf hohe Wahrscheinlichkeiten. |
| Frequency Penalty | 0.0 | Wiederholungen von Hex-Mustern sind erwünscht. |

## 5. RE-Methodik: Beobachtung -> Hypothese -> Verifikation

Nutze den `pi_re_client.py`, der dieses Format erzwingt.
- **Beobachtung:** "Byte 4 springt von 00 auf 01."
- **Hypothese:** "Byte 4 ist der Status der Play-Taste."
- **Verifikation:** "Drücke die Play-Taste erneut und prüfe, ob Byte 4 wieder reagiert."
