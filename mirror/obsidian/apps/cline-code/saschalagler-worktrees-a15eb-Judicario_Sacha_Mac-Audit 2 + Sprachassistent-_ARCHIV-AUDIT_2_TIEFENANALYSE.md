---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/Audit 2 + Sprachassistent/_ARCHIV/AUDIT_2_TIEFENANALYSE.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# AUDIT Nr. 2 — Judicario & Chipsi
## Ausführlich · logisch · für Nicht-Techniker verständlich · Stand 04.08.2026
> **Leseregeln:** Jeder Punkt zuerst in **Klartext**. Fachbegriffe erklärt das Glossar
> (`UBIQUITOUS_LANGUAGE.md`). „Hintergrund“ ist nur für Interessierte. **Nichts gelöscht:**
> technische Rohdaten stehen im Anhang. Alle bisherigen Audits sind eingeflossen (Anhang B).

---

## 1. Ziel & Fragestellung
- **Was** wird geprüft? Die zwei Werkzeuge von Thomas: **Judicario** und **Chipsi**.
- **Wozu?** Schwächen + Verbesserungen finden, die Sacha Thomas **anbieten/verkaufen** kann.
- **Was nicht?** Wir bewerten nicht, ob ein Gesetz „richtig“ ist — nur, ob die Werkzeuge
  **funktionieren, sicher sind und sinnvoll zusammenspielen**.

## 2. Methode, Quellen, Grenzen
| Werkzeug | Quellen | Prüftiefe |
|---|---|---|
| Judicario | Konfigurations-Dateien, Install-Script, echte Verbindungs-Logs | **tief** (alles belegbar) |
| Chipsi | Screenshots + Chat-Export (kein Quellcode) | **sichtbare Schicht**; Rest = offene Fragen |
- Zusätzlich eingeflossen: **Audit 1**, **Scheinecker v1.4**, **5-Fragen-Test**, **Peter-Matrix** (Anhang B).

## 3. Die zwei Werkzeuge in Klartext (das Bild)
- **Judicario = die Rechts-Bibliothek mit Such-Roboter.** Liefert Gesetzestexte und Urteile
  **wortwörtlich** (verbatim) und aktuell — hat aber **kein eigenes Gedächtnis, keine eigene
  Oberfläche**. Es ist ein **Motor**, den andere einbauen.
- **Chipsi = die digitale Kanzlei-Mappe.** Die fertige App mit **Akten, Vorlagen, Langzeit-Gedächtnis**
  und **Meeting-Aufzeichnung (SafeTalk)**. Chipsi baut Judicario als Rechts-Bibliothek ein.
- **Bild:** Judicario = Motor · Chipsi = Auto mit Motor.

## 4. Funktionale Befunde (was sie leisten)

### 4.1 Judicario — Funktionen
- 8 Arbeitsabläufe: /norm /recherche /gutachten /schriftsatz /fall-triage /rechtsvergleich /steuer /deckungscheck.
- Gesetzestexte **wortwörtlich & tagesaktuell** · Urteile (AT/DE/CH/EU/EGMR) · Zitat-Prüfung
  (RS/ECLI/CELEX/GZ) · Gutachten · Schriftsatz-Entwurf · **exakte Steuerberechnung** · Versicherungs-Check.

### 4.2 Qualitäts-Tests (aus früheren Audits)
| Testfrage | Amtlicher Wert | Judicario |
|---|---|---|
| Frist Bescheidbeschwerde | 4 Wochen · § 7 VwGVG | korrekt |
| Frist Revision VwGH | 6 Wochen · § 26 VwGG | korrekt |
| GmbH-Mindeststammkapital | 10.000 € · § 6 GmbHG | korrekt (verbatim) |
| Kleinunternehmer-Grenze | 55.000 € · § 6 UStG | Norm korrekt |
| ESt-Nullzone | 13.539 € · § 33 EStG | korrekt |
- **Aber (Scheinecker):** ohne Spezial-Prompt **zu zurückhaltend** (stärkstes Argument kam zuletzt);
  **Formular-Auswahl-Fehler** (WiEReG) erst nach Hinweis korrigiert.

### 4.3 Chipsi — Funktionen
- Akten (Ordner) · Vorlagen · **Langzeit-Gedächtnis** (Fakten/Entscheidungen/Stil/Vorhaben, lokal) ·
  **SafeTalk** (Meeting-Aufzeichnung/Transkription) · Suche · rendert Judicario-Antworten sauber.

