# CLAUDE.md: NoMoreApply/services

## Project

PDF brochure pipeline for the NoMoreApply engineering collective. Converts per-person Markdown profiles into polished PDFs (one team brochure + individual pages) via Pandoc + Typst, built automatically in CI and published to GitHub Pages.

## Toolchain

**Current stack:** Pandoc + Typst (local install). See `docs/audit-trail.md` for why XeLaTeX was dropped.

**Template:** `templates/nomoreapply.typ` — design aligned to nomoreapply.com brand.

**Design tokens:**
- Background: `#FAFAFA` (off-white)
- Text: `#09090B` (near-black)
- Accent: `#e8002d` (NMA brand red — role lines, team taglines only)
- Secondary: `#71717A` (muted grey)
- Dividers: `#E4E4E7` (light grey rules and card borders)
- Font: Inter, weights 400/600/700
- Name: 26pt bold, tracking -0.02em
- Section headings: 7.5pt bold uppercase, tracking 0.1em, grey rule

**Fallback option:** WeasyPrint/CSS - if Typst hits layout limitations. Document trigger and rationale in `docs/audit-trail.md` before switching.

**Local dev:** `make all` (requires `pandoc` and `typst` installed natively). No Docker.

## Writing Style

All prose in `sources/` must follow these rules. Apply them when extracting or editing content.

- **No em dashes.** Replace ` — ` with a comma, colon, or plain hyphen. No exceptions.
- **No AI-sounding filler.** Avoid phrases like "leveraged", "spearheaded", "delivered impactful solutions", "passionate about", "driven by", "results-oriented". Write like a person, not a job board.
- **Concrete over vague.** Name companies, technologies, outcomes. "Built a GraphRAG pipeline used in clinical trials" beats "developed innovative AI solutions".
- **Active voice, present tense** for current work; simple past for completed roles.

## Conventions

- **Profile ordering:** always alphabetical: Angel Aytov, Catalin Waack, Cosmin Poieana
- **Resource filenames:** `{FirstName}_{LastName}-{type}-{DD_MM_YYYY}.ext`
- **Source filenames:** kebab-case (`angel-aytov.md`, `catalin-waack.md`, `cosmin-poieana.md`)
- **Generated PDFs:** go to `output/` (gitignored). Never generate PDFs manually. CI owns this.
- **CI rebuild triggers:** changes to `sources/`, `templates/`, `scripts/`, `site/`, `Makefile`, or `.github/workflows/build-pdfs.yml`
- **Team members:** Angel Aytov, Catalin Waack, Cosmin Poieana — all male, use he/him pronouns in profile prose

## Source Markdown Schema

Each `sources/*.md` file must follow the same YAML front matter + H2 section structure so the template can consume them consistently. Sections in order:
1. `## Summary`
2. `## Expertise`
3. `## Notable Work`
4. `## Tech Stack`
5. `## Background`

Gaps (e.g. missing CV data) are marked with `<!-- TODO: ... -->` comments inline.

## Ongoing Maintenance Procedures

These are the recurring operations an agent will be asked to perform. Follow them exactly.

### 1. Adding or updating a resource

When new material arrives for a person (CV, LinkedIn export, website snapshot, portfolio link, etc.):

1. Place the file in `resources/` with the naming convention `{FirstName}_{LastName}-{type}-{DD_MM_YYYY}.ext`, using today's date.
2. Add or update the corresponding entry in `metadata.yml`: file, person, type, source_url, added date, notes.
3. If this replaces an older file of the same type, keep the old file (historical record) and add the new one alongside it with the updated date suffix.

Do not edit \`sources/\` yet. That is a separate step.

### 2. Syncing resources into sources

When resources have been updated and the source markdown needs to reflect them:

1. Read the relevant files in `resources/` for the person being updated.
2. Extract and distill content into the person's `sources/*.md` file, following the schema above. This is a one-way sync: `resources/` is the source of truth.
3. Keep the prose tight: brochure-style, not a CV dump. Each section should be the sharpest possible version of the person's story.
4. Mark any gaps where data is unavailable with `<!-- TODO: describe what's missing -->`.
5. Do not touch other people's source files in the same operation.

After editing `sources/`, the commit and push triggers CI. PDFs rebuild automatically.

### 3. Updating the template or build system

When layout, styling, or build mechanics change:

1. Edit `templates/nomoreapply.typ` and/or `Makefile`/`scripts/`.
2. Test locally before pushing: `make all` (requires `pandoc` and `typst` installed natively).
3. Verify the output visually: off-white background, Inter font, correct sections, no overflow.
4. If a toolchain fallback is triggered (switching away from XeLaTeX), document the reason in `docs/audit-trail.md` and update the "Current stack" line in this file.

### 4. Logging an audit trail entry

Log two categories of changes:

**Pipeline decisions** (toolchain, schema, structural, hosting):

```
**YYYY-MM-DD** - Short title

Decision: One sentence.

Rationale: Why. What alternatives were considered and rejected.
```

**Source updates** (when a `sources/*.md` file is meaningfully changed):

```
**YYYY-MM-DD** - Updated {person}: {brief summary of change}

What changed: Specific sections or facts updated.

Why: New resource added / corrected information / new AI synthesis instruction / previous version was missing X.
```

Do not log trivial edits (fixing a typo, rewording one sentence). Log when new resources are synced, when the AI synthesis approach changes, or when factual content is corrected.

**The audit trail is append-only.** Never edit or delete existing entries. Only prepend new ones above the previous most-recent entry.

## Blueprint

See [docs/blueprint.md](docs/blueprint.md).

Keep the blueprint current as a living document. Update it whenever:
- A phase changes status (in progress, complete, blocked)
- Per-person extraction progress changes (TODOs resolved, new resources added)
- A toolchain, build, or CI decision is made that affects pipeline architecture

The blueprint covers **what the system is and where it stands**. It does not overlap with:
- `docs/audit-trail.md` — the append-only log of *what changed and why*
- `metadata.yml` — the inventory of raw resources and their provenance

Blueprint entries should be forward-looking status snapshots. Audit trail entries are backward-looking records. Metadata is a ledger. They are complementary, not redundant.

## Audit Trail

See [docs/audit-trail.md](docs/audit-trail.md).
