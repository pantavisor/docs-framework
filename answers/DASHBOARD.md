# Findings dashboard

**Last generated:** 2026-08-20, from the 39 runs in [`index.md`](index.md) as of that
date. This is a manual, periodic snapshot — not regenerated automatically by
`RUNBOOK.md`. Re-run the same read-and-tally pass over `answers/**/*.md` after a
batch of new runs to refresh it; stale numbers here are a sign it's due, not a bug.

Severity labels are `rubric.md`'s: **S1 — Critical**, **S2 — Major**,
**S3 — Minor**, **S4 — Trivial**.

Note: 7 of the 39 reports (all Prompt C "jargon audit" runs for personas 01, 04, 05,
06, 08, 10, 11) use a plain Term/First-use/Definition table with no Severity/Type
columns, so they're outside the counts below by design — the tallies cover the 32
reports (187 finding rows) that use the rubric's Severity/Type table.

## Severity counts (187 findings, 32 reports)

| Severity | Count | Share |
|---|---|---|
| S1 — Critical | 60 | 32% |
| S2 — Major | 47 | 25% |
| S3 — Minor | 48 | 26% |
| S4 — Trivial | 32 | 17% |

## Gap-tag frequency

| Tag | Count |
|---|---|
| `missing-concept` | 55 |
| `broken-path` | 41 |
| `undefined-jargon` | 41 |
| `stale` | 15 |
| `outside-docs` | 14 |
| `no-example` | 10 |
| `unlinked` | 7 |
| `wrong-audience` | 2 |

Two rows used a non-standard tag, `friction` (both in
`11-manufacturing-provisioning/…promptB…`, both S3 — Minor) — not one of
`rubric.md`'s 8 tags. Worth a maintainer fix to the prompt or a one-off report
correction; not folded into the counts above.

## Dominant severity per tag

| Tag | Total | Dominant severity | Full breakdown |
|---|---|---|---|
| `missing-concept` | 55 | S1 — Critical (45) | S1:45, S2:3, S3:7 |
| `broken-path` | 41 | S2 — Major (31) | S2:31, S3:3, S4:7 |
| `undefined-jargon` | 41 | S3 — Minor (28) | S1:3, S2:5, S3:28, S4:5 |
| `stale` | 15 | S4 — Trivial (12) | S2:1, S3:2, S4:12 |
| `outside-docs` | 14 | S1/S4 tie (5 each) | S1:5, S2:3, S3:1, S4:5 |
| `no-example` | 10 | S1 — Critical (5) | S1:5, S3:4, S4:1 |
| `unlinked` | 7 | S2 — Major (3) | S1:2, S2:3, S4:2 |
| `wrong-audience` | 2 | — | S2:1, S3:1 |

Reading this: `missing-concept` is both the most common tag and the one most
likely to be a hard blocker (82% of its rows are S1). `broken-path` and
`undefined-jargon` are nearly as common but usually survivable (mostly S2/S3)
— the information exists, the reader just has to work for it.

## Worst findings — leaderboard

One representative S1 per persona/theme (many reports independently re-cite the
same underlying gaps — see Recurring gaps below — so this list picks distinct
root causes rather than repeating them).