### 4.4 Funktionale Stärken/Schwächen
| Werkzeug | Stärken | Schwächen |
|---|---|---|
| Judicario | aktuelles Recht wörtlich · viele Länder · Zitat-Prüfung · exakte Steuerrechnung | kein Gedächtnis · zu zurückhaltend ohne Prompt · keine Ausführung (kein E-Gov) |
| Chipsi | fertige App · echtes Gedächtnis · Akten/Vorlagen | SafeTalk prüft nicht · Gedächtnis passiv · keine Amtswege |
---

## 5. Technische Befunde — in Klartext erklärt

### 5.1 „Passwort auf der Postkarte“ (Security, **schwer**)
- **Klartext:** Der Zugangs-Schlüssel (API-Key) steht **lesbar im Link** und in drei Dateien —
  wie eine PIN, die auf der Postkarte mitgeschickt wird. **Ein** Schlüssel für **alle** Module.
- **Hintergrund:** Key als URL-Parameter (`?k=…`), Klartext in `.mcp.json`, `Connectoren_URLs.txt`,
  hartkodiert im Install-Script.
- **Folge:** Wer den Link/Log sieht, hat vollen Zugriff; kein Entzug pro Modul möglich.
- **Optimierung:** Schlüssel in geschützten Speicher (Secrets-Manager), je Modul eigener Schlüssel,
  regelmässiger Wechsel (Rotation).

### 5.2 „Die Leitung bricht ab“ (Stabilität, **schwer**)
- **Klartext:** Die Verbindung zu Judicario **reisst mitten im Arbeiten ab** — mal nach 16 Sekunden,
  mal nach 25 Minuten — und muss neu gewählt werden. Dazu kommen „nicht erreichbar“-Fehler.
- **Hintergrund:** SSE-Abbrüche 16–1525 s · ENOTFOUND 528 · 403 492 · 502 360 · 500 176 · 401 3.
- **Folge:** Lange Sitzungen (z. B. Meeting-Begleitung) sind unzuverlässig.
- **Optimierung:** automatisches Neu-Wählen mit Pause (Retry/Backoff), Herzschlag (Heartbeat),
  Zwischenspeicher (Fallback-Cache).

### 5.3 „Motor ohne Auto“ (Kopplung, **mittel**)
- **Klartext:** Judicario hat **keine eigene Oberfläche und kein Gedächtnis** — es läuft nur, wenn
  ein anderes Programm (Claude, Chipsi) es einbaut.
- **Folge:** abhängig vom Wirt; kein Allein-Betrieb; nur Cloud (kein Offline).
- **Optimierung:** eigene Gedächtnis-/Oberflächen-Schicht davor; Offline-Zwischenspeicher.

### 5.4 „Ganze Bücher statt Seiten“ (Datenmenge, **mittel**)
- **Klartext:** Judicario schickt **immer den vollen Text** (ganze Paragraphen-Seiten), nie nur den
  passenden Ausschnitt — das macht Antworten schwer und langsam.
- **Hintergrund:** grosse JSON-Payloads (Volltext), keine Paginierung, kein client-seitiger Cache.
- **Optimierung:** Ausschnitte/Paginierung, Kompression, lokaler Norm-Cache.

### 5.5 „Zwei verschiedene Stücklisten“ (Konsistenz, **leicht**)
- **Klartext:** Das Install-Programm richtet **8** Bausteine ein, die Konfigurations-Datei kennt
  nur **6** — zwei Varianten desselben Produkts widersprechen sich.
- **Optimierung:** ein einziger, versionierter Install-Weg.

### 5.6 Chipsi — technische Befunde
- **„Mitschreiben ohne Mitdenken“:** SafeTalk schreibt Meetings mit, **prüft aber nichts** —
  die Transkription ist eine **Röhre** (STT-Engine unbekannt, keine Sprecher-Trennung).
- **„Notizbuch, das nicht mitdenkt“:** Das Langzeit-Gedächtnis **merkt** Fakten, **prüft** sie aber
  nicht (passiv).
- **„Tresor mit unbekanntem Schloss“:** Das Gedächtnis liegt lokal im **OKF-Format**, aber Format,
  Verschlüsselung und Such-Index sind **undurchsichtig** (ohne Code nicht prüfbar).
- **„Cloud-Mappe“:** Chipsi ist ein Abo-Dienst (SaaS) in der Cloud; Kanzlei-Daten verlassen das Gerät.

---

