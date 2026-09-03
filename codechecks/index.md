# Run index

One row per run, newest first. Populated by `CODECHECKBOOK.md` — see that
file for the process. Manual runs not filed through `CODECHECKBOOK.md` aren't
tracked here unless someone adds them by hand.

| Date | Repo | Ref | Commit | Section | Model | Worst finding | Report |
|---|---|---|---|---|---|---|---|
| 2026-09-03 | pantavisor | master | 5ae3894 | all | claude-opus-5 | S2: `PV_SECUREBOOT_TRUSTSTORE`/`PV_SECUREBOOT_OEM_TRUSTSTORE` documented as absolute paths with defaults that are neither the source default nor the right kind of value (source takes a store name) | [link](pantavisor/2026-09-03-all-5ae3894-claude-opus-5.md) |
| 2026-09-03 | meta-pantavisor | master | 760e523 | all | claude-opus-5 | S1: six load-bearing feature tokens (`wakelocks`, `console-logging`, `automod`, `caam-nxp`, `dcp`, `debug-hooks`) have zero mention anywhere in `docs/` | [link](meta-pantavisor/2026-09-03-all-760e523-claude-opus-5.md) |
| 2026-09-03 | pvr | master | 45b4dbf8 | all | claude-opus-5 | S1: `PVR_NOFAKEROOT` and `FAKEROOT_CMD` have zero mention anywhere in `docs/`, on the very page explaining the fakeroot behaviour they modify | [link](pvr/2026-09-03-all-45b4dbf8-claude-opus-5.md) |
| 2026-08-27 | pantavisor | master | c228d1e | all | claude-sonnet-5 | S1: `PV_POWER_DEVMETA_EAGER_PUSH` and `PV_SYSTEM_DISKSDIR` are shipping config keys with zero mention anywhere in `docs/` | [link](pantavisor/2026-08-27-all-c228d1e-claude-sonnet-5.md) |
| 2026-08-27 | meta-pantavisor | master | f9613e7 | all | claude-sonnet-5 | S1: the `.github/configs/release/` path was removed from source but is still the literal, copy-pasteable command in 14 docs files | [link](meta-pantavisor/2026-08-27-all-f9613e7-claude-sonnet-5.md) |
| 2026-08-27 | pvr | master | 5c1cc35 | all | claude-sonnet-5 | S1: the entire 10-flag global/root flag set (`--user`, `--password`, `--baseurl`, etc.) has zero documentation anywhere in `docs/` | [link](pvr/2026-08-27-all-5c1cc35-claude-sonnet-5.md) |
