CC=latex
CONV=dvipdf
SRC=rapport
TEST=test

all: dvi
	${CONV} ${SRC}.dvi

dvi: ${SRC}.tex
	${CC} ${SRC}.tex

bib: dvi
	bibtex ${SRC}
	${CC} ${SRC}.tex
	${CC} ${SRC}.tex
	${CONV} ${SRC}.dvi

test:
	${CC} ${TEST}.tex
	${CONV} ${TEST}.dvi; 


clean:
	rm -f *.dvi
	rm -f *.log
	rm -f *.aux
	rm -f *.toc
	rm -f *.out
	rm -f *.bbl
	rm -f *.blg
	rm -f *.nav
	rm -f *.snm
	rm -f *.vrb

