# AUDITBOOK — check a repo's live docs against its own AGENTS.md

This file is what a Claude Code session follows to scan a repo's docs **as
published on `https://docs.pantavisor.io/<VERSION>/`** against the rules in
that repo's own `AGENTS.md` — specifically its **Documentation Structure**,
**Actionability (docs/)**, and **Link conventions (docs/)** sections — and file
a compliance report. It's runner-agnostic, same as `RUNBOOK.md`: a cron job, a
`claude -p "..."` invocation, or a manual session can all point at this file
the same way.

This runs against the **live site**, not a repo checkout — same data source as
`RUNBOOK.md`'s persona runs, unlike `FIXBOOK.md` which always needs a checkout
to make an edit. That's a deliberate trade-off, not an oversight: see
"What live-site auditing can and can't verify" below before reading the steps.
Findings still land in a shape (`file`/location, evidence, suggested fix)
compatible with `FIXBOOK.md`'s fix workflow — see `CLAUDE.md`'s "Applying a
fix" section — which re-verifies against real source before editing anyway.

## What live-site auditing can and can't verify

Rendered pages have fully-resolved `href`s. A relative link, an absolute
`/repo/section/page` link, and a full URL can all render to the same working
link, so **this file cannot tell what syntax the source markdown actually
used** — that part of Link Conventions genuinely needs a source read, which
`FIXBOOK.md` already does when it locates the real file to edit.

What live-site auditing *can* verify, reliably:

- **Broken links** — anything that 404s.
- **Version drift** — a `/development/` page linking to an unversioned URL or
  a different version's URL (a real bug found in this pack's own persona
  runs: unversioned footer/nav links silently drop the reader onto a
  different version tree).
- **Retired MkDocs-era paths** — these "dangle on the Docusaurus site" per
  `AGENTS.md` itself, i.e. they're supposed to 404 — so this is really a
  subset of the broken-links check, just worth calling out by pattern
  (`.../reference/legacy/`, `.../reference/<NNN>/`, `.../pantavisor-src/docs/...`).
  Off-domain links to `docs.pantahub.com` or similar are a related, separate
  check — flag them, don't assume they're wrong (see `FIXBOOK.md`'s
  `outside-docs` handling for the existing precedent).
- **Leftover MkDocs syntax that failed to render** — a literal `!!! Note` or
  `:material-check:` shows up as raw, un-styled text on the page instead of
  the intended admonition/icon; this is directly visible on the rendered page.
- **Orphaned pages** — reachable by sitemap/direct URL but not linked from
  anywhere in the relevant section's navigation or in-content links (see
  step 3).
- **Actionability** — reading rendered prose for "is there a concrete
  command/config-key/path next to this feature description" is exactly as
  valid on the rendered page as on source; nothing is lost here.

So: **Link Conventions checking on this file is symptom-based** (catches real
breakage and drift), not syntax-based (can't verify the literal source
pattern). Report findings as what a reader actually hits, and let whoever
applies the fix confirm the source-level convention violation when they open
the real file.

## Invocation contract

> Follow `AUDITBOOK.md` in the docs-eval repo. repo=`<meta-pantavisor|pantavisor>`
> [version=`<VERSION>`] [section=`<all|top-level-docs-subdir>`]

Example: `repo=meta-pantavisor` (defaults to `version=development`,
`section=all`), or `repo=pantavisor section=overview` to scope one run to the
`overview` section only. **`version` defaults to `development`** — this pack's
term for the version tracking each repo's main/master branch (there is no
literal `/master/` path on the site; `/development/` is it). One invocation =
one fixed `(repo, version, section)` combination, same discipline as
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

1. **Read that repo's own `AGENTS.md` fresh, every run**, from GitHub directly
   — `gh api repos/pantavisor/<repo>/contents/AGENTS.md --jq '.content' | base64 -d`
   (no checkout needed for this). Never assume you already know its rules from
   a prior run or from this file — the two repos' `AGENTS.md` files are
   parallel but not identical (different directory names, different structure
   split: meta-pantavisor is two-way by audience, pantavisor is three-way by
   release-versioning), and either can change independently. Locate:
   - The **Documentation Structure** section (a `##`-level heading in
     meta-pantavisor; may appear under a differently-named heading in other
     repos — read for the concept, not the exact heading text).
   - The **`### Actionability (docs/)`** section.
   - The **`### Link conventions (docs/)`** section.

   If a repo's `AGENTS.md` is missing one of these three, note that in the
   report's header and skip only that category for this run — don't fail the
   whole audit over one missing section.

