#!/bin/bash

#
# Init
#
rmdir --ignore-fail-on-non-empty ~/Public/
mkdir -p ~/Music ~/Documents ~/Videos ~/SC ~/Desktop ~/src ~/bin
cp blue/* ~

######################
### System
######################
apt-get install sudo aptitude python3-pip make ctags apt-file apt-show-versions htop strace vim git gitk gitg

######################
### Utils
######################
aptitude install elinks mc rsync byobu wireshark ranger bmon wicd nmap wget curl
ranger --copy-config=all

######################
### Dev (python, c, fortran etc)
######################
#aptitude install python3-dev gfortran libopenblas-dev # version ?
pip3 install --user ipython jupyter matplotlib numpy scipy

######################
### Apps
######################
aptitude install firefox thunderbird midori gimp libreoffice

######################
### Music (xmms2 plugin)
######################
aptitude install xmms2 vlc audacity xmms2 gxmm2 \
    xmms2-plugin-alsa xmms2-plugin-asf xmms2-plugin-avcodec xmms2-plugin-faad xmms2-plugin-flac xmms2-plugin-id3v2 xmms2-plugin-mad xmms2-plugin-mp4 xmms2-plugin-vorbis

######################
### Bluetooth
######################
aptitude install pulseaudio-module-bluetooth blueman
pactl load-module module-bluetooth-discover


######################
### Web Server
######################
# @debug make webmain links...
echo "Installing nginx..."
# Kill apache ?
aptitude install nginx 
aptitude install php-fpm php php-cgi uwsgi
echo "need to set up con files for sites..."
P="/home/dtrckd/Desktop/workInProgress/conf/etc/nginx/sites-available/"
cp $P/* /etc/nginx/sites-enabled/
service nginx restart

# push apt-source and etc file.. ?
# Intall Mongo
# Install Virtualbow

#./install_from_scratch
