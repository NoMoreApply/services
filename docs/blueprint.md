# Blueprint — NoMoreApply Services PDF Pipeline

Complete execution guide for all remaining phases after initial scaffolding.

## Human vs. Machine responsibilities

**Our job (manual):**
1. Keep `resources/` up to date: add new CVs, profile exports, portfolio links, website snapshots — anything that describes a member.
2. Sync resources into `sources/`: read the raw inputs, extract and distill the relevant content into each person's `.md` file. This is a one-way sync: resources are the source of truth, sources are the structured output.
3. Commit and push.

**CI's job (automated, triggered on every push):**
- Reads `sources/*.md` and `templates/wandercode.latex`
- Runs Pandoc + XeLaTeX to produce all PDFs
- Publishes to GitHub Pages

We never generate PDFs manually. The PDF is always the CI output. If something looks wrong in the PDF, fix the source markdown or the template, then push — CI rebuilds.

## Pipeline Overview

```
resources/ (raw PDFs, exports, web snapshots)
    |
    | [human: extract + distill]
    v
sources/*.md (structured Markdown per person)  <-- commit & push triggers CI
    |
    | [CI: pandoc + xelatex]
    v
output/*.pdf (team brochure + 3 individual profiles)
    |
    | [CI: GitHub Actions → Pages]
    v
nomoreapply.github.io/services/ (public, always reflects latest push)
```

---

## Phase 3: Source Markdown Extraction

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
1. `## Summary` — 2-3 sentence pitch. Lead with the outcome, not the role.
2. `## Expertise` — 5-8 bullet points. Core capabilities, technically specific.
3. `## Notable Work` — 3-5 career highlights. Company name, what was built, measurable outcome.
4. `## Tech Stack` — Categorized list: languages, frameworks, infra, AI/ML tools.
5. `## Background` — Education, distinctions, speaking, community.

Gaps are marked with `<!-- TODO: source missing -->` so they're visible in diffs.

### Per-person extraction guide

**Cosmin Poieana (`sources/cosmin-poieana.md`)**
- Primary: `/Users/cmin/Work/cmin764/cmin764/cv.md` (full Markdown source)
- Supplementary: wandercode.ltd service pages, portfolio GitHub list
- Compress 13 experience entries to 3-5 highlights (Wandercode, VONQ, Sema4AI, Robocorp + acquisition note)
- Anchor the "2B tokens/month" stat — it's concrete and credibility-building
- Role framing: "Fractional AI Product Strategist"

**Catalin Waack (`sources/catalin-waack.md`)**
- Primary: `resources/Catalin_Waack-CV-06_04_2026.pdf`
- Supplementary: LinkedIn profile PDF, contra.com profile
- Frame for AI/consulting positioning (not raw CV listing)
- Include electacar.com and rivoara.com as client/project evidence
- Download contra.com profile and add to resources when available

**Angel Aytov (`sources/angel-aytov.md`)**
- Primary: `resources/Angel_Aytov-profile-06_04_2026.pdf` (LinkedIn only)
- CV not yet available — mark all gaps with TODO comments
- Use roles of interest as positioning signal: AI Automation Architect, Principal Engineer, MLOps Engineer, Data Engineer, AWS Architect
- Location: Dublin, Ireland (remote/hybrid)

### Team master file (`sources/team.md`)

Contains team-level front matter and a brief intro paragraph. The build script populates the member section from individual files.

```yaml
---
documenttype: team
team_name: "NoMoreApply"
team_tagline: "Trusted engineers. Direct introductions."
team_description: >
  A vetted collective of senior engineers available for fractional and contract
  engagements. We embed inside your team — shared Slack, shared GitHub, shared
  standups. Not a vendor on the outside.
cta: "Reach out via nomoreapply.com"
---
```

---

## Phase 4: LaTeX Template

**File:** `templates/wandercode.latex`

### Design spec (Wandercode aesthetic)

| Element | Value |
|---------|-------|
| Paper | A4 |
| Margins | 25mm L/R, 20mm top, 25mm bottom |
| Background | `#F5F4EF` (cream) |
| Body text | `#1A1A2E` (near-black) |
| Accent | `#2A6F6F` (teal) — rules, dividers, links only |
| Font | Inter via fontspec (files in `templates/fonts/`) |
| Body size | 10.5pt |
| Line spread | 1.65 |
| H1 (name) | 18pt Inter SemiBold |
| H2 (sections) | 11pt Inter SemiBold, uppercase, wide tracking, teal rule below |
| Footer | Entity name + URL only |

Fallback font if Inter unavailable in container: Fira Sans (ships with TeX Live). Document in CLAUDE.md if switched.

### Template modes