2. **Enumerate pages in scope.** Fetch `https://docs.pantavisor.io/sitemap.xml`
   and extract every URL whose path starts with the target repo's segment
   (`meta-pantavisor/` or `pantavisor/`) — the sitemap itself is unversioned,
   so strip the domain and re-apply it under the resolved `<VERSION>`:
   `https://docs.pantavisor.io/<VERSION>/<path-from-sitemap>`. Filter to
   `section=` if one was given (the path segment right after the repo name,
   e.g. `overview`, `getting-started`, `reference`, `tools`). This is the
   closest available approximation to "every page that exists" without a
   checkout — it can miss a page that exists under `<VERSION>` but not under
   whatever version the sitemap reflects, which is itself worth noting as a
   finding if you happen to hit one via an in-content link during step 4.

3. **Fetch each page.** Prefer the `.md` export (append `.md` to the path)
   over rendered HTML for reading prose/Actionability content — same
   preference as `RUNBOOK.md`. For Link Conventions checking specifically,
   also fetch the rendered HTML and read actual `<a href>` values: this
   pack's own persona runs found that the `.md` export silently drops link
   syntax after bold text or at the end of a list item (a real site bug, not
   a content gap — see `answers/`'s findings tagged `broken-path` with `.md`-
   export evidence for the established pattern) — checking rendered HTML
   avoids misreporting that export bug as a Link Conventions violation.

4. **Link Conventions — check what's checkable** (see "What live-site
   auditing can and can't verify" above): for every link found in scope,
   check whether it resolves (fetch or `HEAD` it), whether it stays within
   the same `<VERSION>` when it should, whether a retired-MkDocs-style path
   pattern appears, and whether raw MkDocs admonition/icon syntax is visible
   as literal text on the rendered page. Do this with the Bash tool (`curl
   -o /dev/null -w '%{http_code}'` per link, or batched) rather than
   eyeballing — mechanical checks should be mechanical.

5. **Documentation Structure and Actionability — judgment pass.** These need
   actual reading:
   - **Structure**: does each page's top-level section match the audience
     test in step 1's rules (e.g. meta-pantavisor: "using Pantavisor" →
     `getting-started/`, "building/contributing to this layer" →
     `overview/`)? Is it reachable from the section's own index page or
     sidebar navigation — a page the sitemap lists but that nothing in the
     rendered site links to is an orphan, a structure violation even if it's
     under the right path.
   - **Actionability**: for each page, does every feature description have an
     adjacent concrete command, config key, or on-disk path (ideally a fenced
     code block), or an explicit "no action needed" statement for genuinely
     automatic features? A page that only explains a concept in prose with
     nothing runnable nearby is a violation.

   Read every page in scope for a `section=`-scoped run; for `section=all` on
   a large repo, it's fine to check every page's links mechanically (step 4
   scales regardless of count) but sample representatively for the two
   judgment categories and say so explicitly in the report's closing summary
   — don't silently under-cover a large repo and report it as exhaustive.

