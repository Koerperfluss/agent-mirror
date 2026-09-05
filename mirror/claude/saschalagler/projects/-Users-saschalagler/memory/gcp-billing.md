---
name: gcp-billing
description: "GCP-Rechnungskonten-Lage (Stand 2026-07-16) — 867€ Startup-Guthaben, Quota, Fallstricke"
metadata: 
  node_type: memory
  type: project
  originSessionId: b7e0db30-0233-46fa-abf5-e4d17709c0f3
---

**Stand 2026-07-16:**
- **Einziges aktives Rechnungskonto:** `015D43-AC6CDE-D17A3A` (Körperfluss Technologies FlexCo) — 867,15 € Startup-Guthaben, gültig bis 23.04.2027. Quoten-Erhöhung wurde von Google bewilligt; Massen-Verknüpfung der Projekte ist erfolgt. Primäre Karte: Mastercard ••••1879.
- **Geschlossen (nicht mehr verwenden):** `0154CD-53DAEA-BD5FB4` und `016C8A-8149F6-D561F7`.
- **Endgültig geklärt:** Google One / Gemini Advanced (21,99 €) und Workspace (~30 €) sind private Abos und können NIE mit Cloud-Credits bezahlt werden — getrennte Abrechnungssysteme.
- **⚠ Offener Schaden aus Gemini-Session:** `barbulls-app` (Produktions-Shop! siehe [[bar-bulls-firebase]]) und `nervenav` wurden von der Abrechnung ENTKOPPELT (unlink) → Firebase fällt auf Spark zurück. Nach gcloud-Login wieder verknüpfen: `gcloud billing projects link barbulls-app --billing-account=015D43-AC6CDE-D17A3A`.
- **⚠ Lokales gcloud wurde resettet** (`rm -rf ~/.config/gcloud`) — vor jeder Arbeit `gcloud auth login` nötig.
- Gemini-CLI: Projekt via `~/.gemini/.env` (`GOOGLE_CLOUD_PROJECT`) gepinnt, Modell via `~/.gemini/settings.json` (`model.name`). Das ist das gesamte "Hardcoding" — keine versteckten Werte.
