# Original Prompt — 2026-04-06

The following is the original prompt that kicked off this pipeline. Preserved for historical reference.

---

Aiming to build a template (and CI mechanism) with which I'll be generating a simple one-pager PDF as a brochure helping exposing more and more our software engineering capabilities given the admins of NoMoreApply org (just 3 of us for now: Catalin Waack, Angel Aytov, Cosmin Poieana)

Adding in the `resources` subdir useful ones aiding with the research, like CV, personal projects, cover letters, profiles, website, portfolio, links and anything else relevant. Also pasting here in the project as URLs.

Goals:
1. Discover each person strong points and what we're capable of, including our positioning we're aiming for
2. Come up with the right template which can be populated with info extracted from the resources, so that we can automate a CI building from that output Markdown file a PDF each time we push/deploy (inspire for example from @~/Work/cmin764/ -- see CI flow in there)
3. Ensure a template file and sources markdown for each of our profiles (one file per person) deduced from the resources we currently have in this context and locally in the aforementioned resources dir
4. Ensure CI configuration which automatically builds a nice looking PDF using the template and the input source markdowns we have extracted from the brought in content, then this PDF should be uploaded and accessible from GitHub (like github.io domain) so we can share that publicly with the wider audience

Document a README.md pipeline in Mermaid and essential text on how this is happening: resources collection -> sources synthesis -> templating -> PDF (CI automated)

Tech:
- use cheap simple Haiku agents for reading sources
- use Sonnet low effort on executing clear plans without doubts
- invoke Opus medium effort for doing the heavy thinking before having a plan

In terms of design system, feel free to inspire yourself from what I'm already using with Wandercode (simple black on white + creamy tones) given repo: @~/Work/cmin764/wandercode/ (look for design as an idea)

Before you start, please save the prompt in a new docs dir, so we can reference historically to it to see from where we started.

---

## Context: Cosmin's positioning and design system brief

Here's how I'd characterize the design system and tone for your Wandercode PDFs, written as prompt instructions:

**Wandercode PDF Design System — Prompt Instructions**

**Brand identity to internalize first:** Wandercode is a one-person fractional operation, not an agency. The person behind it has shipped production systems at companies later acquired by Apple and Siemens. Tone is direct, confident, and technically specific. No puffery. No filler. Every sentence should feel like it was written by someone who has seen too many bad consulting decks and decided to do the opposite.

**Typography**

Use a geometric sans-serif for headings (something with weight and presence, like Sora, DM Sans, or Outfit) paired with a neutral, highly readable body font. The website uses a bold-weight heading that commands attention without being decorative. Mirror that: headings are large, dark, and decisive. Body text is compact and functional, not airy. No serif fonts. No decorative typefaces.

Hierarchy should be immediately legible at a glance: document title, section header, body, metadata/labels. Four levels max. Labels (like "FRACTIONAL AI PRODUCT STRATEGIST" on the site) should appear in small-caps or uppercase with wide tracking, functioning as signposts rather than headings.

**Color palette**

Near-white cream background (#F5F4EF range, matching the site). Near-black text (#1A1A2E or similar). One accent pulled from the teal/dark-green family visible in the site's nav elements. Use that accent sparingly: callout borders, section dividers, key stat highlights. No gradients. No color-washing full sections. White space does the heavy lifting.

The black-on-cream combination reads as intentionally understated. It signals someone who doesn't need color to compensate for thin content.

**Layout and structure**

Single-column with generous margins. Not a two-column agency brochure layout. Think long-form proposal, not slide deck. Sections breathe. Avoid cramming the page.

Lead each section with a short, declarative statement (the "what and why in one sentence"), followed by supporting detail. Bullet points are acceptable for capability lists or deliverable breakdowns, but body reasoning stays in prose. No more than 3-4 bullets per block before returning to prose.

Use horizontal rules or thin accent lines between major sections instead of boxes or shaded panels. The visual style is editorial, not corporate.

**Structural sections (for a services/capability PDF)**

1. Short positioning statement (1-3 sentences max, no bio)
2. Problem framing specific to the client's context or industry
3. What you do, precisely (not a generic list, a methodology-grounded description)
4. Relevant proof (client outcomes, not logos, actual results)
5. Engagement model (how it works, what it costs to get started)
6. One clear CTA at the end

**Tone and copy style**

Write like someone who has earned the right to be direct. Avoid "I help companies achieve..." constructions. Lead with the problem or the outcome, not your role in it.

Good: "Most AI projects fail at the spec stage, not the build stage."
Bad: "I help B2B companies navigate AI adoption."

Use specific numbers when available. "17 documents" beats "a comprehensive audit package." "2B tokens/month" beats "intensive AI usage." Specificity is credibility.

No testimonials formatted as blockquotes with headshots unless they're unambiguously real and short. One sentence from a client CTO is more trustworthy than a paragraph.

**Things to actively avoid**

No stock imagery or AI-generated illustrations. If visuals are used at all, they should be diagrams, flowcharts, or system maps (matching Excalidraw-style or clean Mermaid aesthetics). No decorative icons next to every bullet point. No gradient hero banners. No "trusted by" logo strips unless you have explicit permission to use those logos. No purple. No "Let's build the future together" closing lines.

**PDF-specific technical notes**

If rendering from Markdown, use a CSS stylesheet that sets `font-size: 10-11pt` for body, generous `line-height` (1.6-1.7), and explicit `page-break-before` on major sections. Avoid widow lines (single sentences stranded on a new page). The footer should contain only your name, entity (Wandercode Limited), and a contact handle, nothing more.

---

## Member context (from Discord)

**Cosmin Poieana:**
- CV: https://cmin764.github.io/cmin764/cv.pdf
- Website: http://wandercode.ltd/
- Portfolio: https://github.com/stars/cmin764/lists/portfolio
- LinkedIn: https://www.linkedin.com/in/cmin764/
- GitHub: https://github.com/cmin764
- Email: cmin764@gmail.com
- Phone: +40756260927
- Also: cmin764.medium.com (blog)

**Catalin Waack:**
- CV: CatalinWaackCV.pdf (shared in Discord)
- LinkedIn: https://www.linkedin.com/in/catalinwaack/
- Contra: https://contra.com/catalin_waack_jxfa7eut/work
- Website (outdated): https://catalinwaack.com/
- Client project: https://electacar.com/
- Work in progress: https://rivoara.com/
- GitHub: https://github.com/c4t4
- Note: "framing should be for AI/consulting"

**Angel Aytov:**
- LinkedIn: https://www.linkedin.com/in/angel-aytov
- Email: angel@aytov.com
- Open to: AI Automation Architect, Principal Engineer, MLOps Engineer, Data Engineer, AWS Architect
- Location: Dublin, Ireland (remote or hybrid)
- Note: CV not yet provided

---

## Decisions made during planning

- **PDF format:** Both a 1-page team brochure AND individual profile pages (3 pages), published together
- **Audience:** Startup CTOs/founders + enterprise procurement teams
- **Toolchain:** Pandoc + XeLaTeX (with WeasyPrint/CSS and Typst documented as fallbacks)
- **Hosting:** nomoreapply.github.io/services/ (this repo's GitHub Pages)