| # | Persona / Prompt / Date | What blocked me | Tag | Report |
|---|---|---|---|---|
| 1 | 01 — Yocto integrator, A, 2026-07-30 | The whole page pivots on "trail" as if I already know what it is — never saw it defined anywhere I clicked from the overview. | `missing-concept` | [link](01-yocto-no-containers/2026-07-30-promptA-claude-sonnet-5-development.md) |
| 2 | 02 — Buildroot engineer, A, 2026-08-04 | Nothing on this page or anywhere I reached from it ever states plainly "this build system is Yocto/BitBake" — I had to infer it myself. | `missing-concept` | [link](02-buildroot-no-yocto-no-containers/2026-08-04-promptA-claude-sonnet-5-development.md) |
| 3 | 03 — Cloud-native dev, A, 2026-08-04 | I'm about to run `pvr app add` against our private company registry, but nothing says how the pull authenticates. | `missing-concept` | [link](03-cloud-native-no-embedded/2026-08-04-promptA-claude-sonnet-5-development.md) |
| 4 | 05 — OTA migrator, A, 2026-08-04 | I need to know how to roll a revision out to 5% of the fleet — the only deployment primitive targets exactly one device; the docs tell me straight out this doesn't exist yet. | `missing-concept` | [link](05-ota-migrator/2026-08-04-promptA-claude-sonnet-5-development.md) |
| 5 | 06 — BSP bring-up, B, 2026-08-04 | I have a working kernel and need to know what to change in my defconfig — nothing tells me which kernel options or subsystems Pantavisor depends on. | `missing-concept` | [link](06-bsp-bringup/2026-08-04-promptB-claude-sonnet-5-development.md) |
| 6 | 07 — Security reviewer, A, 2026-08-04 | I'm told exactly how Pantavisor validates a revision's signature once it's running, but nothing describes what authenticates the bootloader, kernel, or initrd — the trust chain has no documented beginning. | `missing-concept` | [link](07-security-reviewer/2026-08-04-promptA-claude-sonnet-5-development.md) |
| 7 | 08 — Adoption evaluator, A, 2026-08-04 | I came in looking for a reason to say no, and the one page built to give me independently reproducible numbers instead tells me the numbers don't exist yet. | `missing-concept` | [link](08-adoption-evaluator/2026-08-04-promptA-claude-sonnet-5-development.md) |
| 8 | 09 — Field support operator, B, 2026-08-04 | I'm told to press Enter for a debug shell, but nothing on the site actually shows me what that looks like — I have no reference-good log to eyeball a stuck device against. | `no-example` | [link](09-field-support-operator/2026-08-04-promptB-claude-sonnet-5-development.md) |
| 9 | 10 — Git-fluent dev, A, 2026-08-04 | I never found `pvr checkout` or `pvr get` documented as actual commands, so I can't tell if git's fetch/checkout split exists in pvr at all. | `outside-docs` | [link](10-git-fluent-pvr-newcomer/2026-08-04-promptA-claude-sonnet-5-development.md) |
| 10 | 11 — Manufacturing engineer, B, 2026-08-04 | I need to know where per-unit secrets and certificates get injected at manufacture — the docs say outright that this isn't written yet. | `missing-concept` | [link](11-manufacturing-provisioning/2026-08-04-promptB-claude-sonnet-5-development.md) |

Runner-up: **12 — AI agent consumer, C, 2026-08-04** — `composable-firmware`
defines the product's own core differentiator term but has zero inbound links
anywhere on the site (`unlinked`).

## Recurring gaps (cited independently in 3+ reports)

The strongest signal in the pack: a gap that surfaces from multiple, unrelated
persona angles is a page that needs to exist or be linked, not a one-off.

| Gap | Cited in |
|---|---|
| **"trail" never structurally defined**, despite being load-bearing across install/remove/rollback docs | `01-yocto-no-containers` (promptA, 2026-07-30), `03-cloud-native-no-embedded` (promptA, both runs), `04-app-dev-on-device` (promptA), `08-adoption-evaluator` (promptB), `12-ai-agent-consumer` (promptB) — 6 reports |
| **LXC used to define "Container" itself, never defined anywhere** | `02-buildroot-no-yocto-no-containers` (promptB), `03-cloud-native-no-embedded` (promptB, both runs), `04-app-dev-on-device` (promptA), `06-bsp-bringup` (promptA), `07-security-reviewer` (promptB), `12-ai-agent-consumer` (promptB) — 7 reports |
| **Glossary exists but is unreachable / zero inbound links** | `02-buildroot-no-yocto-no-containers` (promptA, promptB), `03-cloud-native-no-embedded` (promptB), `08-adoption-evaluator` (promptA), `10-git-fluent-pvr-newcomer` (promptA), `12-ai-agent-consumer` (promptC) — 6 reports |
| **Serial console assumed familiar, never explained** (what it is / which adapter) | `06-bsp-bringup` (promptB), `10-git-fluent-pvr-newcomer` (promptB), `11-manufacturing-provisioning` (promptA) — 3 reports |
| **`status_goal`/"status goal" enum values never resolved on the reader's actual path** | `05-ota-migrator` (promptA), `09-field-support-operator` (promptA, promptB), `12-ai-agent-consumer` (promptB) — 4 reports |

These five map closely onto `ground-truth.md`'s gaps #1 (glossary unreachable),
#4/#12 (cross-repo enums unresolvable), #7 (Yocto/BitBake/KAS undefined), and
#14 ("trail" promised but not delivered) — the pack is still finding the same
seeded gaps from new angles, which is the expected, healthy result.
