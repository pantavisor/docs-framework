# Answers — Persona 10 — Git-fluent dev meeting pvr

Persona card & prompts: [`../../personas/10-git-fluent-pvr-newcomer/`](../../personas/10-git-fluent-pvr-newcomer/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: `put`, `post`, and `putobjects` are never distinguished anywhere on `docs.pantavisor.io/development/`; the CLI reference's only pointer for the full command set is the off-domain legacy `docs.pantahub.com/pvr`, so the question has no answer inside the fence at all | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S2 (no S1): `pvr app add`'s own flags list on `cli-tools/pvr-cli` omits `--group` and `--status-goal` entirely, even though the mechanism they control (container startup order) is real and load-bearing; the definitions exist only after crossing into the `pantavisor/` runtime reference section | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: `checkout` is never a command in pvr's vocabulary — only ever a noun for the directory `pvr clone` produces — and nothing in the cli-tools section says the git metaphor exists, let alone that this is where it silently breaks; a git-fluent reader would type `pvr checkout <rev>` and get nothing, with no warning anywhere. | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
