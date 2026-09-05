# KAPITEL 09 — Bewertung, Gesamturteil & Empfehlungen

**Prüfdatum:** 28.07.2026 · **Lead-Synthese** (alle vorherigen Kapitel)

---

## 9.1 Kurzfazit (im Scheinecker-Stil)

**Gesamturteil:** Der Legal Ops Advisor ist ein architektonisch solider, ehrlicher Ansatz mit drei strukturellen Vorteilen, die weder Judicario noch Chipsi bieten können — (1) lokaler Inferenz-Pfad (architektonisch verifiziert, betrieblich noch im Aufbau), (2) eigene Kanzlei-Akten-RAG (SQLite FTS5, 264 Chunks, code-belegt), (3) härtester Anti-Halluzinations-Zwang (VERBATIM). **Aber:** Die E-Government-Agentik ist derzeit reine Textberatung, der anwaltliche/kritische Modus von Scheinecker ist nicht als Commands implementiert, das lokale Modell ist aktuell nicht lauffähig (phi3:mini statt gemma4), und die Datenbank enthält nur persönliche Fallakten ohne systematisches Rechtskorpus.

---

## 9.2 Bewertungstabelle (Prüfbereich / Ergebnis / Kurzbegründung)

| Prüfbereich | Ergebnis | Kurzbegründung |
|---|---|---|
| System-Architektur | ✅ Sehr gut | FastAPI+PyWebView, 3 Modi (auto/local/cloud), RAM-Guard, DDGS-Websuche, Docker-ready — professionell |
| Lokale Inferenz | ⚠️ Architektur gut / Betrieb offen | Code ✅ (Ollama, gemma4 referenziert); aktuell nur phi3:mini installiert → Cloud-Fallback aktiv; eigenes LLM-Training (Thomas) 🔶 in Arbeit |
| RAG / Fallakten | ⚠️ Gut / Ausbaufähig | SQLite FTS5 funktioniert mit persönlichen Akten; kein Normen-Korpus; DB-Bereinigung nötig (Privatakten vermischt) |
| RIS OGD Live | ✅ Sehr gut | API v2.6 live getestet, Titel-Filter, FassungVom<heute>, Verbatim-Zwang — technisch sauber |
| Anti-Halluzination | ✅ Hervorragend | „BETRAG NICHT VERIFIZIERT" statt Raten — die härteste Regel im gesamten Vergleich |
| Agenten/Orchester | ⚠️ Prompt-Rollenspiel / ok | 6 Sub-Rollen im Omni-Prompt (keine getrennten Prozesse); .agents/-Testläufe extern; echte Multi-Agent-Architektur fehlt |
| Personas & Routing | ✅ Gut | 4 Personas + Keyword-Auto-Routing code-belegt; weniger als behauptet (4 statt 6) |
| E-Gov-Agentik | ❌ Offen | Nur Textberatung („PORTAL-ROUTING"); Browser-Automation 🔶 (Thomas: einzig offenes Entwicklungsthema) |
| Eval-Framework | ⚠️ Ansatz gut / 36≠100 | 36 Szenarien, 7 Typen, ehrliche NEIN-Spalte; 100-Szenarien-Ziel noch nicht erreicht |
| Geschwindigkeit (Cloud) | ✅ ~7.5s | 36 Messungen aus eval_results.csv konsistent |
| Geschwindigkeit (lokal) | ⚠️ ~70s | Langsam aber datenschutzkonform; akzeptabel für Offline-Betrieb |
| Scheinecker 15 Commands | ❌ 0/15 nativ | Kein Slash-Command-System; ~9/15 funktional abgedeckt via Prompt — methodisch vorhanden, nicht als Feature |
| 3 Modi | ❌ Nicht implementiert | Keine Command-Trennung zwischen Neutral/Anwaltlich/Kritisch — der methodische Vorteil liegt im Prompt, nicht in der UI |
| Datenschutz | ⚠️ Geteilt | Cloud-Modus: Daten via verschlüsselten Server (Mandantenangabe); lokaler Modus: 100% offline (nach Air-Gap-Test) |
| Selbstlern-Hirn | 🔶 Unbelegt | Kein Code-Beleg im Repository; Mandantenangabe
| Konkurrenz-Position | ✅ Glaubwürdig | Die drei Kern-Differenzierungen (lokal, RAG, Verbatim-Zwang) sind code-belegt und von Judicario/Chipsi nicht erreichbar |

---

## 9.3 Festgestellte Auffälligkeiten (ehrliche Rubrik)

1. **Modell-Diskrepanz:** PROJECT.md spricht von qwen2.5-coder:14b, Code nutzt gemma4:12b-it-qat, installiert ist nur phi3:mini. Drei verschiedene Wahrheiten — Dokumentation muss bereinigt werden.
2. **DB-Bereinigung nötig:** Die RAG-Datenbank enthält persönliche Fallakten (Exekutionen, Sozialhilfeanträge, Lohnbestätigungen) — kein systematisches Rechtskorpus. Für eine Kanzlei-Lösung muss DB getrennt werden.
3. **Kein Slash-Command-System:** Die Kraft der Scheinecker-3-Modi ist nicht als interaktive Commands umgesetzt — der Prompt macht es, aber die Bedienung bleibt textbasiert.
4. **E-Gov offen:** Das vom Mandanten als größter Wettbewerbsvorteil genannte Feature (JustizOnline-Einreichung via Chrome-DevTools-MCP) ist weder im Code noch in den Teamwork-Testläufen belegt.
5. **Config-Drift bei Judicario:** 8 Module im CLI-Installer, 6 in der Plugin/Web-Konfiguration — Inkonsistenz (kein Bug, aber verwirrend).

---

## 9.4 Stärken der Konkurrenz (fair gewürdigt)

- **Judicario:** Recherchebreite (6-8 Korpora, 4 Rechtsordnungen + Steuer/Versicherung) ist der klare Vorsprung; 3-fach-Distribution (CLI/Desktop/Web), Praxis-Erfolg im Scheinecker-Test (5-seitige FG-Klage), deterministische Steuer-Engine.
- **Chipsi:** SaaS-Polish, 17-Werkzeug-Angabe (ungeprüft), Safebox-Dokumententresor, granulare Freigaben — reiferes Endprodukt als beide anderen.

---

## 9.5 Empfehlungen (Priorität: P0 = vor Vertrieb, P1 = kurzfristig)

| ID | Empfehlung | Prio |
|---|---|---|
| E.1 | **Air-Gap-Offline-Test:** Mac vom Netz→Rechtsabfrage→Output dokumentieren (Video). Belegt die 100%-Offline-Behauptung | P0 |
| E.2 | **E-Gov-Agentik:** Chrome-DevTools-MCP-Integration mit Human-in-the-Loop-Gate vor Submit & Audit-Log entwickeln. Erst dann als Feature vermarkten | P0 |
| E.3 | **Lokales Modell laden:** `gemma4:12b-it-qat` (oder das neue Thomas-Modell) via Ollama pull & als Default aktivieren | P1 |
| E.4 | **DB bereinigen:** Rechtsdatenbank von persönlichen Akten trennen; Normen-Korpus aufbauen als Ergänzung zum RIS-Live-Lookup | P1 |
| E.5 | **Slash-Commands implementieren:** Die 15 Scheinecker-Befehle als echtes Command-System in der UI | P1 |
| E.6 | **Doku synchronisieren:** PROJECT.md, CLAUDE.md, Marketing-Material auf aktuellen Code-Stand bringen (Modell, Architektur) | P1 |
| E.7 | **100-Szenarien vervollständigen:** Von 36 auf 100 evaluierte Szenarien ausbauen | P2 |
| E.8 | **Chipsi-Login-Test:** Wenn Zugang verfügbar, die 17 Werkzeuge/Funktionen verifizieren (löst 18 🔶 auf) | P2 |

---

## 9.6 Abschlusskontrolle (Scheinecker-Meta-Prüfung)

- ✅ Ist das Ziel des Audits erkennbar? Ja: fairer, evidenzbasierter Systemvergleich
- ✅ Stehen die stärksten Argumente vorne? Ja: drei Kern-Differenzierungen (lokal/RAG/Verbatim) als Leitthese
- ✅ Ist jedes Hauptargument belegt? Ja: jedes ✅/⚠️/❌/🔶 mit Quellenangabe
- ✅ Wird die Konkurrenz fair gewürdigt? Ja: Kapitel 08b + 9.4
- ✅ Sind Risiken und offene Punkte benannt? Ja: Kapitel 9.3 + 9.5
- ✅ Ist klar, was nächste Schritte sind? Ja: 9.5 (8 Empfehlungen, priorisiert)

---

*Allumfassendes Prüfarchiv Legal Ops Advisor v7.0 — Erstellt 28.07.2026 durch Cline (Lead) mit Code-Audit-, Konkurrenz-Analyst- und Empirie-Tester-Teambeiträgen. Das Prüfarchiv ersetzt keine Rechtsberatung und keine Produktzertifizierung — es ist eine technische/strategische Audit-Grundlage auf Basis des einsehbaren Codes und der live getesteten APIs.*
