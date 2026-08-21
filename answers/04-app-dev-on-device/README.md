# Answers — Persona 04 — App developer targeting a Pi

Persona card & prompts: [`../../personas/04-app-dev-on-device/`](../../personas/04-app-dev-on-device/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | S2: the install walkthrough's clone step requires a device IP it never explains how to find — only discoverable by stumbling onto `pvr device scan` on the CLI reference page while there for an unrelated reason | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S2: the actual starter-image file for step 1 isn't hosted on `docs.pantavisor.io` at all — `getting-started/start/download-and-flash` sends the reader to `https://pantavisor.io/downloads/`, a different domain, with no `curl`/`wget` alternative given on the docs page itself | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed | "Yocto" is used on the `develop` page as though it's just another tool name, and it is never defined anywhere reachable (not the glossary, not the meta-pantavisor overview) — it's the exact concept I have a hard stop on, introduced with zero warning | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
