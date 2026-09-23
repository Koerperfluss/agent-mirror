# Memory-Diagnose + George/Thomas-Status

## Teil 1: Warum Skills/Memory in Claude nicht feuern
1. KEINE CLAUDE-CODE-NUTZUNG SEIT DEM DEJA-INSTALL: Die neueste Session-Transcript unter ~/.claude/projects/ ist vom 15.09.2026 14:01 (find ~/.claude/projects -name '*.jsonl' -newermt 2026-09-20 → leer; neueste Datei via stat geprüft). deja wurde erst 20.09.2026 14:18 installiert (settings.json-mtime 20.09. 14:18; ~/.config/deja/wiring.json 14:19). Sascha hat den neuen Auto-Recall in Claude Code also noch nie in Aktion sehen können — der Eindruck 'feuert nicht' stammt aus der Zeit vor dem Setup bzw. aus dem Vergleich mit ZCode (dort ist <deja-recall> im Session-Start-Kontext dieser Session sichtbar bewiesen).
2. 6 DER GEROUTETEN SKILLS FEHLEN IN CLAUDE KOMPLETT: Existenz-Loop über alle 25 Routing-Ziele der STANDARD-SKILLS-Tabelle zeigte, dass loki-os-health, deja-search, gsd-core, roo-code und ralph-loop sowie coderabbit nur in ~/.agents/skills existieren, NICHT in ~/.claude/skills. Bei genau diesen Aufgaben kann Claude Code den Skill weder laden noch aufrufen — die Tabelle in ~/.claude/CLAUDE.md verweist ins Leere. Die anderen 19 Ziele (z.B. lisa-therapeut, grilling, diagnosing-bugs, tdd, ponytail, loki-dev) sind vorhanden (173 Skill-Dirs, 0 ohne SKILL.md).
3. KEIN ZWANGSMECHANISMUS FÜR ROUTING: Die Routing-Tabelle in ~/.claude/CLAUDE.md (Abschnitt B, 27 Tabellenzeilen, kompletter STANDARD-SKILLS-Block mit Markern <!-- STANDARD-SKILLS:START/END -->, Sync = JA, mtime 20.09. 19:07) ist nur Text-Empfehlung. Der einzige Enforcement-Hook ~/.agents/tools/gate-enforcer.py (UserPromptSubmit, settings.json) löst NUR bei Build-Trigger-Wörtern aus (Regex Z.14-19: baue/erstelle/mach mir/übernimm/onboard/takeover/finish) — Lisa-Fall, Bug, Entscheidungen etc. hängen rein an Modell-Eigenwahl. Zudem ist der deja-Recall-Output so formuliert ('If none helps, say nothing about them'), dass ein erfolgreiches Recalling für Sascha unsichtbar bleibt. Die These 'Skills feuern NUR bei Namensnennung' ist zu eng: ~/.claude/CLAUDE.md ist der automatische User-Memory-Pfad und wird in jede Claude-Session geladen — die Auswahl der Skills bleibt aber modellabhängig, es gibt keinen Auto-Dispatch in der Config (settings.local.json enthält nur Permissions, keine Blocker).

