# Audit — pantavisor — overview — 2026-08-11

Repo: pantavisor
Target: https://docs.pantavisor.io/development/pantavisor/
Version: development
Section: overview
Date: 2026-08-11
Model: claude-sonnet-5
Run by: manual session (inline invocation, `repo=pantavisor version=development section=overview`)

## Findings

| Location | Category | Rule | Violation | Evidence | Severity | Suggested fix |
|---|---|---|---|---|---|---|
| `https://docs.pantavisor.io/development/pantavisor/overview/watchdog` | actionability | Actionability (docs/) | Feature described (4 named watchdog modes: Disabled/Shutdown/Startup/Always) with no adjacent concrete config key | Page text only says "Pantavisor also offers some [configurable] convenience..." linking to the generic, unscoped `pantavisor-configuration#summary` table; it never names `PV_WDT_MODE` (values `disabled`/`shutdown`/`startup`/`always`, confirmed present in `reference/pantavisor-configuration.md`) or `PV_WDT_TIMEOUT` anywhere on the page | S3 | Add the `PV_WDT_MODE` / `PV_WDT_TIMEOUT` keys (with their values) inline, ideally one next to each mode heading, instead of only a generic link to the full configuration table; confirm exact key names against source when fixing. |
| `https://docs.pantavisor.io/development/pantavisor/overview/pantavisor-architecture` | actionability | Actionability (docs/) | Top-level overview page is pure prose describing container orchestration / outside-world communication with no command, config key, or path of its own | Whole page body has zero fenced code blocks and zero config-key/path mentions; every actionable detail lives only in the linked child pages (revisions, updates, storage, remote-control, local-control) | S4 | Acceptable as a book-style index page since every concept links onward to a page that *is* actionable — flagged for awareness only, not a hard violation; if tightened, add a one-line "no action needed here — see linked pages" note. |
| n/a | links | Link conventions | External link returns HTTP 403 to automated fetch | `https://www.raspberrypi.com/documentation/computers/config_txt.html#tryboot_a_b` (linked from `overview/disks.md`, `rpiab` section) returns `403 Forbidden` to both a bare `curl` and a browser-UA `curl` from this environment | S4 | Likely a bot/WAF block on raspberrypi.com rather than a real dead link (page is presumably reachable in an actual browser); re-verify with a real browser before treating as broken. |

No S1 or S2 findings: every internal `/development/pantavisor/overview/...`, `/development/pantavisor/reference/...`, `/development/pantavisor/tools/...`, and cross-repo `/development/meta-pantavisor/...` link found across all 15 content pages resolved with HTTP 200 (see Scope covered), all within the `/development/` version tree — no version drift. The two spots where the `.md` export visibly drops link text (`bsp.md`'s "gohere", `pantavisor-configuration-levels.md`'s "ourhow-to") were confirmed, per rendered HTML, to be intact working links (`.../getting-started/troubleshooting/` and `.../getting-started/operate/device-access/`, both 200) — this is the known `.md`-export bug, not a real Link Conventions violation. No leftover MkDocs syntax (`!!! Note`, `:material-*`) found on any rendered page; all admonitions render as proper Docusaurus/Markdown blockquotes.

## Scope covered

- **Categories checked**: all three — structure, actionability, links.
- **Pages in scope**: 16 (the `overview/` index page plus all 15 pages listed in `AGENTS.md`'s "Technical Overview (`docs/overview/`)" table: `pantavisor-architecture`, `revisions`, `bsp`, `containers`, `updates`, `storage`, `disks`, `remote-control`, `local-control`, `ipam`, `pantavisor-configuration-levels`, `init-mode`, `hooks`, `watchdog`, `xconnect`) — this matches the sitemap's `pantavisor/overview/` URL count exactly (15 non-index pages), and the `<VERSION>`-resolved (`/development/`) equivalents all returned HTTP 200 on both the rendered page and the `.md` export (except the index page, whose `.md` export needs the no-trailing-slash form `overview.md` rather than `overview/index.md`).
- **Coverage**: every page in scope was read in full (both `.md` export for prose and rendered HTML for link/admonition checking) — no sampling, per the `section=`-scoped rule.
- **Links checked mechanically**: 29 unique internal target paths (stripped of `#fragment`) and 18 unique external URLs, all via `curl` status checks (following redirects).

## Worst finding

S3: `overview/watchdog` describes four watchdog modes but never names the `PV_WDT_MODE` / `PV_WDT_TIMEOUT` configuration keys that actually control them, only a generic unscoped link to the full config table.

## What's compliant

- **Structure**: fully compliant. All 15 `overview/` pages match `AGENTS.md`'s own "Technical Overview" table 1:1 (same set, same page slugs), every page is reachable from `overview/`'s own numbered index (which lists all 15 in the same order as `AGENTS.md`'s table), and no orphans were found — nothing in the sitemap for this section falls outside the linked structure.
- **Links**: fully compliant on everything checkable — zero broken internal or cross-repo links, zero version drift, zero retired MkDocs-era paths, zero raw MkDocs syntax leaking through.
- **Actionability**: compliant on 13 of 15 content pages — `bsp`, `containers`, `revisions`, `disks`, `storage`, `hooks`, `ipam`, `local-control`, `xconnect`, `updates`, `remote-control`, `pantavisor-configuration-levels`, and `init-mode` all pair feature descriptions with concrete config keys, JSON/shell examples, on-disk paths, or explicit command names (e.g. `pantabox`, `pvcontrol`, the full `run.json`/`device.json` snippets in `disks.md`). `watchdog` and, to a lesser degree, `pantavisor-architecture` are the exceptions noted above.

## Rules skipped

None of the three `AGENTS.md` categories were missing this run — `pantavisor/AGENTS.md` has all three, split across its "## Documentation" (structure) and "## Docs Pipeline" (`### Actionability (docs/)`, `### Link conventions (docs/)`) headings as expected.

Standing limitation (always applies, per `AUDITBOOK.md`): this run cannot see the literal source-level link syntax (relative vs. absolute vs. full URL) — only that rendered links resolve. Confirming the exact Link Conventions pattern used in `docs/overview/*.md` source needs a checkout, which this audit intentionally does not perform.
