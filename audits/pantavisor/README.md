# Audits — pantavisor

`AGENTS.md`-compliance audits of `pantavisor`'s docs, as published on
`docs.pantavisor.io`. See [`../../AUDITBOOK.md`](../../AUDITBOOK.md) for the process.
Rows mirror [`../index.md`](../index.md), filtered to this repo.

| Date | Version | Section | Model | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-11 | development | overview | claude-sonnet-5 | S3: `overview/watchdog` describes four watchdog modes but never names the `PV_WDT_MODE`/`PV_WDT_TIMEOUT` config keys that control them | [link](2026-08-11-overview-development-claude-sonnet-5.md) |
| 2026-09-03 | development | all | claude-opus-5 | S3 (no S1 this run): `overview/remote-control` describes the Pantacor Hub client across 763 words with zero fenced blocks or inline code, never naming `PV_CONTROL_REMOTE`, `PV_CONTROL_REMOTE_ALWAYS` or `pvcontrol cmd go-remote` | [link](2026-09-03-all-development-claude-opus-5.md) |
