#!/bin/bash

# Golang
GOTARGET="go1.9.1.linux-amd64.tar.gz "
wget https://storage.googleapis.com/golang/$GOTARGET
sudo tar -zxvf  $GOTARGET -C /usr/local/
rm $GOTARGET
mkdir $HOME/.go

# NPM
git clone https://github.com/creationix/nvm.git $HOME/.nvm
. $HOME/.nvm/nvm.sh
nvm install node


