#!/bin/bash

set -e

AGGRESSIVE=1
MORE=1
LATEX=1
XMMS=1
PYTHON=1
NGINX=0
BLUETOOTH=0
SETUP_ENV=1
SETUP_APP=1


#
# Init
#

OPTS="-y --no-install-recommends"


######################
### System
######################
sudo apt install $OPTS sudo aptitude make psmisc rfkill apt-file apt-show-versions htop strace net-tools jq ripgrep curl wget zip xclip mc rsync tmux vim neovim git gitk gitg tree bat xsel git-delta

#sudo apt-get install $OPTS firmware-linux-nonfree
#ranger --copy-config=all

# Optionals (but advised !)
if [ $AGGRESSIVE == 1 ]; then
    sudo apt install $OPTS apt-listbugs acpi bmon nmap wireshark fish autossh wkhtmltopdf direnv
    # for protonmail bridge on linux
    sudo apt install $OPTS
    # Build
    sudo apt install $OPTS build-essential autoconf cmake libtool pkg-config exuberant-ctags universal-ctags parallel debsig-verify debian-keyring gnome-keyring cargo
    sudo update-alternatives --config ctags
fi

######################
### Snap and Docker
######################
if [ $AGGRESSIVE == 1 ]; then
    sudo apt install $OPTS snapd docker.io docker-compose
fi

######################
### More App
######################
if [ $MORE == 1 ]; then
    sudo apt install $OPTS elinks w3m thunderbird gimp libreoffice hunspell-fr pandoc lmodern graphicsmagick-imagemagick-compat # midori opera
fi

######################
### Python Dev
######################
if [ $AGGRESSIVE == 1 ]; then
    # Debian dependancies.
    sudo apt install $OPTS python3 python3-dev python3-pip python3-venv
    # LSP
    pip install python-lsp-server ruff-lsp pylsp-mypy jupyter-lsp
fi
if [ $PYTHON == 1 ]; then
    # dev/ia
    #sudo apt install $OPTS gfortran libopenblas-dev python3-tk cython3
    pip install cython ipython jupyter matplotlib numpy scipy pandas scikit-learn requests fastapi pydantic ansible
    # tools
    pip install pip_search pipdeptree pypandoc markdown2ctags pandoc-shortcaption pandoc-eqnos pandoc-fignos pandoc-xnos pandocfilters
    #pip install Scrapy scrapy-splash

    # Add unstable python version
    # sudo apt install -t unstable python3.12
    #sudo update-alternatives --remove python /usr/bin/python3.11
    #sudo update-alternatives --remove python /usr/bin/python3.12
    #sudo update-alternatives --remove python3 /usr/bin/python3.11
    #sudo update-alternatives --remove python3 /usr/bin/python3.12
    #sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.11 30
    #sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 10
    #sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 30
    #sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 10
    #sudo update-alternatives --auto python
    #sudo update-alternatives --auto python3
fi

######################
### Music (xmms2 plugin)
######################
if [ $XMMS == 1 ]; then
    sudo apt  install $OPTS vlc audacity ffmpeg xmms2 \
        xmms2-plugin-alsa xmms2-plugin-pulse xmms2-plugin-asf xmms2-plugin-avcodec xmms2-plugin-faad xmms2-plugin-flac xmms2-plugin-id3v2 xmms2-plugin-mad xmms2-plugin-mp4 xmms2-plugin-vorbis
fi


######################
### Latex
######################
if [ $LATEX == 1 ]; then
    sudo apt install $OPTS texlive texlive-latex-extra texlive-science texlive-fonts-extra texlive-latex-base texlive-extra-utils texlive-bibtex-extra texlive-plain-generic
fi


######################
### Bluetooth
######################
if [ $BLUETOOTH == 1 ]; then
    sudo apt install $OPTS pulseaudio-module-bluetooth blueman
    pactl load-module module-bluetooth-discover
fi


######################
### Web Server
######################
if [ $NGINX == 1 ]; then
    # @debug make webmain links...
    echo "Installing nginx..."
    # Kill apache ?
    sudo apt install $OPTS nginx php-fpm php php-cgi uwsgi
    echo "need to set up con files for sites..."
    P="/home/dtrckd/main/conf/etc/nginx/sites-available/"
    sudo cp $P/* /etc/nginx/sites-enabled/
    sudo service nginx restart
fi


######################
### SETUP ENV
######################
if [ $SETUP_ENV == 1 ]; then
    ./setup-env.sh rust
    ./setup-env.sh npm
    ./setup-env.sh go
fi


######################
### SETUP APP
######################
if [ $SETUP_APP == 1 ]; then
    ./setup-app.sh kitty
    ./setup-app.sh proton
    ./setup-app.sh aichat
    ./setup-app.sh nvim
    # @see chadtree @requirement install
    sudo update-alternatives --config vim
fi
