---
app: zcode
quelle: "saschalagler/cli/artifacts/sess_83697431-c946-417e-b8f1-22a2e256eba6/dwfrun-7449257a-0cc9-4f74-8832-4b7a3a516754_artifact_1_1-tool-result-2084edb7-41d3-445b-8a65-e223c232b25d.md"
stand: 2026-10-19
tags: [spiegel, zcode]
---

# MagicLine-API anbinden — 2 Wege (Stand Recherche 19.10.2026)

**Ergebnis Zeile 1:** Beide Wege starten mit demselben Schritt — **Thomas beantragt den API-Key per E-Mail an Sportalliance** (danach trennen sich die Wege: Weg A via **Make-Connector**, Weg B via **direkte REST-Abfragen** durch George). Für **Sofort-Tests reicht die Sandbox**; für den echten Betrieb braucht es den Produktiv-Key. Ein Zeitrahmen für die Key-Zusendung ist **nicht dokumentiert** — nachfragen.

---

## Wer macht was
| Akteur | Aufgabe |
|---|---|
| **Thomas** | 1 E-Mail an Sportalliance schreiben (Vorlage unten), Antworten abwarten |
| **George** | Nach Key-Erhalt: Abfragen bauen (Weg A oder B), liefert Ergebnisse zurück |

## Was George per API abfragen kann (wenn Key da ist)
Je nach Endpoint: Studio-/Mitgliederdaten der MagicLine. **Welche Endpoints der Key freischaltet, steht in der Key-E-Mail — nicht vorab ablesbar.**

---

## Schritt 1 (beide Wege, genau 1×):

**Key beantragen — so, nicht anders:**
- **Kanal:** E-Mail. **Adressat:** Das Anfrage-Formular/der Kontakt im Developer-Portal (**developer.sportalliance.com** → Produkt „Developer Portal“ → Kontakt-/Genehmigungsprozess). Eine direkte E-Mail-Adresse ist **nicht öffentlich dokumentiert** — Thomas nutzt das Formular, falls es eine Adresse nennt, diese.
- **Inhalt der Mail (Kopiervorlage):**
  > Betreff: „API-Zugang MagicLine — Integration anfragen“
  > Wir möchten die MagicLine-API für [Studio-Name] nutzen. Bitte um:
  > 1. API-Key (Produktiv) **und** Sandbox-Key
  > 2. unseren **Tenant-Namen** (wofür in der Base-URL `<tenant>` steht)
  > 3. Antwort, **welche Gebühren** für die API anfallen und **ab wann**
  > 4. ungefähren Zeitrahmen für die Zuteilung
  > 5. welke Authentifizierung (API-Key-Header / OAuth / Basic) der Key nutzt
- **Tenant-Name** = die Studio-Instanz in der URL. Thomas kennt ihn vermutlich nicht auswendig — deshalb Punkt 2 in der Mail. Er steht auch im MagicLine-Portal des Studios; falls dort auffindbar, in die Mail einsetzen.

## Weg A — George via Make (fertiger Connector)
1. Thomas legt in **Make** (make.com) ein Konto/Szenario an, Connector „Sport Alliance Magic Line“ wählen.
2. **Voraussetzung:** Für die Connector-Einrichtung braucht Thomas im Make-Konto die **Admin-Rolle** (oder jemand mit Admin erstellt das Szenario). Für den MagicLine-Key selbst braucht er **keine Studio-App-Entwickler-Rolle** — der Key kommt von Sportalliance (Schritt 1).
3. **Connection einrichten:** Der Connector fragt beim Verbinden nach Zugangsdaten. **Welches Feld (API-Key / Basic / OAuth) erscheint, ist undokumentiert** — Thomas klickt „Add Connection“ und folgt dem Dialog; die Antwort aus Schritt 1 (Authentifizierung) steckt dann in die geforderten Felder.
4. George bedient das Szenario: Module = Abfragen; Ausgabe an ihn zurückgeben.

## Weg B — George direkt via REST
1. **Base-URL:** `https://<tenant>.api.magicline.com/...` (Genaueren Endpoint-Pfad aus der OpenAPI-Doku unter developer.sportalliance.com entnehmen). `<tenant>` = Wert aus der Key-E-Mail.
2. Auth: wie in der Key-Mail angegeben (s. o.).
3. **Sandbox zum Testen ja/nein:** DATENLAGE UNKLAR — ob der Sandbox-Key ohne Produktiv-Freigabe funktioniert und dieselben Endpoints abdeckt, **in der Key-Mail mit erfragen** (Vorlage deckt das ab). Empfehlung: mit Sandbox starten, falls sie kommt.
4. **Rate-Limit:** **1.000 Anfragen/Minute** dokumentiert. **Gebühren:** nicht öffentlich dokumentiert → gehört in die Key-Mail (Punkt 3). Bis Antwort gilt: als **kostenpflichtig möglich** behandeln, Abfragevolumen klein halten.

## Thomas' Fragen — kurz beantwortet
| Frage | Antwort |
|---|---|
| Wo beantrage ich den Key? | Formular/Kontakt im **Developer-Portal**; direkte Mail-Adresse nicht öffentlich → falls Formular nichts nennt, über die MagicLine-Partner-Kontaktseite |
| Woher kenne ich meinen Tenant-Namen? | Steht im MagicLine-Studio-Portal; sicherer Weg: in der Key-E-Mail mitliefern lassen (Vorlage Punkt 2) |
| Kostet die API was? | **DATENLAGE UNKLAR** — öffentlich nicht dokumentiert, in Key-Mail erfragen |
| Reicht die Sandbox? | Für erste Tests vermutlich ja; ob sie ohne Produktiv-Key funktioniert: **DATENLAGE UNKLAR**, mit erfragen (Vorlage Punkt 1 fragt beide Keys an) |

## Offen (muß die Recherche/Quelle klären, nicht Thomas)
1. Connector-Auth-Typ (blockiert Weg-A-Schritt 3 bis zur Key-Mail)
2. Sandbox-Fähigkeit ohne Studio-Antrag
3. Gebührenmodell + Key-Zuteilungszeitraum