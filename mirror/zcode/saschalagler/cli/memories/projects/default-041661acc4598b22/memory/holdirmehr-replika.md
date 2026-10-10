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

**Stand 10.10.2026: VOLLVERSION FERTIG — echter Katalog!** Sascha wollte „gesamte App, alle Förderungen, gratis". Live-Server holdirmehr.at kartiert (Sitemap 1.380 URLs), **1.148 echte Förderungs-Detailseiten gecrawlt** (JSON-LD GovernmentService + `<title>`-Parser) → `data/katalog.json` (1,1 MB; 1.138 mit offiziellem Antrag-Link). Neu: `foerderungen.html` (Suche+Bundesland/Bereichsfilter, verifiziert: „photovoltaik"=28, Wien=137), `foerderung.html?id=slug` (Detailseite), `bericht.html` matcht Quiz-Antworten per Keywords+Bundesland gegen echten Katalog (Wien+Heizung → echte Wiener Programme verifiziert). Crawler `/tmp/holdirmehr_crawl.py` (Mimosa-gefährdet → stdin/stdout-Design, keine Datei-I/O, IP-Check, keine Redirects; Update: Sitemap-Slugs pipen, JSON nach data/katalog.json kopieren). **NUR PRIVAT — Katalog © holdirmehr.at, kein Public-Deploy.**

**Vor Livegang zwingend tauschen** (fremde Marke/rechte Personen): Branding „HolDirMehr", Testimonials (Rene/Nicole/Sarah/Noreia/Fabian Eder), Kontakt-E-Mail, Rechtstexte (nur `href="#"`-Stubs), Demo-Checkout → echtes Stripe (nur server-seitig), Demo-Katalog → echter Katalog (Transparenzportal + 9 Landesförderstellen). Details in README.md im Projektordner.

Dossier-Empfehlung für Produktions-Upgrade: Next.js 15 + Supabase + Stripe (siehe [[sigma-local-ai-stack]]-artige Architektur, keine Client-Keys).

**10.10. ABENDS: ONLINE + personalisiert.** 🔴 **Dauerhaft online: https://foerderungen-sascha.web.app/** (Firebase Hosting, Projekt `foerderungen-sascha`, koerperfluss@gmail.com, Spark gratis; Update: `firebase deploy --only hosting` im Projektordner; ⚠️ LEKTION: firebase_init überschrieb index.html — git restore rettete sie; nach firebase_init IMMER git status prüfen; firebase.json braucht `"site":"foerderungen-sascha"`). Brand neutralisiert → „Meine Förderungen", Testimonials echter Personen + Fabian-Eder-Zitat entfernt, noindex + robots Disallow-all. Personalisiert: Strict „Nur NÖ + Bundesweit" (default AN, behebt Saschas Bug „warum Vorarlberg bei NÖ"), Firmen/Gemeinden default AUS, Profil in localStorage (Quiz speichert → Landing „Mein Bericht"), echte €-Summe im Berichtskopf, Zusatzangaben Beruf/Behinderung, PDF-Druck, katalog.js embedded → Doppelklick-fähig, Desktop-`HolDirMehr-starten.command` (Port 8788). GitHub-Pages SCHEITERT (Koerperfluss-Account: „Actions has been disabled for this user"). Workflow dwfrun-e3a76000 holt Listing-Einträge nach (Ziel 502 NÖ + 533 bundesweit, Original-Angabe) — Ergebnis-Nachdeploy offen.
