# Code checks — pantavisor

Source-vs-docs checks of `pantavisor`'s `docs/` tree against its own source
code (CLI, config, API). See [`../../CODECHECKBOOK.md`](../../CODECHECKBOOK.md)
for the process. Rows mirror [`../index.md`](../index.md), filtered to this
repo, grouped by section.

## all

| Date | Ref | Commit | Model | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-27 | master | c228d1e | claude-sonnet-5 | S1: `PV_POWER_DEVMETA_EAGER_PUSH` and `PV_SYSTEM_DISKSDIR` are shipping config keys with zero mention anywhere in `docs/`, sitting right next to sibling keys that are all documented | [link](2026-08-27-all-c228d1e-claude-sonnet-5.md) |
