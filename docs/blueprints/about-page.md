# Claude Code Brief: NMA Services — About Page

## What you are working on

Repo: https://github.com/NoMoreApply/services
Live site: https://nomoreapply.github.io/services/

This repo currently serves one thing: a team brochure page with links to PDF profiles for Angel, Catalin and Cosmin. The task is to add a single `/about` page to this site that replaces the need for two separate HTML artifacts and speaks cleanly to two distinct audiences on the same URL, separated by visual layout rather than navigation.

The main NMA website lives at https://nomoreapply.com and is out of scope. This work is entirely within the services GitHub Pages deployment.

---

## Who NMA is

No More Apply is a private community for senior engineers and technical founders. The core mechanic: you get in because someone inside vouches for you, you get roles because a peer says "this person delivers." No recruiter, no application, no theater.

**Mission:** Get good engineers into good roles through people who know them. No recruiter in the middle, no theater, no ghosting from either side.

**Vision:** A world where your reputation travels with you and is the only credential that matters in hiring.

**Co-founders (alphabetical by first name):**
- Angel Aytov (AA)
- Catalin Waack (CW)
- Cosmin Poieana (CP)

No photos available yet. Use initials inside circles as placeholders.

**Core values (in this order, no exceptions):**
1. No Ghosting — comes first, most prominent. Policy, not platitude: partners who ghost our members stop receiving referrals.
2. Give Value First — contribution is the membership fee, no paywall.
3. Make Life Easy — three interview stages max, async-first, less process.
4. Same Team — engineers helping engineers, shaped by shared experience of the broken system.

**What NMA explicitly is not:**
- Not a job board
- Not a recruiter network (no recruiters allowed inside)
- Not an agency
- Not a paid membership
- Not a place for passive consumers

**The no-ghosting rule has teeth:** if a company ghosts a referred candidate, NMA stops sending them people. Full stop.

---

## Design system

Match nomoreapply.com exactly:

- Background: `#f5f5f3` (light cream)
- White sections: `#ffffff`
- Near-black text: `#111111`
- Accent: `#DC143C` (red, used sparingly: hero accents, value highlights, CTAs)
- Muted text: `#777777`
- Borders: `#e2e2de`
- Font: Inter (weights 400–900) + JetBrains Mono for labels and metadata
- Headlines: very heavy (font-weight 900), tight tracking (-0.03em to -0.04em)
- Section labels: JetBrains Mono, 0.58rem, 0.22em letter-spacing, uppercase, muted color
- No decorative elements, no gradients, no shadows. Structure through borders and spacing only.
- For Companies hero: dark inverted (`#111111` background, white text) to signal audience shift

Two HTML reference files are attached to this brief:
- `nma-about.html` — the engineer-facing community story
- `nma-for-companies.html` — the company-facing hiring and boutique page

These are the canonical design reference. Replicate their structure and styling into the services site.

---

## The task

### 1. Create `/about` in the services repo

Single page, two sections separated by a clear visual break (dark divider, section label, whatever works). Do not use tabs or JS routing — this is a static GitHub Pages site.

**Section 1: The Community (engineer-facing)**

Pull directly from `nma-about.html`. Content in order:

- Hero: "Engineers helping engineers. No middlemen." with red accent on "No middlemen."
- Video placeholder: dark 16:9 block, initials AA / CW / CP overlapping circles, play button, caption "Angel, Catalin & Cosmin — why we built this." Wire up to a real URL when available.
- Why we exist: the peer-intro insight, the broken pipeline paragraph.
- Mission (one sentence) + Vision (two sentences).
- Core values: No Ghosting featured full-width (red underline on the title, "01 · Comes first" in bottom-right corner of the card, neutral white bg — not pink/red bg). Values 02–04 in a three-column grid below.
- What else matters: 2x2 grid: peer recognition over credentials / honest about money / quiet competence over noise / no recruiters no poachers no passengers.
- Transition line: "Trust creates opportunity" (monospace label, not a heading).
- Engineering boutique intro: positions it as a by-product of the community, not NMA's main business. Each co-founder promotes NMA through their own individual brand. Two tags: "By-product of the community" and "Open to vetted members." Ends with a quiet "Are you a company?" separator linking down to Section 2.

**Section 2: For Companies (company-facing)**

Content in order:

