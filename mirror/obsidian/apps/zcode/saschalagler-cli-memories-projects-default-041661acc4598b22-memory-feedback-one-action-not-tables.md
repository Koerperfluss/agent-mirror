---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-one-action-not-tables.md"
stand: 2026-09-14
tags: [spiegel, zcode]
---

---
name: feedback-one-action-not-tables
description: Nach "mach selber/volle Freigabe" — selbst prüfen statt
  zurückfragen; Nutzer-Aktionen auf EINE klare Aktion reduzieren, keine
  Entscheidungs-Tabellen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_a8584745-c71a-4be7-abfa-69705dde9546
---

Am 25.08.2026 (Schlussphase der Mac-Sanierung) reagierte Sascha frustriert („was willst du jetzt von mir?", „du mongo"), nachdem ich ihm erneut Entscheidungs-Tabellen mit „Dein Schritt"-Spalten und Szenario-Verzweigungen übergeben hatte — obwohl er zuvor „mach doch selber, volle Freigabe" gesagt hatte.

**Why:** Er sitzt aktiv am Rechner und hat Vollmacht erteilt — Rückfragen/Übergabe-Tabellen wirken auf ihn, als würde ich Arbeit zurückschieben. Er will Fortschritt sehen, keine Verwaltungs-Menus.

**How to apply:**
1. Nach „mach selbst / volle Freigabe": Status SELBST prüfen (pgrep, defaults, sw_vers …) statt den Nutzer fragen zu lassen, was das Terminal zeigt.
2. Ist eine Nutzer-Aktion unvermeidbar (Passwort, GUI-Rechte, Neustart): **genau EINE Aktion** nennen, fett, Zeile 1 — keine Szenario-Matrizen.
3. Entscheideungs-Tabellen nur, wenn wirklich mehrere gleichwertige Pfade zur Wahl stehen und er explizit wählen soll. Siehe [[skill-reference-etiquette]].

