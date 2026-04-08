# /project:refresh

You are running the NoMoreApply PDF pipeline refresh. This command is triggered after new resources have been added to `resources/`.

Follow these steps in order:

## 1. Identify updated resources

Read `metadata.yml` and run `git log --since="$(git log -1 --format=%ai -- sources/)" -- resources/` to find resource files added after the last `sources/` commit. List which people have new or changed resources.

## 2. Sync each updated person into sources

For each person with new resources, follow CLAUDE.md procedure 2 (Syncing resources into sources):

- Read all resource files for that person in `resources/`
- Update their `sources/*.md` file with the freshest synthesis
- Follow the writing style rules (no em dashes, no AI filler, concrete outcomes)
- Log a source-level audit trail entry in `docs/audit-trail.md`:
  - What changed and why (new resource? corrected info? new AI instruction?)
  - What the previous version was missing or got wrong

## 3. Verify the build

Run `make all` and confirm all 4 PDFs build without errors.

## 4. Summarize

Report which source files were updated, what changed in each, and confirm the build result.
