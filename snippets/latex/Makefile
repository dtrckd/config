.ONESHELL:
SRC = marami

default: xe

dvi: $(SRC).tex
	dvipdf $(SRC).dvi
	latex $(SRC).tex

xe: ${SRC}.tex
	xelatex $(SRC).tex

pdf: ${SRC}.tex
	pdflatex $(SRC).tex

bib:
	bibtex *.aux

all: default bib default



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