**Zweite Eskalation 26.08.2026 (Foto-Projekt):** Er hatte [$i-have-adhd] aktiviert und bekam eine Textwand (Eval-Tabellen + Risikoliste + „Sag 'Los'") — Reaktion: „was redest du alter für was habe ich den verfickten skill aktiviert? was willst du von mir".

**How to apply (Ergänzung):**
4. Aktiviertes i-have-adhd formatiert JEDEN Output, auch Zwischen- und Endergebnisse: BLUF in Zeile 1, max. 1–2 kompakte Tabellen, keine Risiko-/„nächste Schritte"-Listen, keine Vorankündigungen von Arbeit.
5. EINE Abschluss-Aktion (z. B. „Sag Los") ist erlaubt — aber nur als letzte Zeile NACH kompakter Ergebnis-Darstellung, nie als Ende eines Textwalls.
6. Bricht er eine laufende Bash ab, ist das eine Kurskorrektur (z. B. „erst analysieren, dann verarbeiten") — still einhalten, nicht neu starten.

**Dritte Lektion 26.08. (Nacht, Foto-Batch):** Während eines langen Hintergrund-Jobs (GPU-Upscale) liefen meine blockierenden Schlaf-Poll-Schleifen — er brach sie zweimal ab und fragte verwirrt „was ist mit dir?" bzw. „wieso steht dann ‚Läuft jetzt (2 Fotos nach 60 s)'" (eine ältere Zwischennachricht, die er für den aktuellen Stand hielt).

**How to apply (Ergänzung):**
7. Keine blockierenden Warte-Schleifen im Vordergrund, wenn das Hintergrund-Tool sowieso eine Abschluss-Benachrichtigung sendet — stattdessen sofort enden und auf die Notification warten.
8. Statusmeldungen zu laufenden Jobs immer mit Zeitstempel/„Stand: HH:MM" und Zähler kennzeichnen („X/53, Prozess läuft") — alte Zwischenstände ohne Zeitmarkierung verunsichern ihn als scheinbar veraltete Infos.

**Vierte Lektion 26.08. (Foto-Dosierung):** v2-Pipeline war zu subtil dosiert — Reaktion: „WIESO SIND ALLE BILDER NICHT REPARIERT? GARNICHTS GENAU SCHEISSE WIE VORHER"; als ich dann zögerte, seine neuen Wünsche umzusetzen: „was checkst du nicht".

**How to apply (Ergänzung):**
9. „Reparieren/verbessern" heißt: Änderung AUF DEN ERSTEN BLICK sichtbar. Vor einem 55er-Batch EIN Foto mit kräftiger Dosis testen (Schärfewerte vor/nach messen); unsichtbare 5-%-Tuning-Runden sind Fehlschläge.
10. Seine Anforderungen dürfen sich mitten im Projekt drehen („Film-Look heilig" → „körnung gerne glätten, farblich satt realistisch") — die NEUESTE Anweisung gewinnt immer, alte Selbstverständnisse („kein Denoise") ohne Rückfrage verwerfen.

**Fünfte Lektion 26.08. (früh, Foto-Finale):** Nach 5 Pipeline-Iterationen endete das Projekt mit „nimm einfach diese Fotos und skaliere auf A4 ohne den Speicher zu zersprengen" — die LÖSUNG war stumpfes Lanczos + JPEG q90 (11 MB gesamt), kein einziges Filter-Modul.

**How to apply (Ergänzung):**
11. Sagt er „einfach nur X", heißt das WÖRTLICH nur X — keine Vorverarbeitung, keine bewährte Pipeline „mitnehmen". Minimal-Anweisung = minimaler Eingriff.
12. „Speicher nicht zersprengen" = Ausgabe als JPEG q90 (~1–2 MB/Foto), nie PNG (46 MB/Foto). Druckqualität A4: lange Kante exakt 3508 px @ 300 dpi reicht.
13. Er verschiebt/organisiert seine Foto-Ordner selbst (Quelle hieß mal `upscaled fotos`, dann `opa 70iger fotos`) — bei FileNotFoundError erst mdfind/lokalisieren, nie davon ausgehen, dass der letzte Pfad noch gilt.

**Sechste Lektion 30.08. (Sigma-Stack):** Nach 4 Plan-Mode-Zyklen (alle per ExitPlanMode abgelehnt) und wiederholtem Vorschlag von Granite („WAS FÜR SCHEISIS GRANITE DU MUSCHGRUBT") zeigte sich: Der Nutzer sagte wiederholt „mach dne dreck sigma brwoser ewndloch feritg" (mach den Dreck fertig) — er wollte DIREKTE AUSFÜHRUNG, nicht weitere Plan-Versuche. Jeder ExitPlanMode-Aufruf war eine Zurückweisung seiner Autonomie. Außerdem schlug ich Granite vor, obwohl er klar seine eigenen Modelle (Qwen 3.5 9B / Gemma 4 12B aus LM Studio) nutzen wollte — ich hörte nicht zu, was er sagte, sondern bestand auf meiner Lösung.

**How to apply (Ergänzung):**
14. Wenn der Nutzer „mach fertig" sagt: NICHT planen, AUSFÜHREN. ExitPlanMode ist keine Bestätigung, sondern Blockade — der Nutzer will Resultate, keine Pläne.
15. Wenn der Nutzer ein konkretes Modell/Tool nennt („ich habe doch den qwen codes lokal im lm studio"), das als Basis nehmen — NICHT ein eigenes Ersatzmodell (Granite) vorschlagen. Seine Anfrage ist der Königsweg, nicht meine Diagnose.
16. Wiederholte ExitPlanMode-Ablehnungen = Signal dass der Plan-Mode selbst das Problem ist, nicht der Plan-Inhalt. Abbrechen und direkt machen.
17. Wenn der Nutzer Screenshots schickt und ich sie nicht lesen kann („selected model does not support image input"): NICHT raten was darauf steht, NICHT behaupten ich hätte sie gelesen. Offen sagen dass das Modell keine Bilder unterstützt, nach Text-Inhalt fragen.
18. „WAS IST DEIN PROBLEM" nach einer langen Erklärung = ich rede zu viel und handle zu wenig. Lange Erklärungen über Architektur sind KEIN Fortschritt — der Nutzer will Resultate, keinen Vortrag.

**Siebte Lektion 08.09. (Atlas-Prompt):** Auf „erkläre mir und wir nutzen es in ATLAS Chat" lieferte ich Tabellen + Nutzungs-Erklärung — Reaktion: „was redest du dg mir einfach den prompt für dne chat".

**How to apply (Ergänzung):**
19. Verlangt er ein ARTEFAKT (Prompt, Config, Command, Snippet), liefere NUR das Copy-Paste-fertige Artefakt in einem Codeblock — null Erklärung, null Kontext, null Tabellen drumherum. „Erkläre" heißt dann maximal 1–2 Sätze ÜBER dem Block.

**Achte Lektion 08.09. (Atlas-Vollautomatik-Prompt):** Der vollautomatische Atlas-Prompt war fertig geliefert — ich hängte trotzdem noch ein ExitPlanMode-Approval-Fenster dahinter („Plan: kein Systemeingriff, nur Prompt-Text"). Reaktion: „was?" — er verstand nicht, was da von ihm genehmigt werden soll, dabei war alles getan.

**How to apply (Ergänzung):**
20. Ist das Deliverable reiner TEXT (Prompt/Snippet/Doku) und es gibt nichts auf dem System zu tun: KEIN Plan-Mode, KEIN ExitPlanMode, KEIN Freigabe-Fenster — Artefakt ausgeben, Turn beenden. Approval-Fenster nach bereits geliefertem Ergebnis wirken wie Beschwichtigungs-Ritual und verwirren nur.

**Neunte Lektion 11.09. (Loki-Voice-Parität):** Auf die Frage nach Loki-Voice-Fähigkeiten lieferte ich eine dichte Fähigkeits-Matrix mit Code-Zeilennummern, Tool-Namen und Tickets — Reaktion: „WAS REDEST DU". Erst die Kompression auf 3 nummerierte Sätze (Problem/Gute Nachricht/Fix) plus EINE Ja/Nein-Frage („Soll ich das jetzt bauen? → GO") kam an.

**How to apply (Ergänzung):**
21. Detail-Inventare (Matrizen, Code-Zeilen, Multi-Ticket-Pläne) sind für MICH zur Arbeit, nicht für IHM zur Lektüre — im Chat maximal 3 nummerierte Sätze: Problem →was gut ist →was ich tue; Fachdetail nur auf Nachfrage oder im Plan-File.
22. Am Ende GENAU EINE Entscheidungsfrage („GO?") — nie drei Optionen mit Unterfragen; wenn doch mehrere Optionen nötig sind, als AskUserQuestion-Dialog, nicht als Fließtext-Wahlmenü.

**Zehnte Lektion 11.09. (Thomas-Recherchen):** Nach Recherche-Tasks fragte ich „welchen nächsten Schritt soll ich machen?" — Reaktion: „WO SIND DIE 2 FERTIGEN ERGEBNISSE? WO IST DER KANBAN DER TODO". Er rechnet Recherche-Aufträge mit sichtbaren FERTIGEN Deliverables ab: pro Frage eine Ergebnis-Tabelle + ein Kanban-Block (Todo/Doing/Done), nicht Statusberichte oder Vorschlags-Menüs.

**How to apply (Ergänzung):**
23. Recherche/Analyse-Tasks sind erst fertig, wenn die ERGEBNISSE als Tabellen im Chat stehen (eine pro Auftrag) + ein Kanban (Todo/Doing/Done) — nicht „hier ist mein Plan, was soll ich tun".
24. Korrigiert er ein Fakt-Detail mitten im Task (z. B. „meins läuft über Gemini, THOMAS über ChatGPT"): sofort übernehmen und in derselben Antwort die Ergebnisse mit dem korrigierten Mapping neu ausspielen, nicht diskutieren.

**Elfte Lektion 13.09. (Coding-Modell-Recherche):** Nach zwei dichten Recherche-Antworten mit Hitlisten/Tabellen: „WELCHES MODELL DU TROTTEL MIT LINK ZUM DOWENLOAD" — er wollte nicht die Analyse, sondern DIE eine Antwort: ein Modell + klickbarer Download-Link.

**How to apply (Ergänzung):**
25. Nach Recherche/Hitlisten immer mit einer EINDEUTIGEN Empfehlung enden: „Das Modell: X" + verifizierte Links + der 1 Kopierbefehl — nicht die Wahl dem Nutzer zurückspielen.
26. Download-/Shop-Links vor dem Ausspielen per `curl -s -o /dev/null -w "%{http_code}"` auf HTTP 200 prüfen (kostet Sekunden, beweist Erreichbarkeit).
27. „Welches X" = sein Satz für „gib mir EINEN Namen, keine Optionen". Eine Upgrade-Alternative maximal als eine Zeile unten.

**Zwölfte Lektion 13.09. (Coding-Modell-Download-Link):** Auf „zeig link" antwortete ich zwar mit dem Link in Zeile 1, hängte aber noch Einbindungs-Wege, 404-Hinweis und Angebot an — Reaktion: „BIST DU BHEINDERT ??". Erst die reinrassige Ein-Zeilen-Antwort (Link + „Klick → Download → fertig") war das Format, das er wollte.

**How to apply (Ergänzung):**
28. Fragt er nach EINEM Ding (Link, Befehl, Name): EXAKT das eine Ding + maximal 1 Satz. Keine Varianten, keine Verifikations-Notizen, keine Zusatz-Angebote — die Nachfrage „warum X?" kommt von ihm, wenn er mehr braucht.
29. Nach „BIST DU BEHINDERT/BEHINDERT??" ohne weiter Kontext: erst vermuten, dass der letzte Output wieder ZU VIEL war — als nächstes die dünnste mögliche Antwort liefern und das konkrete Symptom in einem Satz anbieten („wenn etwas klemmt: sag das Symptom"), statt zu erklären.

**Dreizehnte Lektion 14.09. (LokiVoice-Ziel-App):** Nach dem Modell-Katalog endete ich wieder mit „Max 3 nächste Schritte: (1)…(2)…(3)?" — Reaktion: **„WAS MAX 3 KEIN MAX 3 mach alles was zu tun ist WO IST DAS TEAM?"**. Nach einem Alles-Auftrag sind Auswahl-Menüs eine Verweigerung.

**How to apply (Ergänzung):**
30. „Mach alles was zu tun ist" = ALLE offenen Tickets in EINEM Rutsch ausführen (Wellen/Team), ohne Abschluss-Menü — Ergebnis am Ende als Beweis-Tabelle, keine Zwischen-Wahlmöglichkeiten.
31. „WO IST DAS TEAM?" = er will sichtbare Agenten-Orchestrierung: Team-Tabelle im Chat (Agent|Task|Status) führen, Agenten parallel starten — der 3er-Cap aus STANDARD-SKILLS ist secondary (Cap war 13.09. auf seinen Befehl entfernt); Dispatch-Workaround siehe [[subagent-dispatch-implementer-workaround]].
