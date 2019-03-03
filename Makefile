.POSIX:
.SUFFIXES:

# Standardize on local variables from NetBSD Make.
.ALLSRC ?= $^

REDIRECT = > /dev/null
DO_LATEX_WRITE18 = xelatex --shell-escape --interaction=nonstopmode contracard.dtx $(REDIRECT)
DO_SPLITINDEX = splitindex contracard $(REDIRECT) 2>&1
DO_MAKEINDEX = makeindex -s gind.ist -o contracard.ind contracard $(REDIRECT) 2>&1
DO_MAKECHANGES = makeindex -s gglo.ist -o contracard.gls contracard.glo $< $(REDIRECT) 2>&1

contracard.pdf: contracard.sty contracard.cls contracard.dtx by-nc.png by.png
	$(DO_LATEX_WRITE18)
	$(DO_LATEX_WRITE18)
	$(DO_SPLITINDEX)
	$(DO_MAKEINDEX)
	$(DO_MAKECHANGES)
	while ($(DO_LATEX_WRITE18) ; \
	grep -q "Rerun to get" contracard.log ) do true; \
	done

contracard.sty contracard.cls: contracard.dtx contracard.ins
	xelatex --interaction=nonstopmode contracard.ins $(REDIRECT)

contracard.zip: contracard.dtx contracard.ins contracard.pdf Makefile LICENSE
	rm -f $@
	mkdir -p contracard/
	cp README.md contracard/README
	cp $(.ALLSRC) contracard/
	zip -9 -f $@ contracard/* >/dev/null
	rm -rf contracard/
