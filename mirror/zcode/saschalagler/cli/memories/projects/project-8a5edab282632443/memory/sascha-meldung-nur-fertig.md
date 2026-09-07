---
name: sascha-meldung-nur-fertig
description: Sascha-Befehl „genug geplant bitte erst melden wenn fertig" — still
  durchbauen ohne Zwischenberichte; MELDUNG erst wenn die Aufgabe/Planstufe
  komplett fertig + bewiesen ist
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Sascha (06.09., nach C2-Fertigmeldung): „genug geplant bitte erst melden wenn fertig". Davor: „FERTIG EIGENSTÄNDIG WAR DER PLAN ODER" — dieselbe Bedeutung.

**Why:** Jeder Zwischenbericht („nächstes baue ich X", Status-Geplänkel) empfindet er als weiteres Planen statt Arbeiten. Er will die Fertig-Meldung EINMAL, mit Beweisen, wenn wirklich alles aus seiner Sicht erledigt ist — Restliste mit seinen eigenen verbleibenden Aktionen (z. B. Installationen) klar benannt.

**How to apply:** Bei „meld erst wenn fertig" / „eigenständig fertig": (1) todos auf die Reststufen setzen, dann STUMM abarbeiten — build→deploy→Asset-Parität→commit je Stufe, keine Chat-Zwischenberichte; (2) E2E-Verifikation der fertigen Sache (nicht nur build-grün); (3) EIN finaler Bericht: Ergebnis-Zeile, Beweis-Tabelle, Rest = nur User-Aktionen; (4) PLAN.md/STATUS.md final aktualisieren+committen statt zu erzählen. Verwandt: [[sascha-3-saeulen-parallelarbeit]] (autonom-weitermachen-Befehle), [[sascha-was-signal]] (Kürze), [[anti-luegen-vertrag]] (Beweise in der Meldung).

**🔴 GRENZE DER REGEL (07.09. gelernt):** „Erst melden wenn fertig" gilt für CHAT-Berichte — NICHT für Deploys! Sascha prüft die Live-App selbst zwischendurch („ES IST NICHTS FERTIG … lösch mal den cache damit ich irgendwas sehe"). Bei Parallel-Agenten-Teams: **nach JEDEM abgeschlossenen Agenten inkrementell deployen** (seriell durch den Hauptagenten — das verhindert Alt-Bundle-Kollisionen; das WARTEN auf alle ist der Fehler), sonst sieht er Wochen-Stand und wütet. Chat-Stille ≠ Deploy-Stau.

**🔴 2. GRENZE (07.09. sidechat): „fertig" = SELBST LIVE ANGESCHAUT.** Nach „kein Barbulls-Rebrand, sieht aus wie vorher — öffne doch den verficktne BROWSER und schau selber nach" bestätigte die eigene Live-Inspektion ECHTE Defekte (Blob-Canvas lag über dem Content und fraß Klicks), obwohl Deploy+HTTP-200+Asset-Parität bewiesen waren. **Deploy-Beweis ≠ Sicht-Beweis:** Vor jeder Fertig-Meldung die UI-States SELBST screenshoten (agent-browser auf Prod, simctl im Simulator) und die Screenshots als Beweise liefern — nicht nur curl/Build-Logs. Sein „schau selber nach" ist wörtlich gemeint.

**🔴 3. GRENZE (07.09. abend: „wartest du auf irgendwas?" + „mach das selber"):** Fertige Deliverables NIEMALS auf langlaufende Subagents parken. Der QA-Volltest-Agent war 2h ohne Rückkehr → Sascha fragte spitz „wartest du auf irgendwas?" und befahl „mach das selber". Regel: Subagent deutlich über ~45–60 Min ohne Ergebnis = Bericht/Deliverable SELBST aus den vorhandenen Beweisen schreiben (Screenshot-Ordner, curl-Logs, Audit-Ergebnisse reichen), Subagent-Ergebnis später mergen wenn er doch kommt. Warten ist für ihn Stillstand = dasselbe wie nichts tun.
