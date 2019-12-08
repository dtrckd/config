#!/bin/bash

# -- Personnal Distribution --
#
#   Unofficial Packages
#
#

Target="$1"

if [ -z "$Target" ]; then
    echo "Please enter: mongo | atom | signal | wekan | robot3t | pycharm | drawio | fish (fishshell)"
    exit
fi




if [ "$Target" == "mongo" ]; then
    # mongodb-org -- stretch/9
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org

    cp ../app/systemd/mongod.servoce /lib/systemd/system/mongod.service
    mkdir -p /var/log/mongodb/ /var/lib/mongodb/
    chown mongodb:mongodb /var/log/mongodb/ /var/lib/mongodb/
    chmod 0755 /var/log/mongodb/ /var/lib/mongodb/
    systemctl --system daemon-reload
    systemctl enable mongod.service
    # Or with docker

    # pull image..and  launch automatically?
    docker pull mongo[:tag]
    # run mongo with port forward and map local drive to access storage
    docker run -d -p 27017:27017 -v /home/dtrckd/src/data/mongo-docker:/data/db mongo
fi
if [ "$Target" == "atom" ]; then
    pushd ~/Downloads/
    # Atom
    wget https://atom.io/download/deb?channel=beta -O atom-beta.deb
    sudo dpkg -i atom-beta.deb
    popd
fi
if [ "$Target" == "wekan" ]; then
    # Wekan
    sudo aptitude install snapd
    snap install wekan
    snap set wekan root-url="http://wekan.localhost"
    snap set wekan port='8080'
    #snap set wekan mongodb-port=27019 # default
    sudo systemctl restart snap.wekan.wekan
    #snap start wekan.wekan

    # Install all Snap updates automatically between 02:00AM and 04:00AM
    # snap set core refresh.schedule=02:00-04:00
    # sudo snap set wekan mail-url='smtps://user:pass@mailserver.example.com:453'
    # sudo snap set wekan mail-from='Wekan Boards <support@example.com>'

    # Old way
    #git clone https://github.com/wekan/wekan-mongodb.git ~/Documents/wekan-mongodb
    #pushd ~/Documents/wekan-mongodb
    ## set the host (sed -> replace in the range matching between "/x/, /y/ ..."
    #sed -i "/^ *environment:$/, /[#\n]/ s/ROOT_URL=.*$/ROOT_URL=http:\/\/wekan.localhost/"  docker-compose.yml
    ## set the port; (sed -> modif the line just after 'ports:')
    #sed -i "/^ *ports:$/ {n;s/[0-9]*:[0-9]*/8080:80/}"  docker-compose.yml
    #sudo apt-mark hold docker.io
    #sudo aptitude install docker-compose
    #docker-compose up
    #popd
fi
if [ "$Target" == "robot3t" ]; then
    # Robo3t
    PAKURL="https://download.robomongo.org/1.2.1/linux/robo3t-1.2.1-linux-x86_64-3e50a65.tar.gz"
    wget $PAKURL
    tar zxvf $(basename $PAKURL)
    popd
fi
if [ "$Target" == "signal" ]; then
    # Signal
    curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update && sudo apt install signal-desktop
fi
if [ "$Target" == "pycharm" ]; then
    # Pycharm
    pushd ~/Downloads/
    PAKNAME="pycharm"
    URLTARG="https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux"
    PAKURL=$(phantomjs djs.js $URLTARG | grep -oiE href=.*${PAK}.*tar.gz[\'\"] | cut -d= -f 2 | tr -d '"')
    wget $PAKURL
    tar zxvf $(basename $PAKURL)
    popd
fi
if [ "$Target" == "drawio" ]; then
    git clone --recursive https://github.com/jgraph/drawio-desktop.git
    cd drawio-desktop
    npm install
    cd drawio
    npm install
    export NODE_ENV=development
    #cd ..
    #npm start
fi
if [ "$Target" == "fish" ]; then
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | sudo tee  /etc/apt/sources.list.d/shells:fish:release:3.list
    wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key -O Release.key
    sudo apt-key add - < Release.key
    rm Release.key
    sudo apt-get update
    sudo apt-get install fish
fi


### TODO

# APT contrib:
# virtualbox
# qemu
# brave


# Ethereum (work in ubuntu, not debian 11/2017 => but yes change distribution `bionic` to `xenial`.)
#add-apt-repository -y ppa:ethereum/ethereum && add-apt-repository -y ppa:ethereum/ethereum-dev
# If pubkey issues (wget -qO - http://ppa.launchpad.net/ethereum/ethereum-dev/ubuntu/dists/vivid/Release.gpg  | apt-key add -) doesn't work :
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  THU_SIG_KEY ...


