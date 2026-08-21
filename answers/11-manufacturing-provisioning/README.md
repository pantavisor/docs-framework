# Answers — Persona 11 — Manufacturing / provisioning engineer *(extended)*

Persona card & prompts: [`../../personas/11-manufacturing-provisioning/`](../../personas/11-manufacturing-provisioning/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | the only documented lead toward bulk/scriptable per-unit device identity — the `PH_FACTORY_AUTOTOK` "factory auto token" — is explained entirely on a different site (`docs.pantahub.com`), so `docs.pantavisor.io` itself contains no answer at all to whether the flashing line needs a per-unit network round-trip and a cloud call | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | the security section of the docs states outright that secret handling — the exact mechanism that would explain per-unit certificate/key injection at manufacture — is future/planned content, so the persona's central worry ("if two units left your line identical, would anything catch it?") has no answer anywhere on this version of the site | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1 — the only documented way to `claim` a device is a one-at-a-time, human-driven web form on hub.pantacor.com, with `/pv/device-id` and `/pv/challenge` never explained for generation, uniqueness, or persistence across re-flash anywhere reachable in the docs, leaving per-unit identity at scale unanswered | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
