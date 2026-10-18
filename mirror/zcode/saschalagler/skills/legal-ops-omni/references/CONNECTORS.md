# Die 8 Judicario / OpenLaw Gateway Connectors

Das System verfügt über direkte Echtzeit-Connectoren zum OpenLaw / Judicario MCP Gateway:

| Modul | Endpoint | Abgedeckte Rechtsnormen & Jurisdiktion |
|---|---|---|
| **judicario-at** | `/mcp/at/` | Österreich (ABGB, ZPO, VwGVG, AlVG, SAG, EO, StPO, AVG) |
| **judicario-de** | `/mcp/de/` | Deutschland (BGB, ZPO, SGB, VwGO, InsO) |
| **judicario-ch** | `/mcp/ch/` | Schweiz (ZGB, OR, SchKG) |
| **judicario-eu** | `/mcp/eu/` | EU & Menschenrechte (DSGVO, EU AI Act, MDR, EMRK, Verordnungen) |
| **judicario-ip** | `/mcp/ip/` | Geistiges Eigentum (UrhG, MarkenSchG, PatG, EU Trademark) |
| **judicario-steuer** | `/mcp/steuer/` | Österreichisches Steuerrecht (BAO, EStG, UStG, GebG, FinStrG) |
| **judicario-insurance** | `/mcp/insurance/` | Versicherungsrecht AT/DE (VersVG, Kfz-Haftpflicht, Schadensersatz) |
| **judicario-steuer-de** | `/mcp/steuer-de/` | Deutsches Steuerrecht (AO, EStG, UStG, GewStG) |

## API Gateway Konfiguration
- **Base URL:** `https://gateway.openlaw.cc/mcp`
- **Standard API Key:** `jud_gtSG0t_c8db2KMG6FGyqr4r1sMPyXED7`
- **Fallback-Mechanismus:** Sollte ein Gateway-Endpoint offline sein, erfolgt automatischer Failover auf:
  1. Lokale SQLite FTS5 Vektordatenbank (`~/.legal-ops-advisor/legal_knowledge.db`).
  2. RIS-Online BKA Such-Scraper (`site:ris.bka.gv.at`).
