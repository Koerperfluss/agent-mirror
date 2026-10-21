Sound bei 56 s identifizieren und isolieren (Acid People FLAC)

1. Spektral-Differenz-Analyse: STFT von 48–56 s gegen 56–64 s vergleichen → messen, welches Frequenzband und ob perkussiv/tonal bei 56 s neu einsetzt. Kein Raten mehr.
2. Hörproben: 5 kurze WAVs (je 56–60 s, ~4 s lang, klein): Vollmix + drums-Stem + bass-Stem + other-Stem + vocals-Stem in den Sample-Ordner. Der Nutzer hört rein und nennt die Datei, in der der Sound liegt (oder sagt „Mix").
3. Isolation: aus dem richtigen Stem den neuen Sound freilegen (HPSS und/oder Bandpass je nach Analyse-Ergebnis aus Schritt 1), schrille Synths draußen halten.
4. Loop-Schnitt: Autokorrelation + nahtloser Schnitt wie gehabt, aber NUR der neue Sound, kurze Datei.
5. Ordnung: nur finale WAV(s) sichtbar, Zwischenprodukte in _archiv/.

Venv: ~/.venvs/demucs (librosa + soundfile installiert). Skripte via Write anlegen (Mimosa-Hook blockt .py in Bash).