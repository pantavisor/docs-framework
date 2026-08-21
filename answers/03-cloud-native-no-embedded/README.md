# Answers — Persona 03 — Cloud-native dev, no embedded

Persona card & prompts: [`../../personas/03-cloud-native-no-embedded/`](../../personas/03-cloud-native-no-embedded/)

All runs of this persona, grouped by prompt, newest first. Rows mirror
[`../index.md`](../index.md); this view exists just to filter it to one persona.
This persona has two runs per prompt on 2026-08-04 — the `-2` files are the
same-day reruns.

## Prompt A — Cold-start journey

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: nothing in this path — including the CLI reference and the Configure page — explains how `pvr app add`/`update` authenticates against a private registry, forcing a guess that it reuses local Docker credentials | [link](2026-08-04-promptA-claude-sonnet-5-development-2.md) |
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: nothing in this path explains how `pvr app add`/`update` authenticates against a private registry, forcing a guess that it reuses local Docker credentials | [link](2026-08-04-promptA-claude-sonnet-5-development.md) |

## Prompt B — Targeted task

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S2: the Start page's own "Next steps" tells you to "install your first application with `pvr`" but gives that step no link, so the page that actually shows the command (and answers whether a Docker image is the same as an LXC container) is only reachable by falling back to sidebar navigation, outside the article content this pack's rules told me to prefer | [link](2026-08-04-promptB-claude-sonnet-5-development-2.md) |
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: the docs tell readers to check the "device console (serial or SSH)" but never explain what a serial console is, that it needs a USB-to-TTL adapter, or which one to buy | [link](2026-08-04-promptB-claude-sonnet-5-development.md) |

## Prompt C — Jargon audit

| Date | Version | Model | Outcome | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: `trail` is used repeatedly across the install/configure/remove pages as the thing an app is added to, removed from, and rolled back through, but it is never structurally defined anywhere reachable — not even the dedicated Revisions concept page, which defines "revision" but not "trail" itself | [link](2026-08-04-promptC-claude-sonnet-5-development-2.md) |
| 2026-08-04 | development | claude-sonnet-5 | completed with detours | S1: `container` is used throughout the develop pages as though it means the same thing as a Docker/Kubernetes container, and nothing on the natural reading path says otherwise until deep into the access-applications page, where it turns out to be an LXC namespace running a pre-baked read-only SquashFS image with no live pull/reconcile step | [link](2026-08-04-promptC-claude-sonnet-5-development.md) |
