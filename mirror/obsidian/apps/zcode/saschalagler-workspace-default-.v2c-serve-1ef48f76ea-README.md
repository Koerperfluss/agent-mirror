---
app: zcode
quelle: "saschalagler/workspace/default/.v2c/serve/1ef48f76ea/README.md"
stand: 2026-10-10
tags: [spiegel, zcode]
---

# HolDirMehr — 1:1 Replika (Kostenlos-Version)

Nachbau der Website **HolDirMehr.at** („Finde deine Förderungen in Österreich") aus den PDFs in `~/Desktop/öförderugnen/` — **auf Saschas Wunsch ohne jede Zahlung: der komplette Bericht ist frei zugänglich** (Paywall, Checkout und alle €39,99-Bezüge entfernt; Stand 10.10.2026). Statische Web-App, kein Build-Step, kein Backend.

## Starten

- Läuft lokal: **http://localhost:61599/** (Deploy-Server dieser Session)
- Oder direkt: `index.html` im Browser öffnen, oder `python3 -m http.server` im Ordner

## Seiten

| Datei | Original (PDF im Ordner) | Funktion |
|---|---|---|
| `index.html` | „Finde deine Förderungen…" (Landing) | Hero + Freitext-Eingabe, Schnell-Check-CTA, Beispiel-Report-Karten (mit Zoom-Lightbox), Benefits, 3 Schritte, Preisvergleich (€0 statt €39,99), Förderkarten, Stats, FAQ-Accordion, CTA, Footer + Cookie-Banner |
| `check.html` | „Schnell-Check starten (6 Fragen)" | Quiz: Bundesland → Haushalt → Wohnen → Vorhaben (Mehrfach) → Start → Anträge; leitet Antworten an `bericht.html` weiter |
| `bericht.html` | „HolDirMehr — … 2.pdf" (Bericht) | **Freier Bericht**: €-Spanne + Förderanzahl aus Antworten, Chips, Rangliste **ohne Schlösser** — jede Förderung klickbar mit **ausklappbarem Antrags-Plan** (Schritte, Unterlagen-Checkliste, Experten-Tipp), Gratis/Voll-Split und Checkout entfernt |
| `entwickler.html` | „Entwickler & API-Nutzung" | 1:1-Struktur, Zahlungs-/Purchase-Stellen auf Lead-Modell umgeschrieben |

Logik in `assets/app.js` (Förder-Katalog `CATALOG` mit vollständigen Plänen), Design in `assets/style.css`. Fonts: Fraunces + Inter via Google Fonts. Berichts-Beträge sind deterministisch aus den Quiz-Antworten gerechnet (Demo-Daten, kein echter Förderkatalog).

## ⚠️ Vor jedem Livegang zwingend ersetzen

1. **Branding:** „HolDirMehr", Logo, `holdirmehr.at` sind Marken/Identität des Original-Betreibers — eigener Name + Logo.
2. **Testimonials** (Rene, Nicole, Sarah, Noreia, „Fabian Eder, Gründer") = echte Personen des Originals → eigene, echte Kundenzitate.
3. **Rechtstexte:** Impressum, Datenschutz, AGB sind Platzhalter (`href="#"`) — echte Österreich-Rechtstexte (TKG/DSGVO) nötig; Entwickler-E-Mail `hallo@holdirmehr.at` ersetzen.
4. **Förderkatalog:** Die Demo-Beträge/Pläne in `app.js` sind plausible Beispiele — vor echten Nutzer-Angaben durch einen geprüften Katalog ersetzen (Transparenzportal + 9 Landesförderstellen) + Disclaimer prüfen.
5. **Falls doch mal Zahlung** (Original-Modell €39,99): Stripe nur server-seitig (Next.js-Route), Keys niemals client-seitig — Dossier-Empfehlung Feb 2026.
