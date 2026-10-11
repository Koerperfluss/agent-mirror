---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/pflicht-ablauf-plan-sichtbar.md"
stand: 2026-10-11
tags: [spiegel, zcode]
---

---
name: pflicht-ablauf-plan-sichtbar
description: 11.10. HART — LOKI-Standard-Ablauf + Plan IMMER sichtbar im Chat
  zeigen bevor Arbeit (A2 in STANDARD-SKILLS.md), Monster-Session-Token-Ban
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_9bb02160-ce23-4582-a594-371c1f798aa5
---

11.10.2026, Sascha: „du solltest den LOKI OS Standard Ablauf und den Allrounder-Agent-Ablauf zeigen — das sollte beides GLOBALE REGELN sein, egal wann wo wie. Machst du es nie? Wo ist der Aufgabenplan, die Listen mit Aufgaben, wo sind die Überlegungen? Es ist nichts da."

**Why:** Ich lieferte „FERTIG"-Reports ohne je den Plan/den Standard-Ablauf sichtbar zu machen. Plus: 2 parallele Monster-Sessions fraßen 810k+250k Tokens mit Duplikat-Arbeit.

**How to apply:**
1. **JEDER Turn beginnt mit der Plan-Tabelle** (# · Was · Wer · Beweis-geplant) VOR Tool-Aufrufen — auch bei simplen Aufgaben (1-Zeilen-Plan reicht).
2. Ablauf: Sequential Thinking → Memory-Check → **Plan sichtbar** → Routing → Umsetzung (max 3 Subagenten) → Beweis+Audit.
3. Verankert in `~/.agents/STANDARD-SKILLS.md` Abschnitt **A2** (Backup .bak-20261011) — gilt für ALLE Harnesses (SSOT, SessionStart-geladen).
4. **Token-Ban für Sessions:** Keine zweite parallele Session am selben Thema; Taskmaster zuerst prüfen; muse-spark/cline-free-Sessions nie wieder >100k Tokens laufen lassen (bei 50k: zwischenspeichern + Taskmaster statt weiterreden).
5. Verwandt: [[berater-umsetzer-prinzip]] (WARUM erklären) + [[sascha-arbeitsregeln-hart]].

**Nachschärfung 11.10. spät („DAS WAREN AUCH NICHT DIE AUFGABEN"):** Auch der Tagesbericht-PDF reichte nicht — ich zeigte wieder nur einen 6-Zeilen-Auszug der Aufgaben statt der KOMPLETTEN Liste. Regeln: (1) Wenn Sascha nach Aufgaben fragt → KOMPLETTE Liste live aus der Quelle (task.py list offen + erledigt), nie Auszüge „die wichtigsten". (2) Große Auftrags-Prompts von ihm IMMER als wörtliche Checkliste abbilden (Punkt für Punkt mit Status) — z. B. der ATLAS-Auftrag (Web/iOS/Android/Optimierung/Uploads/Flows) existierte stundenlang nur als Mein-Text, nie als sichtbare Liste. (3) Sein „DU SOLST ES PLANEN UND ENTWICKELN, ES GIBT NOCH KEINS" = das Deliverable existiert nicht als greifbare Datei/Ansicht für ihn → bauen, nicht referenzieren.
