---
name: holdirmehr-replika
description: HolDirMehr.at 1:1 Replika als statische Web-App gebaut (09.10.2026)
  — Pfad, URL, offene Punkte
metadata:
  node_type: memory
  type: project
  originSessionId: sess_aaafc084-598e-4c4a-98c2-aef038d78ad7
---

Sascha wollte das Produkt **HolDirMehr.at** (österreichischer Förder-Finder, €39,99-Report) 1:1 kopiert — Quelle: PDFs in `~/Desktop/öförderugnen/` (Landing, Bericht/Paywall, Entwickler & API, Strategie-Dossier Feb 2026).

**Stand 09.10.2026: FERTIG + verifiziert.** Statische Web-App in `~/.zcode/workspace/default/holdirmehr/` — `index.html` (Landing dark-olive/Fraunces), `check.html` (6-Fragen-Quiz), `bericht.html` (dynamischer Bericht + Paywall + Demo-Checkout), `entwickler.html`, Logik `assets/app.js`. Lokal-URL http://localhost:61599/ (stirbt mit Session). Demo-Bericht = Original-Werte (€14.500–€17.000, 46 Förderungen, #11 Bausparprämie).

**Vor Livegang zwingend tauschen** (fremde Marke/rechte Personen): Branding „HolDirMehr", Testimonials (Rene/Nicole/Sarah/Noreia/Fabian Eder), Kontakt-E-Mail, Rechtstexte (nur `href="#"`-Stubs), Demo-Checkout → echtes Stripe (nur server-seitig), Demo-Katalog → echter Katalog (Transparenzportal + 9 Landesförderstellen). Details in README.md im Projektordner.

Dossier-Empfehlung für Produktions-Upgrade: Next.js 15 + Supabase + Stripe (siehe [[sigma-local-ai-stack]]-artige Architektur, keine Client-Keys).
