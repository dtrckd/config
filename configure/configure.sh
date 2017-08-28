#!/bin/bash

#./install_from_scratch


######################
### Utils
######################
ranger --copy-config=all


######################
### Bluetooth
######################
apt-get install pulseaudio-module-bluetooth blueman
pactl load-module module-bluetooth-discover


######################
### Web Server
######################
# @debug make webmain links...
echo "Installing nginx..."
aptitude install nginx 
aptitude install php-fpm php php-cgi uwsgi
echo "need to set up con files for sites..."
P="/home/dtrckd/Desktop/workInProgress/conf/etc/nginx/sites-available/"
cp $P/* /etc/nginx/sites-enabled/
service nginx restart
