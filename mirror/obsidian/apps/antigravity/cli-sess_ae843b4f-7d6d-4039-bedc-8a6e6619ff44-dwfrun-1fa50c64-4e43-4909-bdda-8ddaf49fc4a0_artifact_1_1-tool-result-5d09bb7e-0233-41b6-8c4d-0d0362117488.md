---
app: antigravity
quelle: "cli/sess_ae843b4f-7d6d-4039-bedc-8a6e6619ff44/dwfrun-1fa50c64-4e43-4909-bdda-8ddaf49fc4a0_artifact_1_1-tool-result-5d09bb7e-0233-41b6-8c4d-0d0362117488.md"
stand: 2026-10-10
tags: [spiegel, antigravity]
---

# TODO & ZIELE — VERKAUFS-HUB (2026-10-10)

**Quellen:** PLAN.md · PROJECT.md · STATUS.md · DASHBOARD-ANALYSE.md · INVENTAR-VOLL.md · Git-Log (heute verifiziert) · REAL-TOOL-ANALYSE · MARKT · SAMMLUNG · HANDOFF-BLUF (Workflow-Arrays).
**Regel:** Nur belegter Stand wird geplant. Unbelegtes/expertisch Geschätztes ist als **unbestätigt** markiert.
**Glossar:** *Tier* = Einstufung A/B/C nach Verkaufsreife · *SSG* = statisch vorgerenderte HTML-Seiten · *adhoc-Signatur* = macOS-Selbstsignatur ohne Apple-Developer-Zertifikat · *Notarization* = Apple-Prüfsiegel, damit Käufer keine Gatekeeper-Warnung (macOS-Sicherheitsabfrage) bekommen · *DSGVO* = EU-Datenschutzgrundverordnung · *MDR* = EU-Medizinprodukteverordnung · *White-Label* = Verkauf unter Marke des Käufers · *Asset-Deal* = Verkauf des kompletten Codes als Ganzes.

---

## 1. Ziele des Projekts

- **5-Phasen-Pipeline** über die komplette Tool-Sammlung: Inventur → Gap-Analyse → Entwicklung → Marktanalyse → Anbieten (PLAN.md:5, PROJECT.md:3).
- **11-Agenten-Backend** (Python, LLM via OmniRoute :20128, glm-first mit Fallback-Kette) bewertet jedes Tool (PLAN.md:5, PROJECT.md:34, 48).
- **Next.js-Storefront** baut Tool-Seiten aus `tools-v2.json` (SSG) und dient als Verkaufs-Showcase (PLAN.md:5, PROJECT.md:50, DASHBOARD-ANALYSE.md:44-46).
- **Gumroad-Listings** je Tool generieren und nach GO hochladen (PLAN.md:5, PROJECT.md:52, 81).
- **Hub als Datenquelle:** `tools-v2.json` ist die kanonische Tool-Liste — ein Ordner ist erst ein Tool, wenn er dort eingetragen ist (INVENTAR-VOLL.md:6).
- **Voll-Transparenz:** 64 Tools erfasst (56 bewertet + 8 Kandidaten), Ghost-Pfade markiert statt geschönt (INVENTAR-VOLL.md:13, Commit b3a2e8a, HANDOFF-BLUF).
- **Verkaufsreife je echtem Tool herstellen:** LICENSE/README/Doku, Notarization, Keys-Säuberung vor jedem Verkauf (INVENTAR-VOLL.md:16-25, HANDOFF-BLUF).
- **Stopp-Regeln einhalten:** Gumroad-Publish, Storefront-Deploy und `git push` brauchen je ein User-GO (PLAN.md:46-48).

---

## 2. UMGESETZT

