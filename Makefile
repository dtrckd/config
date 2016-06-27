BD_MIXT := mixtures
BD_WEB := webmain
WEB_LOCAL := /var/www/
WEB_AMA := /media/Synology/home/www/
CLEAN_FILES := mixtures/html/* webmain/tez/*.html

PANDOC := /usr/bin/pandoc
#.PHONY: mixtures main


### Make a rule to downlad the content instead
# Dowload the content
TAG = $(wildcard $(BD_MIXT)/md/*.md) 
HTML_FILES_MIXT := index.php menu.php css html
DIR_MAIN = tez
TEZ = $(foreach dir,$(BD_WEB)/$(DIR_MAIN),$(wildcard $(dir)/*.md))
#TEZ_OUT = $(TEZ:.md=.html)
HTML_FILES_MAIN = $(addprefix tez/, *.html) css js

# Timestamp of files no used !
all: mixtures main

mixtures: $(TAG)
	$(info Building Mixtures...)
	./mixtures/md2web.py

main:$(TEZ)
	$(info Building Main...)
	$(foreach tez,$(TEZ),$(PANDOC) $(tez) -o $(tez:.md=.html) ;)

web_local: mixtures
	$(info Web Local in $(WEB_LOCAL)) 
	@mkdir -p $(WEB_LOCAL)/$(BD_MIXT)
	@cp -rv $(addprefix $(BD_MIXT)/, $(HTML_FILES_MIXT)) $(WEB_LOCAL)/$(BD_MIXT)
	@cp -rv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN))  $(WEB_LOCAL)

web_ama: mixtures
	$(info Web Local in $(WEB_AMA)) 
	@mkdir -p $(WEB_AMA)/$(BD_MIXT)
	@cp -rv $(addprefix $(BD_MIXT)/, $(HTML_FILES_MIXT))  $(WEB_AMA)/$(BD_MIXT)
	@cp -rv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN))  $(WEB_AMA)

clean:
	@rm -vf $(CLEAN_FILES)
	@rm -vf $(CLEAN_FILES)
