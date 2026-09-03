# Code checks — meta-pantavisor

Source-vs-docs checks of `meta-pantavisor`'s `docs/` tree against its own
source (BitBake feature defaults, named KAS build targets — see
`../../CODECHECKBOOK.md`'s Repo scope table for why this repo's diffable
surface looks different from `pantavisor`'s). See
[`../../CODECHECKBOOK.md`](../../CODECHECKBOOK.md) for the process. Rows
mirror [`../index.md`](../index.md), filtered to this repo, grouped by
section.

## all

| Date | Ref | Commit | Model | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-27 | master | f9613e7 | claude-sonnet-5 | S1: the `.github/configs/release/` path was removed from source (commit `7cd9f72`) but is still the literal, copy-pasteable command in 14 docs files, and is asserted as a real path in `build-system.md`'s own path-reference table | [link](2026-08-27-all-f9613e7-claude-sonnet-5.md) |
| 2026-09-03 | master | 760e523 | claude-opus-5 | S1: six load-bearing `PANTAVISOR_FEATURES` tokens (`wakelocks`, `console-logging`, `automod`, `caam-nxp`, `dcp`, `debug-hooks`) have zero mention anywhere in `docs/`, two of them advertised in `pvbase.bbclass`'s own comment block | [link](2026-09-03-all-760e523-claude-opus-5.md) |
