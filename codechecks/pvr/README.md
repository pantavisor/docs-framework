# Code checks — pvr

Source-vs-docs checks of `pvr`'s `docs/` tree against its own source (Go CLI
flags/subcommands, the `PV_*` template-argument vocabulary). `pvr` is hosted
on GitLab, not GitHub — see `../../CODECHECKBOOK.md`'s Repo scope table for
the checkout URL. See [`../../CODECHECKBOOK.md`](../../CODECHECKBOOK.md) for
the process. Rows mirror [`../index.md`](../index.md), filtered to this repo,
grouped by section.

## all

| Date | Ref | Commit | Model | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-27 | master | 5c1cc35 | claude-sonnet-5 | S1: the entire 10-flag global/root flag set (`--user`, `--password`, `--access-token`, `--baseurl`, `--http-proxy`, `--repo-baseurl`, `--config-dir`, `--debug`, `--disable-self-upgrade`, `--insecure`) has zero documentation anywhere in `docs/` | [link](2026-08-27-all-5c1cc35-claude-sonnet-5.md) |
