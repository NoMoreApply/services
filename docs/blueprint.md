# Blueprint - NoMoreApply Services PDF Pipeline

Complete execution guide for all remaining phases after initial scaffolding.

## Human vs. Machine responsibilities

**Our job (manual):**
1. Keep `resources/` up to date: add new CVs, profile exports, portfolio links, website snapshots - anything that describes a member.
2. Sync resources into `sources/`: read the raw inputs, extract and distill the relevant content into each person's `.md` file. This is a one-way sync: resources are the source of truth, sources are the structured output.
3. Commit and push.

**CI's job (automated, triggered on every push):**
- Reads `sources/*.md` and `templates/nomoreapply.typ`
- Runs Pandoc + Typst to produce all PDFs
- Publishes to GitHub Pages

We never generate PDFs manually. The PDF is always the CI output. If something looks wrong in the PDF, fix the source markdown or the template, then push - CI rebuilds.

## Pipeline Overview

```
resources/ (raw PDFs, exports, web snapshots)
    |
    | [human: extract + distill]
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

---

## Phase 3: Source Markdown Extraction

**Status: in progress** (Cosmin complete, Angel and Catalin have open TODOs)

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
---
```

**Body sections (in this order, H2 headings):**
1. `## Summary` - 2-3 sentence pitch. Lead with the outcome, not the role.
2. `## Expertise` - 5-8 bullet points. Core capabilities, technically specific.
3. `## Notable Work` - 3-5 career highlights. Company name, what was built, measurable outcome.
4. `## Tech Stack` - Categorized list: languages, frameworks, infra, AI/ML tools.
5. `## Background` - Education, distinctions, speaking, community.

Gaps are marked with `<!-- TODO: source missing -->` so they're visible in diffs.

### Per-person extraction guide

**Cosmin Poieana (`sources/cosmin-poieana.md`)** - complete, 0 TODOs
- Primary: `resources/Cosmin_Poieana-CV-06_04_2026.pdf`
- Supplementary: LinkedIn profile PDF, Discord post
- Remaining to pull: wandercode.ltd service pages, blog (cmin764.medium.com), portfolio starred list

**Catalin Waack (`sources/catalin-waack.md`)** - 2 TODOs remaining
- Primary: `resources/Catalin_Waack-CV-06_04_2026.pdf`
- Supplementary: LinkedIn profile PDF, Discord post
- Remaining to pull: contra.com profile, catalinwaack.com, electacar.com, rivoara.com

**Angel Aytov (`sources/angel-aytov.md`)** - 4 TODOs remaining
- Primary: `resources/Angel_Aytov-profile-06_04_2026.pdf` (LinkedIn only - no CV yet)
- Supplementary: Discord post
- CV not yet available - all gaps marked with TODO comments
- Role targets: AI Automation Architect, Principal Engineer, MLOps Engineer, Data Engineer, AWS Architect
- Location: Dublin, Ireland

### Team master file (`sources/team.md`)

Contains team-level front matter and intro paragraph. `scripts/assemble-team.sh` injects Summary + Expertise from each individual file before the team PDF is built.

---

## Phase 4: Typst Template

**Status: complete**

**File:** `templates/nomoreapply.typ` (note: `wandercode.typ` is a legacy leftover, unused)

### Design tokens (NMA brand)

| Element | Value |
|---------|-------|
| Paper | A4 |
| Background | `#FAFAFA` (off-white) |
| Body text | `#09090B` (near-black) |
| Accent | `#DC143C` (NMA crimson - role lines, team taglines only) |
| Secondary | `#71717A` (muted grey) |
| Dividers | `#E4E4E7` (light grey rules and card borders) |
| Font | Inter, weights 400/600/700 |
| Name | 26pt bold, tracking -0.02em |
| Section headings | 7.5pt bold uppercase, tracking 0.1em, grey rule |

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

Inter `.ttf` files in `templates/fonts/` are loaded directly by Typst (no TeX needed).

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

Tool versions pinned:
- Pandoc: 3.9.0.2
- Typst: 0.14.2
- actions/checkout: v6.0.2
- actions/cache: v5.0.4
- actions/upload-pages-artifact: v4.0.0
- actions/deploy-pages: v5.0.0

Site index (`site/index.html`) is copied into `_site/` alongside the PDFs on every build.

**Prerequisites (done):**
- GitHub Pages enabled on `NoMoreApply/services` (source: GitHub Actions)
- Repo is public (Pages requires public repo on free plan)

---

## Phase 7: README.md

**Status: complete**

Root-level `README.md` with Mermaid pipeline diagram, member list, and link to live PDFs at `nomoreapply.github.io/services/`.

---

## TODO Checklist

### Blockers
- [x] Enable GitHub Pages on NoMoreApply/services
- [x] Source Inter font files -> `templates/fonts/`
- [ ] Angel Aytov CV (missing - high priority)

### Content
- [x] Extract `sources/cosmin-poieana.md`
- [ ] Extract `sources/catalin-waack.md` fully (2 TODOs remaining)
- [ ] Extract `sources/angel-aytov.md` fully (4 TODOs, blocked on CV)
- [ ] Download Catalin's contra.com profile -> `resources/`
- [ ] Download Catalin's catalinwaack.com content -> `resources/`
- [ ] Download wandercode.ltd pages for Cosmin -> `resources/`

### Build
- [x] Write Typst template `templates/nomoreapply.typ`
- [x] Write `scripts/assemble-team.sh`
- [x] Write `Makefile`
- [x] Write CI workflow `.github/workflows/build-pdfs.yml`
- [x] Write `README.md`
- [x] Test locally (pandoc + typst)
- [x] Verify PDFs render correctly
- [x] Verify Pages deployment URL works (`nomoreapply.github.io/services/`)
