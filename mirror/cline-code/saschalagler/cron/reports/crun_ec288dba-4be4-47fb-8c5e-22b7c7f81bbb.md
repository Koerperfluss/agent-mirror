---
runId: crun_ec288dba-4be4-47fb-8c5e-22b7c7f81bbb
specId: cspec_eca49f3a-e1cb-4235-b157-04354074c9aa
scheduleId: sched_79d1d746-7045-4d38-9e92-985c3d6bc2d1
title: Daily change digest
triggerKind: schedule
status: failed
definitionSource: database
workspaceRoot: /
schedule: 0 17 * * *
model: vertex/meta/llama-4-maverick-17b-128e-instruct-maas
sessionId: 1791996940843_cf329
startedAt: "2026-10-14T16:55:40.743Z"
---

# Daily change digest — FAILED

Run of schedule **Daily change digest** (triggered by its schedule) at 2026-10-14T16:55:40.743Z, FAILED in 27.1s.

## Job

- **Definition**: managed schedule `sched_79d1d746-7045-4d38-9e92-985c3d6bc2d1` stored in cron.db (edit via the schedule tools/UI, not a file)
- **Workspace**: /
- **Schedule**: `0 17 * * *`
- **Model**: vertex/meta/llama-4-maverick-17b-128e-instruct-maas
- **Session**: 1791996940843_cf329

### Prompt

```
You write a daily engineering digest for this repository.

## Task

Review everything that landed in the last 24 hours (commits and merged PRs) and distill it into a brief a teammate could read in under a minute.

## Cover

- Changes that matter: new behavior, user-facing impact, and notable bug fixes
- Risky territory: large diffs, sensitive subsystems touched, migrations, dependency or security updates
- Loose ends: missing tests, TODOs introduced, rollout risks, likely follow-ups

## Style

- Group related changes into themes instead of listing every commit.
- Tie every claim to a concrete commit or PR; never guess at intent or invent details.
- Prioritize signal over completeness, and keep the whole digest easy to skim. On quiet days a two-line digest is fine.

## Format

Your last message is the digest itself, so send it directly: no preamble, no process narration, and no notes about how you gathered the information. Start with the date range covered, then 3-7 bullets of meaningful changes, then a short "Worth watching" section with 1-3 risks or pending follow-ups.
```

## Error

The run failed while running the agent turn:

```
Not Found
```

## Usage

- Input tokens: 0
- Output tokens: 0
- Duration: 27.1s
