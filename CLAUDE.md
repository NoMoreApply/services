# CLAUDE.md: NoMoreApply/services

## Project

PDF brochure pipeline for the NoMoreApply engineering collective. Converts per-person Markdown profiles into polished PDFs (one team brochure + individual pages) via Pandoc + Typst, built automatically in CI and published to GitHub Pages.

## Toolchain

**Current stack:** Pandoc + Typst (local install). See `docs/audit-trail.md` for why XeLaTeX was dropped.

**Template:** `templates/nomoreapply.typ` — design aligned to nomoreapply.com brand.

**Design tokens** (canonical table, keep in sync with `templates/nomoreapply.typ`):
- Background: `#FAFAFA` (off-white)
- Text primary: `#09090B` (near-black, also the dark-band fill)
- Text secondary: `#52525B`
- Text tertiary / eyebrow: `#71717A` (muted grey), faint variant `#A1A1AA`
- Accent: `#DC143C` (NMA brand red, confirmed against the live nomoreapply.com — role lines, team taglines, accent bars only)
- Dividers: `#E4E4E7` (light grey rules and card borders)
- Font: Inter, weights 400/600/700
- Name: 26pt bold, tracking -0.02em
- Section headings: 7.5pt bold uppercase eyebrow (`#A1A1AA`), tracking 0.12em, 2pt red accent bar above

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

Each `sources/*.md` file must follow the same YAML front matter + H2 section structure so the template can consume them consistently.

**Front matter** additionally carries `proof:`, a list of 3-4 metric-led fragments (e.g. `"7 of 10 DAX companies"`). This renders as the stat band under the contact line. Avoid `~` in these fragments (Pandoc's Typst writer escapes it when substituting raw template variables, unlike body prose) — write `2B+` rather than `~2B`.

**Body sections, in order:**
1. `## Summary` - 2-3 sentences. Lead with the outcome and the strongest claim, not biography. The team brochure (`scripts/assemble-team.sh`) extracts only the **first paragraph** (up to the first blank line) for the team card, so keep that opening paragraph self-contained and under ~50 words.
2. `## Expertise` - 5-8 bullets. The team brochure also extracts the **first 4 bullets** here, so lead with the strongest ones.
3. `## Notable Work` - **capped at 6 entries.** Write each as an H3 heading (company/project) followed by an italic meta line (`*Role · Years*`), then prose or bullets. Adding a 7th entry means demoting one to `## Also`. Ranking rubric, applied in order: named client or brand a buyer recognises → a hard number → recency → fit with current positioning → technical distinctiveness (ties break toward recency). Every full entry needs at least one number; no metric means it belongs in `## Also`.
4. `## Also` - one-liners for demoted or minor work. Keep brand names visible, cut the detail.
5. `## Tech Stack` - Categorized list: languages, frameworks, infra, AI/ML tools.
6. `## Background` - Education, distinctions, speaking, community.

Gaps (e.g. missing CV data) are marked with `<!-- TODO: ... -->` comments inline.

## Ongoing Maintenance Procedures

These are the recurring operations an agent will be asked to perform. Follow them exactly.

### 1. Adding or updating a resource

When new material arrives for a person (CV, LinkedIn export, website snapshot, portfolio link, etc.):

1. Place the file in `resources/` with the naming convention `{FirstName}_{LastName}-{type}-{DD_MM_YYYY}.ext`, using today's date.
2. Add or update the corresponding entry in `metadata.yml`: file, person, type, source_url, added date, notes.
3. If this replaces an older file of the same type, keep the old file (historical record) and add the new one alongside it with the updated date suffix.
4. If the resource was written for a specific role or audience (e.g. a CV targeted at an iOS position), add a `target:` field to its `metadata.yml` entry recording that intent. A role-targeted resource describes the same work through a different lens: mine it for facts, never let its framing drive the person's positioning.

Do not edit \`sources/\` yet. That is a separate step.

### 2. Syncing resources into sources

When resources have been updated and the source markdown needs to reflect them:

1. Read the relevant files in `resources/` for the person being updated.
2. Extract and distill content into the person's `sources/*.md` file, following the schema above. This is a one-way sync: `resources/` is the source of truth.
3. Keep the prose tight: brochure-style, not a CV dump. Each section should be the sharpest possible version of the person's story.
4. **Enforce the cap.** `## Notable Work` never exceeds 6 entries. Adding one means ranking all candidates by the rubric in the schema section above and demoting the weakest to `## Also`. Never just append.
5. Update `proof:` in front matter whenever a new hard number or brand surfaces that outranks what's currently there.
6. Mark any gaps where data is unavailable with `<!-- TODO: describe what's missing -->`.
7. Do not touch other people's source files in the same operation.

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

## Versioning

Every push to `main` that ships a real change gets a git tag, loose SemVer (`vMAJOR.MINOR.PATCH`), decided by judgment call, not a rule engine:

- **Patch** — a single-fact fix or correction with no new structure: wrong email, wrong color, a typo, a bumped CI action version. (e.g. `v1.0.1`, `v1.0.2`)
- **Minor** — a new section, page, feature, or content addition, including correcting/replacing a whole block of copy (like a pricing or terms section) as long as it doesn't invalidate a live, already-communicated commitment. (e.g. `v1.1.0` new resources, `v1.2.0` build date, `v1.3.0` profile refresh)
- **Major** — reserved for a real pivot: a business-model change that contradicts terms already committed to a real client or already relied upon, a breaking change to the CI/build contract, or a structural rewrite that makes the previous version's output incompatible. Not yet used in this repo.

This repo has no consumers versioning against these tags. The point is a human-readable changelog anchor, not compatibility guarantees. Decide the bump the same way: what would confuse someone diffing v(N) against v(N-1)?

## Blueprint

See [docs/blueprints/initial-structure.md](docs/blueprints/initial-structure.md).

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
