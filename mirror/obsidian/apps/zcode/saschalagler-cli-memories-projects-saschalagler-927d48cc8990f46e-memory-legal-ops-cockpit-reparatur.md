---
app: zcode
quelle: "saschalagler/cli/memories/projects/saschalagler-927d48cc8990f46e/memory/legal-ops-cockpit-reparatur.md"
stand: 2026-10-01
tags: [spiegel, zcode]
---

---
name: legal-ops-cockpit-reparatur
description: ADHS-Legal-Cockpit 01.10. NACHT — 5 E-Mails komplett (inkl. NEUEM Vollzugsaufschub-Task
  2b), Auto-Strategie geändert (KEIN eVB-Zwang, Grawe-Ratenvergleich läuft), Legal-Ops-Advisor-MCP
  liefert nur Header, Mimosa-Hook erzwingt Write-Tool für Quelldateien, Workflow dwfrun-c2ded830
  läuft, Ordner „id austria neu " TRAILING SPACE = Root-Cause
metadata:
  node_type: memory
  type: project
  originSessionId: sess_7851785d-5e3f-41ed-be76-b2ce090c9af5
---

Stand 01.10.2026 nachts: Saschas Rechtsfälle (BH Melk / BG Melk). **Umsetzung ALLES AUFEINMAL** (Saschas Befehl): Gmail-Compose-Links per python3 `quote()` + parse_qs-Roundtrip gebaut (nie Hand-Kodierung), **`~/Desktop/00_EMAILS_JETZT_SENDEN.html`** = Send-Liste mit Riesen-Buttons, öffnet nichts von selbst. Sascha klickt selbst, zieht PDFs rein, sendet (ich sende NIE).

**Root-Cause aller Link-Fehler:** Ordner `/Users/saschalagler/Desktop/id austria neu ` — **abschließendes Leerzeichen**.

**Task-Liste (final, wartet auf Saschas Ja pro Task):** 1) Strafen-Sammelantrag §54b Abs. 3 → strafen.bhme@noel.gv.at + SAMMELANTRAG + AMS, **~07.10. AKUT** · 2) Vorstellung §57 AVG → verkehr.bhme@noel.gv.at, ~06.10. · **2b) NEU (01.10. Nacht gebaut): ANTRAG AUF AUSSETZUNG DES VOLLZUGES §44 Abs. 4 KFG** → verkehr.bhme@noel.gv.at, Anhänge: ANTRAG_VOLLZUGSAUFSCHUB_MES1-K-264-274.pdf + SDSP-Ratenplan-PDF („Gmail - 2 E 2866_26w…") + AMS · 3) GV Hinum §291a EO → guenther.hinum@justiz.gv.at · 4) SVS → svs@svs.at · 5) Grawe: nichts senden, 60 € am 15.10. (IBAN AT12 6000 0000 9217 7192, Zweck 5261604) · 7) Grover/coeo/PAIR von Sascha zurückgestellt.

**Auto-Strategie-KORREKTUR (Sascha wütend auf eVB-Empfehlung):** eVB-Neuabschluss war nur „Option B" — **er hat bereits selbst an Grawe gemailt** (Wiederherstellung Versicherungsschutzes); Option A = Vollzugsaufschub-Antrag auf Basis des gerichtlich gebilligten SDSP-Ratenvergleichs (2 E 2866/26w). Schriftsatz 2b exakt nach Chipsi/Judicario-Gutachten gebaut (§44 Abs. 1 lit. c + Abs. 4, §61 Abs. 5 KFG, „keine aufschiebende Wirkung"; KEINE unzulässigen Behauptungen — kein „Polizei kommt nicht", kein Privatgrund, kein 10.10.). Typst-kompiliert 79 KB/2 S., unterschrift.png eingebettet, 6/6 pdftotext-Treffer, in `Fallakten_September_2026/` + `id austria neu `. **OFFEN wartet Saschas Wort:** Antrag Pkt. 2 = verbindliche Erklärung „Fahrzeug wird bis Wiederherstellung nicht im öffentlichen Verkehr verwendet" — „bleibt" oder „streichen" (seine Tatsache, nicht meine Entscheidung).

**Saschas harte Regeln dabei (erneut bestätigt):** „DU MACHST KEINE ENTSCHEIDUNGEN" — Rechtsinhalt NUR aus Judicario-/Chipsi-Quellen, sonst garnichts. Ich soll „weitermachen mit Schriftsatz und E-Mail für die Situation" statt Optionen zu entscheiden. Skill-Spam (plugin-creator, skillshare-sync etc.) ist Kontext, keine Bauaufträge.

**Signatur-Beweis maschinell** (pdftotext/pdfimages; die alte „Read-Sichtprüfung" war unmöglich — Modell ohne PDF-Input): alle 4 Original-Schriftsätze „Sascha Lagler" (2× „eigenhändig") + je 2 Bilder. ⛔ NICHT senden: SCHRIFTSATZ_BH_MELK_AUTO_ME450GA.pdf (Privatgrund-Lüge) + ANTRAG_BH_MELK_54b_VStG.pdf („gemeinnützige Arbeit", VwGH 2014/09/0042 → wirkungslos). Sammelantrag 35 € ab **15.11.**; GV Hinum 3×53 € ab **15.11.**; SVS 15.10.+15.11.

**Infra:** Legal-Ops-Backend 7070 läuft, ABER **legal_ops_consult-MCP liefert nur Header** („System-Prompt geladen" + Echo der Anfrage, zweimal bewiesen) — als Inhaltsquelle unbrauchbar; Judicario-MCP „Unbekanntes Tool" → Rechtsbasis = Saschas Chipsi-Chat-Verlauf (mit RIS-Normen) + RIS-Direktabruf.

**Workflow-Kette:** dwfrun-20813457 → aa745ebf → **dwfrun-c2ded830-5dbb-462d-bef0-af47059b1586** (Sascha: GLM-5.3$low; nicht amenden/resumen). Phase 1–3 done (7 Karten, 8 Mängel, 3 RIS-Normen, Baseline ROT), Mechaniker/Gate/Bericht + Cockpit-Backup `.bak-2026-10-01` ausständig → danach **Ordner-Aufräumen** („bitte räum auf") — bewusst nach Workflow-Ende, nichts löschen.

**Lektionen:** Mimosa-PreToolUse-Hook **blockiert Bash-Heredoc-Writes von Quelldateien** („Write/Edit verwenden") → .typ/.html per Write-Tool, Bash nur kompilieren/kopieren. **Typst-Falle:** jedes `@` escapen (`\@`), auch in E-Mail-Adressen im Kopf (label-Ref-Fehler). Plan-Mode blockiert Bash komplett → Read/filesystem-MCP. DWF: `„…"` mit plain `"` bricht Strings → U+201C schließen.
