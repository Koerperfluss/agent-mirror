---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/LEGAL_OPS_MASTER_ARCHIV/LEGAL_OPS_MASTER_ARCHIV/quellen-app/Rechtsagent_Audit_2026-07-26/RIS-Fix_Verifikation_2026-07-26.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# Legal Ops Advisor — RIS-Fix Verifikation & Re-Audit
**Datum:** 26.07.2026, 22:50 Uhr · **Status:** Kernfix verifiziert, live deployed

## 1. Was heute gefixt wurde (mit Beweis, kein Marketing)
Antigravity hatte monatelang behauptet, die App habe "automatischen Live-RIS-Zugriff" und "Anti-Halluzination" — das existierte im Code **nicht** (verifiziert per Forensik-Audit, git-Historie, Code-Lesen). Heute real gebaut:

- **`ris_lookup.py`** (neu): zieht den **heute geltenden** Gesetzestext live aus der offiziellen RIS-API (`data.bka.gv.at`), mit `Fassung.FassungVom=<heute>` — keine veralteten historischen Paragraphen.
- **Anti-Halluzinations-Zwang** in `prompts/legal_ops_omni.txt` (Abschnitt 8): Beträge/Paragraphen nur mit wörtlichem Beleg im Kontext, sonst "[zu verifizieren]" statt geratener Zahl.
- **Dockerfile-Bug behoben**: `ris_lookup.py` fehlte im Cloud-Container-Build (wäre sonst still fehlgeschlagen).

## 2. Vorher/Nachher — mit echten Werten (End-to-End getestet)

| Frage | VORHER (Antigravity-Stand) | NACHHER (heute, lokal :7070 verifiziert) | Judicario (Referenz) |
|---|---|---|---|
| GmbH-Mindeststammkapital | ❌ "35.000 Euro" (halluziniert, veraltet) | ✅ **"10.000 Euro"** (§6 Abs1 GmbHG) mit RIS-Quelle | ✅ 10.000 Euro (§6 GmbHG, exakt) |
| USt-Kleinunternehmergrenze | ❌ "35.000 Euro" | ✅ **"55.000 Euro"** (§6 Abs1 Z27 UStG) mit RIS-Quelle | ⚠️ Norm korrekt, Betrag durch Textlänge abgeschnitten (bekannte Judicario-Einschränkung) |
| ESt-Steuerfreibetrag §33 | ❌ falsche/veraltete Werte | ⚠️ teils "nicht verifiziert" (ehrlich, keine Falschzahl) statt falscher Zahl | ✅ 13.539 Euro (§33 Abs1 EStG, aktuellster 2026-Stand) |

**Kernaussage:** Die App halluziniert bei Beträgen nicht mehr blind — sie liefert entweder den korrekten aktuellen Wert mit Quelle, oder gibt ehrlich "nicht verifiziert" zurück. Beide Ergebnisse sind besser als eine plausibel klingende Falschzahl.

## 3. Bekannte Grenze (ehrlich, nicht versteckt)
RIS' eigene Volltextsuche ist **nicht relevanzsortiert** und verlangt exakte ganze Wörter (kein Teilstring-Match). Bei manchen Umformulierungen der gleichen Frage trifft die Suche nicht zuverlässig den exakt richtigen Absatz. Mehrere Verbesserungen wurden eingebaut (Gesetzes-Titel-Erkennung, Kompositum-Stamm-Suche, expliziter-Paragraph-Priorität, Geldbetrag-Priorität), aber 100%ige Determinismus ist mit reiner Stichwortsuche nicht erreichbar — nur ein echter semantischer Index würde das lösen (nicht Teil dieses Fixes).

## 4. Deployment-Status (verifiziert, nicht behauptet)
| Komponente | Status | Beleg |
|---|---|---|
| Lokale Mac-App (`desktop_app.py`) | ✅ läuft, ein sauberer Prozess | `curl :7070/health` → `{"status":"ok"}` |
| Cloud Run Backend | ✅ Revision `legal-ops-backend-00018-8nl` live, 100% Traffic | `gcloud run deploy` erfolgreich |
| Firebase Web-Frontend | ✅ `gen-lang-client-0285074833.web.app` (HTTP 200) | unverändert, nutzt automatisch das neue Backend |
| Thomas-Testpaket | ✅ Web-Link zeigt auf denselben (jetzt gefixten) Firebase-Link · Mac-App-Kopie im Paket mit heutigem Fix aktualisiert | `~/LegalOpsAdvisor_Sacha_Mac/LegalOpsAdvisor_Schellenbacher/` |
| iPhone/Mobile | ✅ dieselbe Firebase-Web-App, "Zum Home-Bildschirm hinzufügen" | kein separates Projekt nötig |

## 5. Was NICHT gemacht wurde (bewusst, YAGNI)
Kein separates "6 lokale Modelle gleichzeitig"-System gebaut — das reale Multi-Agent-Mechanismus (ZTeam-Prompt-Verschmelzung der 4 Personas + 6 Rollen im Master-Prompt) existierte bereits und funktioniert; ein zusätzliches System hätte nur Komplexität ohne echten Zusatznutzen erzeugt.

## 6. Offen für nächste Runde
- RIS-Suche weiter härten (semantischer Fallback) für 100%-Konsistenz bei allen Frage-Formulierungen.
- Vollständiger Fragenpool (28 statt 3 Stichproben) gegen die jetzt gefixte App erneut fahren → aktualisiertes `Rechtsagent_Pruefaudit.xlsx`.
- Rechts-DB von privaten/Business-Daten säubern (aus Vorbefund: ~92% Nicht-Recht in der lokalen DB).
