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
BD_PAPER = $(HOME)/main/networkofgraphs/papers/personal/relational_models/
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
# Download the content
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


# ================================
# Backdown
# ================================

BIN_FILES = $(shell cat configure/bin.txt)

configure_server:
	./configure/conf_serv_my.sh

update_conf_server:
	# Reset/Configure Profile
	cp -r dotfiles/{.bash_profile,.tmux.conf} ~/
	cp dotfiles/.vimshortrc ~/.vimrc
	# Delete the matched and the next line (recursive)
	awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' ~/.tmux.conf > ~/.tmux.conf.temp && mv ~/.tmux.conf.temp ~/.tmux.conf
	awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' ~/.bash_profile > ~/.bash_profile.temp && mv ~/.bash_profile.temp ~/.bash_profile
	# Uncomment the next line (recursive)
	sed -i '/# @SERVER/{n;s/^.//}' ~/.tmux.conf
	sed -i '/# @SERVER/{n;s/^.//}' ~/.bash_profile
	# ---
	# Root conf
	# Reset/Configure Profile
	sudo cp -r dotfiles/{.bash_profile,.tmux.conf} /root/
	sudo cp dotfiles/.vimshortrc /root/.vimrc
	# Delete the matched and the next line (recursive)
	sudo awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' /root/.tmux.conf > .tmux.conf.temp && sudo mv .tmux.conf.temp /root/.tmux.conf
	sudo awk '/# @LOCAL/ {while (/# @LOCAL/ && getline>0) ; next} 1' /root/.bash_profile > .bash_profile.temp && sudo mv .bash_profile.temp /root/.bash_profile
	# Uncomment the next line (recursive)
	sudo sed -i '/# @ROOT/{n;s/^.//}' /root/.tmux.conf
	sudo sed -i '/# @ROOT/{n;s/^.//}' /root/.bash_profile

get_pip:
	curl https://bootstrap.pypa.io/get-pip.py -o ~/bin/get-pip.py

get_docker_compose:
	curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-$(shell uname -s)-$(shell uname -m)" -o ~/bin/docker-compose
	chmod +x ~/bin/docker-compose

configure_laptop: _dotfiles _etc _bin _configure _vim

_install_init:
	cd app/init_package
	dpkg -i *.deb
	cd -

_bootstrap: 
	# -- Pre bootstrap
	#usermod -aG sudo dtrckd && su - dtrckd
	#sudo apt get update && sudo apt install make
	#sudo apt-get install -y aptitude make ntfs-3g vim sudo aptitude firmware-linux-nonfree
	# -- Post boostrap
	# Fish Config
	# replace "cd" by "builtin cd" in /usr/share/fish/functions/{popd,pushd}.fish
	# fish_config prompt
	#remove fish and thefuck from /root/bash_profile
	# Root Config
	#cp dotfiles/.vimshortrc /root/.vimrc
	#

_dotfiles:
	# Warning: Junk file will stay on target (cp don't remove files)
	ls -A dotfiles/ | xargs -I{} cp -r dotfiles/{}  ~/

_etc:
	sudo cp etc/rc.local /etc
	sudo chmod +x /etc/rc.local
	sudo cp -r etc/wpa_supplicant/ /etc
	#sudo cat etc/sysctl.conf >> /etc/sysctl.conf

_bin:
	mkdir -p ${HOME}/bin
	$(foreach f,$(BIN_FILES), /bin/ln -fs $(f) $(HOME)/bin/$(basename $(notdir $(f))) ;)

_configure:
	cd configure/
	./configure.sh # install package
	cd -

_vim:
	mkdir -p ~/.vim/bundle/
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim -c PluginUpdate

# ================================
# Backup
# ================================

backup: backbin snapshot calendar backup_dot backup_firefox backup_thunderbird #backup_wekan

backbin:
	# Create bin.txt
	ls -l $(HOME)/bin | grep '>' |cut -d'>' -f2 > configure/bin.txt

