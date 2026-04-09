# Audit Trail

---

**2026-04-09** - Brand color correction, font cleanup, template spacing fix

Decision: Updated accent color from `#DC143C` to `#e8002d` (confirmed from nomoreapply.com HTML source). Removed 16 unused font files (Inter Black/ExtraLight/Light/Medium/Thin/ExtraBold, all InterDisplay variants, InterVariable-Italic) — kept only Regular, SemiBold, Bold, Italic. Fixed bullet list paragraph spacing propagation in Typst template that caused visible gaps on wrapped items.

Rationale: `#DC143C` is CSS named "crimson" and was a best-guess approximation. The actual NMA brand red extracted from nma-about.html and nma-for-companies.html is `#e8002d`. Font dir had 20 files; template only uses 4 weights.

---

**2026-04-09** - Updated Cosmin: Tech Stack and Background additions

What changed: Added Robot Framework/RPA/OCR/IDP to AI/ML stack (from Robocorp work). Added Vim, invoke, Fabric to Tooling. Added Medium blog, WordPress blog, and photography note to Background.

Why: Previous version omitted Robocorp-era tooling which is a distinct and marketable RPA specialty. Blog and photography links pulled from cv.md.

---

**2026-04-09** - Fetched web resources for Catalin Waack and Angel Aytov

What changed: Added 5 new resource files: Catalin's contra.com portfolio, catalinwaack.com, electacar.com, rivoara.com; Angel's ai-expert.com company page. Updated metadata.yml with new entries and resolved Catalin's todos.

Why: Catalin's source had 2 open TODO sections blocked on these URLs. Angel's resource set was thin (LinkedIn + Discord only); ai-expert.com adds context on his current healthcare AI role.

---

**2026-04-07** - Redesigned PDF template to match NoMoreApply brand

Decision: Replaced `templates/wandercode.typ` with `templates/nomoreapply.typ`, aligning all design tokens to the nomoreapply.com visual identity.

Rationale: Original template used a warm wandercode aesthetic (cream #F5F4EF, navy #1A1A2E, dark red #A0303A). The actual NMA brand uses off-white #FAFAFA, near-black #09090B, and crimson #DC143C. Typography updated: name 26pt bold with -0.02em tracking, section headings 7.5pt uppercase with subtle grey rule instead of a red rule. Member card borders switched from red to light grey (#E4E4E7) — red is now reserved for role lines only.

---

**2026-04-06** — Switched PDF engine from XeLaTeX to Typst

Decision: Replaced `templates/wandercode.latex` with `templates/wandercode.typ`; updated Makefile to use `--pdf-engine=typst`.

Rationale: XeLaTeX via `pandoc/extra` took 3-5 minutes per build locally (cold font cache, multi-pass compilation, 2GB image). Typst compiles in seconds, uses the same `pandoc/extra` image (Typst is bundled), and has simpler template syntax. No content or schema changes — same Pandoc variable system (`$name$`, `$body$`, etc.). LaTeX fonts directory (`templates/fonts/`) retained in repo but no longer used by the pipeline.
