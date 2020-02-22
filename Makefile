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

configure_server:
	cp -r dotfiles/{.bash_profile,.tmux.conf} ~/
	cp dotfiles/.vimshortrc ~/.vimrc

	# Delete the match and the next line (recursive)
	awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' ~/.tmux.conf  > ~/.tmux.conf.temp && mv ~/.tmux.conf.temp ~/.tmux.conf
	awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' ~/.bash_profile  > ~/.bash_profile.temp && mv ~/.bash_profile.temp ~/.bash_profile

	# Delete the next (recursive)
	sed -i '/# @SERVER/{n;s/^.//}' ~/.tmux.conf
	sed -i '/# @SERVER/{n;s/^.//}' ~/.bash_profile

	# Install plugin
	# tmux plugin
	[ ! -f ~/.tmux/plugins/tpm/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

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

full_backup: snapshot backapp backbin folders backup_wekan backup
backup: backup_dot backup_atom

snapshot:
	mkdir -p configure/snapshots/
	uname -a > configure/snapshots/uname
	apt list --installed > configure/snapshots/apt
	pip freeze > configure/snapshots/pip
	snap list > configure/snapshots/snap
	npm list -g --depth 0 > configure/snapshots/npm

backapp: backup_atom backup_dot
	# Todo Debug
	cd configure/
	./backapp.sh
	cd -

backbin:
	# Create bin.txt
	ls -l $(HOME)/bin | grep '>' |cut -d'>' -f2 > configure/bin.txt

folders:
	echo "TODO -- backsync on -- \
		SC/ \
		workInProgress/ \
		src/config/ \
		src/data/"

#
# Extra setup
# (factor backup rule and and backapp.sh)
# Not all dotfile are backed up
backup_dot:
	@cp -v ~/.bash_profile dotfiles/
	@cp -v ~/.vimrc dotfiles/
	@cp -v ~/.tmux.conf dotfiles/
	@cp -v ~/.config/fish/aliases.fish dotfiles/.config/fish/

backup_atom:
	@cp -v ~/.atom/config.cson dotfiles/.atom
	@cp -v ~/.atom/keymap.cson dotfiles/.atom
	apm-beta list --installed --bare > dotfiles/.atom/package-list.txt

backup_wekan:
	cd $(HOME)/workInProgress/conf/wekan
	./wekan-backup.sh
	cd -

configure_atom:
	apm-beta install --packages-file dotfiles/.atom/package-list.txt

#
# Clean stuff
#

deb_clean:
	# Add -force option ?
	#dpkg --list | grep '^rc ' | awk '{ print $2 }' | xargs dpkg -P
	# Show configuration orphant files
	dpkg --list |grep '^rc'
	apt-get -s autoremove
	apt-get -s autoclean

clean:
	@rm -vf $(CLEAN_FILES)

