# audits/

Output of `AGENTS.md`-compliance scans against a target repo's `docs/` tree,
produced by `../AUDITBOOK.md`. Unlike `../answers/` (which evaluates the live
site as a persona would experience it), these runs check source markdown in a
repo checkout against that repo's own written rules — Documentation Structure,
Actionability, and Link Conventions. Runs can be triggered any way a Claude Code
session can be started unattended or semi-attended — a cron job,
`claude -p "..."`, or a manual session that chooses to file its report here
instead of just pasting output in chat.

## Layout

```
audits/
  <repo>/
    <YYYY-MM-DD>-<section>-<model-slug>.md
    <YYYY-MM-DD>-<section>-<model-slug>.md
    ...
  index.md
```

- **`<repo>/`** — one folder per audited repo (`meta-pantavisor`, `pantavisor`,
  ...). Every run for that repo — any section, any date, any model — lands as a
  flat file directly in this folder; there is no per-section subfolder.
- **`<YYYY-MM-DD>-<section>-<model-slug>.md`** — the full findings table +
  closing summary for one run, in the format `../AUDITBOOK.md` step 6 specifies,
  with the header from step 7. `<section>` is `all` for a full-repo run, or the
  scoped `docs/` subdirectory otherwise — always present in the filename so
  runs never collide. If a file for the exact same repo/section/date/model
  already exists, append `-2`, `-3`, etc. — never overwrite a prior run's file.
- **`index.md`** — one-row-per-run log: date, repo, section, model, worst
  finding, link to the full report.

Don't hand-edit audit files after the fact — if a finding turns out to be
wrong (e.g. `AGENTS.md` changed since the run), note that in a later run rather
than rewriting history.
