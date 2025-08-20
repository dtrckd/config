#!/bin/bash

set -e

# -- Personnal Distribution --
#
#   Unofficial Packages
#
#

Target="$1"

if [ -z "$Target" ]; then
    echo "Please enter: mongo | signal | wekan | robot3t | drawio | fish (fishshell) | manta | proton | kitty | gdrive | aichat | nvim | git-bug"
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
if [ "$Target" == "wekan" ]; then
    # Wekan
    sudo aptitude install snapd
    snap install wekan
    snap set wekan root-url="http://wekan.localhost"
    snap set wekan port='8989'
    #snap set wekan mongodb-port=27019 # default
    sudo systemctl restart snap.wekan.wekan
    #snap start wekan.wekan

    # Install all Snap updates automatically between 02:00AM and 04:00AM
    # snap set core refresh.schedule=02:00-04:00
    # sudo snap set wekan mail-url='smtps://user:pass@mailserver.example.com:453'
    # sudo snap set wekan mail-from='Wekan Boards <support@example.com>'
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
if [ "$Target" == "drawio" ]; then
    # Use excalibur insstead !
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
if [ "$Target" == "manta" ]; then
    wget https://github.com/hql287/Manta/releases/download/v1.1.4/Manta-1.1.4-x86_64.AppImage -O ~/Downloads/Manta.AppImage
    ~/Download/https://github.com/hql287/Manta/releases/download/v1.1.4/Manta.AppImage
fi
if [ "$Target" == "proton" ]; then
    # Bridge
    VERSION="3.8.2-1"
    wget https://proton.me/download/bridge/protonmail-bridge_${VERSION}_amd64.deb
    sudo dpkg -i protonmail-bridge_${VERSION}_amd64.deb
    rm protonmail-bridge_${VERSION}_amd64.deb
    # VPN
    VERSION="1.0.3-3"
    wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_${VERSION}_all.deb
    sudo dpkg -i protonvpn-stable-release_${VERSION}_all.deb
    rm protonvpn-stable-release_${VERSION}_all.deb

    sudo apt update
fi
if [ "$Target" == "kitty" ]; then
    # Install or update kitty.
    # https://sw.kovidgoyal.net/kitty/binary/
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi
if [ "$Target" == "gdrive" ]; then
    VERSION="3.9.1"
    URL="https://github.com/glotlabs/gdrive/releases/download/$VERSION/gdrive_linux-x64.tar.gz"
    wget $URL
    tar zxvf $(basename $URL)
    rm $(basename $URL)
    mv gdrive ~/bin/gdrive
fi
if [ "$Target" == "aichat" ]; then
    #URL="https://github.com/sigoden/aichat/releases/download/v0.13.0/aichat-v0.13.0-x86_64-unknown-linux-musl.tar.gz"
    #wget $URL
    #tar zxvf $(basename $URL)
    #rm $(basename $URL)
    #mv aichat ~/bin/ai
    cargo install aichat
fi
if [ "$Target" == "nvim" ]; then
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    mv nvim-linux-x86_64.appimage nvim.appimage
    chmod +x nvim.appimage
    mv nvim.appimage ~/Downloads/
    sudo update-alternatives --install /usr/bin/vim vim ~/Downloads/nvim.appimage 60
fi
if [ "$Target" == "git-bug" ]; then
    wget https://github.com/git-bug/git-bug/releases/latest/download/git-bug_linux_amd64
    mv git-bug_linux_amd64 git-bug
    chmod +x git-bug
    mv git-bug ~/bin
fi


### TODO

# APT contrib:
# virtualbox
# qemu
# brave
# opera


# Ethereum (work in ubuntu, not debian 11/2017 => but yes change distribution `bionic` to `xenial`.)
#add-apt-repository -y ppa:ethereum/ethereum && add-apt-repository -y ppa:ethereum/ethereum-dev
# If pubkey issues (wget -qO - http://ppa.launchpad.net/ethereum/ethereum-dev/ubuntu/dists/vivid/Release.gpg  | apt-key add -) doesn't work :
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  THU_SIG_KEY ...


