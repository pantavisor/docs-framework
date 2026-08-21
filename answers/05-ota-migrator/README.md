# Answers — Persona 05 — OTA engineer migrating off Mender/RAUC

Persona card & prompts: [`../../personas/05-ota-migrator/`](../../personas/05-ota-migrator/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | S1: the Operate-devices page admits canary rollouts and staged-deployment guides are "coming soon," and the only deployment command found anywhere (`pvr post <device-url>`) targets one device at a time — for a 40,000-device fleet, that answer doesn't exist on this version of the site yet | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: `security/atomicity-and-trust` — the page whose whole purpose is proving the atomic-update claim — gives one asserted sentence ("a power cut leaves the device able to boot *some* good revision") instead of stage-by-stage evidence for what's on the device at each of five power-fail points | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | on `.../migrate/mender`, `pvr commit` (a CLI action, run before an update reaches a device) and the runtime health-gated commit (the bootloader marking a booted trial revision as good) are both just called "commit," and the page's own text — "Both gate the commit on a healthy boot" — reads as if they're the same action | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |

*Exploratory lane — no seeded gap in `ground-truth.md` yet (see that file's "Lane coverage").*
