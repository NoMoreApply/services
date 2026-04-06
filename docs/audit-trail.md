# Audit Trail — NoMoreApply/services

All material AI-assisted decisions, in reverse chronological order.

---

**2026-04-06** — PDF output format

Decision: Two outputs per CI run: (1) 1-page team brochure combining all 3 members, (2) one individual profile page per person.

Rationale: Team brochure for intro/overview use; individual profiles for deeper dives. Both serve startup CTOs/founders and enterprise procurement.

---

**2026-04-06** — Repository and hosting

Decision: Build and publish from `NoMoreApply/services` repo to `nomoreapply.github.io/services/`.

Rationale: Keeps brochure assets co-located with the services repo. Avoids creating a separate public repo for a single artifact. Revisit if the repo grows and a dedicated `brochure` repo makes more sense.

---

**2026-04-06** — Initial architecture decision

Decision: Pandoc + XeLaTeX as the primary toolchain, mirroring the existing `cmin764/cmin764` CV pipeline.

Rationale: Proven setup already in production use for Cosmin's CV. Team familiarity reduces onboarding friction. Fallback paths (WeasyPrint, Typst) documented above and will be evaluated if styling requirements outgrow what LaTeX templates can deliver cleanly.
