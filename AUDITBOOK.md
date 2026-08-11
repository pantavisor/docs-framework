# AUDITBOOK — check a repo's docs against its own AGENTS.md

This file is what a Claude Code session follows to scan one repo's `docs/` tree
against the rules in that repo's own `AGENTS.md` — specifically its
**Documentation Structure**, **Actionability (docs/)**, and **Link conventions
(docs/)** sections — and file a compliance report. It's runner-agnostic, same as
`RUNBOOK.md`: a cron job, a `claude -p "..."` invocation, or a manual session can
all point at this file the same way.

This is a different kind of run from `RUNBOOK.md`/`FIXBOOK.md`. `RUNBOOK.md`
simulates a reader's experience against the live site; this scans source markdown
in a repo checkout against a written spec. Findings from either land in a
comparable enough shape (file/location, evidence, suggested fix) that
`FIXBOOK.md`'s fix workflow handles both — see `CLAUDE.md`'s "Applying a fix"
section.

## Invocation contract

> Follow `AUDITBOOK.md` in the docs-eval repo. repo=`<meta-pantavisor|pantavisor>`
> [section=`<all|top-level-docs-subdir>`]

Example: `repo=meta-pantavisor` (defaults to `section=all`), or
`repo=pantavisor section=overview` to scope one run to `docs/overview/` only.
One invocation = one fixed `(repo, section)` combination, same discipline as
`RUNBOOK.md`'s one-persona-one-prompt rule — keeps runs comparable and each
report reviewable. Don't invoke this with a free-form task ("check the docs
structure") — if the trigger passes something other than this exact form, stop
and report the mismatch instead of guessing.

**Repo scope**: this file supports any repo with an `AGENTS.md` at its root
containing the three target sections — currently `meta-pantavisor` and
`pantavisor`. If asked to run against a repo without one (e.g. `pvr`, which has
no `AGENTS.md` today), say so and stop rather than inventing rules to check
against.

## Steps

1. **Get a checkout.** Reuse `CLAUDE.md`'s repo checkout convention:
   `../docs-fix-repos/<repo>/`. Clone if it doesn't exist yet, `git pull` if it
   does — this run needs current source markdown, not the rendered site.

2. **Read that repo's own `AGENTS.md` fresh, every run.** Never assume you
   already know its rules from a prior run or from this file — the two repos'
   `AGENTS.md` files are parallel but not identical (different directory names,
   different structure split: meta-pantavisor is two-way by audience,
   pantavisor is three-way by release-versioning), and either can change
   independently. Locate:
   - The **Documentation Structure** section (a `##`-level heading in
     meta-pantavisor; may appear under a differently-named heading in other
     repos — read for the concept, not the exact heading text).
   - The **`### Actionability (docs/)`** section.
   - The **`### Link conventions (docs/)`** section.

   If a repo's `AGENTS.md` is missing one of these three, note that in the
   report's header and skip only that category for this run — don't fail the
   whole audit over one missing section.

3. **Enumerate** every `.md`/`.mdx` file under `docs/` in the checkout,
   filtered to `section=` if one was given (a top-level subdirectory of
   `docs/`, e.g. `overview`, `getting-started`, `reference`, `tools`).

4. **Link Conventions — deterministic pass.** This is the one category that's
   mechanically checkable, so check it mechanically rather than by eye: for
   every file in scope, extract every markdown link (`[text](target)`) and
   classify it against the rules just read in step 2 — same-folder relative,
   cross-folder-within-repo relative, cross-repo `../../<repo>/<section>/<page>.md`
   pattern, full URL to a curated site page, a retired MkDocs-era prefix (dangles
   on the Docusaurus site), or leftover MkDocs syntax (`!!! Note` admonitions,
   `:material-*:` icon codes) instead of Docusaurus MDX (`:::note ... :::`).
   Do this with a short one-off shell/grep/python pass through your Bash tool —
   write it fresh each run, don't look for a persisted script (this repo
   deliberately has none) — since regex classification of link syntax is far
   more reliable here than reading each file's links by eye across dozens of
   pages.

