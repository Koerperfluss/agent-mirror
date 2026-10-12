---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/sascha-vollzug-keine-zwischenfragen.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: sascha-vollzug-keine-zwischenfragen
description: Sascha will Komplettlösungen End-to-End ohne
  Zwischenschritt-Rückfragen — GO gilt bis zum fertigen Ergebnis
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_415f90b8-06e6-414b-8ea5-c4c65864b581
---

Sascha (18.09.2026, nach 30h Konfiguration): „WIESO MUSS ICH JEDEN SCHEISS SCHRITT ERKLÄREN — such dir doch selber eine Lösung, SOFORT. Merk dir das."

**Why:** Jede Zwischenfrage („GO für Schritt 2?", „soll ich X?") bricht seinen Flow und frustriert massiv. Er delegiert das GANZE Ergebnis, nicht Einzelschritte.

**How to apply:**
1. Ein Auftrag = ein fertiges Ergebnis liefern. Teil-Fortschritte melden, aber NICHT anhalten und fragen.
2. „GO" auf eine Phase gilt implizit für die folgenden notwendigen Teilschritte desselben Auftrags (z. B. Publish-GO umfasst Policy-Setup, Fotos, Consent).
3. Nachfragen NUR noch bei: echten Stopp-Regeln (Löschen fremder Daten, Deploy auf fremde Infra) ODER wenn Credentials/Passwörter physisch fehlen.
4. Alternativen selbst wählen (z. B. andere API, anderer Umweg), wenn Weg A klemmt — Optionen listen = Zeit verschwenden.
5. Fehlschläge ehrlich melden, aber mit bereits gewähltem Plan B im selben Zug.