**Fixbar ohne dich:** FIXBAR OHNE SASCHA (reine Datei-Arbeit, Auftrag war aber read-only — nur benannt): 6 fehlende Skills nach ~/.claude/skills spiegeln: cp -R ~/.agents/skills/{loki-os-health,deja-search,gsd-core,roo-code,ralph-loop,coderabbit} ~/.claude/skills/ — danach feuert die Routing-Tabelle in ~/.claude/CLAUDE.md (Z. 20-48) auf alle Ziele. · FIXBAR: gate-enforcer.py (~/.agents/tools/gate-enforcer.py, UserPromptSubmit-Hook) um weitere Trigger-Muster erweitern (z.B. Lisa-Nennung → lisa-therapeut, Bug-Wörter → diagnosing-bugs) — dann wird Routing aus Empfehlung zu erzwungener Injektion. · FIXBAR: CLAUDE.md-Sync existsiert (20.09. 19:07) — zusätzlich könnte der deja-Hook-StatusMessage-Output sichtbarer gemacht werden, damit Sascha sieht, dass Recall läuft. · AN SASCHA GEHANGEN: (a) Beweis, dass die deja-Hooks in Claude laufen, gibt es nur durch einen echten Claude-Code-Session-Start — die letzte Claude-Session ist vom 15.09., vor dem Install (20.09.): er muss Claude Code einmal starten, dann SessionStart-Output in der Transcript prüfen. (b) Wenn er faktisch fast nur ZCode nutzt (Beweis: keine Claude-Transcripts nach 15.09. unter ~/.claude/projects/), ist 'Claude stimmt für kein Skill' primär Nutzungsverhalten, kein Config-Fehler — das kann keine Datei reparieren. · NICHT BEWEISBAR gewesen (offen gesagt): ob die deja-Hooks im nächsten Claude-Start tatsächlich feuern — Verkabelung (settings.json Z. 103/121 + deja-hook-Wrapper + /opt/homebrew/bin/deja) ist intakt, aber nie in einer Session angelaufen.