- Dark hero section (inverted colors): "Hire people, not applications." with "applications." in red. Subheading: warm intro over cold pipeline. CTA: "Get in touch" linking to mailto:info@nomoreapply.org.
- Two tracks side by side: Referral hire (light card, "10% of the hire's monthly pay, paid across their first 10 months. Nothing if they don't start. No retainer, no exclusivity.") and Engineering boutique (dark card).
- How a referral hire works: four steps (Brief us / Match and vouch / Three stages then a decision / Placement, then 10for10 — 10% of monthly pay invoiced once a month for ten months, starting 30 days after the start date; invoicing just stops if they leave early).
- The deal, plainly: three cards ("10% x 10, nothing else" / "The monthly drip is the guarantee" / "No ghosting, ever"). No fixed retention window and no replacement clause exist in the real model, don't reintroduce one.
- The 10for10 explainer, a dedicated block answering the four questions a company needs before they'll ask for the agreement:
  - **The offer** (row): named "10for10" explicitly. Ten payments of 10% of gross monthly pay, once a month, for ten months, only if the person starts. One number, no negotiation.
  - **The math** (row): worked example on a $108,000 base — $9,000/month pay, $900 per payment, $9,000 total across ten payments (chosen so the numbers divide evenly and read cleanly; not tied to any real client's salary). Frame as roughly 8.3% of a first year's salary vs. the 20-25% an agency search runs.
  - **What happens if** (three numbered steps, reusing the `.how-section`/`.steps` pattern): they leave early (invoicing stops, nothing refunded or chased, no guarantee/replacement period) / you already knew them (5 business days from the introduction to say so with a dated record) / you hire them for a different role later (introduction stays live 12 months, any role, any affiliate).
  - **What signing commits you to** (row): nothing — no retainer, no exclusivity, no obligation to hire. Names the contracting entity plainly: agreements are signed and invoiced by Driftware Dynamics Ltd, which runs the NoMoreApply community; NoMoreApply is a brand, not a legal entity. One line noting the same 10for10 shape (reversed direction) is what Cosmin offers recruiters at wandercode.ltd/10for10. Ends with a `.cta-btn.primary` linking to mailto:info@nomoreapply.org, "Request the agreement."
  - Governing law/jurisdiction is deliberately not mentioned on this page — left to be agreed per client in the actual signed agreement. No bank/IBAN details, no client or candidate names, no full clause text, no candidate quality/performance guarantees ever appear here — those live only in the signed agreement, kept outside this public repo.
- This isn't for everyone: disqualifying list with ✕ markers (CV farmers, 6+ round processes, companies who ghost, bulk/junior hiring, middleman replacement).
- Dual CTA: Referral hire (primary red button to mailto) and Engineering boutique (secondary button to https://nomoreapply.github.io/services/).

### 2. Link the About page from the existing services index

The current index at `nomoreapply.github.io/services/` is a minimal page with links to PDFs. Add a clear "About NMA" link at the top, pointing to `/about`. Keep the existing PDF links intact.

### 3. Navigation

Add a minimal nav to the about page:
- Left: "No More Apply" logotype linking back to https://nomoreapply.com
- Right: "Services →" linking to https://nomoreapply.github.io/services/

---

## GitHub org README guidance

The org README lives at: https://github.com/NoMoreApply/.github (create `profile/README.md` inside that repo if it doesn't exist — GitHub will render it on https://github.com/NoMoreApply).

Keep it short. The org page is not a landing page, it is a credibility signal for engineers and companies who land there after seeing one of the co-founders' personal brands. Suggested structure:

```markdown
# No More Apply

A private community for senior engineers. Skip the recruiter.  
Get direct introductions through people who know your work.

**[→ nomoreapply.com](https://nomoreapply.com)**  
**[→ About & For Companies](https://nomoreapply.github.io/services/about)**  
**[→ Services Brochure](https://nomoreapply.github.io/services/)**

---

**Co-founders:** Angel Aytov · Catalin Waack · Cosmin Poieana  
**Community:** Invite only · Europe & US · Engineers helping engineers.
```

No mission statement wall of text. No bullet lists of values. The website and About page do that work. The README is a pointer, not a pitch.

If the `.github` repo does not exist yet: create it under the NoMoreApply org, add `profile/README.md` with the above content.

---

## File structure expected in the services repo after this work

```
services/
  index.html              ← existing, add About link at top
  about/
    index.html            ← new combined page (both audiences)
  team-brochure.pdf       ← existing, untouched
  angel-aytov-profile.pdf ← existing, untouched
  catalin-waack-profile.pdf
  cosmin-poieana-profile.pdf
```

GitHub Pages will serve `about/index.html` at `/about` automatically.

---

## Constraints

- Static HTML + CSS only. No build step, no framework, no JS beyond what already exists.
- Fonts loaded from Google Fonts (already used in the reference files).
- No external component libraries.
- The brochure PDF links must remain working.
- The `mailto:info@nomoreapply.org` is the correct contact email.
- Services brochure URL: https://nomoreapply.github.io/services/
- Do not modify nomoreapply.com. Entirely separate deployment.
