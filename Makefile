BD_WEB = webmain
BD_MIXT = mixtures
BD_TEZ = tez
WEB_LOCAL = /var/www/
WEB_AMA = /media/Synology/home/www/
CLEAN_FILES = webmain/mixtures/html/* webmain/tez/*.html

# Bin
PANDOC = /usr/bin/pandoc
MD2WEB = webmain/mixtures/md2web.py
#.PHONY: mixtures main

### Make a rule to downlad the content instead
# Dowload the content
TAG := $(wildcard $(BD_WEB)/$(BD_MIXT)/md/*.md) 
TEZ := $(foreach dir,$(BD_WEB)/$(BD_TEZ),$(wildcard $(dir)/*.md))
#TEZ_OUT = $(TEZ:.md=.html)
HTML_FILES_MIXT := html/ index.php menu.php css 
HTML_FILES_TEZ := *.html papers/
HTML_FILES_MAIN := css/ js/ *.html *.php *.py

# Timestamp of files no used !
all: mixtures tez

# @Debug: nnot up to date !
#mixtures: $(TAG)
mixtures:  $(TAG)
	$(info Building Mixtures...)
	$(MD2WEB)

tez: $(TEZ)
	$(info Building tez...)
	$(foreach tez,$(TEZ),$(PANDOC) $(tez) -o $(tez:.md=.html) ;)

web_local:
	$(info Web Local in $(WEB_LOCAL)) 
	@mkdir -p $(WEB_LOCAL)/$(BD_MIXT)
	@mkdir -p $(WEB_LOCAL)/$(BD_TEZ)
	@cp -rv $(addprefix $(BD_WEB)/mixtures/, $(HTML_FILES_MIXT)) $(WEB_LOCAL)/$(BD_MIXT)
	@cp -rv $(addprefix $(BD_WEB)/tez/, $(HTML_FILES_TEZ)) $(WEB_LOCAL)/$(BD_TEZ)
	@cp -rv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN)) $(WEB_LOCAL)

web_ama: mixtures
	$(info Web Local in $(WEB_AMA)) 
	@mkdir -p $(WEB_AMA)/$(BD_MIXT)
	@mkdir -p $(WEB_AMA)/$(BD_TEZ)
	@cp -rv $(addprefix $(BD_WEB)/mixtures/, $(HTML_FILES_MIXT)) $(WEB_AMA)/$(BD_MIXT)
	@cp -rv $(addprefix $(BD_WEB)/tez/, $(HTML_FILES_TEZ)) $(WEB_AMA)/$(BD_TEZ)
	@cp -rv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN)) $(WEB_AMA)

clean:
	@rm -vf $(CLEAN_FILES)
	@rm -vf $(CLEAN_FILES)