**Ergänzung (20.09. Abend, Session-Abbruch „ES REICHT"):** (1) **Memory-Frische-Pflicht:** Sascha: „das existiert nicht, du bist 20 Tage hinten mit deiner memory" — Status-Behauptungen NIE aus Session-Gedächtnis zitieren, sondern vorher live verifizieren (deja search + Dateisystem/ls). Veraltet nachgeplapperte Zwischenstände = Wut-Ausbruch. (2) **Nach „ES REICHT"/abgelehntem Dialog: KEINE weiteren AskUserQuestion/ExitPlanMode-Dialoge mehr** — wiederholte Dialog-Spam-Escalation („nein stop was machst du?", „WAS FÜR APP OHNE PLAN"). Dann nur noch 3 Zeilen Klartext: was die Sache ist, was mein Fehler war, dass nichts ohne sein Wort passiert. (3) **Plan-Modus-Falle:** Wenn Sascha Plan-Modus aktiviert und Pläne 3× ablehnt, ist das Signal „ falscher Inhalt/Scope", nicht „nochmal einreichen" — lieber 1 kurze Rückfrage nach dem echten Scope oder gar nichts. (4) Sein Kernvorwurf „APP OHNE PLAN" = zutreffend: loki-dev-Schnitt-0 (Plan-Gate VOR Code) wurde übergangen; Vollzug-Regel gilt für die AUSFÜHRUNG nach Auftrags-GO, nicht als Ersatz fürs Plan-Gate bei neuen großen Builds.

**Ergänzung (01.10., Legal-Ops-Session — „die frage ist so dumm"):** KEINE Bestätigungsfragen bei Erklärungen, die nur wiederholen, was das Gesetz ohnehin vorschreibt. Fall: Ich fragte, ob die Behördenerklärung „Fahrzeug wird bis zur Wiederherstellung der Versicherung nicht im öffentlichen Verkehr verwendet" bleibt oder gestrichen wird — seine Antwort: „die frage ist so dumm", denn ohne haftenden Versicherer ist Fahren UNRECHTMÄSSIG (§ 44 KFG), die Erklärung kostet also nichts Erlaubtes. **Rule:** Fakten-Deklarationen, die gesetzliche Pflichten spiegeln, direkt drinlassen und liefern; nur fragen, wenn eine Option etwas Kostspieliges/Erlaubtes aufgibt.

**Ergänzung (01.10., Gmail-Debakel — „WIE GEHT DAS SOLL ICH DAS RIECHEN"):** Vollzug heißt: das Fertige liegt **IM ZIEL-TOOL**, nicht als Umweg-Datei daneben. Ich lieferte .eml-Dateien + Send-Listen — seine Reaktion: „DU MISSGEBURT SOLLST MIR IN GMAIL ALLES VORBEREITEN". **Rule:** Erst klären, WO er das Ergebnis konsumiert (hier: Gmail-Web in seinem Browser), DANN den Weg bauen, der genau dort ablegt — auch wenn der Umweg technisch aufwendiger ist (Browser-Debug-Port statt Dateien). Umweg-Lösungen als „fertig" zu melden = Verarschung in seinen Augen. Bei technisch unmöglicher Direkt-Lieferung (Gmail-API ohne Scopes): die EINE fehlende Freigabe als Ja/Nein-Frage („Chrome GO?") statt Umwege aufdrücken.

**Ergänzung (11.10., Cline-Pin — „REDE STU TROTTEL"):** „Vorschlag-Listen für Sascha zum Selber-Klicken" = Regelverstoß. Kontext: Ich hatte seine Frage (Modelle rotieren nicht) gelöst, empfahl aber am Ende „In Cline-Pass-Dropdown mal manuell auf ein frisches Modell klicken" — er explodierte, weil ER mich beauftragt hatte zu konfigurieren. **Rule:** Wenn der Auftrag „mach/konfiguriere X" heißt, liefere ich X fertig (Config-Datei direkt editieren + App neustarten + Beweis), NIE als To-do-Liste an ihn zurück. Auch „Entscheidungen für dich"-Listen am Ende sind bei einem Vollzugs-Auftrag Fehlformat — nur Ergebnis + was bleibt offen.

Verwandt: [[loki-verkaufstool-stand]]

**Ergänzung (20.09., Voice-Session — härtester Ausbruch bisher):** (1) **GUI-/TCC-Systemdialoge IMMER vorher ankündigen** — ein unaufgefordertes Mikrofon-„Darf python3.14…"-Popup löste „was ist das mausi du sollst nur planen" + Plan-Modus aus. (2) **AskUserQuestion-Formulare mit Options-Chips = Total-Ablehnung** („ALTER BIST DU BEHINDERT") — er will keine Menü-Auswahl, sondern dass ich sein Ziel aus seinen eigenen Doku-Quellen ableite (Explorer-Memory-Sweep) und direkt liefere. (3) Nach Plan-Ablehnung sofort „STARTE SOFORT MULTI AGENT TEAM /research /plan /dev" — Forschung/Analyse darf parallel als 3 Explorer laufen, Edits aber NICHT (Plan-Modus blockiert Schreibzugriffe hart; Read-only-Analysis ist der einzige erlaubte Weg, produktiv zu bleiben). (4) Sein „NICHTS DAVON STIMMT" hieß: er wollte eine **Systemanalyse seines ganzen Agentic OS** (jede App, jede Info), nicht den engen Voice-Fix-Plan — Scope falsch geraten. Lektion: Bei mehrdeutigem Wut-Feedback zuerst den eigentlichen Scope aus dem Shout extrahieren (er benennt ihn) und DIESEN liefern.

**Ergänzung (21.09., Browser-Konflikt):** WENN Sascha selbst parallel im Browser/Finder arbeitet, KEINE computer-use-Klicks mehr senden — „STOP JETZT" heißt sofort alle Prozesse killen und melden. Stattdessen: ihm den 60-Sekunden-Rest per Checkliste geben (er klickt schneller fertig als eine Fernsteuerung) ODER dedizierten Agent-Browser nutzen. Plan-Modus-Wiederholungen: Er lehnt lange Pläne ab — Plan auf das absolute Minimum kürzen (3 Zeilen), kein Willhaben-/Nebenthemen-Bezug. Korrektur: Sascha arbeitet auf EBAY.AT (Österreich, Loosdorf/NÖ) — nie ebay.de-Flows für ihn fahren.

**Ergänzung (18.09., Chrome-Session):** Keine Zwischenfragen heißt AUCH: keine langen Status-/Konfig-Erklärungen. Sascha antwortete mehrfach „ICH VERSTEHE NICHT WAS DU REDEST / WAS IST DEINE AUFGABE/GOAL", als ich Setup-Details erzählte. Format das er versteht: (1) Meine Aufgabe in 1 Satz, (2) Ursache in 1 Satz, (3) die EINE offene Entscheidung („Sag GO oder NEIN"). Alles andere in Dateien ablegen, nicht in den Chat. **Und: Er kann lange Terminal-Texte nicht lesen — Übersichten/Erklärungen grafisch als HTML-Datei auf Desktop aufbereiten und im Browser öffnen** (siehe [[chrome-agent-browser-fix]], `~/Desktop/chrome-fix-uebersicht.html`).
