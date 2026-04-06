## NoMoreApply — PDF brochure build system
## Usage (local): docker run --rm -v $(pwd):/data -w /data pandoc/extra:latest /bin/sh -c "make all"

PANDOC   := pandoc
TEMPLATE := templates/wandercode.typ
OUTDIR   := output
SOURCES  := sources

MEMBERS  := angel-aytov catalin-waack cosmin-poieana
PROFILES := $(addprefix $(OUTDIR)/,$(addsuffix -profile.pdf,$(MEMBERS)))
TEAM_PDF := $(OUTDIR)/team-brochure.pdf
TEAM_MD  := $(OUTDIR)/_team-assembled.md

ALL_PDFS := $(TEAM_PDF) $(PROFILES)

PANDOC_FLAGS := \
	--pdf-engine=typst \
	--template=$(TEMPLATE) \
	--variable=documenttype:individual

.PHONY: all clean

all: $(ALL_PDFS)

## Individual profiles
$(OUTDIR)/%-profile.pdf: $(SOURCES)/%.md $(TEMPLATE) | $(OUTDIR)
	$(PANDOC) $(PANDOC_FLAGS) --variable=documenttype:individual -o $@ $<

## Team brochure: assemble first, then render
$(TEAM_PDF): $(TEAM_MD) $(TEMPLATE) | $(OUTDIR)
	$(PANDOC) \
		--pdf-engine=typst \
		--template=$(TEMPLATE) \
		--variable=documenttype:team \
		-o $@ $<

$(TEAM_MD): $(SOURCES)/team.md $(addprefix $(SOURCES)/,$(addsuffix .md,$(MEMBERS))) | $(OUTDIR)
	bash scripts/assemble-team.sh $@ $(SOURCES)/team.md $(addprefix $(SOURCES)/,$(addsuffix .md,$(MEMBERS)))

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)
