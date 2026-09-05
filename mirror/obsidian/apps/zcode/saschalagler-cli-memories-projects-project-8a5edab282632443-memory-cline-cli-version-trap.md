---
app: zcode
quelle: "saschalagler/cli/memories/projects/project-8a5edab282632443/memory/cline-cli-version-trap.md"
stand: 2026-09-05
tags: [spiegel, zcode]
---

---
name: cline-cli-version-trap
description: Cline npm-CLI nur als 3.0.15 lauffähig (Upstream-Publish-Gap der
  Plattform-Binaries); vor Upgrade Versionsabgleich prüfen
metadata:
  node_type: memory
  type: project
  originSessionId: sess_16f82fae-2f37-43eb-af25-e2e10796996e
---

Die npm-CLI "Cline Code" brach am 22.08.2026 mit `npm i -g cline@latest` (3.0.56): Das Hauptpaket verlangt das Binary-Paket `@cline/cli-darwin-arm64@3.0.56`, das in der Registry aber nur bis 3.0.15 existiert (Upstream-Publish-Gap, auch Stunden später noch nicht nachgeliefert). npm überspringt fehlende optionalDependencies still → Fehler "Could not find the Cline CLI binary for your platform". Brach am selben Tag ZWEIMAL: beim zweiten Mal war das Paket komplett aus `npm ls -g` verschwunden und `/opt/homebrew/bin/cline` war ein toter Symlink — gleiches Fehlersymptom. Fix jeweils: `npm i -g cline@3.0.15` (verifiziert: `cline --version` → 3.0.15). Recovery-Alias `cline-fix` steht jetzt in `~/.zshrc` (installiert 3.0.15 + zeigt Version).

**Why:** Sascha nutzt die Cline-CLI im Terminal; ein naives Upgrade auf @latest kappt die CLI sofort wieder — passierte trotz Warnhinweis erneut.

**How to apply:** Bei "Could not find the Cline CLI binary": sofort `cline-fix` (Alias) bzw. `npm i -g cline@3.0.15`; nicht mit @latest "reparieren" versuchen. Vor jedem Cline-CLI-Upgrade prüfen: `npm view @cline/cli-darwin-arm64 version` muss mit der Hauptpaket-Version übereinstimmen — sonst auf höchste matchende Version pinnen. Desktop-App `/Applications/Cline Code.app` ist unabhängig (eigenes Binary `cline-app`) und vom Bug nicht betroffen. Wichtig: CLI ≠ VS-Code-Extension — die OmniRoute-Verkabelung ([[omniroute-verkabelung]]) gilt für die Extension (`~/.cline/data/`); die Terminal-CLI hat eine eigene Config, dort beim ersten Start `http://localhost:20128/v1` + Modell `glm-universum` eintragen.
