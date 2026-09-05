---
app: cline-code
quelle: "saschalagler/worktrees/a15eb/Judicario_Sacha_Mac/GIT_HYGIENE_PLAN.md"
stand: 2026-09-05
tags: [spiegel, cline-code]
---

# GIT_HYGIENE_PLAN — Worktree a15eb/Judicario_Sacha_Mac

**Task task_0004 | Nur Analyse & Kopierliste — KEINE Befehle ausgeführt.**

## 1) IST-Zustand (erhoben am Worktree-Root)

- **Detached HEAD**: `git status` → „Im Moment auf keinem Branch."
- **Aktueller Commit**: `2234085` „Initial commit through Cline Kanban" (einziger Commit im Repo).
- **Branches**: nur `master` — ist mit `+` markiert → in einem **anderen Worktree** ausgecheckt, hier nicht verfügbar.
- **Unversioniert**: kompletter Ordner `sprachassistent/` (stt.py, test_stt.py, .venv, .pytest_cache, __pycache__).
- **Geändert, bereits versioniert**: `.DS_Store` (macOS-Müll im Index — sollte raus).
- **Kritisch**: `sprachassistent/.venv` = **194 MB**; darf niemals committet werden.
- **Gefahr Detached HEAD**: Ein Commit ohne Branch wäre nach `git checkout`/Reset **verloren**.

## 2) .gitignore-Entwurf (Datei: Repo-Root, gilt rekursiv)

```gitignore
# Python / sprachassistent
.venv/
venv/
__pycache__/
.pytest_cache/
*.pyc
*.pyo
.env
.env.*

# macOS
.DS_Store
```

Hinweis: Root statt `sprachassistent/.gitignore`, damit `.DS_Store` repoweit abgedeckt ist.
Da `.venv` etc. **nie getrackt** waren, greift die Ignore-Regel sofort — kein `--cached`-Cleanup nötig.

## 3) Befehlssequenz zum Fixen (Kopierliste — selbst ausführen)

```bash
cd /Users/saschalagler/.cline/worktrees/a15eb/Judicario_Sacha_Mac

# a) Branch vom aktuellen HEAD (2234085) anlegen → Detached HEAD aufgelöst
git switch -c feature/sprachassistent

# b) .gitignore mit Inhalt aus Abschnitt 2 anlegen (Editor/Cline)

# c) macOS-Müll aus dem Index entfernen (Datei bleibt lokal erhalten!)
git rm --cached .DS_Store

# d) Selektiv stagen — .gitignore schützt vor .venv & Cache
git add .gitignore sprachassistent/

# e) KONTROLLE vor Commit: darf KEINE .venv-/pycache-Pfade zeigen!
git status

# f) Commit
git commit -m "feat: sprachassistent STT-Modul + .gitignore; .DS_Store aus Index entfernt"
```

## 4) Risiko-Hinweise

1. **Schritt e) ist Pflicht**: Taucht `sprachassistent/.venv/...` in `git status` auf → IGNORE-Datei prüfen, NICHT committen (194 MB, Repo unbrauchbar).
2. `git rm --cached .DS_Store` ändert nur den Index — lokal bleibt die Datei; kein Datenverlust.
3. `master` gehört einem anderen Worktree → hier **keine** master-Operationen, kein Merge/Push ohne Abstimmung.
4. Branch-Name `feature/sprachassistent` ggf. an Team-Konvention anpassen, bevor committet wird.
5. `git switch -c` verliert nichts (neuer Branch zeigt exakt auf HEAD `2234085`) — sicherster erster Schritt.
