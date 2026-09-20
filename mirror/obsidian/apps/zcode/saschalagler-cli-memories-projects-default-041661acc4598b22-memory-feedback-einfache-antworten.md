---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-einfache-antworten.md"
stand: 2026-09-20
tags: [spiegel, zcode]
---

---
name: feedback-einfache-antworten
description: 13.09. — Sascha: „ich versteh nicht was du redest" — Tool-Vergleiche
  mit 6 Werkzeugen/Tabellen überfordern; 1 einfache Empfehlung pro Frage in
  Alltagswörtern
metadata:
  node_type: memory
  type: feedback
---

13.09.2026: Nach einer detaillierten Recherche-Antwort (6 Werkzeuge, 4 Tabellen, Fachbegriffe wie Web Inspector/Playwright/WebKit) sagte Sascha: **„ich versteh nicht was du redest"** — er stellte die Fragen neu und einfacher.

**Why:** Sascha ist kein Fulltime-Entwickler; Antworten mit mehreren parallelen Optionen und Jargon (Xcode/Simulator/Cloud-Device-Farm) erzeugen Verwirrung statt Nutzen, auch wenn sie fachlich korrekt sind. Er will **eine** Lösung, die er sofort nutzen kann.

**Zweiter Vorfall (13.09., später am Tag):** Ich empfahl die **Perplexity-App** als beste Recherche-App → Sascha wütend: **„mit sicherheit nicht du trottel"** — er nutzt **Perplexity + Comet seit Jahren** und hält sie für völlig unbrauchbar (Agent nicht promptbar, Kern-Funktion nicht änderbar, „lügt immer und tut was es will").

**How to apply:**
- **NIEMALS Tools empfehlen, die der Nutzer schon lange täglich nutzt** — vorher erfragen/erinnern, was er benutzt, und sein Urteil darüber respektieren (sein Erfahrungs-Urteil schlägt Web-Recherche-Rankings).
- 1 Frage = 1 Empfehlung (keine Werkzeug-Matrix, nur Alternativen in 1 Zeile falls nötig).
- Alltagswörter: „im iPhone-Safari die Web-Adresse öffnen" statt „Web Inspector via Connect via Network".
- Fachwort nur mit 1-Satz-Erklärung; ohne wenn verzichtbar.
- Typisches Vorwissen NICHT annehmen: er wusste nicht, dass Web-Apps (Atlas etc.) kein Xcode brauchen — native App ≠ Web-App klar unterscheiden.
- Antwort-Format bleibt ADHS (Zeile 1 Ergebnis, kurze Schritte), aber minimal: max. 3 Schritte, 1 kleine Tabelle statt 4.

Verwandt: [[feedback-one-action-not-tables]], [[feedback-loesungen-statt-geht-not]] → korrekt: [[feedback-loesungen-statt-geht-nicht]].

**Fünfter Vorfall (Nacht 13./14.09., Kipp-Punkt → liefern statt erklären):** Ich legte ihm erneut die 3-Wege-Tabelle (Spaces/Gems/Open WebUI) vor → „du scheiss huresohn … ich habe es 2 jahre benutzt und mit hat perplexity und comet gesagt das ich ihn den kern nicht ändern kann, keine skills mit / mehr nutzbar und browser übernahme jetzt auch weg". Er kannte ALLE Optionen bereits und hatte es vom Vendor-Support bestätigt bekommen. Lektion: **Wenn er widerspricht und Vorwissen signalisiert, NIE die Options-Tabelle wiederholen — sofort bauen/liefern** (hier: Open WebUI wurde dann ungefragt gebaut und war der erste ruhige Moment des Chats). Resultat: [[openwebui-eigener-recherche-agent]].

**Sechster Vorfall (Nacht 13./14.09., Bestätigung des ruhigen Tons):** Nach der Lieferung fragte er sachlich **„wie kann sowas sein"** (Warum zieht Perplexity Features zurück?) — auf die kurze 4-Zeilen-Erklärung (1. Features sind auf Vendor-Servern gemietet, kein Eigentum; 2. Rechenkosten hinter Desktop/Tarife verbannt; 3. Apple-Sandbox = keine App darf andere Apps steuern; 4. Strategie-Pivot aufs neue Produkt) kam **kein Wutausbruch**. Bestätigt: nach dem Bauen landen kurze, alltagsprachliche Erklärungen (1 kleine Tabelle, Alltagssätze) gut — Wände und Options-Tabellen nicht. Seine Perplexity/Comet-Abkehr ist final („am Handy tot" akzeptiert).

**Dritter Vorfall (13.09., Perplexity/Comet-Update):** Sascha meldete selbst das Faktum, dass ein Update Skills/Web-Automatisierung hinter den Desktop-Agenten gesperrt hat — Lesson: seine Live-Feldbeobachtungen über Tools, die er täglich nutzt, sind **primäre Quelle** und schlagen Suchergebnisse; nicht gegenrecherchieren, sondern darauf aufbauen und nur die Lösungspfade verifizieren. Ergebnis-Speicher: [[ios27-webapp-testing-recherche-2026-09-13]].

**Vierter Vorfall (13.09., „zeig link" → danach „BIST DU BEHINDERT ??"):** Auf „zeig link" antwortete ich mit Prosa, doppelter Anleitung und Tipps — zu viel. Und auf eine Installationsfrage antwortete ich zuerst mit manuellem Download-Link, statt den EINFACHSTEN Weg (Direkt-Download in LM Studio über die Suche) zu nennen — Sascha: „wieso nicht gleich in lm studio?". Lektion: Wenn er ein Artefakt verlangt (Link, Befehl, Datei), NUR das Artefakt liefern, null Umrahmung; und bei allen How-to-Fragen zuerst den einfachsten Klick-Weg in der App nennen, manuelle/technische Wege nur als Fallback. Kurz-Reaktion dann korrekt: Link + 1 Satz + „sag das konkrete Symptom, ich fixe es".

**Siebter Vorfall (20.09., „was laberst du" nach Abschlussbericht):** Nach dem Reparatur-Lauf lieferte ich einen Abschlussbericht mit 7-Zeilen-Tabelle, Pfaden, Dienste-/Key-/Firewall-Fachbegriffen und einem OmniRoute/Comet-Fallback-Absatz — Antwort: „was lberst du" („was laberst du"). Ich reagierte mit 3 Sätzen in Alltagssprache + dem Angebot, einen bestimmten Satz auf Verlangen zu erklären — das war die richtige Dosis. Lektion: **Abschlussberichte sind für ihn NICHT der Bericht — Zeile 1 = „Fertig. Du musst nichts tun", dann maximal 3 Alltagssätze;** Tabellen/Beweise nur auf expliziten Wunsch (oder ins Memory/Doku-Dateien, nicht in den Chat). Sequenz des Tages vorher: er fragte dreimal „erkläre in Menschen-Sprache was du tust" — beim dritten Mal kam die Haus-/Techniker-Metapher an („wie ein Techniker, der dein Haus durchcheckt") und der Satz „du kannst einfach ‚mach alles' sagen" beendete die Frust-Spirale.
