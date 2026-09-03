# Audits — meta-pantavisor

`AGENTS.md`-compliance audits of `meta-pantavisor`'s docs, as published on
`docs.pantavisor.io`. See [`../../AUDITBOOK.md`](../../AUDITBOOK.md) for the process.
Rows mirror [`../index.md`](../index.md), filtered to this repo.

| Date | Version | Section | Model | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-11 | development | overview | claude-sonnet-5 | S3: `overview/index.md`'s hand-ordered Topics/Build Guide lists omit `composable-firmware`, `examples/`, `glossary`, `port/`, and `testing/` — five of ten top-level `overview/` subsections | [link](2026-08-11-overview-development-claude-sonnet-5.md) |
| 2026-09-03 | development | all | claude-opus-5 | S1: three broken links — `develop/cli-tools/pvcontrol` → `/pantavisor/reference/pantavisor-tools` (unversioned + retired path), `overview/boot-flow` → `glossary.md#trail` (`.md` extension + wrong folder), and both `how-to-install/boards/` pages → `/start/download-and-flash` (no such curated page) | [link](2026-09-03-all-development-claude-opus-5.md) |
