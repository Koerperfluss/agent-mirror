---
app: zcode
quelle: "saschalagler/plans/plan-sess_415f90b8-06e6-414b-8ea5-c4c65864b581.md"
stand: 2026-09-17
tags: [spiegel, zcode]
---

# PLAN: eBay-Keys scharf schalten + NEU-Preise in alle Vorlagen

**Fakten (bewiesen):** Du hast das **eBay PRODUCTION-Keyset** erstellt (Screenshot): App-ID `SaschaLa-zcode-PRD-2a21ac5d6-a4db7a16` · Dev-ID `ce0ca28e-bf6c-40db-ae5d-6d2fa3a96163` · **Cert-ID ist im Portal maskiert („3-72da")** → muss aufgedeckt werden. Und: „alles NEU" = Gemini-NEU-Preistabelle gilt.

## Schritt 1 — eBay-Keys einschleusen (Env, nie Repo/Chat)
- Prüfen, ob die eBay-Session im CDP-Browser (Port 9223) liegt → wenn ja: `developer.ebay.com/my/keys` öffnen, Auge-Symbol für Cert-ID, Wert auslesen.
- Wenn Session woanders liegt: du klickst das Auge 🖉 neben „Zertifikats-ID" und schickst 1 Screenshot (oder tippst die Zeile ins Terminal: `read -rs C && echo "export EBAY_CERT_ID=$C" >> ~/.zshenv`).
- Schreiben: `~/.zshenv` → `EBAY_APP_ID`, `EBAY_DEV_ID`, `EBAY_CERT_ID` (chmod 600, .gitignore-Check).
- Live-Verify: OAuth client_credentials-Call → Token = Beweis.

## Schritt 2 — NEU-Preise in alle 14 Vorlagen + UEBERSICHT (Summe 1980 €)
| # | Objekt | alt → NEU |
|---|---|---|
| 01 | Web-IO 57631M | 219 € (bleibt) |
| 02 | LOGO! 24R | 49 → **69 € VB** |
| 03 | LOGO! DM8 | 69 € (bleibt) |
| 04 | S7-200 CPU 224 | 89 → **149 € VB** |
| 05 | MOXA E2210 | 129 → **249 € VB** |
| 06 | Nook | 25 → **35 € Fest** |
| 07 | **Beijer E1011** | 299 → **1190 € VB** · Titel + „NEU OVP unbenutzte Lagerware" · Preisvorschlag ab 900 € |
- Anzeigentexte: Zustand auf „NEU/unbenutzt" umgestellt; Beschreibungstexte sauber formulieren („neuwertig, unbenutzt") statt reklamehaft übertrieben — eBay-Käufer reklamieren sonst.
- sync per sed + grep-Verify; QA-Re-Check (Titel-Länge, Preis-Sync) wie zuletzt.

## Schritt 3 — eBay-Listings scharf
- `~/loki-verkaufstool` Server mit Keys neu starten (scripts/start.sh, Port 8077) → eBay-Browse-Preisabfrage live testen (Objekt 01) → Inventor-Listings für alle 7 (Publish nur nach deinem GO).

## Stopp-Regeln bleiben
- **Publish auf eBay = nur mit deinem GO.** Keys nie im Chat/Repo. nichts löschen.

~20 min · Flash-first · Keine Rückfragen außer: falls die Cert-ID nicht holbar ist → 1 Auge-Klick von dir.