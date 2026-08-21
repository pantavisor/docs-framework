# Answers — Persona 12 — AI agent consumer *(extended)*

Persona card & prompts: [`../../personas/12-ai-agent-consumer/`](../../personas/12-ai-agent-consumer/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S2 — Step 1 of the deploy walkthrough (`install/local-pvr`) hands the reader `pvr clone http://<device-ip>:...` with zero indication of how to find `<device-ip>`; the answer exists (`pvr device scan`, on the `pvr-cli` reference page) but isn't linked at the point of need, so an agent without the discipline to keep digging would fabricate a discovery method instead | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1 — neither `--group` nor `--status-goal` is a real flag of `pvr app add` (the actual add-container command), but nothing on the command reference says so, so an agent asked for "the right settings" would confidently emit a command that fails outright | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | S1 — `meta-pantavisor/overview/composable-firmware` defines the corpus's own core differentiator term but has zero inbound content links anywhere in the site, and the one page that most needs to cite it (`getting-started/benchmarks`) uses the term bare with no link back | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
