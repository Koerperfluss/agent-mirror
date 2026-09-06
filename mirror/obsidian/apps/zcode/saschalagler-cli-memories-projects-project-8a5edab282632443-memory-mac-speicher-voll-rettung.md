---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/mac-speicher-voll-rettung.md"
stand: 2026-09-06
tags: [spiegel, zcode]
---

---
name: mac-speicher-voll-rettung
description: Saschas Mac-Platte 06.09. voll (22/460 GB frei) — gemessene Zahlen,
  genehmigter Rettungsplan, Beweis-Ordner ~/Desktop/SPEICHER-RETTUNG, offene
  Frage iCloud-Plan-Größe
metadata:
  node_type: memory
  type: project
  originSessionId: sess_3ffe33ff-d0c0-4639-a973-ab1d721343be
---

**Stand 06.09.2026 abends:** Mac 460 GB, nur noch 22 GB frei (95 % belegt). Baseline in `~/Desktop/SPEICHER-RETTUNG/00-baseline.log`.

Gemessene Real-Zahlen (du):
- **Schreibtisch 98,1 GB · Dokumente 84,65 GB** (videos 17,2 + djo videos 8,4 + BB-Videos 9,4 + viele Einzel-MP4s à 200–400 MB) = primäre Auslager-Kandidaten
- Library ~82 GB: Application Support 48 GB (Claude-3p 12 GB, Claude 10 GB, **Google/DriveFS nur 7,7 GB**, Sigma 6 GB) + Containers 13 GB + Mobile Documents 10 GB — Saschas „Application Support 90 GB" war die GANZE Library; DriveFS ist NICHT der Riesen-Block (Annahme im ersten Plan korrigiert)
- AI-Caches: .lmstudio 19,65 GB · .claude 9,62 · .gemini 8,79 · .zcode 8,78 · .cache 3,61 · .hermes 3,27

**Kernbefund (Sascha-Screenshot):** iCloud Drive AKTIV — Cloud nur **6,70 GB**, aber Offline-Kopien belegen **100,86 GB lokal** → iCloud-Plan zu klein für die Dateien, deshalb ist die Platte voll. Er hat „endlich iCloud" UND Google Drive („endlos", App installiert).

**Genehmigter Plan (ExitPlanMode approved):** 1) Google Drive auf Streaming-Modus (computer-use), Cache leert sich selbst · 2) Videos/Dokumente in Cloud hochladen (iCloud falls Plan reicht, sonst Google Drive Streaming) → Stub bleibt im Finder sichtbar · 3) lokale Kopie erst freigeben NACH Upload-Beweis · 4) df vorher/nachher + Stichprobe als Beweis (Anti-Lügen-Vertrag).

**Offen:** iCloud-Plan-Größe unbekannt — 1 Frage an Sascha gestellt („weiß nicht" möglich → via Systemeinstellungen/computer-use ablesen). STOP-Ereignis mitten in der Desktop/Dokumente-Messung brach du ab — Fortsetzung erst nach seiner Antwort. Siehe [[sascha-agenten-ordner-unantastbar]], [[anti-luegen-vertrag]].
