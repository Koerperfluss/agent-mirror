---
app: zcode
quelle: "saschalagler/cli/memories/projects/default-041661acc4598b22/memory/feedback-belege-am-mac-suchen.md"
stand: 2026-09-15
tags: [spiegel, zcode]
---

---
name: feedback-belege-am-mac-suchen
description: Belege/Dokumente (Kontoauszüge, Rechnungen, PDFs) ERST auf dem Mac
  suchen (Desktop/Downloads/projektordner), bevor man Sascha auffordert sie zu
  liefern — 16.09. eingemahnt („schau doch sind doch am mac")
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_89889126-6bec-4e4b-b8ec-d30614619344
---

16.09.: Ich forderte Sascha auf, den Bank-Auszug September beizubringen („das kann nur er liefern"). Seine Antwort: **„schau doch sind doch e am mac"** — die Sparkasse-Auszüge lagen tatsächlich in `~/Desktop/Sozialhilfeneu/` und lösten die offene 36-€-Frage fast vollständig.

**Why:** Sascha hortet seine Belege auf dem Mac (Desktop-Ordnerstruktur, oft in Kontext-Ordnern wie Sozialhilfeneu/, rechnungen/). Der Mac ist die erste Beweisquelle — der Nutzer ist die letzte.

**How to apply:** Bevor eine Aussage endet mit „das kann nur der Nutzer liefern": ① mdfind/find nach Dateinamen-Stichworten (Kontoauszug, Rechnung, Beleg, IBAN-Pattern), ② typische Ordner prüfen (Desktop ± 3 Ebenen, Downloads, ~/Documents), ③ PDFs per pdftotext -layout + grep auswerten. Erst wenn wirklich nichts auf der Platte liegt, den Nutzer bitten. Verwandt: [[feedback-one-action-not-tables]], [[gcloud-billing-fall-2026-09-15]].
