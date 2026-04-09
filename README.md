# NoMoreApply: Services Brochure Pipeline

```mermaid
flowchart TD
    subgraph HUMAN["① Human: Resource Collection"]
        direction LR
        R1[CVs / LinkedIn exports]
        R2[Discord / community posts]
        R3[Website snapshots / portfolio repos]
        R4[Cover letters / publications / articles]
        R5[Products / hobby projects]
        R1 & R2 & R3 & R4 & R5 --> RES[resources/]
    end

    subgraph AI["② AI: Source Synthesis  (/project:sync-sources)"]
        direction LR
        RES --> READ[Read & distill resources]
        READ --> SRC["sources/*.md: per-person profiles"]
        READ --> TRAIL["docs/audit-trail.md: what changed and why"]
    end

    subgraph CI["③ CI: PDF Generation & Deploy  (on push to main)"]
        direction LR
        SRC --> BUILD["make all: pandoc + typst"]
        BUILD --> PDF["output/*.pdf: team + 3 individual"]
        PDF --> PAGES["nomoreapply.github.io/services/"]
    end

    HUMAN --> AI
    AI --> CI
```

**Stage 1** is manual: gather raw materials into `resources/`.  
**Stage 2** is AI-driven: run `/project:sync-sources` to synthesize `sources/*.md` from the latest resources.  
**Stage 3** is automated: push to `main` triggers GitHub Actions, builds PDFs, deploys to Pages.

---

## Members

- Angel Aytov: AI systems, GraphRAG, cloud infrastructure (AWS)
- Catalin Waack: Full-stack product engineering, Shopify, rapid MVP delivery
- Cosmin Poieana: Fractional AI strategy, Python, agentic systems

## Live PDFs

[nomoreapply.github.io/services/](https://nomoreapply.github.io/services/)