| # | Baustein | Stand | Beweis |
|---|---|---|---|
| 1 | Pipeline-Scaffold (S2): `pipeline/`, `storefront/`, `listing/` | ✅ | PLAN.md:21; Start-Befehle auf alle 3 Module in PROJECT.md:9-23 |
| 2 | Schema-Migration v2 (S3) → `tools-v2.json` | ✅ 48 Tools (A:3 B:10 C:35), inzwischen 56 bewertet | PROJECT.md:47; DASHBOARD-ANALYSE.md:8; `ls tools-v2.json` heute = existiert |
| 3 | Agenten-Backend: 11 Agenten + Runner (OmniRoute-Fallback-Kette, A11-Retry) | ✅ | PROJECT.md:48, 34 |
| 4 | Pilot-Bewertung Tier A (S5): 3 Tools × 11 Agenten, 33 echte LLM-Calls | ✅ | PROJECT.md:49, 56-63 |
| 5 | Voll-Bewertung aller bewertbaren Tools | ✅ 56/56 = 100 % | DASHBOARD-ANALYSE.md:8, 43; Commit `455a4a5` |
| 6 | Storefront + Dashboard + FastAPI-Backend-Spec | ✅ 56 Tool-Seiten, Dashboard mit Tier-Bars + Pipeline-Status | DASHBOARD-ANALYSE.md:43-46; Commits `3c0c684`, `79c461a`, `713cc2f` |
| 7 | Listing-Texte (S8) | ✅ generiert je Tool (mehr als die 3 Tier-A) | PROJECT.md:52; `ls listing/` heute: ≥10 .md (u. a. agent-mirror.md, ai-3d-druck.md); Commit `455a4a5` |
| 8 | Inventar-Voll-Scan 5 Zonen | ✅ 64 Tools gesamt, 8 neue Kandidaten in der Liste | INVENTAR-VOLL.md:13, 27-38; Commit `c595bca` |
| 9 | PATH-AUDIT (Ghost-Bereinigung) | ✅ 52 Phantom-Pfade markiert (dev_status=ghost) — nur 12 Tools real | Commit `b3a2e8a`; HANDOFF-BLUF: 21 auditiert, 13 ai_studio-Fragmente = Ghost |
| 10 | Dashboard-Render-Fix (statisch, crash-frei) | ✅ | Commit `713cc2f` |
| 11 | Firebase-Fix dokumentiert | ✅ Dokumentation da, **Redeploy fehlt noch** (→ OFFEN #14) | `ls pipeline/FIREBASE-FIX.md` heute = existiert; DASHBOARD-ANALYSE.md:57 |
| 12 | Real-Tool-Analyse (dieser Workflow): 12 Tools mit Einzelbeweisen verifiziert | ✅ Stand je Tool: 4× läuft, 1× leergestellt, 6× Prototyp, 1× leergestellt (Chipsi) | REAL-TOOL-ANALYSE-Array (Beweis-Feld je Tool) |
| 13 | Markt-/Preis-Analyse Top 5 | ✅ Kanal+Preis je Tool; **Preise = Vorwissen-Anker, unbestätigt** (WebSearch 429) | MARKT-Array, Feld `kanal` nennt die 429-Begründung je Zeile |
| 14 | Neue-Funde-Scan: 13 Kandidaten mit Pfaden + Verkaufs-Signalen | ✅ | SAMMLUNG-Array (Beweis-Feld je Fund) |
| 15 | Storefront-Firebase-Export lokal aktualisiert | ✅ lokal; **Live-Deploy alt** (→ OFFEN #14) | Git-Status heute: `storefront/out-firebase/*` modified; DASHBOARD-ANALYSE.md:57 |

**Nicht umgesetzt (Aus PROJECT.md):** S9 Jules-Key-Validierung ⛔ 3× 401 (PROJECT.md:53).

---

## 3. OFFEN

Zuständigkeit: **Subagent** = delegierbar · **Du** = braucht dich (GO, Zertifikat, Kontakt, Entscheidung).

| # | Aufgabe | Blocker | Zuständigkeit | Aufwand |
|---|---|---|---|---|
| 1 | Live-Verifikation Hub (Backend :8055 + Storefront :3300 heute starten) | STATUS.md:7-9 zeigt ⏳; Laufstatus heute nicht geprüft (**unbestätigt**) | Subagent | S |
| 2 | OmniRoute: API-Keys-Logik säubern (White-Label-Vorbereitung) | Keys-Logik enthält persönliche Credentials (INVENTAR-VOLL.md:31); Port 20128 beim Prüfzeitpunkt ohne Listener (REAL-TOOL-ANALYSE omniroute) | Subagent | M |
| 3 | Native Legal Ops: ~~Source-Repo auffinden~~ **gelöst/nachkorrigiert** — Repo gefunden und heute per `ls` verifiziert: `/Users/saschalagler/Desktop/Coworkspace_Ich/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/NativeLegalOps` (NativeLegalOps.xcodeproj + „NativeLegalOps 2.xcodeproj", 2 .app-Bundles, Package.swift, Sources, Tests; `find -name '*.swift' \| wc -l` → 36). Der REAL-TOOL-ANALYSE-Befund „nur .app-Bundle, kein Source/Build-Setup" bezog sich nur auf den Desktop/Applications-Ordner (siehe HANDOFF-ANALYSE §2/§4, nachkorrigiert) | Rest läuft über OFFEN #4 (Doku/LICENSE) + #5 (Notarization) | Subagent | S |
| 4 | Native Legal Ops: Produktdoku + LICENSE + Verkaufsvereinbarung | Doku fehlt (INVENTAR-VOLL.md:34) | Subagent | S |
| 5 | Notarization + sauberes DMG für LokiVoice & Legal Ops | adhoc-Signatur → Gatekeeper-Warnung beim Käufer; Apple-Developer-Zertifikat nötig (REAL-TOOL-ANALYSE judicario + native-legal-ops) | Du (Zertifikat) + Subagent (DMG-Skript) | M |
| 6 | Judicario LokiVoice: Käufer-README, Fallbezüge (Thomas/Peter) entfernen | Fallbezogene Personalisierung im Produkt (REAL-TOOL-ANALYSE judicario) | Subagent | S |
| 7 | agent-mirror: Produktdoku statt Lovable-Boilerplate, LICENSE, Tests, DSGVO-Klärung | Boilerplate-README, kein lokales .git, Datenschutzfrage offen (REAL-TOOL-ANALYSE agent-mirror) | Subagent | M |
| 8 | 3d.-UPGRADE-: lokalen Clone ziehen, Vertriebs-README, Backend-Kostenklärung | Repo nur auf GitHub, nicht lokal; MIT-Lizenz macht Einzelverkauf schwer (REAL-TOOL-ANALYSE koerperfluss-3d) | Subagent | M |
| 9 | Paraletts/BarBulls: Checkout/Payment + eigenes Repo | Nur statische Site ohne Payment, kein Git (REAL-TOOL-ANALYSE paraletts) | Subagent | M |
| 10 | IRIS-AI: Copyright-/Lizenzklärung | Copyright bei Drittanbieter Harsh Pandey (Source-Available) blockiert Weiterverkauf (REAL-TOOL-ANALYSE iris-ai) | Du (Kontakt/Entscheid) | L |
| 11 | Chipsi: Produktklärung (was genau verkaufen?) + Backend-Crash beheben | Backend 100 % Crash (Prüfbericht); abhängig von Marinus/Reinhard (REAL-TOOL-ANALYSE chipsi) | Du | M |
| 12 | Bewertungslauf für die **8 INVENTAR-Kandidaten** starten (`python3 pipeline/runner.py`) — gemeint sind die 8 aus dem 5-Zonen-Scan (INVENTAR-VOLL.md:13/27-38, Commit `c595bca`), **nicht** die 8 „unklar"-Funde aus HANDOFF §7; gemäß §6 (Zeile agent-os-stack: „Bewertungslauf entscheidet über Tier") fließen zusätzlich die 2 §6-Ja-Funde (agent-os-stack, mywhoop-go) in denselben Lauf ein | User-GO nötig (INVENTAR-VOLL.md:43-44) | Du (GO) → Subagent | M |
| 13 | Jules-Key neu generieren (S9) | 3× 401 (PROJECT.md:53) | Du | S |
| 14 | Firebase-Redeploy der Storefront | Web zeigt alten Stand (DASHBOARD-ANALYSE.md:57); Deploy-GO (Stopp-Regel PLAN.md:47) | Du (GO) → Subagent | S |
| 15 | Gumroad-Upload der Listings | Publish-GO (PROJECT.md:81, Stopp-Regel PLAN.md:47) | Du | S |
| 16 | Tier-C-Priorisierung (35 Tools: bewerten oder nur Status-Liste) | Nutzwert-Filter fehlt (PROJECT.md:90) | Subagent | M |
| 17 | Marktpreis-Validierung der Top-5-Preise nachziehen | WebSearch war 429 → alle Preise sind Vorwissen-Anker (**unbestätigt**, MARKT-Array) | Subagent | S |

---

## 4. Bis verkaufsfertig — je echtem Tool (aus REAL-TOOL-ANALYSE, 12 Tools)

Reihenfolge = Blocker-Aufwand × Cashflow-Wert (Abschnitt 5). Aufwand = Gesamt bis verkaufsfertig.

| Pos | Tool | Lücken bis verkaufsfertig | Aufwand |
|---|---|---|---|
| 1 | **paraletts-3d-shop** (Bar Bulls, läuft) | Checkout/Payment einbauen, eigenes Git-Repo, README/Tests; 3mf-Extractor als Konfigurator verpacken | **M** (Site selbst steht bereits — schnellster Abschluss) |
| 2 | **native-legal-ops** (läuft) | ~~Source-Repo auffinden~~ → gefunden (`…/THOMAS - CHIPS JUDICARIO/THOMAS - CHIPS JUDICARIO /Legal_Ops_Zentrale/NativeLegalOps`, 36 .swift-Dateien, OFFEN #3); Doku (INVENTAR-VOLL.md:34), LICENSE/Verkaufsvereinbarung, Notarization | **M** |
| 3 | **judicario-loki-voice** (läuft) | Notarization + DMG, Käufer-README/LICENSE, Fallbezüge (Thomas/Peter) entfernen | **M** |
| 4 | **agent-mirror** (läuft) | Produktdoku statt Boilerplate, LICENSE, Tests, DSGVO-/Datenschutz-Klärung, Git-Anbindung | **M** |
| 5 | **omniroute** (leergestellt zum Prüfzeitpunkt) | API-Keys-Logik säubern (INVENTAR-VOLL.md:31), Start-/Daemon-Doku, Release-Verpackung, mehr Tests | **M** |
| 6 | **koerperfluss-3d-v2-upgrade** (Prototyp, nur auf GitHub) | Lokalen Clone, Vertriebs-README/Landing-Page, Backend-Kostenklärung, Demo-Daten, Lizenz-Strategie (MIT!) | **M** |
| 7 | **iris-ai** (Prototyp) | **Lizenzklärung Copyright Harsh Pandey (harter Blocker)**, Tests stark erweitern (nur 2 Dateien), eigene Doku/Branding | **L** (blockiert) |
| 8 | **koerperfluss-pilot-ai** (Prototyp) | Scope-Klärung (Fördercockpit ≠ AI-Studio-Prototyp), aktueller Build/Deploy, README/Lizenz, Tests/Demo | **M** (nur als Bundle) |
| 9 | **loki-os-app-v18** (Prototyp) | LICENSE, Tests, Notarization/DMG, Entkopplung von LOKI-Interna (Brain-Pfade, OmniRoute) | **L** — nur als LOKI.OS-Suite sinnvoll |
| 10 | **auto-sync-save** (Prototyp) | Sync-/Backup-Logik fertigstellen, eigenes Git, LICENSE, Produktdoku statt Boilerplate, Tests | **L** |
| 11 | **chipsi** (leergestellt, 0 EUR einzeln) | Produktklärung (Webapp? Wrapper?), Backend-Crash (100 %, abhängig von Marinus/Reinhard), LICENSE/README | **M** (wartend auf Klärung) |
| 12 | **loki-dashboard-app** (Prototyp, 0 EUR/Baublock) | ALLES: Features, Doku, LICENSE, Git, Tests — Build unverifiziert | **L** → zurückstellen |

**Gesamt-Reihenfolge:** 1→6 zuerst (max. 4–6 Wochen, siehe Abschnitt 5 WANN); 7 wartet auf Lizenzklärung; 8–12 nachgelagert bzw. zurückgestellt. Hinweis HANDOFF-BLUF: vor der PATH-Audit-Korrektur galten nur 4 Tools (OmniRoute, IRIS, LOKI.OS v18, Native Legal Ops) als real verkaufstauglich — die neuere Real-Tool-Analyse belegt 12 echte Projekte mit Detailbefunden; Prototypen bleiben Prototypen bis die Lücken oben geschlossen sind.

---

## 5. Vermarktung je Top-Tool (aus MARKT)

⚠️ **Alle Preise sind Vorwissen-Anker (WebSearch 429, unbestätigt)** — vor Upload Validierung nachziehen (OFFEN #17). Reihenfolge = Cashflow-Wunschreihenfolge.

| Reihenfolge | Tool | WAS verkaufen | WO (Kanal) | WIE (Preis/Listing) | WANN (Timing) |
|---|---|---|---|---|---|
| 1 | **paraletts-3d-shop** | Fertige Bar-Bulls-Shop-Site als Kundenprojekt + monatliche Betreuung | b2b_direct — Direktverkauf an den vorhandenen Kunden (Site steht: deploy/index.html „BAR BULLS … Parallettes", 297 MB) | **249 € einmalig (Shop-Bau) + 29 €/Monat** Hosting/Betreuung; alte SaaS-Empfehlung 149/449 €/Monat (listing/paraletts-3d-shop.md) ist ohne Checkout nicht haltbar | **Sofort (Woche 1)** — kein Signier-/Lizenz-Blocker, nur Payment → schnellster Cashflow |
| 2 | **native-legal-ops** | Einmallizenz macOS-App (Legal-Nische, 100 % lokal-DSGVO-Argument vs. CoCounsel ~100–150 USD/Nutzer/Monat, Harvey ab ~100k USD/Jahr) | b2b_direct — LinkedIn + Netzwerke an DACH-Kanzleien (DSGVO-Argument zieht nur im Vertrauenskanal) | **999 € Einmallizenz pro Kanzlei**, Upsell Team 2.490 €/Jahr; 101/110 E2E-Tests (Prüfbericht 02.10.2026) als Reife-Beweis im Listing; über listing/legal-ops.md:19 (499 €) | **Woche 1–2** — Kontakte ab jetzt, Verkauf nach Doku/LICENSE (OFFEN #3/#4) |
| 3 | **judicario-loki-voice** | Einmallizenz Voice-/Legal-Tool als günstiger Dragon-Legal-Ersatz (Anker 600–900 €) | b2b_direct — Kanzlei-Direktverkauf | **299 € Einmallizenz pro Nutzer**; 54/54 Unit-Tests grün (Prüfbericht 02.10.2026); Listing erst nach Notarization + DMG (sonst Compliance-Blocker, listing/judicario-loki-voice.md:19) | **Woche 2–4** — nach Notarization (OFFEN #5/#6) |
| 4 | **agent-mirror** | Team-Abo Dev-Docs-Sync (10-Minuten-Loop, läuft: HTTP 200 auf Cloud Run) | b2b_direct — Dev-Teams/DevTool-Anbieter; SaaS-Marktstandard 49–199 €/Monat | **79 €/Monat (Team-Abo, Einstieg)** zwischen alten Tiers 49/199 € (listing/agent-mirror.md:19); erst nach LICENSE/Doku/DSGVO (OFFEN #7) | **Monat 1–2** |
| 5 | **koerperfluss-3d-v2-upgrade** | Institutionslizenz 3D-Anatomie-Education (MDR-frei) | klinik_lizenz — DACH-Physio-Schulen/-Studios über Bildungsnetzwerke | **1.290 €/Jahr pro Standort (bis 30 Nutzer)**, bewährte Empfehlung listing/koerperfluss-3d-v2-upgrade.md:19; vorher lokaler Clone + Lizenz-Klärung (OFFEN #8) | **Monat 2** |

**Flankierend (nicht in MARKT):** OmniRoute als White-Label 50–150 €/Monat erst nach Keys-Säuberung (OFFEN #2); Chipsi 0 € einzeln, nur als Teil des Judicario-Gesamtpakets (REAL-TOOL-ANALYSE wert).

---

## 6. Neue Funde (aus SAMMLUNG) — aufnehmen ja/nein

Maßstab: Tool-Definition = Eintrag in `tools-v2.json` (INVENTAR-VOLL.md:6); LOKI-Interna und Teilprojekte werden nicht einzeln gelistet (INVENTAR-VOLL.md:40-41).

> **Gilt-Regel (Widerspruch gelöst):** Diese Liste ist **verbindlich** gegenüber den Erstsignalen in HANDOFF-ANALYSE-2026-10-10.md §7 (dort „3 ja · 2 nein · 8 unklar" aus den Roh-Signalen). Abweichungen: mywhoop-go hier Ja-mit-Vorbehalt (WHOOP-API-Nutzungsbedingungen klären), ATLAS-Apps hier Nein-einzeln (Build-Artefakte von ATLAS_MASTER, INVENTAR-VOLL.md:41/68). **Die „8 unklar" aus HANDOFF §7 sind NICHT die 8 INVENTAR-Kandidaten aus OFFEN #12** — Zahlenkollision, nicht dieselben Objekte.

| Fund | Aufnehmen? | Warum |
|---|---|---|
| **agent-os-stack** (`~/agent-os/agentos`) | **Ja — zur Bewertung** | Echtes Python-Framework (orchestrator, router, discovery, slicer, engines, security/ + run_tests.py, Testinfra) — fehlt komplett im Inventar; Bewertungslauf (OFFEN #12) entscheidet über Tier |
| **mywhoop-go** (`Documents/GitHub/mywhoop`) | **Ja — zur Bewertung (mit Vorbehalt)** | Vollständiges Go-Projekt (Tests, Dockerfile, export/); Blocker vor listing: WHOOP-API-Nutzungsbedingungen klären |
| **loki-os-app-v17** | Nein | Vorversion von loki-os-app-v18 → Dubletten-Risiko; 522 MB Archiv, LOKI-Interna |
| **loki-voice** (`loki-ki/loki-voice`) | Nein (einzeln) | Gleiche Produktlinie wie judicario-loki-voice (eigener id-Match-Check: anderer Pfad) → nur Bestandteil des Judicario-Pakets |
| **loki-hud** | Nein | Terminal-HUD für LOKI-Agentenstatus = reine LOKI-Interna, kein externer Markt |
| **loki-mind-ios** | Nein | Nur 3 Dateien (ContentView, ShareViewController, Info.plist) — kein eigenständiges Produkt |
| **lokitrigger-ios** | Nein | Xcode-Fragment („CALO COACH ATLAS") — Teilprojekt des ATLAS-Coach |
| **chitchat-macos** | Nein | WebView-Chat-Wrapper (WhatsMac-/Sparkle-Signale) → wahrscheinlich fremder Upstream, Lizenz-Risiko ungeklärt |
| **scite-zotero-plugin** | Nein | Plugin für Fremdprodukt (Zotero/scite) — Vertrieb läuft über deren Ökosystem, Lizenz unklar |
| **antigravity-rutherford** | Nein | Agent-Arbeitsraum/Orchestrator-Infra (workspace, Test-Infra) — kein Marktprodukt |
| **antigravity-einstein** | Nein | Skills-Scaffold mit uv-Workflow (main.py, pyproject) — kein Produkt |
| **atlas-calisthenics-coach-app** | Nein (einzeln) | Gebautes .app = Export-Artefakt von ATLAS_MASTER (Teilprojekt, INVENTAR-VOLL.md:41); Wert nur als Build-Beweis |
| **atlas-master-app** | Nein | Bereits als „app" im Scan erfasst (INVENTAR-VOLL.md:68) — Teilprojekt des Cali-Coach |

**Bilanz:** 2× Ja (nur Bewertungsstufe, nach GO), 11× Nein mit Begründung — **diese Bilanz gilt** (Maßstab `tools-v2.json`); die HANDOFF §7-Zähler („3 ja · 2 nein · 8 unklar") sind nur Erstsignale.

---

## GO-Punkte (Stopp-Regeln, PLAN.md:46-48) — Sammelliste

1. **GO Bewertungslauf** — die **8 INVENTAR-Kandidaten** (5-Zonen-Scan, INVENTAR-VOLL.md:13) **+ die 2 §6-Ja-Funde** (agent-os-stack, mywhoop-go, siehe OFFEN #12); **nicht** die 8 „unklar" aus HANDOFF §7 (OFFEN #12)
2. **GO Firebase-Redeploy** (OFFEN #14)
3. **GO Gumroad-Upload** (OFFEN #15)
4. **GO git push** — keiner der Punkte setzt einen Push voraus
5. **Apple-Developer-Zertifikat** für Notarization (OFFEN #5) — Beschaffung durch dich
