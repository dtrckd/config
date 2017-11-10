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

# Pycharm
PAKNAME="pycharm"
URLTARG="https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux"
PAKURL=$(phantomjs djs.js $URLTARG | grep -oiE href=.*${PAK}.*tar.gz[\'\"] | cut -d= -f 2 | tr -d '"')
wget $PAKURL
tar zxvf $(basename $PAKURL)


# wekan
(todo)


