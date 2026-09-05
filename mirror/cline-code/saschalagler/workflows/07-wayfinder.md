# Workflow 07: WAYFINDER — Riesen-Arbeit planen (>1 Session)

Für Arbeit zu groß für eine Session (große bestehende Projekte, Migrationen, Produkte). Nutze den Skill `wayfinder` (~/.zcode/skills/wayfinder/SKILL.md bzw. ~/.agents — lies und folge seinem Karten-Format).

Ablauf:
1. Map anlegen: `<projekt>/.wayfinder/map.md` mit Destination (1-2 Zeilen), Notes (Skills/Modell-Regeln: glm-plan für Entscheidungen), Decisions so far (Index, 1 Zeile + Link), Not yet specified (Nebel), Out of scope
2. Tickets als Dateien `.wayfinder/tickets/NN-<name>.md` mit Label (wayfinder:research|prototype|grilling|task), HITL/AFK, blocked-by-Kante, DONE-WHEN
3. Blocking-Kanten im 2. Durchgang verdrahten (Dateien brauchen erst Namen)
4. Frontier = offene, unblockierte Tickets → pro Session GENAU 1 Ticket abarbeiten (claim→lösen→Resolution-Kommentar in Ticket→map-Decisions-Zeile)
5. Nebel nachtragen, wenn Tickets Entscheidungen freigeben

Beispiel-Referenz: `~/Desktop/Coworkspace_Ich/Analyse-Memorybase tool/.wayfinder/` (Map+4 Tickets live). Konfig-Landkarte global: `~/.agents/WAYFINDER-GLM.md`.
