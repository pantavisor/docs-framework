# Answers — Persona 06 — BSP bring-up engineer

Persona card & prompts: [`../../personas/06-bsp-bringup/`](../../personas/06-bsp-bringup/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: the docs never state what kernel config (namespaces, cgroups, overlayfs, squashfs) an existing BSP kernel needs for LXC and the config-overlay mechanism to work — the exact container/kernel boundary this persona's mental model says the docs have to draw | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: nothing on the runtime (`pantavisor/`) or BSP (`meta-pantavisor/`) side of the docs shows what a healthy boot looks like on the serial console, so a failed bring-up has no reference-good log to diff against | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | `platform` is used consistently in the SoC/board-family sense on the two pages I was sent to read, but the same bare word means a CPU-architecture string in one place and the name of a default container startup-group in another, one and two link-hops away, with nothing anywhere flagging the overload — exactly the "you'd wire it up wrong and lose a day" failure mode this prompt was built to catch | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
