## NoMoreApply — PDF brochure build system
## Usage (local): make all  (requires pandoc and typst installed natively)

PANDOC   := pandoc
TEMPLATE := templates/nomoreapply.typ
OUTDIR   := output
SOURCES  := sources

MEMBERS  := angel-aytov catalin-waack cosmin-poieana
PROFILES := $(addprefix $(OUTDIR)/,$(addsuffix -profile.pdf,$(MEMBERS)))
TEAM_PDF := $(OUTDIR)/team-brochure.pdf
TEAM_MD  := $(OUTDIR)/_team-assembled.md

ALL_PDFS := $(TEAM_PDF) $(PROFILES)

PANDOC_FLAGS := \
	--pdf-engine=typst \
	--pdf-engine-opt=--font-path=templates/fonts \
	--template=$(TEMPLATE) \
	--variable=individual:true

.PHONY: all clean

all: $(ALL_PDFS)

## Individual profiles
$(OUTDIR)/%-profile.pdf: $(SOURCES)/%.md $(TEMPLATE) | $(OUTDIR)
	$(PANDOC) $(PANDOC_FLAGS) -o $@ $<

## Team brochure: assemble first, then render
$(TEAM_PDF): $(TEAM_MD) $(TEMPLATE) | $(OUTDIR)
	$(PANDOC) \
		--pdf-engine=typst \
		--pdf-engine-opt=--font-path=templates/fonts \
		--template=$(TEMPLATE) \
		--variable=team:true \
		-o $@ $<

$(TEAM_MD): $(SOURCES)/team.md $(addprefix $(SOURCES)/,$(addsuffix .md,$(MEMBERS))) | $(OUTDIR)
	bash scripts/assemble-team.sh $@ $(SOURCES)/team.md $(addprefix $(SOURCES)/,$(addsuffix .md,$(MEMBERS)))

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)
