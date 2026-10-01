---
name: homebrew-taps-workflow
description: 02.10. Homebrew-Tap-Trust VOLLZUG — sqz getrustet ✅, node@20 entfernt ✅,
  ffmpeg gelinkt ✅; offen: untap render braucht --force, certifi link --overwrite,
  sudo mv include/node (Passwort), brew doctor Endkontrolle
metadata:
  node_type: memory
  type: project
  originSessionId: sess_ea4d6e7b-84b7-4777-8062-4dc0a3123686
---

02.10.2026: Homebrew-Doctor-Befunde via `/workflow` analysiert (Run **dwfrun-05fa4a67-facf-4b3c-9797-5162b67b106b**, ABGESCHLOSSEN, alle 4 Befunde verified). Ergebnis:

| Befund | Empfehlung | Beleg |
|---|---|---|
| `ojuschugh1/sqz` | `brew trust ojuschugh1/sqz` | sqz real+aktiv (635 Stars, 282 Commits, Tap-Commit vor 8 Tagen, SHA256-Checksums); persönlicher Tap ohne Core-Review → Checksums im Auge behalten |
| `render-oss/render` | `brew untap render-oss/render` | offizieller Render.com-Tap, aber Repo 06.05.2026 archiviert (read-only); Docs empfehlen nur noch `brew install render` (homebrew-core) |
| node@20 deprecated | `brew uninstall node@20` | `brew uses --installed node@20` = leer; Homebrew disabled Formel am 2026-10-28 |
| `/usr/local/include/node` | NICHT blind löschen — erst `sudo mv node node.bak`, testen, dann löschen | root:wheel, Mai 2025 → NICHT von Homebrew (brew=/opt/homebrew, aktives node v26.8.2); vermutlich alte Intel-Brew/nodejs.org-Install |

**VOLLZUG durch Sascha am 02.10. (Terminal-Output bewiesen):** trust sqz ✅ · node@20 uninstall ✅ (2.068 files, 47,4 MB) · ffmpeg link ✅ (110 Symlinks, ffmpeg-full 9.0.2 → ffmpeg 9.0.1_1 gewechselt).

**Rest-Befehle (Stand Ende der Session offen):**
- `brew untap render-oss/render` blockiert paradox (untrusted tap kann nicht geladen werden, um enttappt zu werden) → **Fix: `brew untap render-oss/render --force`**
- `brew link certifi` blockiert: alte Dateien in `/opt/homebrew/lib/python3.14/site-packages/certifi/` → **Fix: `brew link --overwrite certifi`**
- `sudo mv /usr/local/include/node …/node.bak` lief NICHT (hat auf Passwort gewartet) — noch offen
- Endkontrolle: `brew doctor`

Bericht-Artifact „Homebrew-Taps: Entscheidungsvorlage" (dwfrun-05fa4a67). Siehe [[deja-vu-install]] (brew-Ökosystem).
