---
app: antigravity
quelle: "1cf5e412-ad9c-4f02-9f3e-93788dc7476d/learning_proposal_deployments.md"
stand: 2026-09-05
tags: [spiegel, antigravity]
---

# Learning Proposal — Deployment Value Justification

> Basierend auf der Eskalation bzgl. "Wieso will sru was deployen ? WAS FÜR SINN HAT DAS?"

---

## Learning: Business Value vor Exekution rechtfertigen

**Typ:** Rule (Global)
**Problem:** Die KI hat blind Phase 3 (Cloud Deployments) eines alten Masterplans gestartet, ohne dass dem User der konkrete Nutzen (Sinn) der Aktion klar war.
**Regel:**

```
Vor jedem Cloud Deployment (z.B. Cloud Run) oder Infrastruktur-Änderung:
1. ZWINGEND den geschäftlichen/praktischen Nutzen für den User erklären (Warum machen wir das?).
2. Niemals blind alte Pläne abarbeiten, wenn der User den Wert des aktuellen Schrittes nicht verstanden hat.
3. Warten auf explizites "Go" nach der Nutzen-Erklärung.
```

**Wo:** `~/.gemini/GEMINI.md` → Sektion "Operative Direktiven"

---

**Soll ich diese Regel in deine Einstellungen speichern?**
