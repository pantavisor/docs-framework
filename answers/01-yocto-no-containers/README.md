# Answers — Persona 01 — Yocto integrator, no containers

Persona card & prompts: [`../../personas/01-yocto-no-containers/`](../../personas/01-yocto-no-containers/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-07-30 | development | claude-sonnet-5 | blocked at step 3 | S1: "trail" is the load-bearing concept for the whole layer and is never defined anywhere reachable from the entry point | [link](2026-07-30-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: the Benchmarks page — built for exactly the flash/RAM/boot-time/build-time cost question this task asks — states plainly that those numbers aren't published yet. | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | S1: LXC is used to define Pantavisor's core "Container" concept and reappears in commands and source-tree names, but is never defined, linked, or expanded anywhere reachable | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
