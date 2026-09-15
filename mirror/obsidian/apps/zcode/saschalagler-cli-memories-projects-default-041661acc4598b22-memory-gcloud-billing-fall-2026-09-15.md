---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/gcloud-billing-fall-2026-09-15.md"
stand: 2026-09-15
tags: [spiegel, zcode]
---

---
name: gcloud-billing-fall-2026-09-15
description: 15./16.09. Google-Cloud-Billing-Fall — 24,08 € überfällig auf 015D43
  (=Gemini-API-Sperre, 15 Projekte); Reviewer-Revision bestanden; 36-€-Frage GELÖST
  (37,20 € Workspace-Abo 03.09., nicht Cloud); wartet auf Karten-Deckung, dann Zahlung auf GO
metadata:
  node_type: memory
  type: project
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

**Fall (15.09.2026):** Google Cloud/Firebase/Gemini-Billing-Chaos bei koerperfluss@gmail.com — 3 Billing-Konten, Spark↔Blaze-Wechsel, Gemini-API „Suspended Service Tier" (09./10.09.2026). Sascha war im Google-Support-Live-Chat (Agent „christian"), ist herausgefallen, pastete das ganze Transkript hierher mit /feature-dev + control-browser: „erledige alles was nötig ist".

**Verifizierte Fakten aus dem Support-Chat (christian, 15.09. ca. 21:36 MESZ):**
| Konto | Name | Saldo |
|---|---|---|
| `015D43-AC6CDE-D17A3A` | Körperfluss Technologies FlexCo | **1,03 € offen** — laut Support DIE Ursache der Gemini-API-Sperre |
| `0154CD-53DAEA-BD5FB4` | Mein Rechnungskonto | **4,05 € offen** |
| `016C8A-8149F6-D561F7` | Mein Rechnungskonto 1 | **0 €** (Mahnungen 10.06.–09.09. waren alt/bereits ausgeglichen) |

Gesamt offen ≈ **5,08 €**. Google verlangt bei manueller Zahlung oft Mindest-10 € (Überhang = Guthaben).

**Zahlungshistorie (Gmail-Belege):** 1,42 € (01.02.→016C8A), 19,74 € (21.03.→0154CD), 27,99 € (06.05.→015D43), 10,66 € (08.07.→015D43), 19,32 € (15.07.→0154CD); weitere ~35–36 € nie zuordenbar. Karten MC ••1879 + MC ••9784 wurden mehrfach wg. mangelnder Deckung abgelehnt (015D43 suspendiert seit 09.06., Mahnungen inkl. 16.07.+05.09.; Gemini-API-Projekt 709873485696 schon 23.05. wegen Spend-Cap pausiert).

**Betroffene Projekte:** koerperfluss-antigravity, KoerperflussWebfrontendkooper/gen-lang-client-0285074833, andi/gen-lang-client-0795463141, My Maps Project/influential-kit-426111-d4 (alle →015D43); außerdem Koerperfluss Edu-Suite, BARBULLS-App, NerveNav, My Project 61797, Reflect Daily, forerclautad2026. "Nur ~3–5 Projekte wirksam nutzbar" nach Google-Strukturwechsel März/April 2026 (ungeklärt, ob Google-seitig).

