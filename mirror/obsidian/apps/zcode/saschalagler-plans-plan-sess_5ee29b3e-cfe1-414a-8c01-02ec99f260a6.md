---
app: zcode
quelle: "saschalagler/plans/plan-sess_5ee29b3e-cfe1-414a-8c01-02ec99f260a6.md"
stand: 2026-09-18
tags: [spiegel, zcode]
---

# Fix: Browser-Verweis + Dauer-Profil (Login bleibt) + Memory-Layer

## Ursachen (live bewiesen)
1. Keine feste Browser-Adresse in `~/.mcp.json` → Agents starten eigene Wegwerf-Chromes → **jedes Mal neu einloggen** (keine Cookies)
2. Haupt-Chrome (PID 61650) sperrt Profil → **Cache nicht löschbar**
3. 13 doppelte claude-mem-Server (PIDs bewiesen) + Config pinnt alte Version 13.18.0

## Schritte
1. Backup `~/.mcp.json`
2. chrome-devtools-Config: feste Adresse `http://127.0.0.1:9222` + **PERSISTENTES** Profil `~/.zcode/chrome-agent-profile` (KEIN isoliertes Wegwerf-Profil — Cookies/Login bleiben erhalten)
3. Chrome einmal mit diesem Profil starten → du loggst dich EINMAL ein → danach für immer gespeichert
4. claude-mem: Version 13.18.0 → 13.24.23, 12 überzählige Doppel-Prozesse beenden (PID-Liste vorher sichern)
5. `~/.zshenv`: CHROME_PATH + CHROME_DEVTOOLS_URL
6. Verifikation: `curl 127.0.0.1:9222/json/version` (Chrome-Version als Beweis) + Prozess-Count claude-mem = 1

## Ergebnis
- Agents steuern EINEN Chrome, Login bleibt, Cache getrennt, Memory sauber