snapshot:
	mkdir -p configure/snapshots/
	uname -a > configure/snapshots/uname
	apt list --installed > configure/snapshots/apt
	pip freeze > configure/snapshots/pip
	snap list > configure/snapshots/snap
	npm list -g --depth 0 > configure/snapshots/npm
	brew list > configure/snapshots/brew

calendar:
	# Deprecated (we use thunderbiar calendar)
	#echo "Backup calendar..."
	#cd ~/.cache/calendar.vim && \
	#	git add * && \
	#	git commit -am "backup" && \
	#	git push && \
	#	cd -

#
# Extra setup
# (factor backup rule and and backapp.sh)
# Not all dotfile are backed up
backup_dot:
	@cp -v ~/.bash_profile dotfiles/
	@cp -v ~/.config/fish/aliases.fish dotfiles/.config/fish/
	@cp -v ~/.vimrc dotfiles/
	@cp -v ~/.tmux.conf dotfiles/
	@cp -v	~/.config/user-dirs.dirs dotfiles/.config/
	@cp -vr	~/.config/aichat dotfiles/.config/

	# Backup Atom file and package
	#@cp -v ~/.atom/config.cson dotfiles/.atom/
	#@cp -v ~/.atom/keymap.cson dotfiles/.atom/
	#@cp -v ~/.atom/projects.cson dotfiles/.atom/
	#apm list --installed --bare > dotfiles/.atom/package-list.txt

	@echo "TODO: check backup for: "\
		"~/.config/htop/"\
		"~/.config/mc/"\
		"~/.config/xmms2/"\
		"~/.config/xfce4/"

backup_dot_fast:
	@cp -v ~/.bash_profile dotfiles/
	@cp -v ~/.config/fish/aliases.fish dotfiles/.config/fish/
	@cp -v ~/.vimrc dotfiles/
	@cp -v ~/.tmux.conf dotfiles/
	@cp -v	~/.config/user-dirs.dirs dotfiles/.config/
	

backup_wekan:
	cd $(HOME)/main/conf/wekan
	./wekan-backup.sh
	cd -

backup_firefox:
	find ${HOME}/.mozilla/firefox/snctzemu.default-esr -name "logins.json" -o -name "key[34].db" -o -name "search.json*" | xargs -I{} rsync --progress -R {} ./app/home/firefox

backup_thunderbird:
	#... | sed "s~$HOME/~~g" | ...
	find ${HOME}/.thunderbird/l7nymwge.default/ -name "*.dat" -o -name "*.json" | xargs -I{} rsync --progress -R {} ./app/home/thunderbird
	# Better
	# copy the profile folder to new folder (new machine for exemple)
	# then do
	# 	thunderbird -profilemanager
	# Create a new profile by selecting the copied one...its done !
	# http://kb.mozillazine.org/Moving_your_profile_folder_-_Thunderbird#Use_the_Profile_Manager_to_move_your_profile

	gpg --armor --export > app/home/some_data/pgp-public-keys.asc
	gpg --armor --export-secret-keys > app/home/some_data/pgp-private-keys.asc
	gpg --export-ownertrust > app/home/some_data/pgp-ownertrust.asc
	# Restore
	# gpg --import pgp-public-keys.asc
	# gpg --import pgp-private-keys.asc
	# gpg --import-ownertrust pgp-ownertrust.asc

# ================================
# sync
# ================================

sync:
	git pull orgin --rebase
	cd ~/.cache/calendar.vim && \
		git pull origin --rebase && \
		cd -

# ================================
# Database
# ================================

mongo_start:
	 docker run -d -p 27017:27017 -v ~/src/data/mongo-docker:/data/db mongo


# ================================
# Clean stuff
# ================================

deb_clean:
	# Add -force option ?
	#dpkg --list | grep '^rc ' | awk '{ print $2 }' | xargs dpkg -P
	# Show configuration orphant files
	dpkg --list |grep '^rc'
	apt-get -s autoremove
	apt-get -s autoclean

clean:
	@rm -vf $(CLEAN_FILES)