**Browser-Operation (15.09., Plan genehmigt, LOGIN FERTIG — Fall NEU untersucht abgeschlossen):** Login lief (Passwort+2FA von Sascha). **Konsolen-Befunde (15.09., 5 Beweis-Screenshots in ~/.zcode/workspace/default/beweis-*.png):**
- **015D43**: NICHT 1,03 € — **24,08 € überfällig** (unbezahlter Kontoauszug 31.08.2026; Dialog wörtlich „Der Zahlungsaussteller hat Ihre Zahlung abgelehnt") + 1,03 € Sept = **25,12 € offen**. Beide Karten (1879, 9784) „Transaktion abgelehnt". **15 Projekte verknüpft** (koerperfluss-antigravity, Edu-Suite, Reflect Daily, „Gemini API", NoVA …). Gemini-API auf Projektebene „Aktiviert", Tier-Sperre hängt an diesem Saldo.
- **0154CD**: gesund — Karte **4280** (12/30) funktioniert, 4,96 € Sept-Nutzung zieht automatisch ein, kein Handlungsbedarf.
- **016C8A**: 0 €, sauber (direkt per URL aufrufbar, auch wenn nicht in der Kontoliste).
- **christians „5,08 €" = FEHLER**: Er las nur den September-Saldo (1,03 €); die Rechnungsliste beweist den offenen August-Auszug. Konsole > Chat.
- **Wichtig:** Google bietet KEINE Guthaben-Zahlung an (Dialog: nur abgelehnte Karte retry ODER andere Zahlungsmethode); Mindestzahlung ~10 €. Ich retrye abgelehnte Karten nie ohne GO.
- **Report:** `~/Desktop/GOOGLE_BILLING_NEUNTERSUCHUNG_2026-09-15.md`
- **Offen:** Sascha muss Zahlungsmethode fikitiv machen (Deckung auf 1879 ODER neue Methode — Kartendaten tippt NUR er), dann klicke ich die 24,08-€-Zahlung und prüfe die automatische API-Reaktivierung (kann Stunden dauern).

**Komplette Landkarte (15.09., Kontoverwaltung aller 3 Konten live geprüft):**
| Konto | Profil | Karte | Projekte |
|---|---|---|---|
| 015D43 „Körperfluss Technologies FlexCo" | Firma (FlexCo-Organisation) | 1879+9784 ABGELEHNT | **15** (koerperfluss-antigravity, Edu-Suite, Reflect Daily, NoVA, „Gemini API"/gen-lang-client-0837965106, TOOLS VERKAUSHUB, FOREDER OPERATIONS, Samuel Analyse, andi×2, Sample Firebase AI App, My First Project, My Project 61797, My Maps, praxis-effort) |
| 0154CD „Mein Rechnungskonto" | Privat | 4280 OK | **3** (forerclautad2026, loki-ki, **KoerperflussWebfrontendkooper**) |
| 016C8A „Mein Rechnungskonto 1" | Privat | — | **0** (leere Hülle) |

**Chaos-Aufklärung (Saschas 3 Kernfragen, 15.09.):** ① 3 Konten = 1× Firmen-Organisation (FlexCo-Registrierung erzeugte 015D43) + 2 private Artefakte — klassisch angewachsen, kein Angriff. ② Projekte verstreut, weil jedes Projekt an das im Erstell-Moment aktive Konto gebunden wurde; **KoerperflussWebfrontendkooper war im Juni laut Support-Historie an 015D43, heute an 0154CD** → Verschiebungen sind nachweisbar (Grund ungeklärt: er/Tool/Google). ③ API-Keys wurden nie umgeschrieben — Keys gehören zu Projekten; neue AI-Studio-Keys erzeugten teils neue gen-lang-client-Projekte, und Spark/Blaze-/Konto-Wechsel änderten deren Limits.

**Aufräum-Plan (wartet auf GO, ich klicke):** ① 24,08 € auf 015D43 zahlen → API-Tiers kommen automatisch. ② 3 Privat-Projekte von 0154CD auf 015D43 umziehen (dort das 867-€-Guthaben). ③ 016C8A leer lassen/später schließen. ④ AI-Studio-Standard-Projekt festnageln gegen neue Streu-Projekte.

**Prüf-Lauf (15.09., Report Abschnitt 8 — Sascha forderte Prüfinstanz/Zweitbeweis):** Da Prüf-Subagenten im Harness blockiert sind, Prüfung als Zweit-Lauf über unabhängige Beweiswege: ① 24,08 € DREIFACH bestätigt (Zahlungsdialog + Rechnungsliste + Transaktionsseite, die wörtlich schreibt: „Monatliche Rechnungsstellung über 24,08 € per Mastercard •••• 9784 abgelehnt. Unzureichende Mittel. M5815659689790147" am 01.09., Grund „Verfügungsrahmen ausgereizt"; „1.–31. Aug. 2026 Endsaldo: 24,08 €"). ② 867,15-€-Credit live auf Gutschriften-Seite belegt („Verfügbar, 100 %", Screenshot) — warum er die Rechnung nicht zahlt: Nutzungsbereich „Bestimmte Nutzung" (nur GenAI-App-Builder/Vertex-Produkte). ③ NEU gefunden: **8,08 € „Google Developer Program premium benefit"-Monats-Credit verfügbar (94 %), Scope „Google Cloud gesamt + Maps"** — dieser dürfte reguläre Cloud-Kosten decken (monatlich neu ~8,5 €). Report jetzt mit Abschnitt 7 (Landkarte) + 8 (Prüf-Lauf), **7 Beweis-Screenshots** in ~/.zcode/workspace/default/beweis-*.png (inkl. beweis-867EUR-guthaben-gutschriften.png, beweis-24EUR-transaktionen-karte-abgelehnt.png, beweis-015D43-rechnungen-24EUR-august.png, beweis-015D43-15-projekte-verknuepft.png).

**Die mysteriösen „35–36 €"-Zahlung (15.09., Report Abschnitt 9 — Sascha: „für was habe ich 36 € vor paar Tagen gezahlt?"):** pay.google.com live geprüft — unter koerperfluss@gmail.com gibt es GENAU **2 Zahlungsprofile**: „Körperfluss - Leben in Bewegung" (ID 1258-5069-0452, **null Transaktionen**) und „Sascha Lagler" (ID 9344-7331-6394, nur Google One 10,99 €/Monat — zuletzt 21.08. — + Workspace Individual 8,99 €/Monat seit 2024). **Keine ~36-€-Zahlung im September bei Google angekommen.** Plausible Auflösung: 24,08 € (Aug) + 10,66 € (Juni-Auszug) = **34,74 € ≈ seine „35–36 €"-Erinnerung** (Summe unbeglichener Auszüge/fehlgeschlagener Zahlversuch, im Kopf als „bezahlt" festgesetzt). Entscheidender Beweis = SEIN Bankkonto (September nach „GOOGLE" belasten durchsuchen) — das kann nur er. Zusatzbefund: Das Zahlungszentrum mahnt **016C8A UND 015D43** (beide via Karte 1879), obwohl 016C8A 0 € Nutzung hat.

**Die „36-€"-PDFs (15.09. spät, Anhang):** Sascha gab 2 PDFs („Gmail - Kontoauszüge 08_2026.pdf" + „Kontoauszüge 08:2026.pdf") — beide per pdftotext durchsucht: Es sind **Gmail-Exports des Sozialhilfe-Schriftverkehrs (BH Melk / Thomas Schauer)**, KEINE echten Sparkasse-Auszüge (die wären nur Anhänge der Mails gewesen und wurden nicht mitexportiert). **0 Google-Transaktionen, 0 Kartenzahlungen drin** → 36-€-Frage weiterhin offen; Beweis kann nur der ORIGINAL-Auszug aus George/Sparkasse liefern (dort nach „GOOGLE" suchen). Nebenbefund: Zahlungscenter mahnt weiterhin beide Konten (016C8A + 015D43) via Karte 1879.

