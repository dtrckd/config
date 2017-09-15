#!/bin/bash

#
# Init
#
rmdir --ignore-fail-on-non-empty ~/Public/
mkdir -p ~/Music ~/Documents ~/Videos ~/SC ~/Desktop ~/src ~/bin

######################
### System
######################
apt-get install sudo aptitude python3-pip make ctags apt-file apt-show-versions htop strace vim git 

######################
### Utils
######################
aptitude install elinks mc rsync byobu wireshark ranger bmon wicd nmap wget curl
ranger --copy-config=all

######################
### Dev (python, c, fortran etc)
######################
# aptitude install python3-dev ?
pip3 install --user ipython jupyter jupyter pyside matplotlib numpy scipy

######################
### Apps
######################
aptitude install firefox thunderbird midori gimp libreoffice

######################
### Music (xmms2 plugin)
######################
aptitude install xmms2 vlc audacity gxmm2

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
