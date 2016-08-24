# Base directory
BD_WEB = webmain
BD_MIXT = mixtures
BD_TEZ = tez

# WEB LOCATION
WEB_LOCAL = /var/www/
WEB_AMA = /media/Synology/home/www/

# PDF RESSOURCES
BD_PAPER = $(HOME)/Desktop/workInProgress/networkofgraphs/papers/personal/relational_models/
PAPERS_NAME = hdp_dynamics.pdf  hdp.pdf  ibp.pdf  lfc_model.pdf  poisson_binomial.pdf  rm_tab.pdf

# Stuff to clean
CLEAN_FILES = webmain/mixtures/html/*.html webmain/tez/*.html

# Bin
PANDOC = /usr/bin/pandoc
MDOWNPY = markdown_py
MD2WEB = webmain/mixtures/md2web.py

#.PHONY: mixtures main
.PHONY: papers

# Files to compile
### Make a rule to downlad the content instead
# Dowload the content
TAG := $(wildcard $(BD_WEB)/$(BD_MIXT)/md/*.md) 
TEZ := $(foreach dir,$(BD_WEB)/$(BD_TEZ),$(wildcard $(dir)/*.md))
PAPERS := $(foreach file,$(PAPERS_NAME), $(BD_PAPER)/$(file))

# Web files to copy
HTML_FILES_MIXT := html/ index.php menu.php css/ images
HTML_FILES_TEZ := *.html papers/ mlss2015/
HTML_FILES_MAIN := css/ js/ images/ *.html *.php *.py

# Timestamp of files no used !
all: mixtures tez

# @Debug: nnot up to date !
mixtures:  $(TAG)
	$(info Building Mixtures...)
	$(MD2WEB)

tez: $(TEZ)
	$(info Building tez...)
	#$(foreach tez,$(TEZ),$(PANDOC) $(tez) -o $(tez:.md=.html) ;)
	$(foreach tez,$(TEZ), $(MDOWNPY) $(tez) > $(tez:.md=.html) ;)

papers:
	$(info copying papers...)
	$(foreach paper,$(PAPERS), /bin/cp -u $(paper) $(BD_WEB)/tez/papers/ ;)

web_local:
	$(info Web Local in $(WEB_LOCAL)) 
	@mkdir -p $(WEB_LOCAL)/$(BD_MIXT)
	@mkdir -p $(WEB_LOCAL)/$(BD_TEZ)
	@cp -ruv $(addprefix $(BD_WEB)/mixtures/, $(HTML_FILES_MIXT)) $(WEB_LOCAL)/$(BD_MIXT)
	@cp -ruv $(addprefix $(BD_WEB)/tez/, $(HTML_FILES_TEZ)) $(WEB_LOCAL)/$(BD_TEZ)
	@cp -ruv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN)) $(WEB_LOCAL)

web_ama:
	$(info Web Local in $(WEB_AMA)) 
	@mkdir -p $(WEB_AMA)/$(BD_MIXT)
	@mkdir -p $(WEB_AMA)/$(BD_TEZ)
	@cp -ruv $(addprefix $(BD_WEB)/mixtures/, $(HTML_FILES_MIXT)) $(WEB_AMA)/$(BD_MIXT)
	@cp -ruv $(addprefix $(BD_WEB)/tez/, $(HTML_FILES_TEZ)) $(WEB_AMA)/$(BD_TEZ)
	@cp -ruv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN)) $(WEB_AMA)

web: web_ama web_local

clean:
	@rm -vf $(CLEAN_FILES)
