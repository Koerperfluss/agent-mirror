# Ubiquitous Language
Glossar für Audit 2 + Assistent (Sacha ↔ Thomas). Klartext für Nicht-Techniker.

## Werkzeuge & Rollen

| Term | Definition | Aliases to avoid |
|---|---|---|
| **Judicario** | Rechts-Motor (MCP-Connector), der Gesetzestexte & Urteile wortwörtlich liefert | Motor, Engine, Connector |
| **Chipsi** | Fertiges Rechts-Produkt (App), das Judicario als Daten-Layer einbaut | SaaS, Produkt |
| **Thomas** | Eigentümer der Produkte (Kunde/Partner) | – |
| **Sacha** | Prüfer & Anbieter der Optimierungen | – |
| **Legal Ops Advisor** | Saschas eigenes Werkzeug: lokales KI-Rechtsbüro (Aktenarchiv + 4 Expertenrollen) auf dem Mac | Werkstatt, Blaupause |

## Chipsi-Module

| Term | Definition | Aliases to avoid |
|---|---|---|
| **SafeTalk** | Meeting-Aufnahme-/Transkriptions-Modul von Chipsi | Safebox |
| **Safebox** | Upload-Bereich für Mandantendaten (NICHT die Transkription) | SafeTalk |
| **Langzeit-Gedächtnis** | Lokaler Wissensspeicher (OKF), merkt Fakten/Entscheidungen/Stil über alle Chats | Memory, Second Brain |
| **Akten** | Fall-Ordner in Chipsi | Dateien |
| **Vorlagen** | Dokument-Vorlagen in Chipsi | Templates |
| **Konnektor** | Steckverbindung zu externen Engines (z. B. Judicario) | Connector |

## Legal-Ops-Begriffe (Sachas Werkzeug)

| Term | Definition | Aliases to avoid |
|---|---|---|
| **Aktenarchiv (RAG)** | Lokale SQLite-Datenbank mit den eigenen Dokumenten; die KI sucht dort zuerst, bevor sie antwortet | Vektor-DB |
| **FTS5** | Volltextsuche der SQLite-Datenbank — das Suchregister des Archivs | – |
| **Chunking** | Zerlegen langer Texte in überlappende Stücke (1200/200 Zeichen), damit juristische Zusammenhänge erhalten bleiben | – |
| **Persona** | Eine der einprogrammierten Expertenrollen (Allgemeinrecht, GdB/Behinderung, VwGH, Compliance) | Sub-Agent |
| **Lokale Inferenz (Ollama)** | Die KI rechnet auf dem eigenen Gerät; Sensitivdaten bleiben lokal | – |
| **Fallback-Kaskade** | Automatische Reserve-Kette: lokales Modell → Gemini-Cloud, wenn lokal nicht verfügbar | – |
| **RIS** | Offizielles Rechtsinformationssystem des Bundes (ris.bka.gv.at); Judikatur-Import über die OGD-API | – |
| **Beleg-Zwang** | Regel: keine Rechtsaussage ohne wörtliche Fundstelle; im Legal-Ops-Prompt als Abschnitt 8 vorgesehen | – |
| **Eval-Harness** | Test-Programm, das einen Fragenkatalog gegen das System fährt und Erfolgsquote/Latenz misst | – |
| **Halluzination** | Antwort aus dem Modell-Gedächtnis statt aus Fundstellen — das Hauptrisiko bei leerem Archiv | – |
| **Selbstprüfung** | Audit des eigenen Werkzeugs mit derselben Härte wie fremde (Code-Belege statt Eigenlob) | – |

## Assistent-Konzepte

| Term | Definition | Aliases to avoid |
|---|---|---|
| **Prüfkopf** | Prüf-Einheit, die Aussagen gegen Judicario/RIS abgleicht | Fehler-Engine |
| **Fehlerhinweis** | Belegter Hinweis auf einen Fehler (kein Rechtsakt) | Einspruch |
| **Verbatim-Zwang** | Regel: kein Fehlerhinweis ohne wörtliche Quelle | – |
| **Melde-Regel** | Nie unterbrechen; nur melden bei belegtem Fehler oder wenn gefragt | – |
| **Second Brain** | Sitzungs-übergreifendes Gedächtnis-Konzept des Assistenten | Langzeit-Gedächtnis |

## Audit-Begriffe

| Term | Definition | Aliases to avoid |
|---|---|---|
| **Audit** | Dokumentierte, belegte Prüfung eines Werkzeugs | Review |
| **Schwäche** | Belegter Mangel, paarweise mit Optimierung geführt | Bug, Fehler |
| **Optimierung** | Konkreter Verbesserungsvorschlag zu einer Schwäche | Fix |
| **Scorecard** | Bewertung 1–5 je Dimension (Funktion + Technik) | Rating |

## Relationships
- **Chipsi** baut genau einen **Judicario** als Daten-Layer ein (über einen **Konnektor**).
- **SafeTalk** erzeugt Transkripte; der **Prüfkopf** prüft sie gegen **Langzeit-Gedächtnis** + **Judicario**.
- Ein **Fehlerhinweis** trägt genau eine wörtliche Quelle (**Verbatim-Zwang**).
- Jede **Schwäche** hat genau eine **Optimierung** (Paar-Prinzip).
- **Legal Ops Advisor** liefert die Blaupause für den **Prüfkopf**: RIS-Grounding + **Beleg-Zwang** + messbare Evaluation.

## Example dialogue
> **Sacha:** „SafeTalk schreibt mit, prüft aber nichts — es ist eine Röhre.“
> **Thomas:** „Aber mein Langzeit-Gedächtnis merkt sich doch Fakten?“
> **Sacha:** „Ja, das **Langzeit-Gedächtnis** merkt — aber es prüft nicht. Der **Prüfkopf** koppelt beides: Transkript + Gedächtnis + **Judicario**.“
> **Thomas:** „Und wenn der Prüfkopf unsicher ist?“
> **Sacha:** „Dann gilt **Verbatim-Zwang**: ohne wörtliche Quelle kein **Fehlerhinweis** — und nie ein **Einspruch**, das ist ein Rechtsakt.“

## Flagged ambiguities
- **„Safebox“ vs. „SafeTalk“:** früher vermischt — Safebox = Upload-Bereich, SafeTalk = Transkription.
- **„Einspruch“ vs. „Fehlerhinweis“:** Einspruch ist ein prozessualer Rechtsakt → immer **Fehlerhinweis** sagen.
- **„Second Brain“ vs. „Langzeit-Gedächtnis“:** Second Brain = Assistenten-Konzept; Langzeit-Gedächtnis = bestehender Chipsi-Speicher.
- **„Motor/Engine“ vs. „Produkt“:** Judicario = Motor (kein UI/Gedächtnis); Chipsi = Produkt.
- **„Legal Ops“ vs. „Judicario“:** Legal Ops = lokales Archiv (antwortet aus eigener DB, kann irren); Judicario = Live-Motor (liefert verbatim vom Gateway). Nicht verwechseln.
