#!/bin/bash

AGGRESSIVE=1
PERS=1
BLUETOOTH=0
OPTS="-y"

#
# Init
#

# Base packages (see Makefile)
#sudo apt-get install -y aptitude make ntfs-3g vim sudo aptitude firmware-linux-nonfree

######################
### System
######################
sudo aptitude install $OPTS -R sudo aptitude make psmisc python3-setuptools rfkill apt-file apt-show-versions htop strace net-tools python3-pip
pip3 install --user --upgrade setuptools wheel pip

######################
### Utils
######################
sudo aptitude install $OPTS -R mc rsync tmux ranger wicd vim git gitk gitg
ranger --copy-config=all
# Optionals (but advised !)
if [ $AGGRESSIVE == 1 ]; then
    sudo aptitude install $OPTS -R apt-listbugs zip xclip acpi bmon nmap curl wget wireshark ksysguard iotop jq ripgrep fish
fi

######################
### Python Dev
######################
sudo aptitude install $OPTS -R gfortran libopenblas-dev python3-tk
if [ $AGGRESSIVE == 1 ]; then
    sudo aptitude install $OPTS -R build-essential autoconf libtool pkg-config python3-dev cython3 exuberant-ctags
    pip3 install --user -U cython
fi
pip3 install --user -U ipython jupyter matplotlib numpy scipy

######################
### Apps
######################
if [ $AGGRESSIVE == 1 ]; then
    sudo aptitude install $OPTS pandoc lmodern pandoc-citeproc parallel
    pip3 install --user pypandoc markdown2ctags pandoc-shortcaption pandoc-eqnos pandoc-fignos  pandoc-xnos pandocfilters
fi

if [ $PERS == 1 ]; then
    sudo aptitude install $OPTS -R elinks w3m  firefox thunderbird gimp libreoffice hunspell-fr # midori
fi

######################
### Music (xmms2 plugin)
######################
if [ $PERS == 1 ]; then
    sudo aptitude  install $OPTS -R vlc audacity xmms2 gxmms2 \
        xmms2-plugin-alsa xmms2-plugin-asf xmms2-plugin-avcodec xmms2-plugin-faad xmms2-plugin-flac xmms2-plugin-id3v2 xmms2-plugin-mad xmms2-plugin-mp4 xmms2-plugin-vorbis
    # (mp3cut) => poc-streamer
fi


######################
### Latex
######################
if [ $PERS == 1 ]; then
    sudo aptitude install $OPTS -R texlive texlive-latex-extra texlive-science texlive-fonts-extra texlive-latex-base texlive-extra-utils texlive-bibtex-extra texlive-plain-generic
fi


######################
### Bluetooth
######################
if [ $BLUETOOTH == 1 ]; then
    sudo aptitude install $OPTS -R  pulseaudio-module-bluetooth blueman
    pactl load-module module-bluetooth-discover
fi


######################
### Snap and Docker
######################
if [ $AGGRESSIVE == 1 ]; then
    sudo aptitude install $OPTS -R snapd docker.io
    snap install mattermost-desktop insomnia signal-desktop telegram-desktop hugo gitter-desktop fractal
fi

######################
### Web Server
######################
if [ $PERS == 1 ]; then
    # @debug make webmain links...
    echo "Installing nginx..."
    # Kill apache ?
    sudo aptitude install $OPTS nginx
    sudo aptitude install $OPTS php-fpm php php-cgi uwsgi
    echo "need to set up con files for sites..."
    P="/home/dtrckd/main/conf/etc/nginx/sites-available/"
    sudo cp $P/* /etc/nginx/sites-enabled/
    sudo service nginx restart
fi

######################
### Extra
######################
if [ $AGGRESSIVE == 1 ]; then
    ./setup-env.sh npm
    ./setup-env.sh go
    ./setup-apps.sh atom

    # Brew
    ./setup-env.sh brew
    git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
    ~/.linuxbrew/bin/brew install git-delta
fi


######################
### Init directories
######################
rmdir --ignore-fail-on-non-empty ~/Public/ ~/Templates/
mkdir -p ~/Music ~/Documents ~/Videos ~/SC ~/Desktop ~/src ~/bin
mkdir ~/.config/calendar.vim
