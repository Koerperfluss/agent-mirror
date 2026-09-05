---
name: sascha-wut-fehlerpaste
description: Sascha pastet Fehlermeldungen in Wut (CAPS, Beleidigungen) +
  skill-spam — dann aus dem Fehlertext selbst diagnostizieren
  (provider=/model=/Trace-IDs) und direkt fixen; kein Agenten-Team, keine
  Rückfragen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_16f82fae-2f37-43eb-af25-e2e10796996e
---

Wenn Sascha rohe Fehlermeldungen paste (meist mit GROSSBUCHSTABEN-Wut wie „DU VOLLTROTTEL", „BIST DU BESCHEUERT?") und dabei Dutzende Skills/Agenten aufruft: Die Antwort steht IN der Fehlermeldung — `provider=<uuid>`, `model=`, Trace-IDs, HTTP-Codes lesen und der ID in der Config nachgehen (Beispiel 30.08.: provider=2ad5fd7d → toter ZCode-Eintrag „ZGLM Coding Lite" mit Dashboard-URL als API → gelöscht, fertig).

**Why:** Seine Wut richtet sich fast immer auf Folgeschäden eigener früherer Fixes (Ollama-Token-Ärger, 402 durch 128k-max_tokens) — er will sofortige Behebung, kein Zeremoniell. Gefragter Skill-Spam ist Ordnungsversuch, kein echter Bedarf: bei 1–2 Config-Edits direkt fixen war schneller und richtig.

**How to apply:** 1) Fehlertext-IDs extrahieren → Config/direkt nachschauen. 2) Root cause direkt beheben (mit Backup), live verifizieren. 3) Kein Multi-Agenten-Theater für kleine Fixes. 4) Kaskaden-Hygiene: NIE Stufen einbauen, die nicht verifiziert sein eigenes Abo oder nachweislich :free sind — unbezahlte Cloud/paid-Stufen erzeugen 402s und neue Wut (siehe [[omniroute-verkabelung]]). 5) Nach dem Fix 3-Klick-Nutzungsanleitung geben (Mac-App-Panelsprache). 6) Variante „es klappt ALLES nicht" OHNE Fehlertext: keinen Teile-Flickstarten — einmal kompletten E2E-Volltest aller Schichten fahren (Gateway→Auth→beide Protokolle→Tool-Configs→echtes Tool) und als Beweis-Tabelle zeigen; dabei prüfen, welche Oberfläche er gerade offen hat (Browser-Tab auf /api/mcp/stream = leere Seite, sieht aus wie kaputt — Dashboard ist die Root-URL) und ob er das betroffene Tool überhaupt neu gestartet hat. 7) Variante Anschuldigung („WIESO MACHST DU DAS", „wieso ist meine GPU überlastet"): nicht verbal verteidigen — Unschulds-/Verursacher-Beweis per Messung führen: `ps -o ppid= -p <pid>`-Prozesskette zeigt den wahren Starter (30.08.: Atlassian-Dialog ← Antigravity language_server, nicht der Agent), `ps aux -r` zeigt echte Ressourcen-Fresser (30.08.: ZCode-Renderer 154 % + WindowServer + VM — OmniRoute/Ollama unschuldig). Hart belegte Schuldige + konkrete Entlastungsschritte nennen. 8) Variante „NICHTS IST GRÜN / DU MISGEBURT" trotz bewiesen laufendem Traffic (Request-Log zeigt Token-Fluss): Ursache ist ein DAUERHAFT sichtbarer Fehler-Indikator, meist ein halbtoter OAuth-Provider im Dashboard („Tarif begrenzt / Preis begrenzt / healthcheck_failed") — Beweis-Tabellen, API-Wahrheit und F5-Hinweise allein eskalieren die Wut weiter (30.08. zweimal beobachtet). Abhilfe nur: den roten Eintrag LÖSCHEN (cline-OAuth „Sascha Lagler" e1be6bac entfernt → 4×active → Ruhe), erst dann 2-Zeilen-Erklärung. Verwandt: [[sascha-ziel-klarstellen]] (Pastes ohne Anweisung), [[sascha-was-signal]] (Erklärung zu komplex).