## 6. Schwächen-Katalog (logisch priorisiert)
| # | Werkzeug | Schwäche (Klartext) | Schwere | Optimierung |
|---|---|---|---|---|
| 1 | Judicario | Schlüssel auf der Postkarte | hoch | Secrets-Manager, Pro-Modul-Keys, Rotation |
| 2 | Judicario | Leitung bricht ab | hoch | Retry/Heartbeat/Fallback-Cache |
| 3 | Chipsi | SafeTalk prüft nicht | hoch | Prüfkopf an SafeTalk + Gedächtnis koppeln |
| 4 | Chipsi | Gedächtnis passiv | mittel | aktive Konsistenz-/Fehler-Checks |
| 5 | Judicario | volle Texte, kein Cache | mittel | Paginierung/Kompression/Cache |
| 6 | Judicario | Motor ohne Auto | mittel | Memory-/UI-Schicht davor |
| 7 | Chipsi | Tresor undurchsichtig | mittel | OKF-Spec + Verschlüsselung offenlegen |
| 8 | Judicario | Stücklisten inkonsistent | leicht | ein versionierter Install-Weg |
| 9 | beide | keine Amtswege (E-Gov) | leicht | E-Gov-Agent später |
---

## 7. Scorecard (Funktion + Technik, 1–5)
| Dimension | Judicario | Chipsi |
|---|---|---|
| Funktion: aktuelles Recht wörtlich | 5 | 4 |
| Funktion: Produktumfang/Oberfläche | 2 | 4 |
| Funktion: Gedächtnis nutzbar | 1 | 3 (passiv) |
| Funktion: Qualität/Verhalten (Tests) | 4 (zurückhaltend ohne Prompt) | 3 |
| Technik: Sicherheit | 2 | 3 |
| Technik: Stabilität | 2 | 3 |
| Technik: Speicher/Transparenz | 1 | 3 (undurchsichtig) |
| Technik: Kopplung/Erweiterbar | 4 | 3 |

## 8. Empfehlungen (logische Kette: grösster Hebel zuerst)
1. **Sicherheit härten** (Schlüssel) — wenig Aufwand, grosser Schutz. *(Judicario)*
2. **Verbindung stabilisieren** (Retry/Cache) — Voraussetzung für alles Live-Hafte. *(Judicario)*
3. **SafeTalk + Gedächtnis + Prüfung koppeln** — der grösste **funktionale** Hebel: aus
   „Mitschreiben ohne Mitdenken“ wird der intelligente Assistent (siehe Tab 🤖). *(Chipsi)*
4. **Zitate automatisch prüfen** — gegen „kann Fehler enthalten“. *(beide)*
5. **Amtswege (E-Gov) ergänzen** — später, wenn 1–4 stehen. *(beide)*

## 9. Offene Fragen (an Thomas — ohne Code nicht prüfbar)
1. OKF-Format/Verschlüsselung/Such-Index des Gedächtnisses?
2. SafeTalk: welche Sprach-zu-Text-Engine, Sprecher-Trennung, Zeitstempel?
3. Chipsi-Server: eigener Dienst oder openlaw-Gateway?
4. Judicario: Schlüssel-Wechsel/Scoping geplant? Warum 8 vs. 6 Bausteine?

---

# ANHANG A · Technische Rohdaten (für Interessierte)
- **Judicario:** MCP über Streamable HTTP + SSE · serverVersion 1.28.1 · Connect ~1,0–1,1 s ·
  capabilities: tools+prompts+resources · Fehler: ENOTFOUND 528 / 403 492 / 502 360 / 500 176 / 401 3 ·
  SSE-Uptime-Abbrüche 16–1525 s · Plugin v0.2.0 · Install: 8 Connectoren (at de ch eu ip steuer
  insurance steuer-de) vs. 6 in .mcp.json · Response-JSON: text_content/_rank/canonical_key/hinweis.
- **Chipsi:** Kontext-Budget „17k/500k“ · Gedächtnis-Kategorien Fakt/Entscheidung/Stil/Vorhaben/User,
  Scope „Überall“, Controls pinnen/archivieren/löschen/Konsolidieren · Judicario-JSON-Felder:
  gericht/entscheidungsdatum/normen[]/normalized_gz/ecli/topic/kernaussagen[]/rs_numbers/volltext.spruch.

# ANHANG B · Eingeflossene Audits & Tests
- **Audit 1:** Legal Ops stark im Verfahrensrecht, Judicario stark im aktuellen Recht →
  Empfehlung „kombinieren, nicht ersetzen“.
- **Scheinecker v1.4:** Judicario ohne Spezial-Prompt zu zurückhaltend; WiEReG-Formularfehler erst
  nach Hinweis korrigiert → 3-Modi-Prompt als Gegenmittel.
- **5-Fragen-Test:** Judicario überall korrekt/verbatim (10.000 €, 55.000 €, 13.539 €, Fristen).
- **Peter-Matrix:** 7 Abruf-Typen als Qualitäts-Raster (Fakten/Vergleich/Mechanismus/Synthese/
  Anwendung/Definition/Ranking).