Controlled by `$documenttype$` Pandoc variable:

**`individual`** (default)
- Name as H1, role + tagline as subtitle block
- Contact details right-aligned in header
- All 5 sections full width
- Thin accent rule between sections

**`team`**
- Centered team name + tagline at top
- Team description paragraph
- 3 member cards in sequence, each with accent left-border rule:
  - Name, role (small-caps label), Summary, top 3-4 Expertise bullets
- CTA footer

### Required LaTeX packages

`geometry`, `fontspec`, `xcolor`, `pagecolor`, `titlesec`, `enumitem`, `hyperref`, `fancyhdr`, `parskip`

All available in `pandoc/extra:latest`.

### Font setup

Download Inter from Google Fonts (OFL license). Place these files in `templates/fonts/`:
- `Inter-Regular.ttf`
- `Inter-SemiBold.ttf`
- `Inter-Bold.ttf`

Reference in template:
```latex
\setmainfont[
  Path=templates/fonts/,
  BoldFont=Inter-SemiBold.ttf,
  BoldItalicFont=Inter-SemiBold.ttf
]{Inter-Regular.ttf}
```

---

## Phase 5: Build System

**File:** `Makefile` at repo root.

```makefile
PANDOC    = pandoc
ENGINE    = --pdf-engine=xelatex
TEMPLATE  = --template=templates/wandercode.latex
COMMON    = $(ENGINE) $(TEMPLATE)

INDIVIDUAL_SRCS = sources/angel-aytov.md sources/catalin-waack.md sources/cosmin-poieana.md
INDIVIDUALS = $(patsubst sources/%.md,output/%.pdf,$(INDIVIDUAL_SRCS))
TEAM        = output/team-brochure.pdf

all: $(TEAM) $(INDIVIDUALS)

output/%.pdf: sources/%.md templates/wandercode.latex | output
	$(PANDOC) $< -o $@ $(COMMON)

output/team-brochure.pdf: sources/team.md $(INDIVIDUAL_SRCS) templates/wandercode.latex | output
	bash scripts/assemble-team.sh
	$(PANDOC) output/team-assembled.md -o $@ $(COMMON)

output:
	mkdir -p output

clean:
	rm -rf output/

.PHONY: all clean
```

**`scripts/assemble-team.sh`** — reads `sources/team.md` as header, then extracts `## Summary` and `## Expertise` blocks from each individual file, assembles into `output/team-assembled.md`.

**Local test command:**
```sh
docker run --rm -v $(pwd):/data -w /data pandoc/extra:latest /bin/sh -c "make all"
```

---

## Phase 6: CI Workflow

**File:** `.github/workflows/build-pdfs.yml`

Triggers:
- Push to `main` touching `sources/`, `templates/`, `scripts/`, `Makefile`, or the workflow file
- `workflow_dispatch` (manual)

Jobs:
1. **build**: checkout → `make all` in `pandoc/extra` container → assemble `_site/` with PDFs + `index.html` → upload Pages artifact
2. **deploy**: `actions/deploy-pages@v4` → publishes to `nomoreapply.github.io/services/`

**Prerequisites (manual, one-time):**
- Enable GitHub Pages on `NoMoreApply/services` repo
- Set source to "GitHub Actions" (not a branch)
- Requires org admin

---

## Phase 7: README.md

Root-level `README.md` with:
- One-line project description
- Mermaid pipeline diagram (resources → sources → PDFs → Pages)
- Quick start (local build with Docker)
- Links to live PDFs
- Team member list (alphabetical)
- Link to this blueprint

---

## TODO Checklist

### Blockers
- [ ] Enable GitHub Pages on NoMoreApply/services (org admin: Cosmin)
- [ ] Source Inter font files → `templates/fonts/`
- [ ] Angel Aytov CV (missing — high priority)

### Content
- [ ] Extract `sources/cosmin-poieana.md` from cv.md + wandercode.ltd
- [ ] Extract `sources/catalin-waack.md` from CV PDF + LinkedIn
- [ ] Extract `sources/angel-aytov.md` from LinkedIn PDF (sparse, mark gaps)
- [ ] Download Catalin's contra.com profile → `resources/`
- [ ] Download Catalin's catalinwaack.com content → `resources/`
- [ ] Download wandercode.ltd pages for Cosmin → `resources/`

### Build
- [ ] Write LaTeX template `templates/wandercode.latex`
- [ ] Write `scripts/assemble-team.sh`
- [ ] Write `Makefile`
- [ ] Test locally with Docker
- [ ] Write CI workflow
- [ ] Write `README.md`
- [ ] Verify PDFs render correctly (cream bg, Inter font, all sections)
- [ ] Verify Pages deployment URL works
