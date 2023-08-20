$(eval SHELL:=/bin/bash)

OUT = output
INNEROUT = output
TEX = document.tex
PROJ = document

TIMEZ = Pacific/Auckland

BLANK :=
SLASH = \$(BLANK)

CLEAN_DIRS  = $(OUT) $(PAGES) .

.PHONY : clean
clean : 
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.swp         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.aux         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.bbl         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.blg         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.fdb_latexmk )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.fls         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.log         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.out         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.gz          )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.toc         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.glo         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.glsdefs     )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.glsist      )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.ist         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.odt         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.4ct         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.4tc         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.bcf         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.dvi         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.idv         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.lg          )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.tmp         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.xref        )
	@ -rm -r $(OUT) || true 
	@ -rm -r $(OUT)-* || true 
	@ -mkdir $(OUT)

.PHONY : superclean
superclean:
	make clean
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.pdf         )

# example usage: 
# for a custom name:
# 	make NAME=custom rename
# for the default name:
# 	make rename
.PHONY : rename
rename:
	-mv $(PROJ).docx $(NAME).docx
	-mv $(PROJ).pdf $(NAME).pdf

# example usage:
# 	make PAGE=2020-12-07 convertMD
# without PAGE=prefix, it will prompt for a filename
#@for PAGE in $(shell ls ${PAGES}/*.md); 
.PHONY : convertMD
convertMD:
	mkdir -p ${OUT}
	mkdir -p ${OUT}/${INNEROUT}
	ls *tex
	cp *tex ${OUT}

	@for PAGE in $(shell find pages -name '*.md'); \
		do \
			BASE="`echo $${PAGE} | sed 's/\.md$$//g'`"; \
			FROM=$${BASE}.md; \
			TO=${OUT}/$${BASE}.tex; \
			cat template/page-header-footer/head.tex > $${TO}; \
			pandoc -f markdown -t latex $${FROM} >> $${TO}; \
			cat template/page-header-footer/tail.tex >> $${TO}; \
		done



.PHONY : pdf
pdf:
	make convertMD
	cd $(OUT) && mkdir -p $(OUT)
	cd $(OUT) && pdflatex --shell-escape -output-directory $(INNEROUT) $(TEX)
	cd $(OUT) && pdflatex --shell-escape -output-directory $(INNEROUT) $(TEX) 
	cp $(OUT)/$(INNEROUT)/*pdf .

.PHONY : clatex
clatex:
	pdflatex ${FILE}

.PHONY : version
version:
	tex --version