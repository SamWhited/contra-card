.POSIX:
.SUFFIXES:

# Standardize on local variables from NetBSD Make.
.ALLSRC ?= $^

REDIRECT = > /dev/null
DO_LATEX = xelatex --shell-escape --interaction=nonstopmode contracard.dtx $(REDIRECT)

contracard.pdf: contracard.sty contracard.cls contracard.dtx by-nc.png by.png
	$(DO_LATEX)
	$(DO_LATEX)
	splitindex contracard $(REDIRECT) 2>&1
	makeindex -s gind.ist -o contracard.ind contracard $(REDIRECT) 2>&1
	makeindex -s gglo.ist -o contracard.gls contracard.glo $< $(REDIRECT) 2>&1
	while ($(DO_LATEX) ; \
	grep -q "Rerun to get" contracard.log ) do true; \
	done

contracard.sty contracard.cls: contracard.dtx contracard.ins
	xelatex --interaction=nonstopmode contracard.ins $(REDIRECT)

contracard.zip: contracard.dtx contracard.ins contracard.pdf Makefile LICENSE
	rm -f $@
	rm -rf contracard/
	mkdir -p contracard/
	cp README.md contracard/README
	cp $(.ALLSRC) contracard/
	zip -9 $@ contracard/*
	rm -rf contracard/
