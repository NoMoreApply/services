# Blueprint - NoMoreApply Services PDF Pipeline

Complete execution guide for all remaining phases after initial scaffolding.

## Human vs. Machine responsibilities

**Our job (manual):**
1. Keep `resources/` up to date: add new CVs, profile exports, portfolio links, website snapshots, cover letters, publications, hobby projects — anything that describes a member.
2. Sync resources into `sources/`: run `/project:sync-sources` or follow CLAUDE.md procedure 2 manually. This is a one-way sync: resources are the source of truth, sources are the structured output.
3. Commit and push.

**CI's job (automated, triggered on every push):**
- Reads `sources/*.md` and `templates/nomoreapply.typ`
- Runs Pandoc + Typst to produce all PDFs
- Publishes to GitHub Pages

We never generate PDFs manually. The PDF is always the CI output. If something looks wrong in the PDF, fix the source markdown or the template, then push — CI rebuilds.

## Pipeline Overview

```
resources/ (raw PDFs, exports, web snapshots, discord posts, etc.)
    |
    | [human + AI: extract + distill via /project:sync-sources]
    v
sources/*.md (structured Markdown per person)  <-- commit & push triggers CI
    |
    | [CI: pandoc + typst]
    v
output/*.pdf (team brochure + 3 individual profiles)
    |
    | [CI: GitHub Actions -> Pages]
    v
nomoreapply.github.io/services/ (public, always reflects latest push)
```

### How the team brochure summary works

