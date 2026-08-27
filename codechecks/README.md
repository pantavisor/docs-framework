# codechecks/

Output of source-vs-docs scans against a target repo's actual **source code**
(not a live site, not `AGENTS.md`), produced by `../CODECHECKBOOK.md`. Unlike
`../answers/` and `../audits/`, this check needs a repo checkout — there's no
live equivalent of "does this CLI flag still exist in source." See
`../CODECHECKBOOK.md`'s "What this check can and can't verify" for the exact
boundary. Runs can be triggered any way a Claude Code session can be started
unattended or semi-attended — a cron job, `claude -p "..."`, or a manual
session that chooses to file its report here instead of just pasting output
in chat.

## Layout

```
codechecks/
  <repo>/
    <YYYY-MM-DD>-<section>-<short-sha>-<model-slug>.md
    <YYYY-MM-DD>-<section>-<short-sha>-<model-slug>.md
    ...
    README.md
  index.md
```

- **`<repo>/`** — one folder per checked repo (`pantavisor`,
  `meta-pantavisor`, `pvr` today — see `../CODECHECKBOOK.md`'s Repo scope
  table for what's diffable in each). Every run
  for that repo — any section, any commit, any date, any model — lands as a
  flat file directly in this folder; there is no per-section subfolder.
- **`<YYYY-MM-DD>-<section>-<short-sha>-<model-slug>.md`** — the full findings
  table + closing summary for one run, in the format `../CODECHECKBOOK.md`
  step 5 specifies, with the header from step 6. `<section>` is `all` for a
  full run, or the scoped surface (`cli`/`config`/`api`) otherwise;
  `<short-sha>` is the commit the run actually checked against — always
  present in the filename so runs never collide and stay traceable to an
  exact code state. If a file for the exact same
  section/commit/date/model already exists, append `-2`, `-3`, etc. — never
  overwrite a prior run's file.
- **`<repo>/README.md`** — a human-readable rollup of that repo's runs,
  grouped by section, sourced from `index.md`'s rows for that repo.
- **`index.md`** — one-row-per-run log: date, repo, ref, commit, section,
  model, worst finding, link to the full report.

Don't hand-edit a code-check report after the fact — if a finding turns out
to be wrong (source moved on, or the extraction pattern needs a fix), note
that in a later run rather than rewriting history.