6. **Produce the report**, one table, most severe first:

   | Location | Category | Rule | Violation | Evidence | Severity | Suggested fix |
   |---|---|---|---|---|---|---|
   | `https://docs.pantavisor.io/development/meta-pantavisor/overview/get-started` | links | Link conventions | Cross-repo link 404s | `[state format](.../pantavisor-src/docs/reference/...)` returns 404 | S1 | Point the link at the current cross-repo pattern; verify against source when fixing. |

   - **Category** — one of `structure` / `actionability` / `links`, matching
     `AGENTS.md`'s own three-way split. Not `rubric.md`'s 8-tag gap taxonomy —
     that taxonomy is about a reader's experience gaps, not rule compliance,
     and doesn't map cleanly here.
   - **Severity** — reuses the `S1`–`S4` *letters* from `rubric.md` for
     familiarity, but redefined for compliance rather than reader experience:
     - **S1** — actively broken: a link that 404s, a page required by the
       structure rules that doesn't exist at all.
     - **S2** — non-compliant but still resolves: version-drift link that
       still loads (wrong version, not wrong URL), a page reachable but
       clearly in the wrong top-level section.
     - **S3** — present but incomplete: a feature described with no adjacent
       action, a page that's live but not linked from its section's nav
       (orphan).
     - **S4** — pure style: leftover MkDocs syntax rendering as raw text,
       minor drift from the documented pattern that doesn't affect the
       reader.
   - **Suggested fix** — one sentence, hard limit, same rule as `rubric.md`:
     say where the rule was broken, not how to rewrite the page. For a Link
     Conventions finding, note that the exact source-level fix needs
     confirming against the real file (see "What live-site auditing can and
     can't verify") — don't guess at source syntax you can't see.
   - **Evidence** — short verbatim quote, the failing URL, or the specific
     link/heading in question, plus the HTTP status for a broken link. A
     finding without a citation isn't a finding.

   Close with the same four-line summary shape as `rubric.md`, adapted:
   - **Scope covered** — which category/ies were checked, how many pages
     were in scope (sitemap count), and whether judgment categories were
     fully read or representatively sampled (see step 5).
   - **Worst finding** — the one S1 that most deserves attention, or "none"
     if clean.
   - **What's compliant** — say so explicitly when a section follows its own
     rules cleanly; absence of a finding is a finding, same principle as
     `rubric.md`.
   - **Rules skipped** — any `AGENTS.md` section that was missing or
     unreadable this run (see step 1), plus the source-syntax limitation
     noted above (always applies).

7. **Write the report** to:

   ```
   audits/<repo>/<YYYY-MM-DD>-<section>-<VERSION>-<model-slug>.md
   ```

   Use today's date and a filesystem-safe model slug (e.g. `claude-sonnet-5`).
   If a file for this exact repo/section/version/date/model already exists,
   append `-2`, `-3`, etc. — never overwrite a prior run's report. Prepend
   this header:

   ```markdown
   # Audit — <repo> — <section> — <YYYY-MM-DD>

   Repo: <repo>
   Target: https://docs.pantavisor.io/<VERSION>/<repo>/
   Version: <VERSION>
   Section: <section>
   Date: <YYYY-MM-DD>
   Model: <model-slug>
   Run by: <however this session was invoked>
   ```

8. **Append one row** to `audits/index.md` (create it from `audits/README.md`'s
   template if it doesn't exist yet):

   | Date | Repo | Version | Section | Model | Worst finding | Report |
   |---|---|---|---|---|---|---|
   | 2026-08-11 | meta-pantavisor | development | overview | claude-sonnet-5 | S1: `overview/get-started`'s cross-repo state-format link 404s | [link](meta-pantavisor/2026-08-11-overview-development-claude-sonnet-5.md) |

   Pull "Worst finding" straight from the report's own closing summary.

9. **Commit** the new report file and the updated `audits/index.md` with git,
   in **this** repo (`docs-framework`) — no target-repo checkout is touched
   by an audit run. Commit message like `docs-audit: meta-pantavisor overview
   run (2026-08-11)`. **Do not push.** Same rule as `RUNBOOK.md` step 7 —
   whether/where these commits get pushed is a separate, explicit decision.

## Suggested cadence

Not enforced by this file. `AGENTS.md` rules change far less often than the
live site's content, so a much lower cadence than persona runs is reasonable —
monthly per repo (`repo=meta-pantavisor`, then `repo=pantavisor`, each
`section=all`) is a sane starting point. Re-running the same `(repo, version,
section)` combination periodically is what lets `audits/index.md` show drift —
new docs added since the last run that don't follow convention, a link that's
gone stale, or a rule that's now satisfied that wasn't before.

## Applying a fix from an audit report

Same as an `answers/` finding — see `CLAUDE.md`'s "Applying a fix" section,
which accepts either `answers/<persona>/<report>.md` or
`audits/<repo>/<report>.md` as input to the same `FIXBOOK.md`-based workflow.
`FIXBOOK.md` clones/reuses a checkout to make the actual edit — that part is
unchanged; only the *audit* itself is checkout-free.

## What this run is not

It does not gate or block anything — this repo's whole model is
surface-findings-then-draft-a-PR, human merges, same as every other process
here. A CI check that actually fails a PR on a Link Conventions violation
would need to live in the target repo's own `.github/workflows/`, as a
deterministic script running against source at PR time (which can check the
literal syntax rule this file can't) — a natural follow-on, not something this
file does.

It also doesn't rewrite `AGENTS.md` itself. If a run reveals the rules
themselves are ambiguous, contradictory, or out of date with the docs they
govern, that's a finding to raise with a human, not something to silently
resolve by picking an interpretation.
