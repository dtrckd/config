.ONESHELL:
SHELL = /bin/bash

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
CLEAN_FILES = webmain/mixtures/html/*.html webmain/tez/html/*.html

# Bin
PANDOC = /usr/bin/pandoc
MDOWNPY = markdown_py
MD2BLOG = webmain/mixtures/md2blog.py
MD2WIKI = webmain/tez/md2wiki.py

#.PHONY: mixtures main
.PHONY: papers bin

# Files to compile
### Make a rule to downlad the content instead
# Dowload the content
TAG := $(wildcard $(BD_WEB)/$(BD_MIXT)/md/*.md)
TEZ := $(wildcard $(BD_WEB)/$(BD_TEZ)/md/*.md)
PAPERS := $(foreach file,$(PAPERS_NAME), $(BD_PAPER)/$(file))

# Web files to copy
HTML_FILES_MIXT := css/ js/ images/ html/ index.php menu.php
HTML_FILES_TEZ  := css/ js/ images/ html/ a.php menu.php papers/ mlss2015/
HTML_FILES_MAIN := css/ js/ images/ *.html *.py *.js

default: local

local: mixtures tez web_local

web: web_ama web_local

mixtures:  $(TAG)
	$(info Building Mixtures...)
	$(MD2BLOG)

tez: $(TEZ) papers
	$(info Building tez...)
#$(foreach tez,$(TEZ), $(MDOWNPY) $(tez) > $(tez:.md=.html) ;)
	$(MD2WIKI)

papers:
	$(info copying papers...)
	$(foreach paper,$(PAPERS), /bin/cp -u $(paper) $(BD_WEB)/tez/papers/ ;)

web_local:
	$(info Web Local in $(WEB_LOCAL))
	sudo mkdir -p $(WEB_LOCAL)/$(BD_MIXT)
	sudo mkdir -p $(WEB_LOCAL)/$(BD_TEZ)
	sudo cp -ruv $(addprefix $(BD_WEB)/mixtures/, $(HTML_FILES_MIXT)) $(WEB_LOCAL)/$(BD_MIXT)
	sudo cp -ruv $(addprefix $(BD_WEB)/tez/, $(HTML_FILES_TEZ)) $(WEB_LOCAL)/$(BD_TEZ)
	sudo cp -ruv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN)) $(WEB_LOCAL)

web_ama:
	$(info Web Local in $(WEB_AMA))
	@mkdir -p $(WEB_AMA)/$(BD_MIXT)
	@mkdir -p $(WEB_AMA)/$(BD_TEZ)
	sudo cp -ruv $(addprefix $(BD_WEB)/mixtures/, $(HTML_FILES_MIXT)) $(WEB_AMA)/$(BD_MIXT)
	sudo cp -ruv $(addprefix $(BD_WEB)/tez/, $(HTML_FILES_TEZ)) $(WEB_AMA)/$(BD_TEZ)
	sudo cp -ruv $(addprefix $(BD_WEB)/, $(HTML_FILES_MAIN)) $(WEB_AMA)


#
#
# Backdown
#
#

BIN_FILES = $(shell cat configure/bin.txt)

configure_laptop: _bootstrap _install_init _configure _vim _web 

_bootstrap: _dotfiles _etc bin
	# Base packages
	sudo apt-get install -y aptitude make ntfs-3g vim sudo aptitude firmware-linux-nonfree

_dotfiles:
	# Warning: Junk file will stay on target (cp don't remove files)
	ls -A dotfiles/ | xargs -I{} cp -r dotfiles/{}  ~/

_etc:
	sudo cp etc/rc.local /etc
	sudo chmod +x /etc/rc.local
	sudo cp -r  etc/wpa_supplicant/ /etc
	sudo cat etc/sysctl.conf >> /etc/sysctl.conf

bin:
	mkdir -p ${HOME}/bin
	$(foreach f,$(BIN_FILES), /bin/ln -fs $(f) $(HOME)/bin/$(basename $(notdir $(f))) ;)

_install_init:
	cd app/init_package
	dpkg -i *.deb
	cd -

_configure:
	cd configure/
	./configure.sh # install package
	cd -

_vim:
	mkdir -p ~/.vim/bundle/
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim -c PluginUpdate

_web:
	ln -s ~/Desktop/workInProgress/webmain/ webmain

#
#
# Backup
#
#

backup: snapshot backapp backbin folders

snapshot:
	mkdir -p configure/snapshots/
	pip freeze > configure/snapshots/pip
	uname -a > configure/snapshots/uname
	apt list --installed > configure/snapshots/apt

backapp:
	# Todo Debug
	cd configure/
	./backapp.sh
	cd -

backbin:
	# Create bin.txt
	ls -l $(HOME)/bin | grep '>' |cut -d'>' -f2 > configure/bin.txt

folders:
	echo "backsync on -- \
		SC/ \
		workInProgress/ \
		src/config/ \
		src/data/"

deb_clean:
	# Add -force option ?
	#dpkg --list | grep '^rc ' | awk '{ print $2 }' | xargs dpkg -P
	# Show configuration orphant files
	dpkg --list |grep '^rc'
	apt-get -s autoremove
	apt-get -s autoclean

clean:
	@rm -vf $(CLEAN_FILES)

