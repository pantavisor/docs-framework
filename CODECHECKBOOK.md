# CODECHECKBOOK — check a repo's docs against its own source code

This file is what a Claude Code session follows to compare a repo's `docs/`
tree against the actual **source code** in that repo — not against
`AGENTS.md`'s structural rules (`AUDITBOOK.md`), not by simulating a reader
(`RUNBOOK.md`) — and file a findings report. It's runner-agnostic, same as the
other two: a cron job, a `claude -p "..."` invocation, or a manual session can
all point at this file the same way.

This is the only check in this pack that needs a **repo checkout**, not the
live site: `RUNBOOK.md` and `AUDITBOOK.md` both fetch `docs.pantavisor.io`,
but there's no live equivalent of "does this CLI flag still exist in source" —
that only exists in the repo itself. Findings still land in a shape
compatible with `FIXBOOK.md`'s fix workflow — see `CLAUDE.md`'s "Applying a
fix" section.

Three repos are in scope today, each with a different shape of "diffable
literal" — see **Repo scope** below before running against one you haven't
used yet. The mechanics (checkout, extract, diff, report) are the same across
all three; only what counts as a symbol and where it lives differs.

## What this check can and can't verify

**Can verify, reliably** — anything that's a literal string on both the
source side and the docs side:

- Whether a symbol defined in source (a CLI subcommand/flag, a config key, a
  REST endpoint, a build-time feature token, a named build target) is
  mentioned anywhere in the relevant `docs/` page(s).
- The reverse: something documented that no longer exists in source at all —
  a stale/removed-feature doc.
- An obvious value mismatch visible directly from the extracted literals — a
  documented default that doesn't match the source default, a documented HTTP
  method that doesn't match the registered one, two docs pages that state
  different values for the same source symbol (report all the conflicting
  values as one finding, not two — reconciling three-way disagreement is one
  fix, not two).

**Can't verify:**

- Prose quality, or whether a documented *description* is accurate beyond an
  obvious literal mismatch — that's what a persona run or a human reviewer is
  for, not this check.
- Runtime/behavioral correctness — this reads source text, it doesn't execute
  anything.
- Whether an omission is a genuine defect or a deliberate choice (an
  internal/debug-only flag nobody meant to document). Flag it as a finding
  either way, but say so, and let a human close it as intentional if it is —
  don't guess and silently skip it.
- A symbol reached only through indirection the extraction step didn't follow
  — e.g. `pvr`'s flags are sometimes declared once in a shared helper function
  and reused by several subcommands (see `pvr` row below); a per-file literal
  grep can miss those. Note any such indirection you had to chase down by
  hand in the report's closing summary, so a false negative here doesn't look
  like a clean pass.

## Invocation contract

> Follow `CODECHECKBOOK.md` in the docs-eval repo. repo=`<pantavisor|meta-pantavisor|pvr>`
> [ref=`<git-ref>`] [section=`<all|repo-specific-section>`]

Example: `repo=pantavisor` (defaults to `ref=<default branch>`,
`section=all`), or `repo=pvr section=cli` to scope one run to `pvr`'s CLI
surface only. One invocation = one fixed `(repo, ref, section)` combination,
same discipline as `RUNBOOK.md`'s one-persona-one-prompt rule and
`AUDITBOOK.md`'s one-`(repo, version, section)` rule. `section` values are
**repo-specific** — see the table below; a `section` valid for one repo isn't
valid for another. Don't invoke this with a free-form task ("check if the
docs match the code") — if the trigger passes something other than this exact
form, stop and report the mismatch instead of guessing.

## Repo scope

Only these three repos are supported — the ones with a clean docs/-vs-source
literal-string surface confirmed by hand. If asked to run against another
repo, say so and stop rather than inventing an extraction pattern for source
you haven't verified is diffable this way.

| Repo | Host / clone URL | Sections | What's diffable |
|---|---|---|---|
| `pantavisor` | `https://github.com/pantavisor/pantavisor.git` | `cli`, `config`, `api` | C daemon + shell CLI tools: literal flag/subcommand strings, a config-key enum, registered REST endpoints. |
| `meta-pantavisor` | `https://github.com/pantavisor/meta-pantavisor.git` | `features`, `kas-targets` | Yocto/BitBake layer: no CLI/API of its own — the diffable surface is build-time feature tokens and named KAS build targets instead. |
| `pvr` | `https://gitlab.com/pantacor/pvr.git` (GitLab, not GitHub — `git clone`, no `gh api`) | `cli`, `templates` | Go CLI (`urfave/cli` v1): subcommand/flag `Name`/`EnvVar` literals, plus a separate `PV_*` template-argument vocabulary. |