`scripts/assemble-team.sh` extracts the first paragraph (up to the first blank line) of `## Summary` and the first 4 bullets of `## Expertise` from each individual `.md` file, wraps them in Typst `#accentcard()` blocks, and injects them into the assembled team markdown before Pandoc + Typst renders the team PDF. Full profiles stay in their individual PDFs. Every value it injects is escaped for Typst special characters (`#`, `$`, `@`, `\`, `[`, `]`, `<`, `>`) before insertion, so raw member prose can never break the build.

---

## Phase 3: Source Markdown Extraction

**Status: in progress** (Cosmin complete, Catalin complete, Angel has 1 TODO remaining: speaking/community; blocked on missing CV for full completion)

**Goal:** One well-structured `.md` file per person under `sources/`, extracted from available resources.

### Schema (all files must follow)

**YAML front matter:**
```yaml
---
name: "Full Name"
role: "Title / Positioning"
tagline: "One-liner"
location: "City, Country"
linkedin: "https://..."
github: "https://..."          # optional
website: "https://..."         # optional
email: "..."
proof:
  - "3-4 metric-led fragments, e.g. '7 of 10 DAX companies'"
---
```

**Body sections (in this order, H2 headings):**
1. `## Summary` - 2-3 sentence pitch. Lead with the outcome and the strongest claim, not the role or biography. The team brochure extracts only the first paragraph verbatim, so keep it self-contained.
2. `## Expertise` - 5-8 bullet points. Core capabilities, technically specific. No manual line breaks inside bullets. The team brochure extracts the first 4.
3. `## Notable Work` - **capped at 6 entries**, each an H3 heading + italic meta line (`*Role · Years*`) + prose/bullets. Which 6 survive is ranked: named brand → hard number → recency → positioning fit → technical distinctiveness. The survivors are then ordered chronologically (end date descending). Every entry needs at least one number.
4. `## Also` - one-liners for work demoted from Notable Work, or minor engagements. Keep the brand name, cut the detail.
5. `## Tech Stack` - Categorized list: languages, frameworks, infra, AI/ML tools.
6. `## Background` - Education, distinctions, speaking, community.

Gaps are marked with `<!-- TODO: source missing -->` so they're visible in diffs.

### Per-person extraction guide

**Cosmin Poieana (`sources/cosmin-poieana.md`)** - complete, 0 TODOs, `proof:` front matter added 2026-09-04 (already at the 6-entry cap, no cuts needed); resynced 2026-10-05 from the Markdown CV, codex and README
- Primary: `resources/Cosmin_Poieana-cv-05_10_2026.md` (supersedes `Cosmin_Poieana-CV-06_04_2026.pdf`, kept for history), `resources/Cosmin_Poieana-codex-05_10_2026.md`
- Supplementary: README, LinkedIn profile PDF, Discord post, portfolio snapshot, wandercode `About.tsx`
- Remaining to pull (optional enrichment): wandercode.ltd service pages, portfolio starred list

**Catalin Waack (`sources/catalin-waack.md`)** - repositioned 2026-09-04
- Primary: `resources/Catalin_Waack-CV-04_09_2026.pdf` (supersedes `Catalin_Waack-CV-06_04_2026.pdf`, kept for history)
- Also mined: `resources/Catalin_Waack-cv-ios-04_09_2026.pdf` (role-targeted, `target: iOS-focused role` in metadata.yml, facts only)
- Supplementary: LinkedIn profile PDF, Discord post, contra.com, `resources/Catalin_Waack-website-04_09_2026.txt`, electacar.com, rivoara.com
- Notable Work capped at 6 (was 14), rest demoted to `## Also`; `proof:` front matter added
- All TODOs resolved

**Angel Aytov (`sources/angel-aytov.md`)** - capped 2026-09-04, 1 TODO remaining (speaking/community section, plus a flagged timeline gap)
- Primary: `resources/Angel_Aytov-profile-06_04_2026.pdf` (LinkedIn only - no CV yet)
- Supplementary: Discord post, `resources/Angel_Aytov-aiexpert-09_04_2026.txt` (ai-expert.com), `resources/Angel_Aytov-github-09_04_2026.txt`, `resources/Angel_Aytov-website-09_04_2026.txt`
- CV not yet available - Notable Work and Background certifications still incomplete
- Notable Work capped at 6 (was 9); 2009-2017 timeline gap flagged with `<!-- TODO -->` rather than papered over
- Role targets: AI Automation Architect, Principal Engineer, MLOps Engineer, Data Engineer, AWS Architect
- Location: Dublin, Ireland

### Team master file (`sources/team.md`)

Contains team-level front matter and intro paragraph. `scripts/assemble-team.sh` injects Summary + Expertise from each individual file before the team PDF is built.

---

## Phase 4: Typst Template

**Status: complete**

**File:** `templates/nomoreapply.typ`

### Design tokens (NMA brand)

| Element | Value |
|---------|-------|
| Paper | A4 |
| Background | `#FAFAFA` (off-white) |
| Body text | `#09090B` (near-black, also the dark-band fill) |
| Accent | `#DC143C` (NMA brand red - confirmed against the live nomoreapply.com) |
| Text secondary | `#52525B` |
| Text tertiary / eyebrow | `#71717A`, faint variant `#A1A1AA` |
| Dividers | `#E4E4E7` (light grey rules and card borders) |
| Font | Inter, weights 400/600/700 + Italic |
| Name | 26pt bold, tracking -0.02em |
| Section headings | 7.5pt bold uppercase, tracking 0.1em, grey rule |

### Font files (templates/fonts/)

Only 4 files kept (unused variants removed 2026-04-09):
- `Inter-Regular.ttf` (400)
- `Inter-SemiBold.ttf` (600)
- `Inter-Bold.ttf` (700)
- `Inter-Italic.otf` (italic)

### Template modes

Controlled by Pandoc `--variable` flags:

**`individual:true`** (default for profile PDFs)
- Name as large bold heading, role + tagline as subtitle
- Contact line (location, email, LinkedIn, GitHub, website)
- All 5 body sections

**`team:true`** (for team brochure)
- Centered team name + tagline
- Team description paragraph
- Member cards assembled from individual Summary + Expertise sections
- CTA footer

### Toolchain

```sh
# Individual profile
pandoc --pdf-engine=typst --pdf-engine-opt=--font-path=templates/fonts \
  --template=templates/nomoreapply.typ --variable=individual:true \
  sources/person.md -o output/person-profile.pdf

# Team brochure (assemble first)
bash scripts/assemble-team.sh output/_team-assembled.md sources/team.md sources/*.md
pandoc --pdf-engine=typst --pdf-engine-opt=--font-path=templates/fonts \
  --template=templates/nomoreapply.typ --variable=team:true \
  output/_team-assembled.md -o output/team-brochure.pdf
```

Inter `.ttf`/`.otf` files in `templates/fonts/` are loaded directly by Typst (no TeX needed).

---

## Phase 5: Build System

**Status: complete**

- `Makefile` at repo root: `make all` builds all PDFs, `make clean` removes `output/`
- `scripts/assemble-team.sh`: assembles team brochure markdown from individual sources
- Local build: `make all` (requires `pandoc` and `typst` installed natively)

---

## Phase 6: CI Workflow

**Status: complete**

**File:** `.github/workflows/build-pdfs.yml`

Triggers on push to `main` touching `sources/`, `templates/`, `scripts/`, `site/`, `Makefile`, or the workflow file. Also supports `workflow_dispatch`.

Tool versions pinned (matches local dev toolchain):
- Pandoc: 3.11
- Typst: 0.15.1
- actions/checkout: v6.0.2
- actions/cache: v5.0.4
- actions/upload-pages-artifact: v5
- actions/deploy-pages: v5

Site index (`site/index.html`) is copied into `_site/` alongside the PDFs on every build.

**Prerequisites (done):**
- GitHub Pages enabled on `NoMoreApply/services` (source: GitHub Actions)
- Repo is public (Pages requires public repo on free plan)

---

## Phase 7: README.md

**Status: complete**

Root-level `README.md` with Mermaid pipeline diagram, member list, and link to live PDFs at `nomoreapply.github.io/services/`.

---

## Slash Command

**`/project:sync-sources`** (file: `.claude/commands/sync-sources.md`)

Triggered after new resources are added. Identifies which people have updates since the last `sources/` commit, synthesizes each person's markdown, verifies the build, and logs audit trail entries.

---

## TODO Checklist

### Blockers
- [x] Enable GitHub Pages on NoMoreApply/services
- [x] Source Inter font files -> `templates/fonts/`
- [ ] Angel Aytov CV (missing - high priority)

### Content
- [x] Extract `sources/cosmin-poieana.md`
- [x] Extract `sources/catalin-waack.md` fully (all TODOs resolved 2026-04-09)
- [ ] Extract `sources/angel-aytov.md` fully (1 TODO remaining: speaking/community)
- [x] Download Catalin's contra.com profile -> `resources/`
- [x] Download Catalin's catalinwaack.com content -> `resources/`
- [x] Download electacar.com and rivoara.com -> `resources/`
- [x] Fetch Angel's ai-expert.com -> `resources/`
- [ ] Download wandercode.ltd pages for Cosmin -> `resources/` (optional enrichment)

### Build
- [x] Write Typst template `templates/nomoreapply.typ`
- [x] Write `scripts/assemble-team.sh`
- [x] Write `Makefile`
- [x] Write CI workflow `.github/workflows/build-pdfs.yml`
- [x] Write `README.md`
- [x] Test locally (pandoc + typst)
- [x] Verify PDFs render correctly
- [x] Verify Pages deployment URL works (`nomoreapply.github.io/services/`)
- [x] Redesign site/index.html (team brochure hero, named profile links, footer)
- [x] Remove unused font files (kept 4, removed 16)
- [x] Correct brand red to `#DC143C`
- [x] Fix bullet list spacing in template
