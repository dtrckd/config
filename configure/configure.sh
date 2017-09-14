#!/bin/bash

#
# Init
#
rmdir --ignore-fail-on-non-empty ~/Public/
mkdir -p ~/Music ~/Documents ~/Videos ~/SC ~/Desktop ~/src ~/bin

######################
### System
######################
apt-get install sudo aptitude apt-file apt-show-versions strace vim git 

######################
### Utils
######################
aptitude install elinks mc rsync byobu wireshark ranger
ranger --copy-config=all

######################
### Dev (python, c, fortran etc)
######################
# todo

######################
### Music (xmms2 plugin)
######################
aptitude install  xmms2 vlc audacity

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

#./install_from_scratch
