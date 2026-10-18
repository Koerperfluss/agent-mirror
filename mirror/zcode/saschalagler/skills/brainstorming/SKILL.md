---
name: brainstorming
description: Sharpen a raw, fuzzy idea into a concept precise enough to grill. Use when the user has a germ of an idea — a feeling, a half-sentence, a "what if" — but hasn't defined what it actually IS yet. Stops when the idea is sharp enough for /grilling.
disable-model-invocation: true
---

# /brainstorming — Ideation Interview

Take a raw, fuzzy idea and shape it into a concept sharp enough to hand off to `/grilling`.

## When to use this vs grilling

**Brainstorming** is *convergence* — the idea is still a germ. You don't yet know what it IS. The goal is to give it a name, a boundary, and a core.

**Grilling** is *validation* — the idea has shape. The goal is to test whether it holds up (wozu, was blockiert es, was ist das einfachste, woran erkennst du erfolg).

If the user can already state what the thing is in one sentence, skip straight to `/grilling`.

## How to run it

Ask ONE question at a time. For each, give your recommended answer based on everything you know — context, memory (claude-mem), Kanban, past sessions, the user's project history. Wait for the answer before asking the next.

If a *fact* can be found by exploring the environment, look it up rather than asking. The *decisions* are the user's.

## The arc

Stop at the first question where the user's answer is already sharp — don't ask the rest:

1. **What is this?** — Push for a noun, not a verb. ("A tool that..." → "A [thing] for [whoever] that [does what].")
2. **Who is it for?** — Name the person or role, not a market segment.
3. **What does it replace?** — The delta over today's status quo. If the answer is "nothing," flag it — that's a red flag for grilling.
4. **What do you call it?** — The canonical name. This is the first seed for the ubiquitous language.

## Vocabulary

When a term emerges that could be ambiguous later, flag it inline: "When you say X, do you mean A or B?" Don't build a full glossary — just catch the obvious ones. These are seeds for `/domain-modeling`.

## When to stop

Stop when the user can answer without hedging — or when they say "I already know this, let's grill it." Present the sharpened concept:

> **[Name]** — a [thing] for [who] that [does what], replacing [status quo].

Then ask: "Sharp enough to grill?" If yes, hand off to `/grilling`. In a project flow, grilling feeds the ponytail-gate, which feeds Kanban.

This skill is stateless — no files, no tasks, no code. Pure interview.
