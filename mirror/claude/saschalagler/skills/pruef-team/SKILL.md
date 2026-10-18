---
name: pruef-team
description: >
  Dispatcher für das LOKI Prüf- und Test-Agent-Team. Use when a ticket/build
  claims "fertig", when setup work was done, or the user says "prüfen",
  "prüfinstanz", "team analyse", "audit". Wählt automatisch die richtigen
  Prüfer und aggregiert zu einem Urteil.
---

# Prüf-Team-Dispatcher (kontrollinstanz — always-on)

## Das Team (10 Agenten, Auswahl nach Kontext)
| Agent | Wann |
|---|---|
| @reviewer | Code/Diff vor Commit (Regeln: karpathy + ponytail, 1-Zeilen-Befunde) |
| @qa-tester | „ist fertig" → Funktionstest mit Beweisen |
| @config-auditor | Setup-Arbeit geleistet oder „Settings greifen nicht" |
| @gate-auditor | Pflicht-Audit NACH jedem Build-Turn (Disziplin, Vetorecht) |
| @cavecrew-reviewer | schneller Code-Check, komprimierter Output |
| @cavecrew-investigator | Faktensuche im Code (read-only, ⅓ Tokens) |
| @explore | breite Codebase-Recherche mit Architerktur-Kontext |
| @code-architect | Design-/Plan-Review (nicht nur Code) |
| @implementer | nur für den Korrektur-Pfad nach VETO |
| @cavecrew-builder | kleine chirurgische Fixes nach VETO |

## Ablauf bei „fertig"/„prüf X"
1. **Klassifizieren:** Was wurde gemacht? (Code / Setup / beides)
2. **Parallel prüfen:** je nach Kontext 2–3 Prüfer in EINER Nachricht dispatchen (z. B. @qa-tester + @gate-auditor + @cavecrew-reviewer; bei Setup: @config-auditor + @gate-auditor). Kein Cap mehr — so viele wie der Task braucht.
3. **Aggregieren:** alle Verdicts einsammeln → 1 Tabelle Prüfer | URTEIL | Befund
4. **Urteil:** mindestens 1 VETO oder FAIL = GESAMT-FAIL mit Korrektur-Pfad → @implementer/@cavecrew-builder fixt → ERNEUT prüfen (gleiche Prüfer).
5. **Dem User:** nur das Gesamturteil + Tabelle. PASS nur wenn alle PASS.

## Eiserne Regeln
- Wer gebaut hat, prüft nicht — Prüfer dürfen keine eigenen Artefakte des Turns reviewen.
- PASS ohne Beweis-Zeile ist kein PASS.
- Nach VETO nie selbst „kurz fixen" und durchwinken — Re-Prüfung ist Pflicht.