`section=all` on any repo runs every section listed for that repo.

## Steps

1. **Checkout.** Reuse `CLAUDE.md`'s existing convention:
   `../docs-fix-repos/<repo>/` (a sibling of this `docs-framework` checkout),
   cloning from the URL in the **Repo scope** table above — note `pvr` is on
   GitLab, so `git clone` directly rather than `gh repo clone`. Clone if the
   folder doesn't exist yet; otherwise `git fetch` and check out the resolved
   `ref` (`git pull` first if `ref` is a branch, not a tag). **Record the
   exact commit SHA** you end up on — that's this run's ground truth. Source
   code has no equivalent of "fetch `AGENTS.md` fresh every run"; the commit
   pin is what makes a run reproducible and comparable to a later one.

2. **Extract source-of-truth symbol lists** for each in-scope section,
   mechanically — grep/shell, not eyeballing, same "mechanical checks should
   be mechanical" rule `AUDITBOOK.md` follows. What to extract, per repo and
   section:

   **`repo=pantavisor`**
   - **`cli`**: subcommand and flag literals from the `usage()`/`usage_*()`
     shell functions in `tools/pvcontrol` and `tools/pventer`; the literal
     `argv[1]`/`argv[2]` dispatch cases in `pvtx/src/pvtx.c`.
   - **`config`**: the enum member list in `config.h`. Also locate wherever
     `PH_*` keys are actually defined (grep for the prefix — don't assume a
     path; note in the report if it isn't found).
   - **`api`**: every `pv_ctrl_add_endpoint(<path>, <method>, ...)` call
     across `ctrl/ctrl_*_ep.c`.

   **`repo=meta-pantavisor`**
   - **`features`**: the `PANTAVISOR_FEATURES ??= "..."` default list in
     `classes/pvbase.bbclass` — this is the primary ground truth docs claim
     to describe. Also note (don't treat as a mismatch source, just context
     in the report) the `:append`/`:remove` modifiers layered on top in
     `conf/distro/*.inc`, which change the *effective* default per distro
     without changing the documented base default. Cross-reference each
     token against `recipes-pv/pantavisor/pantavisor_git.bb`'s
     `bb.utils.contains('PANTAVISOR_FEATURES', '<token>', ...)` gates to
     confirm it's load-bearing (gates a real build option), not decorative.
   - **`kas-targets`**: the named build targets under `kas/build-configs/*.yaml`
     (the `target:` field in each file, and the filename itself — both are
     how a reader would invoke `kas build kas/build-configs/<file>.yaml`).
   - **Docs for both sections**: `docs/overview/meta-pantavisor.md` and
     `docs/overview/build-system.md` both state a `PANTAVISOR_FEATURES`
     default — check each against source **and against each other**; a
     three-way disagreement (source vs. doc A vs. doc B) is one `mismatched`
     finding citing all three values, not two separate findings. For
     `kas-targets`, check `docs/overview/get-started.md`,
     `docs/overview/build-system.md`, and
     `docs/getting-started/develop/cli-tools/*.md` for `kas build
     kas/build-configs/...` examples referencing each target.

   **`repo=pvr`**
   - **`cli`**: `cli.Command{Name: ...}` subcommand registrations and
     `cli.Flag` literals (`Name`, `EnvVar` fields) across `cmd/pvrcli/pvrcli.go`
     (root command + global flags) and `cmd/**/*.go` (per-area subcommands:
     `cmd/app/`, `cmd/device/`, `cmd/sig/`, `cmd/wifi/`, `cmd/dm/`, plus flat
     files directly in `cmd/`). The `Name` field packs `"long, short"` or
     `"long,alias"` as one comma-separated string — split and trim before
     comparing against docs. **Known gap**: some subcommands (e.g.
     `app add`/`app update`/`app install`) get part of their flag set from a
     shared helper function (`cmd/app/appflags.go`'s
     `TemplateArgConfigFlags()`) rather than declaring flags inline — a naive
     per-file grep for `cli.Flag{` misses those; follow the function call to
     find the actual flag list.
   - **`templates`**: the `PV_*`-prefixed template-argument vocabulary
     documented in `docs/PVR_TEMPLATES.md` (e.g. `PV_RUNLEVEL`,
     `PV_GROUP`) — locate where these are actually substituted/read in source
     (grep for the prefix under `libpvr/` and `cmd/`; don't assume a path)
     rather than only checking the `EnvVar` fields already covered by `cli`.
   - **Docs**: `docs/commands/*.md` (`app.md`, `auth.md`, `device.md`,
     `wifi.md`, `sig.md`, `lowlevel.md`, `push.md`, `repo.md`, `utils.md`,
     `deprecated.md`, `clone-get-merge.md`) for `cli`; `docs/PVR_TEMPLATES.md`
     for `templates`. Note a flag's env-var alias sometimes appears only in
     `PVR_TEMPLATES.md` and not in its own command's page (or vice versa) —
     check both before calling something undocumented.

   If an expected source file has moved, or the extraction pattern no longer
   matches anything in it, stop and report the mismatch for that section
   rather than guessing a replacement pattern — same discipline as
   `RUNBOOK.md`'s "exactly one folder should match" rule.

3. **Extract doc-side mentions** of the same symbols from the docs pages
   listed per section above.

4. **Diff, mechanically.** Classify every source-side symbol as:
   - **documented** — found in the corresponding docs page(s);
   - **undocumented** — exists in source, no mention anywhere in scope;
   - **stale** (checked in the other direction) — documented, but no longer
     present in source at all.

   For symbols that are documented, do a light check for an obvious mismatch
   visible directly from the extracted literals (default value, type, HTTP
   method, or — for `meta-pantavisor`'s `features` — disagreement between the
   two docs pages themselves) — not a full semantic review of the surrounding
   prose.

5. **Produce the report**, one table, most severe first:

   | Symbol | Surface | Source location | Docs location | Evidence | Severity | Category | Suggested fix |
   |---|---|---|---|---|---|---|---|
   | `pvcontrol cmd unclaim` | cli | `tools/pvcontrol` `usage_command()` | none | `usage_command()` lists `unclaim` as a valid `cmd` argument; `docs/tools/pvcontrol.md`'s `cmd` table has no `unclaim` row | S1 | `undocumented` | Add an `unclaim` row to `pvcontrol.md`'s `cmd` subcommand table. |
   | `PANTAVISOR_FEATURES` default | features | `classes/pvbase.bbclass` | `docs/overview/meta-pantavisor.md`, `docs/overview/build-system.md` | Source: `... xconnect xconnect-dbus-systembus container-mdev`; `meta-pantavisor.md`: `... xconnect` (missing both); `build-system.md`: `... xconnect container-mdev` (missing one) | S2 | `mismatched` | Reconcile both docs pages' default list against `pvbase.bbclass`'s current default. |

   - **Surface** — the section that found it: `cli` / `config` / `api` (for
     `pantavisor`), `features` / `kas-targets` (for `meta-pantavisor`), `cli` /
     `templates` (for `pvr`).
   - **Category** — one of `undocumented` (in source, not in docs), `stale`
     (in docs, not in source), `mismatched` (documented, but a value
     disagrees with source or with another doc page), `unlinked` (documented
     on some page in scope, but not reachable from the natural entry point).
     Not `rubric.md`'s 8-tag taxonomy — that's about a reader's experience
     gaps, not code/doc parity, and doesn't map cleanly here. Not
     `AUDITBOOK.md`'s `structure`/`actionability`/`links` either — that's
     about `AGENTS.md` rule compliance, a different ground truth entirely.
   - **Severity** — reuses `rubric.md`'s `S1`–`S4` letters for familiarity,
     redefined again for this check's own purpose:
     - **S1** — a shipping, user-facing symbol with zero mention anywhere in
       `docs/`, or a doc describing something that no longer exists in source
       at all (actively misleading).
     - **S2** — documented, but wrong in an actionable way: bad default
       value, wrong type, wrong HTTP method, or two docs pages disagreeing
       with each other as well as with source.
     - **S3** — documented somewhere in scope, but not linked from the page a
       reader would naturally land on for it.
     - **S4** — cosmetic drift only: an old name lingering in a comment or
       example that doesn't change what a reader would actually do.
   - **Suggested fix** — one sentence, hard limit, same rule as `rubric.md`:
     say where the mismatch is, not how to rewrite the page.
   - **Evidence** — the exact source line/function and the exact doc excerpt
     (or "not found" if absent) that make the finding checkable without
     re-running the diff. A finding without both sides cited isn't a finding.

   Close with a four-line summary:
   - **Surfaces covered** — which section(s) ran, and roughly how many
     symbols were checked per surface (e.g. "cli: 19 subcommands/flags across
     3 tools; config: 41 keys; api: 15 endpoints").
   - **Worst finding** — the one S1 that most deserves attention, or "none".
   - **What's compliant** — say so explicitly when a surface is fully
     documented and accurate; absence of a finding is a finding, same
     principle as `rubric.md` and `AUDITBOOK.md`.
   - **Ground truth** — the repo, commit SHA, and date this run checked
     against.

6. **Write the report** to:

   ```
   codechecks/<repo>/<YYYY-MM-DD>-<section>-<short-sha>-<model-slug>.md
   ```

   Use today's date, the checked-out commit's short SHA, and a
   filesystem-safe model slug. If a file for this exact
   section/commit/date/model already exists, append `-2`, `-3`, etc. — never
   overwrite a prior run's report. Prepend this header:

   ```markdown
   # Code check — <repo> — <section> — <YYYY-MM-DD>

   Repo: <repo>
   Ref: <ref>
   Commit: <full-sha>
   Section: <section>
   Date: <YYYY-MM-DD>
   Model: <model-slug>
   Run by: <however this session was invoked>
   ```

7. **Append one row** to `codechecks/index.md` (create it from
   `codechecks/README.md`'s template if it doesn't exist yet):

   | Date | Repo | Ref | Commit | Section | Model | Worst finding | Report |
   |---|---|---|---|---|---|---|---|
   | 2026-08-27 | pantavisor | master | a1b2c3d | cli | claude-sonnet-5 | S1: `pvcontrol cmd unclaim` undocumented | [link](pantavisor/2026-08-27-cli-a1b2c3d-claude-sonnet-5.md) |

   Pull "Worst finding" straight from the report's own closing summary.

   Then append the same row's Date/Ref/Commit/Section/Model/Worst
   finding/Report fields to `codechecks/<repo>/README.md` (create it from the
   pattern in another repo's `README.md` under `codechecks/` if this repo
   doesn't have one yet) — a human-readable rollup of the same data.

8. **Commit** the new report file and the updated `codechecks/index.md` (and
   `codechecks/<repo>/README.md`) with git, in **this** repo
   (`docs-framework`). The checkout in `../docs-fix-repos/<repo>/` is
   read-only for this check — nothing is ever committed there by
   `CODECHECKBOOK.md` itself. Commit message like `docs-codecheck: pantavisor
   cli run (2026-08-27)`. **Do not push.** Same rule as `RUNBOOK.md` step 7 —
   whether/where these commits get pushed is a separate, explicit decision.

## Suggested cadence

Not enforced by this file. Symbols only change when a repo ships a release,
so tying runs to tags is more natural than a calendar cadence — a reasonable
starting point is one `section=all` run per tagged release per repo (see
`CHANGELOG/` in `pantavisor`'s checkout, or the equivalent release history for
`meta-pantavisor`/`pvr`, for what shipped), rather than a fixed weekly or
monthly schedule.

## Applying a fix from a code-check report

Same shape as an `audits/` finding — see `CLAUDE.md`'s "Applying a fix"
section, which accepts `codechecks/<repo>/<report>.md` as input to the same
`FIXBOOK.md`-based workflow. A code-check finding is already scoped to one
repo, same as an audit finding, so `FIXBOOK.md`'s URL-segment routing table
isn't needed for it — go straight to locating the file in the
`../docs-fix-repos/<repo>/` checkout already on disk from step 1 above (reuse
it; don't re-clone).

## What this run is not

It doesn't gate or block anything — same surface-findings-then-draft-a-PR,
human-merges model as every other process here. It doesn't judge whether an
undocumented symbol was a deliberate omission — that's a call for whoever
reviews the finding. And it doesn't do the deeper semantic doc review a
persona run or a human maintainer would — it catches literal presence,
absence, and value mismatches, nothing about whether the prose that *is*
there actually explains the feature well.
