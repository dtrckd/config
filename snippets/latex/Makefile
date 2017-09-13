.ONESHELL:
SRC = main
OPTS = --halt-on-error

default: xe
_default : default

	
all: $(SRC).aux bib default _default

dvi: $(SRC).tex
	dvipdf $(SRC).dvi
	latex $(SRC).tex

xe: ${SRC}.tex
	xelatex $(OPTS) $(SRC).tex

pdf: ${SRC}.tex
	pdflatex $(OPTS) $(SRC).tex 

bib:
	bibtex *.aux

$(SRC).aux: default




clean:
	find -name "*.dvi" -delete
	find -name "*.log" -delete
	find -name "*.aux" -delete
	find -name "*.toc" -delete
	find -name "*.out" -delete
	find -name "*.bbl" -delete
	find -name "*.blg" -delete
	find -name "*.nav" -delete
	find -name "*.snm" -delete
	find -name "*.vrb" -delete
	find -name "*.fls" -delete
	find -name "*.fls" -delete
	find -name "*.synctex.gz" -delete
	find -name "*.fdb_latexmk" -delete