5. **Documentation Structure and Actionability — judgment pass.** These need
   actual reading, not regex:
   - **Structure**: for each file, does its top-level `docs/` subdirectory
     match the audience test in step 2's rules (e.g. meta-pantavisor: "using
     Pantavisor" → `getting-started/`, "building/contributing to this layer" →
     `overview/")? Is it registered in the relevant hand-maintained index
     (`overview/index.md`'s ordered topic list, a `_category_.json`) — an
     orphaned page that exists but isn't indexed anywhere is a structure
     violation even if it's in the right directory.
   - **Actionability**: for each page, does every feature description have an
     adjacent concrete command, config key, or on-disk path (ideally a fenced
     code block), or an explicit "no action needed" statement for genuinely
     automatic features? A page that only explains a concept in prose with
     nothing runnable nearby is a violation.

   Read every file in scope for a `section=`-scoped run; for `section=all` on
   a large repo, it's fine to read every file for Link Conventions (step 4
   handles that mechanically regardless of count) but sample representatively
   for the two judgment categories and say so explicitly in the report's
   closing summary — don't silently under-cover a large repo and report it as
   exhaustive.

6. **Produce the report**, one table, most severe first:

   | File | Category | Rule | Violation | Evidence | Severity | Suggested fix |
   |---|---|---|---|---|---|---|
   | `docs/overview/get-started.md` | links | Link conventions | Cross-repo link uses a bare path instead of the `../../pantavisor/...` pattern | `[state format](../../../pantavisor-src/docs/reference/...)` | S2 | Rewrite to the documented cross-repo link pattern. |

   - **Category** — one of `structure` / `actionability` / `links`, matching
     `AGENTS.md`'s own three-way split. Not `rubric.md`'s 8-tag gap taxonomy —
     that taxonomy is about a reader's experience gaps, not rule compliance,
     and doesn't map cleanly here.
   - **Severity** — reuses the `S1`–`S4` *letters* from `rubric.md` for
     familiarity, but redefined for compliance rather than reader experience:
     - **S1** — actively broken: a link that 404s, a page required by the
       structure rules that doesn't exist at all.
     - **S2** — non-compliant but still resolves: wrong link pattern that
       happens to still work, a page in the wrong top-level directory.
     - **S3** — present but incomplete: a feature described with no adjacent
       action, a page that exists but isn't indexed.
     - **S4** — pure style: leftover MkDocs syntax, a stale prefix that
       happens to redirect, minor drift from the documented pattern.
   - **Suggested fix** — one sentence, hard limit, same rule as `rubric.md`:
     say where the rule was broken, not how to rewrite the page.
   - **Evidence** — short verbatim quote or the specific link/heading in
     question. A finding without a citation isn't a finding.

   Close with the same four-line summary shape as `rubric.md`, adapted:
   - **Scope covered** — which category/ies were checked, and whether judgment
     categories were fully read or representatively sampled (see step 5).
   - **Worst finding** — the one S1 that most deserves attention, or "none" if
     clean.
   - **What's compliant** — say so explicitly when a section follows its own
     rules cleanly; absence of a finding is a finding, same principle as
     `rubric.md`.
   - **Rules skipped** — any `AGENTS.md` section that was missing or
     unreadable this run (see step 2).

7. **Write the report** to:

   ```
   audits/<repo>/<YYYY-MM-DD>-<section>-<model-slug>.md
   ```

   Use today's date and a filesystem-safe model slug (e.g. `claude-sonnet-5`).
   If a file for this exact repo/section/date/model already exists, append
   `-2`, `-3`, etc. — never overwrite a prior run's report. Prepend this
   header:

   ```markdown
   # Audit — <repo> — <section> — <YYYY-MM-DD>

   Repo: <repo>
   Checkout: ../docs-fix-repos/<repo>/ @ <commit SHA audited>
   Section: <section>
   Date: <YYYY-MM-DD>
   Model: <model-slug>
   Run by: <however this session was invoked>
   ```

8. **Append one row** to `audits/index.md` (create it from `audits/README.md`'s
   template if it doesn't exist yet):

   | Date | Repo | Section | Model | Worst finding | Report |
   |---|---|---|---|---|---|
   | 2026-08-11 | meta-pantavisor | overview | claude-sonnet-5 | S2: `overview/get-started.md` uses a retired MkDocs cross-repo link pattern | [link](meta-pantavisor/2026-08-11-overview-claude-sonnet-5.md) |

   Pull "Worst finding" straight from the report's own closing summary.

9. **Commit** the new report file and the updated `audits/index.md` with git.
   Commit message like `docs-audit: meta-pantavisor overview run (2026-08-11)`.
   **Do not push.** Same rule as `RUNBOOK.md` step 7 — whether/where these
   commits get pushed is a separate, explicit decision.

## Suggested cadence

Not enforced by this file. `AGENTS.md` rules change far less often than the
live site's content, so a much lower cadence than persona runs is reasonable —
monthly per repo (`repo=meta-pantavisor`, then `repo=pantavisor`, each
`section=all`) is a sane starting point. Re-running the same `(repo, section)`
combination periodically is what lets `audits/index.md` show drift — new docs
added since the last run that don't follow convention, or a rule that's now
satisfied that wasn't before.

## Applying a fix from an audit report

Same as an `answers/` finding — see `CLAUDE.md`'s "Applying a fix" section,
which accepts either `answers/<persona>/<report>.md` or
`audits/<repo>/<report>.md` as input to the same `FIXBOOK.md`-based workflow.

## What this run is not

It does not gate or block anything — this repo's whole model is
surface-findings-then-draft-a-PR, human merges, same as every other process
here. A CI check that actually fails a PR on a Link Conventions violation
would need to live in the target repo's own `.github/workflows/`, as a
deterministic script, not as an LLM-driven run of this file — a natural
follow-on, not something this file does.

It also doesn't rewrite `AGENTS.md` itself. If a run reveals the rules
themselves are ambiguous, contradictory, or out of date with the docs they
govern, that's a finding to raise with a human, not something to silently
resolve by picking an interpretation.
