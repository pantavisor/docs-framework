# Code checks — pantavisor

Source-vs-docs checks of `pantavisor`'s `docs/` tree against its own source
code (CLI, config, API). See [`../../CODECHECKBOOK.md`](../../CODECHECKBOOK.md)
for the process. Rows mirror [`../index.md`](../index.md), filtered to this
repo, grouped by section.

## all

| Date | Ref | Commit | Model | Worst finding | Report |
|---|---|---|---|---|---|
| 2026-08-27 | master | c228d1e | claude-sonnet-5 | S1: `PV_POWER_DEVMETA_EAGER_PUSH` and `PV_SYSTEM_DISKSDIR` are shipping config keys with zero mention anywhere in `docs/`, sitting right next to sibling keys that are all documented | [link](2026-08-27-all-c228d1e-claude-sonnet-5.md) |
| 2026-09-03 | master | 5ae3894 | claude-opus-5 | S2 (no S1 this run): `PV_SECUREBOOT_TRUSTSTORE`/`PV_SECUREBOOT_OEM_TRUSTSTORE` are documented as absolute paths with defaults (`/etc/pantavisor/certs`) that are neither the source default nor the right kind of value — source takes a store name resolved under `<etcdir>/pantavisor/pvs/trust/<name>.crt` | [link](2026-09-03-all-5ae3894-claude-opus-5.md) |
