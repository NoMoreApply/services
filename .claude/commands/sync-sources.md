# /project:sync-sources

You are running the NoMoreApply source sync. This command is triggered after new resources have been added to `resources/`.

## Context

- All team members (Angel Aytov, Catalin Waack, Cosmin Poieana) are male. Use he/him pronouns in all profile prose.
- Bullet text in `sources/` must never contain manual line breaks. Write each bullet as a single continuous line; let the PDF engine wrap naturally.
- Brand red accent is `#e8002d`. Do not use `#DC143C`.
- Writing style rules are in `CLAUDE.md`: no em dashes, no AI filler, concrete outcomes, active voice.

## 1. Identify updated resources

Read `metadata.yml` and run:

```sh
git log --since="$(git log -1 --format=%ai -- sources/)" -- resources/
```

List which people have new or changed resources since the last `sources/` commit.

## 2. Sync each updated person into sources

For each person with new resources, follow CLAUDE.md procedure 2 (Syncing resources into sources):

- Read **all** resource files for that person in `resources/` (not just the newest)
- Synthesize into their `sources/*.md` file: brochure-style, not a CV dump
- The sharpest version of each section: Summary (2-3 sentences, lead with outcome), Expertise (5-8 bullets, technically specific, no manual line breaks), Notable Work (3-5 highlights with company + outcome), Tech Stack (categorized), Background (education, distinctions, community)
- Remove `<!-- TODO -->` comments for any gaps that are now filled
- Keep remaining TODOs for still-missing data
- Log a source-level audit trail entry in `docs/audit-trail.md` (see CLAUDE.md format)

## 3. Verify the build

Run `make all` and confirm all 4 PDFs build without errors.

## 4. Summarize

Report which source files were updated, what changed in each, and confirm the build result.
