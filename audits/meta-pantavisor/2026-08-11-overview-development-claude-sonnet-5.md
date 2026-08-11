# Audit — meta-pantavisor — overview — 2026-08-11

Repo: meta-pantavisor
Target: https://docs.pantavisor.io/development/meta-pantavisor/
Version: development
Section: overview
Date: 2026-08-11
Model: claude-sonnet-5
Run by: manual Claude Code session (inline, `docs-framework` repo)

## Findings

| Location | Category | Rule | Violation | Evidence | Severity | Suggested fix |
|---|---|---|---|---|---|---|
| `https://docs.pantavisor.io/development/meta-pantavisor/overview/` | structure | Documentation Structure — "`overview/index.md` carries a hand-ordered topic list, so add new `overview/` pages there too" | Five of the ten top-level `overview/` subsections are missing from `overview/index.md`'s hand-ordered "Topics" and "Build Guide" lists, discoverable only via sidebar nav, not via the index page's own curated list | `overview.md`'s "Topics" (6 items: meta-pantavisor, build-system, images, flashing-images, boot-flow, pv-flash-bundle) and "Build Guide" (7 items: get-started, supported-device, pantavisor-development, container-development, manifest-audit, component-docs, bootchartd) omit `composable-firmware`, `examples/`, `glossary`, `port/`, and `testing/` entirely — confirmed present in the sidebar nav (`href=/development/meta-pantavisor/overview/{composable-firmware,examples/,glossary,port/,testing/}` in the rendered page's HTML) but absent from both ordered lists in the page body | S3 | Add the five missing sections to `overview/index.md`'s Topics/Build Guide (or a new grouping) per `AGENTS.md`'s own instruction to keep new `overview/` pages listed there. |
| `https://docs.pantavisor.io/sitemap.xml` | links | Link conventions — sitemap is meant to approximate "every page that exists" for a version | Sitemap is unversioned and reflects the **stable/default** version's URL structure for `overview/testing/*`, not `development`'s — re-applying the `/development/` prefix to the sitemap's literal paths 404s | Sitemap lists `meta-pantavisor/overview/testing/automated-workflow`, `testing/development-workflow`, `testing/testplans/testplan-*`; `https://docs.pantavisor.io/development/meta-pantavisor/overview/testing/automated-workflow` → 404. The real `/development/` structure for that subsection is `testing/automated.md` (hub) + `testing/automated/{appengine,device,pvtest-list}.md` and `testing/manual.md` (hub) + `testing/manual/testplans/testplan-*.md` — all confirmed 200 via `.md` export and cross-checked against in-content links from `testing.md`/`testing/manual.md` | S3 | Not an `overview/` authoring issue — flag to whoever owns sitemap generation that it should be generated per-version (or from `development`) rather than reflecting only stable. |

## Scope covered

- **Categories checked**: all three — Documentation Structure, Actionability, Link Conventions (`AGENTS.md` fetched fresh this run via `gh api repos/pantavisor/meta-pantavisor/contents/AGENTS.md`; all three target sections present).
- **Pages in scope**: 43 pages under `https://docs.pantavisor.io/development/meta-pantavisor/overview/` — the 30 non-`testing/` pages the sitemap correctly lists for this repo/section, plus `testing.md`, `testing/automated.md`, its 3 subpages, `testing/manual.md`, and 7 `testing/manual/testplans/*` pages recovered by crawling in-content links after the sitemap/version-drift issue above was hit (see that finding). This is a `section=`-scoped run, so every one of the 43 pages was read in full (not sampled), per `AUDITBOOK.md` step 5.
- **Links checked**: 71 unique in-content link targets extracted from all 43 pages' `.md` exports (cross-repo links into `pantavisor/` and sibling links into `getting-started/` included) — all 71 resolve with HTTP 200, verified both via rendered-HTML redirect-following and via `.md`-export status (the more reliable 404 signal per `AUDITBOOK.md` step 3). No retired MkDocs-era paths, no leftover MkDocs admonition/icon syntax, no off-domain doc-site links found anywhere in scope.
- **Two apparent "unlinked list items"** (`overview/index.md`'s "Continuous Integration" bullet, `testing/index.md`'s "The pvtest Harness" item) were investigated and are **not** findings — both are real `<a href>` links in the rendered HTML that the `.md` export silently drops after bold text / at the end of a list item, the known export bug called out in `AUDITBOOK.md` step 3.

## Worst finding

S3: `overview/index.md`'s hand-ordered Topics/Build Guide lists omit `composable-firmware`, `examples/`, `glossary`, `port/`, and `testing/` — five of ten top-level `overview/` subsections — despite `AGENTS.md`'s explicit instruction to keep new `overview/` pages listed there.

## What's compliant

- **Actionability**: every substantive `overview/` page (build/config/CI/porting/testing pages) pairs its feature descriptions with a concrete command, config key, or file path, usually in a fenced code block — no page found with prose-only feature description and no adjacent action. Reference-style pages (`glossary`, `supported-device`, `ci/status`, `testing/automated/pvtest-list`) are appropriately exempt (definitions / status tables / live badges, not feature descriptions).
- **Link Conventions (symptom-based)**: zero broken links, zero version-drift links, zero retired MkDocs paths, zero leftover MkDocs syntax across all 43 pages and 71 unique link targets in scope.
- **Structure (reachability)**: despite the index-list gap above, every page in scope is reachable from the section's own sidebar navigation — none is a true orphan (unreachable from any nav or in-content link).

## Rules skipped

None — all three `AGENTS.md` sections (Documentation Structure, Actionability (docs/), Link conventions (docs/)) were present and applied. The standing Link Conventions limitation applies as always: this run can confirm every checked link *resolves* and stays in-version, but cannot verify the literal source-level link syntax (relative vs. absolute vs. full URL) `AGENTS.md` prescribes — that needs a source read, per `AUDITBOOK.md`'s "What live-site auditing can and can't verify".
