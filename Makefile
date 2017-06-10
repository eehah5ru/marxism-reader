MASTER_FILE = marxism-reader
VERSION = `git describe --tags`

OUTPUT_FILE = $(MASTER_FILE)-$(VERSION)

TEX = xelatex -shell-escape -interaction=nonstopmode -file-line-error

.PHONY: all view

all: $(OUTPUT_FILE).pdf $(MASTER_FILE).aux

view: $(OUTPUT_FILE).pdf
	open -a /Applications/Preview.app $(OUTPUT_FILE).pdf

$(OUTPUT_FILE).pdf: $(MASTER_FILE).pdf
	cp $(MASTER_FILE).pdf $(OUTPUT_FILE).pdf

# $(MASTER_FILE).aux: $(MASTER_FILE).tex
#		$(TEX) $(MASTER_FILE)

# $(MASTER_FILE).pdf: $(MASTER_FILE).tex
#		$(TEX) $(MASTER_FILE).tex

$(MASTER_FILE).pdf : $(MASTER_FILE).tex $(MASTER_FILE).toc VERSION_FILE
		while ($(TEX) $(MASTER_FILE) ; \
		grep -q "Rerun to get cross" $(MASTER_FILE).log ) do true ; \
		done

$(MASTER_FILE).toc $(MASTER_FILE).aux: $(MASTER_FILE).tex VERSION_FILE
		$(TEX) $(MASTER_FILE)


VERSION_FILE:
	git describe --tags > VERSION

# $(MASTER_FILE).bbl  $(MASTER_FILE).blg: $(MASTER_FILE).aux
#			bibtex $(MASTER_FILE)

# %.bbl: %.aux
#			bibtex $(basename $<)

# index : $(MASTER_FILE).ind

# $(MASTER_FILE).ind : $(MASTER_FILE).aux
#			makeindex $(MASTER_FILE)

clean:
	rm -f ${MASTER_FILE}.{ps,pdf,log,aux,out,dvi,bbl,blg,ind}
	rm -f ${OUTPUT_FILE}.{pdf,aux}
	rm -f *.bbl *.blg
	rm -f *.toc *.lof *.lot
	rm -f *.thm *.out
	rm -f *.ind *.idx *.ilg
	rm -f VERSION
