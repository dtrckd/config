#!/bin/bash

# -- Personnal Distribution --
#
#   Unofficial Packages
#
#


# From /etc/apt/source.list + gpg key, install, enable.
# apt install mongodb-org 
# apt install virtualbox qemu
# apt install brave

# Atom
wget https://atom.io/download/deb?channel=beta -O atom-beta.deb

# Wekan
git clone https://github.com/wekan/wekan-mongodb.git ~/Documents/wekan-mongodb
cd ~/Documents/wekan-mongodb
# set the host (sed -> replace in the range matching between "/x/, /y/ ..."
sed -i "/^ *environment:$/, /[#\n]/ s/ROOT_URL=.*$/ROOT_URL=http:\/\/wekan.localhost/"  docker-compose.yml
# set the port; (sed -> modif the line just after 'ports:')
sed -i "/^ *ports:$/ {n;s/[0-9]*:[0-9]*/8080:80/}"  docker-compose.yml 
#docker-compose up # apt instakk docker-compose # maybe apt-mark hold docker.io
cd -

# Pycharm
PAKNAME="pycharm"
URLTARG="https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux"
PAKURL=$(phantomjs djs.js $URLTARG | grep -oiE href=.*${PAK}.*tar.gz[\'\"] | cut -d= -f 2 | tr -d '"')
wget $PAKURL
tar zxvf $(basename $PAKURL)




