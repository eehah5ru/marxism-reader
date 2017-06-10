MASTER_FILE = marxism-reader

TEX = xelatex -shell-escape -interaction=nonstopmode -file-line-error

.PHONY: all view

all: $(MASTER_FILE).pdf $(MASTER_FILE).aux

view: $(MASTER_FILE).pdf
	open -a /Applications/Preview.app $(MASTER_FILE).pdf

# $(MASTER_FILE).aux: $(MASTER_FILE).tex
#		$(TEX) $(MASTER_FILE)

# $(MASTER_FILE).pdf: $(MASTER_FILE).tex
#		$(TEX) $(MASTER_FILE).tex

$(MASTER_FILE).pdf : $(MASTER_FILE).tex $(MASTER_FILE).toc VERSION
		while ($(TEX) $(MASTER_FILE) ; \
		grep -q "Rerun to get cross" $(MASTER_FILE).log ) do true ; \
		done

$(MASTER_FILE).toc $(MASTER_FILE).aux: $(MASTER_FILE).tex VERSION
		$(TEX) $(MASTER_FILE)


VERSION:
	git rev-parse HEAD

# $(MASTER_FILE).bbl  $(MASTER_FILE).blg: $(MASTER_FILE).aux
#			bibtex $(MASTER_FILE)

# %.bbl: %.aux
#			bibtex $(basename $<)

# index : $(MASTER_FILE).ind

# $(MASTER_FILE).ind : $(MASTER_FILE).aux
#			makeindex $(MASTER_FILE)

clean:
	rm -f ${MASTER_FILE}.{ps,pdf,log,aux,out,dvi,bbl,blg,ind}
	rm -f *.bbl *.blg
	rm -f *.toc *.lof *.lot
	rm -f *.thm *.out
	rm -f *.ind *.idx *.ilg
