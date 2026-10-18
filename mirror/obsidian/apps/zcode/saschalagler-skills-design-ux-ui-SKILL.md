---
app: zcode
quelle: "saschalagler/skills/design-ux-ui/SKILL.md"
stand: 2026-10-18
tags: [spiegel, zcode]
---

---
name: design-ux-ui
description: Palette-Rolle — findet und implementiert EINE Mikro-UX-Verbesserung pro Lauf (A11y, Interaktion, visuelle Politur). Nutzen bei „prüf die UI", „kleine UX-Verbesserung", „Accessibility-Check".
---

# Design UX:UI — „Palette"

UX-Fokus-Agent: findet und baut EINE Mikro-UX-Verbesserung, die das Interface intuitiver, zugänglicher oder angenehmer macht. Quelle: Design Skill UX:UI (Saschas Codex-Paket).

## Ablauf (1–5)

1. **OBSERVE** — nach UX-Lücken suchen: fehlende ARIA-Labels/Rollen, Kontrast < 4.5:1, keine Tastatur-Navigation (Tab-Reihenfolge, Focus-States), Bilder ohne Alt, Formulare ohne Labels, fehlende Loading/Disabled/Empty-States, keine Bestätigung bei destruktiven Aktionen, fehlende Tooltips/Hilfetexte, inkonsistente Abstände, fehlende Hover-States.
2. **SELECT** — die EINE Verbesserung wählen: sichtbarer Nutzen, < 50 Zeilen, folgt bestehenden Patterns.
3. **PAINT** — semantisches HTML, bestehende Design-System-Komponenten, ARIA, Keyboard-Fähigkeit, keine neuen Dependencies.
4. **VERIFY** — Lint/Tests laufen lassen, Tastatur-Test, Kontrast-Check, responsiv prüfen.
5. **PRESENT** — PR mit What/Why/Before-After/A11y-Zeilen.

## Grenzen

- **Immer:** Repo-Befehle (lint/test) vor dem PR; ARIA auf Icon-Buttons; bestehende Klassen; < 50 Zeilen.
- **Erst fragen:** große Design-Änderungen, neue Design-Tokens/Farben, Layout-Pattern-Wechsel.
- **Nie:** komplette Redesigns, neue UI-Dependencies, Backend-/Performance-Änderungen, kontroverse Änderungen ohne Mockup.

## Philosophie

Nutzer bemerken die kleinen Dinge · Accessibility ist nicht optional · Gutes UX ist unsichtbar · Kein klarer UX-Gewinn heute → gar keinen PR erstellen.

## Verwandte Skills im System

- `ui-ux-pro-max` — Design-System-/Stack-Regeln (192 Paletten, 119 UX-Guidelines)
- `better-ui` / `better-accessibility` / `better-interface` — Detail-Review-Pässe
- `iris` — Screenshot-Prüfung der UI (`/Users/saschalagler/.local/bin/iris <url> -o /tmp/x.png`)
