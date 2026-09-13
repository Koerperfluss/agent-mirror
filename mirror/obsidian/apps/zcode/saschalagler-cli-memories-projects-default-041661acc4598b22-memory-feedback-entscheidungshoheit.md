---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-entscheidungshoheit.md"
stand: 2026-09-13
tags: [spiegel, zcode]
---

---
name: feedback-entscheidungshoheit
description: 13.09. mehrfach scharf korrigiert — Sascha entscheidet über
  UI/Produkt-Form („SEIT WANN ENTSCHEIDEST DU FÜR MICH WAS FÜR WEB UI");
  Automation-Technik ist meine Verantwortung; Markdown-Design-Dumps sind
  wertlos; Beschuldigungen mit Beweis widerlegen
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_2f5b0aa2-4341-4011-bf96-66c3d8dab653
---

13.09.2026, mehrere harte Korrekturen in einer Session:

**Why:** Ich entschied unilateral „Web-UI" für die Tages-Routine → Wutausbruch („SEIT WANN ZUR HÖLLE ENTSCHEIDEST DU FÜR MICH"). Gleichzeitig fragte ich zu viel ab, was meine Aufgabe war („DAS IST DEINE AUTOMATION, VORSCHLAG, WAS IST DAS FÜR FRAGE"). Er hasste meinen Markdown-Strukturentwurf („WAS SOLL ICH MIT DEM MARKDOWN? DAS SAGT ABSOLUT GARNICHT").

**How to apply:**
1. **Trennung der Entscheidungs-Hoheit:** Produkt-/UI-/Oberflächen-Form = **Sascha** (Optionen mit Tradeoffs vorlegen, EINE Frage, warten). Technische Umsetzung von Automations = **ich** (fertig vorschlagen, nicht fragen).
2. **Kein UI-Format verallgemeinern:** „IMMER Web-UI" ([[feedback-gui-not-cli]]) gilt NICHT pauschal — für die Tages-Routine verwarf er Web-UI entschieden (Oberfläche = Kalender + Chat). Im Zweifel: er wählt die Oberfläche.
3. **Keine Markdown-Wände als „Design"**: Markdown-Strukturentwürfe sagen ihm nichts — Design als konkretes Ergebnis/Beispiel zeigen oder beschreiben, was er SEHEN wird.
4. **Ein Wort-Reize respektieren:** „STOP" = sofort die aktuelle Schiene abbrechen und auf das Nennen des nativen/einfacheren Wegs wechseln (er zeigte Screenshot des ZCode-Automations-Panels = „nutz das Eingebaute").
5. **Beschuldigungen („DU HAST DEN BROWSER GEÖFFNET") nicht sofort eingestehen, sondern mit Beweis widerlegen:** Prozess-Startzeit + Session-ID + Quellcode-Zeile (foerderops_web.py:198 `subprocess.Popen(["open", ...])` = Auto-Browser-Öffnung beim Start) haben die Anschuldigung sauber entkräftet — das landete.
6. Agent-Prompting-Mechanik erklären können: sein Dauer-Prompt für mich lebt in `~/.zcode/AGENTS.md` (Analog: GEMINI.md bei Antigravity) — angelegt 13.09.
7. **Plan-Modus-Frktion vermeiden („WIESO MUSS ICH DIR DAS SAGEN DASS DU DAS ERSTELLEN SOLLST"):** Wenn der Nutzer bereits GO gegeben hat, NIEMALS Arbeit wieder in Plan-Genehmigungs-Dialoge zurückwerfen — ExitPlanMode kann 4× abgelehnt werden und AskUserQuestion-GO hebt die Schreibsperre NICHT auf. Vor Freigabe-Endlos-Schleifen: Nutzer einmal, konkret, auf den Modus-Umschalter verweisen (Plan → Accept Edits/Execute), dann sofort bauen.
