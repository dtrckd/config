#!/bin/bash

AGGRESSIVE=1
PERS=0
OPTS="-y"

#
# Init
#
rmdir --ignore-fail-on-non-empty   ~/Public/ Templates/
mkdir -p ~/Music ~/Documents ~/Videos ~/SC ~/Desktop ~/src ~/bin
cp blue/* ~

# apt install sudo aptitude vim vim.nox firmaware-linux-nonfree
#
# Basics? python3-pip python3-setuptools  rsync byobu ranger curl wget zip 

######################
### System
######################
sudo aptitude install $OPTS -R sudo aptitude psmisc python3-pip python3-setuptools rfkill apt-file apt-show-versions htop strace 
pip3 install --upgrade setuptools wheel

######################
### Utils
######################
sudo aptitude install $OPTS -R mc rsync byobu ranger wicd vim-nox git gitk gitg
ranger --copy-config=all
# Optionals (but advised !)
if [ $AGGRESSIVE == 1 ]; then 
    aptitude install $OPTS -R apt-listbugs zip xclip acpi bmon nmap curl wget wireshark elinks w3m ksysguard iotop
fi

######################
### Python Dev
######################
sudo aptitude install $OPTS -R gfortran libopenblas-dev python3-tk
if [ $AGGRESSIVE == 1 ]; then 
    sudo aptitude install $OPTS -R build-essential autoconf libtool pkg-config  python3-dev cython
fi
pip3 install $OPTS --user ipython jupyter matplotlib numpy scipy

######################
### Apps
######################
if [ $AGGRESSIVE == 1 ]; then 
    sudo aptitude install $OPTS pandoc parallel
    pip3 install --user pypandoc markdown2ctags pandoc-shortcaption
fi

if [ $PERS == 1 ]; then 
    sudo aptitude install $OPTS -R thunderbird gimp libreoffice # firefox midori
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
if [ $PERS == 1 ]; then 
    sudo aptitude install $OPTS -R  pulseaudio-module-bluetooth blueman
    pactl load-module module-bluetooth-discover
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
    P="/home/dtrckd/Desktop/workInProgress/conf/etc/nginx/sites-available/"
    sudo cp $P/* /etc/nginx/sites-enabled/
    sudo service nginx restart
fi

# Packaging
#./setup-packaging.sh

# Various
#./install_from_scratch

