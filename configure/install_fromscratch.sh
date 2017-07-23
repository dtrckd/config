#!/bin/bash

# -- Personnal Distribution --
#
#   Unofficial Useful Packages
#

# atom
wget https://atom.io/download/deb?channel=beta -O atom-beta.deb

# pycharm
PAKNAME="pycharm"
URLTARG="https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux"
PAKURL=$(phantomjs djs.js $URLTARG | grep -oiE href=.*${PAK}.*tar.gz[\'\"] | cut -d= -f 2 | tr -d '"')
wget $PAKURL
tar zxvf $(basename $PAKURL)

# wekan
(todo)


