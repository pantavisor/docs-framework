# Answers — Persona 02 — Buildroot engineer, no Yocto, no containers

Persona card & prompts: [`../../personas/02-buildroot-no-yocto-no-containers/`](../../personas/02-buildroot-no-yocto-no-containers/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | on `.../meta-pantavisor/overview/get-started`, the page that's supposed to be my first build never states that the toolchain is Yocto/BitBake or says anything about Buildroot — I had to infer it from two off-hand mentions of the word "Yocto" buried in unrelated paragraphs about git-worktree sstate sharing, and even then got no sense of migration cost | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | No S1s this run — every one of the four questions has an answer somewhere on `development`. The worst is S3: the sentence that actually answers "can I skip Yocto" (`.../benchmarks/vs-buildroot`) leans on "LXC fork" without ever defining LXC, which is exactly the kind of container jargon I was told I don't know. | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | S1: on the Starter Image page, "image" means a flashable disk image in one paragraph and a Docker container image two paragraphs later in the same table, distinguished only by the negative parenthetical "(not a flashable device image)" — never a positive explanation of what a Docker image actually is, which is exactly the kind of silent meaning-swap that would send a Buildroot reader down the wrong path without ever knowing they'd gone wrong. | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
