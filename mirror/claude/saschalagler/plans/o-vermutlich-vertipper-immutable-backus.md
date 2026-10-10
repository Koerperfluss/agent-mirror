# PLAN: Verkaufshub fertig machen — die 3 Restaufgaben + Rebuild + Gumroad-Paket

## Context

Der Nutzer hat klargestellt: die Wayfinder-AgentCluster-Research-Tickets im Paste waren **nicht** der Auftrag — die Aufgabe ist der **Tool-Verkaufshub** (60+ Tools). Der maßgebliche Plan existiert bereits als Dokument im Repo: **`TODO-ZIELE-2026-10-10.md`** (17 OFFEN-Punkte, GO-Liste, Top-5-Vermarktung) + **`HANDOFF-ANALYSE-2026-10-10.md`** (Beweise + Stopp-Regeln). Dieser Plan führt genau die dort offenen Punkte aus, die ohne Nutzer-GO machbar sind — kein neues Erfinden.

**Verifizierter Ausgangsstand (heute bewiesen):**
- 67/67 Tools bewertet (`pipeline/runner.py status`), 67 Listings in `listing/`, Hub live (`:3300/hub.html` → 200)
- **LokiVoice-Bereinigung offen** (KEINE `BEREINIGUNG-LOG.md` — Worker brach ab)
- **OmniRoute Keys-Säuberung halb** (Branch `keys-saeuberung` existiert, Änderungen `.env.example` + `setup-*.mjs` uncommittet)
- **`TEAM-BERICHT-2026-10-10.md` fehlt** (Verifikatoren + Integrator liefen nie)
- Storefront-Build zeigt noch alten Stand (`BUILD_EXPORT=1 npx next build` → `out-firebase/`, Mechanik aus deja sess_ae843b4)

**Ausdrücklich NICHT im Scope:** AgentCluster-Orchestrator/-Marketing Wayfinder-Tickets (fremdes Teilprojekt, laut Nutzer „nicht die Aufgabe").

## Stufen (Reihenfolge, 1+2 parallelisierbar nicht nötig — alles inline, keine Subagenten)

| # | Stufe | Quelle | ~Zeit |
|---|---|---|---|
| 1 | **LokiVoice-Bereinigung** (OFFEN #6): 28 Thomas/Peter-Stellen + 4 Namens-Dateien entfernen/generisch machen — NUR mit vorheriger Sicherung (`*.bak` je Datei, Kopie vorab), Ergebnis = `BEREINIGUNG-LOG.md` mit jeder Fundstelle vor→nach | TODO-ZIELE §3 #6, BLOCKER-LISTE.md (32 Fundstellen) | 15–20 Min |
| 2 | **OmniRoute Keys-Säuberung fertig** (OFFEN #2): auf Branch `keys-saeuberung` die uncommitteten Änderungen (`.env.example`, `setup-*.mjs`) vervollständigen → hartcodierte Keys nur aus env/Fallback-Datei, Smoke-Test (`node bin/omniroute.mjs --help` + Tests). **Kein Commit ohne GO** (Stopp-Regel: lokale Commits nur auf Nutzer-Anweisung) | TODO-ZIELE §3 #2, INVENTAR-VOLL.md:31 | 10–15 Min |
| 3 | **TEAM-BERICHT-2026-10-10.md** schreiben: je Worker (BarBulls, LegalOps-DMG, AgentMirror, KF3D-Clone, LokiVoice, OmniRoute-Keys) Beweis-Tabelle `bestätigt/teilweise/widerlegt` + offene GO-Punkte — ersetzt die nie gelaufene Verifikator-Phase | dwfrun-cc0608f8-Plan | 10 Min |
| 4 | **Storefront-Rebuild mit 67er-Daten:** `cd storefront && BUILD_EXPORT=1 /opt/homebrew/bin/npx next build --no-lint` → `hub.html` + `uebersicht.html` frisch generieren → in `out-firebase/` kopieren → `:3300`-Server prüfen/neustarten → `open hub.html` | deja:sess_ae843b4 (Mechanik), FINISH-Pfad | 5 Min |
| 5 | **Gumroad-Paket für Review** (OFFEN #15 vorbereiten, KEIN Upload): Ordner `gumroad-paket-2026-10-10/` mit den Top-5-Listings (`paraletts-3d-shop`, `native-legal-ops`, `judicario-loki-voice`, `agent-mirror`, `koerperfluss-3d-v2-upgrade`) je als `.md` + Preisblatt (unbestätigte Preise markiert) + Reihenfolge/Timing aus TODO-ZIELE §5 | TODO-ZIELE §5 | 5 Min |
| 6 | **Abschlussbericht** mit Stufen-Tabelle, Beweis-Pfaden und der GO-Liste | — | 2 Min |

## Reutilisierte Artefakte (nichts neu bauen)

- LokiVoice-Fundstellen: bereits komplett in **`BLOCKER-LISTE.md`** (32 Fundstellen, inkl. `SafeTalkContractsTests.swift:101`) — Liste abarbeiten, nicht neu suchen
- Rebuild-Mechanik: `BUILD_EXPORT=1 npx next build` → `out-firebase/` (aus Pipeline-Doku/deja)
- Berichtsvorlage: Workflow-Plan von dwfrun-cc0608f8 (Verifikator-Logik: bestätigt/widerlegt/teilweise)

## GO-Gates (NICHT automatisch — Stopp-Regeln)

| Gate | Was | Warum |
|---|---|---|
| **GO Deploy** | Firebase-Redeploy der Storefront | TODO-ZIELE GO #2 |
| **GO Gumroad** | Upload nach Nutzer-Review des Pakets aus Stufe 5 | HANDOFF Stopp-Regel |
| **GO Commit/Push** | OmniRoute-Branch-Commit + Merge | HANDOFF: „lokale Commits nur auf Nutzer-Anweisung" |
| **Zertifikat** | Apple-Developer (99 $/Jahr) für Notarization — kann nicht automatisiert werden | TODO-ZIELE GO #5 |

## Verifikation (DONE-WHEN)

1. `grep -ri "thomas\|peter" <LokiVoice-Pfade>` → 0 Treffer (exkl. Backups) + `BEREINIGUNG-LOG.md` existiert
2. OmniRoute: Smoke-Test grün + `git -C … diff --stat` zeigt vervollständigte Keys-Säuberung, **Working-Tree-Änderungen dokumentiert, kein Commit**
3. `TEAM-BERICHT-2026-10-10.md` existiert im Repo-Root mit 6 Zeilen (je Worker ein Urteil)
4. `ls -la storefront/out-firebase/index.html` = heutiges Datum + `grep -c "tool/" index.html` ≈ 67 · `curl :3300/hub.html` → 200
5. `ls gumroad-paket-2026-10-10/` → 5 Listings + PREISE.md

**Aufwandssumme: ~45–60 Min, kein Subagenten-Quota, keine Credits-Risiken (alles lokal/Flash).**
