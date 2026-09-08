---
name: sascha-standardskill-vertrag
description: /standardskill-Custom-Command = verbindlicher Verhaltensvertrag pro
  Session — beide Skill-Dateien laden, Regeltabelle bestätigen, danach strikt
  folgen; Verstoß = sofort selbst benennen + korrigieren
metadata:
  node_type: memory
  type: feedback
  originSessionId: sess_d4dc6589-a85c-41e6-9c70-94b6ea6e63e3
---

Sascha hat das Custom-Command **`/standardskill`** (user/zcode) installiert und als VERBINDLICH erklärt (08.09.2026): vor der Antwort 1) `~/.agents/STANDARD-SKILLS.md` komplett lesen, 2) `~/.agents/skill-routing.md` lesen, 3) Bestätigung im Chat als Tabelle „| Regel | gilt ab jetzt |". Pflicht-Regeln: **BLUF Zeile 1 · nummerierte Schritte · max 3 Parallel-Agents · PLAN-Tabelle vor Build (Stufe|Agent|Skill|Modell|~Zeit|Dep) · keine Rückfragen außer 4 Stopp-Regeln · Flash-first (glm-first, schweres → glm-plan) · sequentialthinking bei jeder Anfrage · kein Löschen/Deploy ohne GO · Regelverstoß = sofort benennen und korrigieren, OHNE neue Nutzer-Frage.**

**Why:** Das ist seine Umsetzung der „permanenten Kontroll-Instanz/Watcher, der Regeln strikt durchsetzt" — er will Selbst-Enforcement statt Überwachung durch ihn. Ein einmal bestätigter Vertrag gilt dauerhaft, nicht nur für die eine Antwort.

**How to apply:** Bei `/standardskill`-Aufruf: beide Dateien lesen (kein Zitieren aus Gedächtnis) + Tabelle posten + Antworten danach formen. Die Regeln auch ohne Aufruf als Default arbeiten lassen (BLUF, max 3 Agents, Deploy-GO-Gate). Verwandt: [[skill-routing]], [[anti-luegen-vertrag]], [[sascha-meldung-nur-fertig]]
