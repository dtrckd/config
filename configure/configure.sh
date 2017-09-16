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
sudo aptitude install -R sudo aptitude psmisc python3-pip python3-setuptools rfkill apt-file apt-show-versions htop strace 
pip3 install --upgrade setuptools wheel

######################
### Utils
######################
sudo aptitude install -R elinks mc rsync byobu wireshark ranger bmon wicd nmap wget curl vim git gitk gitg
ranger --copy-config=all

######################
### Dev (python, c, fortran etc)
######################
#aptitude install python3-dev gfortran libopenblas-dev # version ?
pip3 install --user ipython jupyter matplotlib numpy scipy

######################
### Apps
######################
sudo aptitude install -R thunderbird gimp libreoffice elinks w3m # firefox midori

######################
### Music (xmms2 plugin)
######################
sudo aptitude -R install vlc audacity xmms2 gxmms2 \
    xmms2-plugin-alsa xmms2-plugin-asf xmms2-plugin-avcodec xmms2-plugin-faad xmms2-plugin-flac xmms2-plugin-id3v2 xmms2-plugin-mad xmms2-plugin-mp4 xmms2-plugin-vorbis

######################
### Bluetooth
######################
sudo aptitude -R install pulseaudio-module-bluetooth blueman
pactl load-module module-bluetooth-discover


######################
### Web Server
######################
# @debug make webmain links...
echo "Installing nginx..."
# Kill apache ?
sudo aptitude install nginx 
sudo aptitude install php-fpm php php-cgi uwsgi
echo "need to set up con files for sites..."
P="/home/dtrckd/Desktop/workInProgress/conf/etc/nginx/sites-available/"
sudo cp $P/* /etc/nginx/sites-enabled/
sudo service nginx restart

# push apt-source and etc file.. ?
# Intall Mongo
# Install Virtualbox qemu

#./install_from_scratch
