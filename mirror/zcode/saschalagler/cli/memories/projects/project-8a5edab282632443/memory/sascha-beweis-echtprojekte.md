---
name: sascha-beweis-echtprojekte
description: Sascha lehnt Beweise an Mini-Testprojekten ab — Beweis = Dokument
  verankern + Anwendung auf echte große bestehende Projekte
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Sascha reagiert mit Ablehnung („DAS INTERESSIERT MICH NICHT DAS DA GARNICHTS"), wenn ein funktionierender Beweis an einem kleinen Toy-/Testprojekt gezeigt wird (z. B. Mini-Todo-App glm-autotest), während sein Anliegen „große schwere BESTEHENDE Projekte" war.

**Why:** Sein Einsatz ist Multi-Projekt-Betrieb an realen Codebasen (loki-ki, Memorybase, Körperfluss, ATLAS); ein Toy-Beweis fühlt sich für ihn wie Ausweichen vom eigentlichen Ziel an.

**How to apply:** Beweise immer in 3 Schritten liefern: (1) Konfiguration als verankertes Dokument anzeigen (Wayfinder-/Map-Format), (2) im System verankern (Routing/STANDARD-SKILLS), (3) auf ein ECHTES Projekt anwenden (z. B. .wayfinder/-Map + Tickets charten). Toy-Projekte nur als kurz erwähnter Nebensatz, nie als Hauptbeweis. Siehe auch [[sascha-ziel-klarstellen]].

**AUSNAHME (05.09. gelernt):** Der Einwand gilt dem SYSTEM-Beweis („damit ist alles gut"), NICHT Workflow-Tests, die ER selbst bestellt: „teste die pipeline die workflow … erstelle retrogame sonic the hedgehog" — ein Spiel-Projekt war dort das richtige Deliverable und wurde ohne Einwand abgenommen. Also: Systembehauptungen immer an echten großen Projekten beweisen; von ihm beauftragte Pipeline-Tests liefern genau das bestellte Objekt.

**ERWEITERUNG (05.09., „ES GIBT NUR RIESNE APPS"):** Nicht nur die Beweise — die DESIGN-DEFAULTS müssen immer auf den Großfall ausgelegt sein. Konditionale Abschwächungen („Parallelisierung lohnt erst bei >10 Features", „bei kleinen Apps reicht Ein-Agent") lösen Wut aus, weil sein Realitätsszenario ausschließlich große Apps sind. Konkret: ui-ux-tester läuft jetzt IMMER mit 2 Parallel-Subagenten (A=Interaktions-Flows, B=Visual-Audit) + zentralem Bericht, ohne Größen-Schwelle. Faustregel: Bei Optional-Auswahl zwischen „schlank für kleine Fälle" und „voll für große Fälle" IMMER die große Variante als Default verankern.