**Prüfinstanz-Revision (16.09. — Reviewer-Agent lief, erster Beweis dass der Subagent-Fix wirkt):** Unabhängiger Reviewer (subagent_type reviewer, 51 s, „PASS mit Auflagen") prüfte den Report advers. Alle 6 Auflagen sofort im Report **Abschnitt 10** umgesetzt: ① 25,12 € = Konsole-Anzeige (Posten-Summe 25,11 € — 1 Cent Rundungsdifferenz, beide Zahlen benannt). ② Christians „5 €" = Summe 1,03+4,05+0 ≈ 5,08 € (fehlte der August-Auszug). ③ Karte-1879-Ablehnung belegt (Screenshot „Transaktion abgelehnt" beider Karten + pay.google-Warnbanner nennt 1879). ④ Alte Fehldeutung „25,12 € Guthaben" jetzt transparent im Report dokumentiert. ⑤ Alle 7 Beweis-Screenshots gelistet. ⑥ Quelle für KoerperflussWebfrontendkooper-Verschiebung = Saschas Support-Transkript. **Offen nur noch:** Bank-Auszug September (36-€-Frage) + Karten-Deckung (dann Zahlung auf GO). Reviewer-Caveat: er konnte PNGs in seiner Umgebung nicht als Bilder lesen (Text-Konsistenz-Prüfung only) — visuelle Zweitprüfung = Sascha.

**Bank-Beweis (16.09., Report Abschnitt 9b — Sascha: „schau doch sind doch am Mac"):** Echte Sparkasse-Auszüge lagen in `~/Desktop/Sozialhilfeneu/`: `kontoauszüge01.06-17.08.pdf` + `AT352025601001229317_2026016.pdf` (Auszug Nr. 016/2026 = 18.08.–31.08., Schluss-Saldo 35,27 €). **ALLE Google-Buchungen Juni–August:** 24,92 € PayPal-Google (04.06.), 1,99 € PayPal (16.06.), **10,66 € GOOGLE CLOUD 9TFZ7N Dublin Karte K2 (08.07. = Manuellzahlung 015D43 ✅)**, **19,32 € GOOGLE CLOUD WDR4X5 (16.07. = 0154CD ✅)**, **32,66 € GOOGLE WORKSPACE_KOERP (01.08.)**, 10,99 € PayPal-Google One (21.08.). **KEINE ~36-€-Zahlung an Google in allen Auszügen.** Plausibelste Erklärungen: ① 32,66 € Workspace (01.08., größte kürzliche Google-Belastung), ② 24,92+10,99=35,91 €, ③ abgelehnter September-Zahlversuch — abgelehnte Abbuchungen erscheinen NIE im Kontoauszug (passt zu „Verfügungsrahmen ausgereizt"). **Lücke:** 1.–15.09. per PDF nicht prüfbar (Auszug 017 kommt erst Ende September) — Live-Check nur Sascha in George-App → Umsätze → „GOOGLE".

**36-€-Frage GELÖST (16.09., Report Abschnitt 9c):** Sascha lieferte den George-Einzelbeleg `~/Desktop/Transaktion_E33B0C22AE9680F8.pdf`: **37,20 € — GOOGLE WORKSPACE_KOERP Dublin, Kartenzahlung (E-COMM, Karte K2) am 03.09.2026 12:40, Valuta 04.09., Status „gebucht"**, Referenz 202562609042ALB-006103AHR7ZC (PDF war bildbasiert → pdftoppm-Render + Vision-Ablesen, pdftotext lieferte leer). Seine Erinnerung war also ECHT (37,20 ≈ 36) — aber das Geld floss ans **Workspace-Abo**, NICHT an Google Cloud. Google führt Workspace/Cloud/One in getrennten Abrechnungssäulen: Workspace-Zahlung tilgt KEINE Cloud-Schuld. Die 24,08 € auf 015D43 bleiben offen; Workspace-Abo bucht weiter monatlich (zuletzt 32,66 € am 01.08., jetzt 37,20 € am 03.09. — Preis offenbar gestiegen).

**Offene Posten-Stand (16.09., Sascha fragte „andere Aufgaben?"):** Alles von Agent-Seite fertig; wartet NUR noch auf Sascha: ① Karten-Deckung + GO für die 24,08-€-Zahlung auf 015D43 (+ danach API-Reaktivierung prüfen), ② GO für Google-Konsolidierung (Projekte umziehen, 016C8A schließen, AI-Studio-Projekt fixieren), ③ GO für Open-WebUI-Autostart (LaunchAgent + Tailscale-Festadresse).

**Lessons:** ① Geld bewegen = immer Stopp-Punkt mit explizitem GO, auch bei „erledige alles". ② Konsolen-Links nie in die Google-Suche tippen lassen (passiert ihm leicht) — direkt öffnen oder anklickbaren Link geben. ③ Sein eigenes Gemini-Gem „Allrounderomni v2" begleitet den Fall parallel mit denselben Fakten — Zahlen mit ihm abgleichen statt konkurrierend zu analysieren. ④ **„Kontostand" auf Google-Billing-Zahlungsseiten = SCHULDEN, nicht Guthaben** (ich habe das falsch gelesen, „25,12 € Guthaben" behauptet und musste scharf korrigiert werden — erst Transaktionen/Rechnungsliste gegenlesen bevor man Geld-Fakten behauptet). ⑤ Support-Agent-Angaben (christian) nie als Wahrheit übernehmen, wenn die Konsole sie widerlegt — Konsole + Screenshots sind die Beweisquelle. ⑥ Playwright-MCP: Eingeloggte Sitzung hält über mehrere Turns; Zahlen auf iframes per browser_find/snapshot-refs lesen, nicht per evaluate (cross-origin). ⑦ Belege liegen meist schon auf dem Mac (Desktop/Downloads) — erst Mac durchsuchen, bevor man den Nutzer nach Dokumenten fragt (16.09. eingemahnt).
