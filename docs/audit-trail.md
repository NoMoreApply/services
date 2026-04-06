# Audit Trail

---

**2026-04-06** — Switched PDF engine from XeLaTeX to Typst

Decision: Replaced `templates/wandercode.latex` with `templates/wandercode.typ`; updated Makefile to use `--pdf-engine=typst`.

Rationale: XeLaTeX via `pandoc/extra` took 3-5 minutes per build locally (cold font cache, multi-pass compilation, 2GB image). Typst compiles in seconds, uses the same `pandoc/extra` image (Typst is bundled), and has simpler template syntax. No content or schema changes — same Pandoc variable system (`$name$`, `$body$`, etc.). LaTeX fonts directory (`templates/fonts/`) retained in repo but no longer used by the pipeline.
