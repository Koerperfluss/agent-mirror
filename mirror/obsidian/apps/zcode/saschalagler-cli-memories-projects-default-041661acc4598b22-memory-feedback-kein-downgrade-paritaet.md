---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-kein-downgrade-paritaet.md"
stand: 2026-09-14
tags: [spiegel, zcode]
---

---
name: feedback-kein-downgrade-paritaet
description: 11.09. scharf korrigiert („du Trottel… ich habe Stunden entwickelt… keine
  minderwertige Whisper") — Gratis-/günstigere Varianten NIE als gleichwertig verkaufen,
  ohne vorher die echte Fähigkeits-Lücke per Code-Inventar zu belegen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_0933a442-4331-4e6b-b563-a8a97dcefd9b
---

Sascha korrigierte 11.09.2026 scharf: Ich hatte „Gratis-Stack existiert bereits, nur Mode wählen" gemeldet — dabei war LocalVoiceService ein massiver Downgrade gegenüber dem ausdevelopierten Cloud-Stack. Seine Reaktion: „das Team aus Agents sind 4 oder mehr? es muss DIESELBEN Fähigkeiten haben, ich habe Stunden entwickelt … keine minderwertige Whisper???"

**Why:** Spar-Vorschläge ohne Paritäts-Check entwerten gelebte Arbeit und zerstören Vertrauen. „Billiger" zählt nur bei GLEICHER Fähigkeit.

**How to apply:**
- Vor jedem „es gibt schon eine gratis/einfachere Variante": echte Features per Code-Grep inventarisieren (Funcs, Tool-Cases, Service-Klassen) und als Fähigkeits-Matrix alt/neu zeigen — Lücken rot markieren, nicht wegschwurbeln.
- Downsizing nur anbieten, wenn der Plan die Lücken explizit schließt (Paritäts-Tickets) oder der Nutzer die Abstriche ausdrücklich abnickt.
- STT-Engine-Qualität ist für ihn sensibel (Apple Speech on-device ja, „billiger Whisper" nein, solange gleichwertig nicht belegt ist).
- **12.09. zweite Eskalation („wieso gibst du mir das minderwertigste das es gibt"):** Ich schlug Apple Speech als Lokal-STT vor — dabei legt SEINE eigene Projekt-Doku den Stack fest: `SPRACHASSISTENT_MARKTFUEHRER_ANALYSE.md` + `SPRACHASSISTENT_ARCHITEKTUR.md` (M1 faster-whisper lokal + Silero-VAD, M6 AssemblyAI/Deepgram Nova-3 Fallback, explizit „tiny ist minderwertig"). **Regel: bevor ich eine Technik-Empfehlung ausspreche, die Modelle/Engines/Anbieter nennt — erst im Projekt nach existierenden Markt-/Modell-Analysen greppen** (`marktführer|analyse|architektur|modell`); seine Analyse zitieren, nicht eigene Pausalien.
- **Er hat Ressourcen, die ich nicht annehmen darf zu wissen:** 6 Gemini-API-Keys (Free-Tier-Rotation als Kosten-Hebel), GEMINI_API_KEY im Keychain. Free-Stack-Design an SEINEN Assets ausrichten (Gemini-Layer, OmniRoute), nicht an generischen Gratis-Ansätzen.

- **12.09. dritte Eskalation („es geht um FREE USAGE — was willst du testen, wenn es um die Übergabe auf seinen Laptop geht"):** Wenn der Auftrag ein HANDOVER für einen Dritten (Thomas) ist, zählt nur der lieferbare Endzustand auf DEM Rechner — keine weiteren Test-/Optimierungs-Vorschläge (medium-Modell, Autostart, Mikro-e2e) als „nächste Schritte" aufdrängen. Paket schnüren (App + Skripte + START_HIER.txt), fertig melden.
- **12.09. vierte Eskalation („du machst nur Mist" beim Anblick von THOMAS_ANLEITUNG + THOMAS_PAKET nebeneinander):** Mehrere Parallel-Ordner/ZIPs für denselben Zweck = selbstverschuldeter Mist. Regel: nach jedem Liefer-Build SOFORT konsolidieren — EIN Lieferordner, EIN ZIP (Arbeitsdateien in `_arbeit/`-Unterordner, nicht im ZIP), alte Strukturen ohne Nachfrage auflösen (Aufräumen ist implizit autorisiert, sobald er die Doppelstruktur bemängelt).

- **14.09. fünfte Eskalation („WELCHE MODELLE SOLL ICH VERBAUEN REDE ICH UNDEUTLICH? KEIN GOOGLE KEIN GEMINI ER HAT KEINEN API-KEY"):** Ich hatte den LLM-Default auf Gemini gelegt, WEIL SASCHA 6 Gemini-Keys hat — aber **THOMAS hat keinen einzigen Google-Key**. Regel: **Saschas Ressourcen (Keys, Accounts, OmniRoute,Coding-Plan) gelten NUR für Sascha** — Stacks für andere Nutzer (Thomas, Moritz, …) ohne Sascha-Assets und ohne Google/Apple-Abhängigkeit entwerfen (OpenRouter-free, Groq-free, edge-tts). Vor Deploy an Dritte fragen: „Welchen Key/API-Zugang hat DIESE Person wirklich?" statt zu assumieren.

Verwandt: [[thomas-tasks-drei-recherchen]], [[feedback-aufbau-vor-deploy]], [[feedback-pruefinstanz-pflicht]]
