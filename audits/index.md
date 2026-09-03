# Run index

One row per run, newest first. Populated by `AUDITBOOK.md` — see that file for the
process. Manual runs not filed through `AUDITBOOK.md` aren't tracked here unless
someone adds them by hand.

| Date | Repo | Version | Section | Model | Worst finding | Report |
|---|---|---|---|---|---|---|
| 2026-09-03 | meta-pantavisor | development | all | claude-opus-5 | S1: three broken links — `develop/cli-tools/pvcontrol` → `/pantavisor/reference/pantavisor-tools`, `overview/boot-flow` → `glossary.md#trail`, and both `how-to-install/boards/` pages → `/start/download-and-flash` | [link](meta-pantavisor/2026-09-03-all-development-claude-opus-5.md) |
| 2026-09-03 | pantavisor | development | all | claude-opus-5 | S3 (no S1): `overview/remote-control` describes the Hub client across 763 words with zero code, never naming `PV_CONTROL_REMOTE`, `PV_CONTROL_REMOTE_ALWAYS` or `pvcontrol cmd go-remote` | [link](pantavisor/2026-09-03-all-development-claude-opus-5.md) |
| 2026-08-11 | meta-pantavisor | development | overview | claude-sonnet-5 | S3: `overview/index.md`'s hand-ordered Topics/Build Guide lists omit `composable-firmware`, `examples/`, `glossary`, `port/`, and `testing/` — five of ten top-level `overview/` subsections | [link](meta-pantavisor/2026-08-11-overview-development-claude-sonnet-5.md) |
| 2026-08-11 | pantavisor | development | overview | claude-sonnet-5 | S3: `overview/watchdog` describes four watchdog modes but never names the `PV_WDT_MODE`/`PV_WDT_TIMEOUT` config keys that control them | [link](pantavisor/2026-08-11-overview-development-claude-sonnet-5.md) |