## Teil 2: Was Thomas mit George gebaut hat (Stand 23.09.)
### Gebaut
- ✅ Eingang/Triage: sascha_knowledge_bridge.py + /api/sascha/inbox-triage — umgesetzt
- ✅ Skill-Zuordnung: inbox_triage, morning_sync, evidence_review, local_draft — umgesetzt
- ✅ Skill-Vertrag: input → steps → output → loop — umgesetzt
- ✅ Lokale Arbeitslogik: Sascha-Vertrag in lokale Ollama-Entwürfe eingespeist — umgesetzt
- ✅ Quellen-/Wiederholbarkeit: source_sha256 in Auftrag, Input und Audit — umgesetzt
- ✅ Ergebnis-Provenienz: result_sha256, Status, Kosten-/Außenwirkungsfeld — umgesetzt
- ✅ Chef-Arbeitsvertrag: workflow_stage, done_when, next_step, open_points — umgesetzt
- ✅ Entscheidungspaket: Frage, Fakten, offene Punkte, Optionen, Empfehlung, Freigabestatus — umgesetzt
- ✅ Lokaler Arbeitsentwurf: create-only Markdown unter 00_Eingang/George_Entwuerfe — umgesetzt
- ✅ Morning Sync: /api/morning-sync mit Status, Entscheidung, erstem Schritt, 3 Prioritäten — umgesetzt
- ✅ Lokale Antwortkette: lokales Ollama mit deutscher, sicherer Antwortlogik — umgesetzt, Alltagstest offen
- ✅ Ergebnis-/Auditpfad: lokales Ergebnis-JSON mit Task-ID, Status, Prüfsumme — umgesetzt
- ✅ Fail-closed-Sicherheitslogik: Versand, Löschen, Zahlungen, Außenwirkung standardmäßig gesperrt — umgesetzt
### Fehlt/blockiert
- ⏳ Whisper/faster-whisper: lokaler Pfad da, echter ruhiger Mikrofon-Abnahmelauf fehlt
- ⏳ LokiVoice-Übergabe: Gateway/Taskweg da, stabiler End-to-End-Hörtest mit korrektem Transkript fehlt
- ⏳ Langzeitgedächtnis: nur begrenzt lokal, bestätigter Alltagstest über mehrere Sitzungen fehlt
- ⏳ Chef-Orchestrierung: Cockpit/Triage/Verträge/Freigaben da, vollständiger autonomer aber sicher begrenzter Arbeitsdurchlauf fehlt
- ⏳ SafeTalk: Claims/Evidence/Audit-MVP da, produktive Connector-Berechtigungen fehlen
- ⏳ Judicario: read-only Routing vorbereitet, Live-Nachweis mit gültigem Zugang fehlt
- ⏳ SafeBox: nur Vertrag/Test-Double, echte API und Rechte fehlen
- ⏳ Chipsi-Übergabe: fail-closed Delivery-Route da, produktive Schnittstelle fehlt
- ⏳ Kosten-/Fallback-Weg: lokal zuerst berücksichtigt, reproduzierbarer zweiter kostenloser Modellweg fehlt
- ⏳ Sascha-Vault/Wiki: Quellen gelesen/zugeordnet, weitere Domänenskill-Verträge praktisch anbinden fehlt
- ⏳ Morgen-/Wochensteuerung: Morning Sync da, belegte Wochenziele anbinden fehlt
- ⏳ Mac2-Warm-Standby: online/abgestimmt, dokumentierter Wiederanlauf-/Failover-Drill fehlt
- ⏳ Gemini Free als produktiver zweiter Weg: Provider-/Schlüssel-/Kapazitätsnachweis fehlt
- ⏳ 17-Modell-Matrix: widersprüchliche Dokumentangaben, keine belegte aktuelle Runtime
- ⏳ 30–40 kostenlose Live-Stimmen: konkrete laufende Providerquelle nicht nachgewiesen
- ⏳ Produktiver SafeBox-/Chipsi-/Judicario-Datenfluss: Rechte und Live-Abnahme fehlen
- ⏳ Magicline/Sport Alliance: keine belastbare API-/Zugangsgrundlage
- ⏳ Vollautonome Außenaktionen: bewusst gesperrt (Versand, Zahlung, Löschen, Änderungen)
- ⏳ --accept-all-/Prompt-gesteuerte Selbstfreigabe: aus Sicherheitsgründen nicht übernommen
- ⏳ Vollständiger Sascha-Laufzeitkern: Doku vorhanden, ausführbarer Originalkern nicht geliefert
- ⏳ Automatische Skill-Loops/Scheduler: beschrieben, lokal nicht nachgewiesen
- ⏳ Zweiter Chef-/Stellvertreteragent: nicht aktiviert, George bleibt zentraler Orchestrator
### Nächste Schritte laut Thomas
- Vollständigen lokalen Auftrag mit realem Ergebnis durchlaufen lassen
- Langzeitgedächtnis über mehrere Sitzungen bestätigen
- Nachweisbares kostenloses Fallback-Gehirn (zweiter Modellweg) einrichten
- Echte, ausdrücklich freigegebene SafeBox-/Judicario-Lesepfade öffnen
- Anschließend: ruhiger LokiVoice-End-to-End-Abendtest
- Sicherheitsgrenze: Sascha-Dokumente nur als belegte Arbeitsvorlagen — kein blindes Ausführen als Fremdcode, kein Kontozugang, keine automatische Freigabe; Mitbegutachtung bleibt offen (George nicht verfügbar, Judicario inhaltlich nicht verwendet, Linear nicht verwendet)
### Vergleich George ↔ dein LOKI.OS
- Gleiche Logik, eigener Stack: George reimplementiert Saschas Agentic-LOKI.OS-Muster (Triage, Skill-Vertrag, Chef-Verträge, Morning Sync, Provenienz-Hashes) vollständig — aber komplett lokal.
- George = lokales Ollama + fail-closed: Außenwirkung (Versand, Zahlung, Löschen) bleibt bis Freigabe gesperrt; kein --accept-all, kein zweiter Chef-Agent.
- Sascha = Cloud-Routing (z.ai/GLM, vormals OmniRoute) + Voice (LokiVoice/Whisper) + produktive Connectoren (Judicario, SafeBox, Chipsi) — genau diese Wege sind bei George nur vorbereitet, nicht produktiv (Sektion 2/3).
- Bewusst nicht übernommen: 17-Modell-Matrix, 30–40 Live-Stimmen, Vollautonomie — George ersetzt Umfang durch Nachweisbarkeit (Hashes, Audit-JSON, Freigabestatus).