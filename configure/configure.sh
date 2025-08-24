#!/bin/bash

set -e

AGGRESSIVE_APT=1
AGGRESSIVE_PYTHON=1
LATEX=1
PYTHON=1
XMMS=1
BLUETOOTH=1
NGINX=0


#
# Init
#

OPTS="-y --no-install-recommends"


######################
### System
######################
sudo apt install $OPTS sudo aptitude make psmisc rfkill apt-file apt-show-versions htop strace net-tools jq ripgrep fd-find curl wget zip xclip mc rsync tmux vim neovim git gitk gitg tree bat xsel git-delta
sudo update-alternatives --config vim

#sudo apt-get install $OPTS firmware-linux-nonfree firmware-iwlwifi
#ranger --copy-config=all

# Optionals (but advised !)
if [ $AGGRESSIVE_APT == 1 ]; then
    sudo apt install $OPTS apt-listbugs acpi bmon nmap wireshark fish autossh direnv ca-certificates snapd fzf acpid
    sudo apt install $OPTS elinks w3m thunderbird firefox gimp libreoffice hunspell-fr pandoc lmodern graphicsmagick-imagemagick-compat pdftk  # midori opera
    # for protonmail bridge on linux
    sudo apt install $OPTS
    # Build
    sudo apt install $OPTS build-essential autoconf cmake libtool pkg-config exuberant-ctags universal-ctags parallel debsig-verify debian-keyring gnome-keyring # cargo
    sudo update-alternatives --config ctags
fi


######################
### Python Dev
######################
if [ $PYTHON == 1 ]; then
    # Debian dependancies and dev utils
    sudo apt install $OPTS python3 python-is-python3 python3-dev python3-pip python3-venv libxml2-dev libxslt1-dev python3-dev
    # LSP
    pip install python-lsp-server ruff-lsp pylsp-mypy jupyter-lsp cython ipython jupyter matplotlib numpy scipy pandas scikit-learn requests
    # tools and edition
    pip install pip_search pipdeptree pypandoc pandoc-shortcaption pandoc-eqnos pandoc-fignos pandoc-xnos pandocfilters
    # For tagbar ctags support
    pip install markdown2ctags
    cp ~/src/config/snippets/elmtags.py ~/.local/bin/

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
    sudo apt install $OPTS vlc ffmpeg xmms2 \
        xmms2-plugin-alsa xmms2-plugin-pulse xmms2-plugin-asf xmms2-plugin-avcodec xmms2-plugin-faad xmms2-plugin-flac xmms2-plugin-id3v2 xmms2-plugin-mad xmms2-plugin-mp4 xmms2-plugin-vorbis # audacity
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
    sudo apt install $OPTS blueman #pulseaudio-module-bluetooth
    pactl load-module module-bluetooth-discover
fi


######################
### Web Server
######################
if [ $NGINX == 1 ]; then
    # @debug make webmain links...
    echo "Installing nginx..."
    # Kill apache ?
    sudo apt install $OPTS nginx # php-fpm php php-cgi uwsgi
    echo "need to set up con files for sites..."
    P="/home/dtrckd/main/conf/etc/nginx/sites-available/"
    sudo cp $P/* /etc/nginx/sites-enabled/
    sudo service nginx restart
fi

