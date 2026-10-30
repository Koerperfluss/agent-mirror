# PLAN — Slice 14–16: Traktor-Pro-4.5-Funktionsabgleich (loki-dev BUILD)

**Ziel:** TraktorClone auf Funktionsparität mit Traktor Pro 4.5 bringen (außer urheberrechtlich gesperrtem Audio-Streaming und Ableton Link [offenes Ticket]).
**DONE-WHEN:** Alle neuen Tests grün · komplette Suite grün · App läuft mit PID · FEATURES.json/STATE.md aktualisiert · Push auf cline/s4sx83cs.

| # | Stufe | Agent | Status | Beweis |
|---|---|---|---|---|
| 1 | Flux Mode + Master-Limiter (Core+Tests) | cavecrew-builder ① | offen | Tests |
| 2 | Pattern Player (Core+Tests) | cavecrew-builder ② | offen | Tests |
| 3 | FX-Ausbau Phaser/Bitcrusher/Gate (Core+Tests) | cavecrew-builder ③ | offen | Tests |
| 4 | 4 Decks C+D (EngineHost+ContentView+AutoDJ) | Director | offen | Build+Tests |
| 5 | Integration UI/Engine | Director | offen | Build+Tests |
| 6 | Gesamtprüfung + Push | Director | offen | PID+Push |

**Aufwand:** ~2–3 h · 3 Subagenten parallel (Budget-Default) + Director. Subagenten schreiben NUR eigene neue Dateien (keine Builds — .build-Kollision, keine UI — Director-Dateien).
