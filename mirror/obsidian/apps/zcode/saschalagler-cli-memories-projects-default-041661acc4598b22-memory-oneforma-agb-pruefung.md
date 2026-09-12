---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/oneforma-agb-pruefung.md"
stand: 2026-09-12
tags: [spiegel, zcode]
---

---
name: oneforma-agb-pruefung
description: 12.09. OneForma/Centific-AGB live verifiziert — AT-kritische
  Klauseln bestätigt; EMPFEHLUNG: JA akzeptieren (4 Spielregeln); Root Cause
  In-App-Ladefehler = 401 nicht eingeloggt (consent-documents-API), Fix: Login
  zuerst
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ada7c3e9-0dea-41df-b07e-18cd66d5ed96
---

OneForma (Centific Global Solutions Inc., Redmond/WA) AGB-Prüfung 12.09.2026: Alle drei Live-Docs von oneforma.com geladen und gegen Saschas Zusammenfassung verifiziert — **Analyse korrekt**, alle kritischen Klauseln wörtlich bestätigt.

**Verifizierte Klauseln (T&C geändert 02.08.2026, Privacy 16.06.2025, GDPR 12.07.2023):**
- Bild-/Namensrechte unbefristet „in jeder Form" + Voll-Schadlosstellung (in AT kaum durchsetzbar: § 78 UrhG, KUG, § 879 ABGB)
- Haftungsdeckel: geringeres aus 2.500 USD / Vergütung letzte 6 Monate
- Gerichtsstand King County/WA; Binding Arbitration gilt textlich NUR für „Services performed within the United States and its territories" → bei Leistung aus Österreich draußen aus der Schiedsklausel, aber im King-County-Gerichtsstand gefangen
- Unterzahlungen binnen 3 Monaten melden, sonst Verzicht; Zahlungsstreit 5 Werktage, „final and binding" nur bei good faith
- KI-GPT-Inhalte ohne explizite Projektfreigabe = Betrug → sofortige Kündigung (für Sascha als AI-Tester kritisch)
- IP = work made for hire, Moral-Rights-Verzicht (in AT unverzichtbar, § 20 UrhG)
- DSGVO-Widerspruch: 2 Verantwortliche — Privacy Policy: Centific Inc. Redmond; GDPR-Klausel: Centific Global Solutions S.L.U. Barcelona (CIF B61227138), Server USA, SCCs + EU-US Privacy Framework, Aufbewahrung 5 J. Profil / 10 J. Steuerdaten

**2 Korrekturen zur Sascha-Analyse:** (1) DSGVO-Kontakt = gdpr@oneforma.com (AEPD), NICHT data_protection@centific.com (nur US-Policy) — bei Rechteausübung an BEIDE schreiben. (2) Schiedsklausel-Scope s.o.

Kontext: In-app-Dokumente im my.oneforma.com-Flow luden nicht („Vereinbarungen konnten nicht geladen werden", Checkboxen disabled) — Live-Versionen auf oneforma.com sind verbindlich; Zustimmung wird mit Zeitstempel+Version protokolliert. Methodik-Note: www.oneforma.com/terms-and-conditions/ & Co. laden per WebFetch wie Marketing-Seite — vollständigen Text via web_reader holen.

**Entscheidung 12.09. (Sascha: „soll ich machen? mach dafür mich"):** Klare Empfehlung **JA, akzeptieren** — OneForma ist legitim (Centific, Payoneer-Auszahlung, keine Anmeldegebühr), ohne Zustimmung kein Zugang, Klauseln US-Standard (Appen/Telus/Outlier ähnlich). 4 Spielregeln als eigentlicher Schutz: (1) KI nur mit expliziter Projektfreigabe, im Zweifel schriftlich nachfragen — größtes reale Risiko als AI-Tester; (2) kein VPN/fake IP; (3) Zahlungen monatlich gegenprüfen (3-Monats-Frist); (4) Gesicht/echten Namen in Projekten meiden wo möglich. Bei Lade-Fehler: Reload, dann Support (oneforma.com/contact-us, bis 3 Werktage); vor Projektannahme Guidelines auf „AI tools allowed" prüfen.

**Root Cause In-App-Fehler 12.09. (live im IAB-Browser reproduziert + verifiziert):** review-policies-Seite zeigt „Couldn't load the agreements" + alle Buttons/Checkboxen disabled, weil `/api/resource/onboarding/v1/consent-documents` (HTTP 200, aber Body) `{"success":false,"code":"401","message":"unauthorized account not logged in"}` liefert — Sascha hatte KEINE Login-Session. KEIN Plattform-Fehler, KEIN VPN/Cache-Problem. Fix: erst [my.oneforma.com/center/login](https://my.oneforma.com/center/login) einloggen, dann review-policies → Docs laden, View klicken, Checkboxen, „Agree and continue". Diagnose-Weg: IAB-Tab → performance.getEntriesByType("resource") filtert die echte Onboarding-API (Rest ist nur Tracking: gtm/facebook/reddit/tiktok/linkedin, Feature-Flags via unleash-prod.oneforma.com).

**Erklär-Session 12.09. (Sascha fragte in einfacher Sprache nach Was/Wie/Sicher/Verdienst):** OneForma = KI-Daten-Nebenjob-Plattform (KI-Training/Bild-Labeling, Suchbewertung, Übersetzen, Audio-Aufnahmen, App-Tests). Realistische Verdienst-Spanne kommuniziert: 3–8 USD/h Einsteiger, 7–15 USD/h Standard, bis 20 USD/h Spezial; **ca. 50–400 USD/Monat** bei Teilzeit. Pro-Aufgabe-Bezahlung (Anfangs langsam), Arbeit nicht immer verfügbar, Auszahlung via Payoneer ca. 10. des Folgemonats. AT-Steuer-Hinweis: Einkommen dem Finanzamt melden, zählt mit anderem Einkommen zusammen (Geringfügigkeitsgrenze ~600 €/Jahr bzw. Jahreseinkommensteuerklärung).
