# NoMoreApply: Services Brochure Pipeline

```mermaid
flowchart TD
    subgraph HUMAN["① Human: Resource Collection"]
        direction LR
        R1[CVs / LinkedIn exports]
        R2[Discord posts / notes]
        R3[Website snapshots]
        R1 & R2 & R3 --> RES[resources/]
    end

    subgraph AI["② AI: Source Synthesis  (/project:refresh)"]
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
**Stage 2** is AI-driven: run `/project:refresh` to synthesize `sources/*.md` from the latest resources.  
**Stage 3** is automated: push to `main` triggers GitHub Actions, builds PDFs, deploys to Pages.

---

## Members

- Angel Aytov: AI Automation, MLOps, AWS
- Catalin Waack: Full-stack, Shopify, React
- Cosmin Poieana: Backend, AI/ML, GraphRAG

## Live PDFs

[nomoreapply.github.io/services/](https://nomoreapply.github.io/services/)
