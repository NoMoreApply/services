# Audit Trail

---

**2026-04-07** - Redesigned PDF template to match NoMoreApply brand

Decision: Replaced `templates/wandercode.typ` with `templates/nomoreapply.typ`, aligning all design tokens to the nomoreapply.com visual identity.

Rationale: Original template used a warm wandercode aesthetic (cream #F5F4EF, navy #1A1A2E, dark red #A0303A). The actual NMA brand uses off-white #FAFAFA, near-black #09090B, and crimson #DC143C. Typography updated: name 26pt bold with -0.02em tracking, section headings 7.5pt uppercase with subtle grey rule instead of a red rule. Member card borders switched from red to light grey (#E4E4E7) — red is now reserved for role lines only.

---

**2026-04-06** — Switched PDF engine from XeLaTeX to Typst

Decision: Replaced `templates/wandercode.latex` with `templates/wandercode.typ`; updated Makefile to use `--pdf-engine=typst`.

Rationale: XeLaTeX via `pandoc/extra` took 3-5 minutes per build locally (cold font cache, multi-pass compilation, 2GB image). Typst compiles in seconds, uses the same `pandoc/extra` image (Typst is bundled), and has simpler template syntax. No content or schema changes — same Pandoc variable system (`$name$`, `$body$`, etc.). LaTeX fonts directory (`templates/fonts/`) retained in repo but no longer used by the pipeline.
