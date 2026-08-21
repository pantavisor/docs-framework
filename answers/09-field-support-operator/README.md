# Answers — Persona 09 — Field support operator

Persona card & prompts: [`../../personas/09-field-support-operator/`](../../personas/09-field-support-operator/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S2 (no S1): `pvcontrol ls`'s `status`/`status goal` columns are never defined anywhere in the serial-console → troubleshooting → pvr-CLI-reference path a field operator actually follows, even though the definitions exist on the site on an unlinked conceptual page | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: the docs describe the serial boot sequence in prose ("bootloader output, then kernel log, then the Pantavisor banner") but never show what it actually looks like, so a field operator has no reference-good boot log to diff a stuck device against | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | S1: the pvtx web UI's REST API section hands over `curl -X POST ".../cgi-bin/pvtx/begin?empty=true"` to "start a fresh transaction" on a live device with no explanation of what that does, whether it's reversible, or how to back out of it — exactly the kind of command that gets run at 2am with no idea what just happened | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
