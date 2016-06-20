all: html

html: md
	$(info Building Markdown...)
	./mixtures/md2web.py

md: ;
