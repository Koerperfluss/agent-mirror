# HolDirMehr — 1:1 Replika

Nachbau der Website **HolDirMehr.at** („Finde deine Förderungen in Österreich") aus den PDFs in `~/Desktop/öförderugnen/`. Statische Web-App, kein Build-Step, kein Backend.

## Starten

- Läuft lokal: **http://localhost:61599/** (Deploy-Server dieser Session)
- Oder direkt: `index.html` im Browser öffnen, oder `python3 -m http.server` im Ordner

## Seiten

| Datei | Original (PDF im Ordner) | Funktion |
|---|---|---|
| `index.html` | „Finde deine Förderungen…" (Landing) | Hero + Freitext-Eingabe, Schnell-Check-CTA, Beispiel-Report-Karten (mit Zoom-Lightbox), Benefits, 3 Schritte, Preisvergleich, Förderkarten, Stats, FAQ-Accordion, CTA, Footer + Cookie-Banner |
| `check.html` | „Schnell-Check starten (6 Fragen)" | Quiz: Bundesland → Haushalt → Wohnen → Vorhaben (Mehrfach) → Start → Anträge; leitet Antworten an `bericht.html` weiter |
| `bericht.html` | „HolDirMehr — … 2.pdf" (Bericht/Paywall) | Dynamischer Bericht: €-Spanne + Förderanzahl aus Antworten, Chips, Rangliste mit Schloss-Icons, Bausparprämie-Teaser (dritter Schritt unscharf), Gratis vs. Voller Plan, Testimonials, Garantie, Checkout (Widerrufs-Checkbox, Apple Pay/PayPal/Karte/EPS, E-Mail-Gate — **Demo, keine echte Zahlung**) |
| `entwickler.html` | „Entwickler & API-Nutzung" | 1:1-Struktur: Was ist HolDirMehr, Google Ads API, Meta CAPI, Tech-Stack, Datenschutz, Kontakt |

Logik in `assets/app.js`, Design in `assets/style.css`. Fonts: Fraunces (Serif-Display) + Inter via Google Fonts. Berichts-Beträge sind deterministisch aus den Quiz-Antworten gerechnet (Demo-Daten, kein echter Förderkatalog).

## ⚠️ Vor jedem Livegang zwingend ersetzen

1. **Branding:** „HolDirMehr", Logo, `holdirmehr.at` sind Marken/Identität des Original-Betreibers — eigener Name + Logo.
2. **Testimonials** (Rene, Nicole, Sarah, Noreia, „Fabian Eder, Gründer") = echte Personen des Originals → eigene, echte Kundenzitate.
3. **Rechtstexte:** Impressum, Datenschutz, AGB, Widerruf, Rückerstattung sind Platzhalter (`href="#"`) — echte Österreich-Rechtstexte (TKG/DSGVO) nötig; Entwickler-E-Mail `hallo@holdirmehr.at` ersetzen.
4. **Zahlung:** Checkout ist Mock. Echte Zahlungen nur mit eigenem Stripe-Konto (EU) + Server-Route (Keys niemals client-seitig).
5. **Förderkatalog:** Die demo­ratischen Zahlen/Beträge sind frei erfunden — echter Katalog z. B. aus Transparenzportal + 9 Landesförderstellen.

## Nächste Schritte (optional)

- **Next.js 15 + Supabase/Stripe** laut Strategie-Dossier (Feb 2026) für echte Berichte, Zahlungen, Katalog-DB (Supabase RLS).
- Echte Katalog-Pipeline + Förder-KI (Gemini) für personalisierte Berichte.
- Analytics: Plausible (privacy-first), Ads-Tracking nur mit Consent-Banner-OK.
