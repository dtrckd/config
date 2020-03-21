#!/bin/bash

Target="$1"

if [ -z "$Target" ]; then
    echo "Please enter: go | npm | docker"
    exit
fi




if [ "$Target" == "go" ]; then
    # Golang

    # First approach
    #GOTARGET="go1.11.8.linux-amd64.tar.gz "
    #wget https://storage.googleapis.com/golang/$GOTARGET
    #sudo tar -zxvf  $GOTARGET -C /usr/local/
    #rm $GOTARGET
    #mkdir -p $HOME/.go

    # Go update approach
    release=$(curl --silent https://golang.org/doc/devel/release.html | /bin/grep -Eo 'go[0-9]+(\.[0-9]+)+' | sort -V | uniq | tail -1)
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(case "$(uname -m)" in i*) echo '386' ;; x*) echo 'amd64' ;; *) echo 'armv61'; esac)

    VER="$release.$os-$arch"
    sudo mkdir -p "/usr/local/lib/$VER"
    #curl --silent "https://storage.googleapis.com/golang/$VER.tar.gz" | sudo tar -vxz --strip-components 1 -C "/usr/local/lib/$VER"
    sudo rm -f /usr/local/bin/go
    sudo rm -f /usr/local/bin/gofmt
    sudo ln -s "/usr/local/lib/$VER/bin/go" /usr/local/bin/go
    sudo ln -s "/usr/local/lib/$VER/bin/gofmt" /usr/local/bin/gofmt
    source ~/.bashrc
    echo "updated to $(go version)"
fi
if [ "$Target" == "npm" ]; then
    # NPM
    git clone https://github.com/creationix/nvm.git $HOME/.nvm
    . $HOME/.nvm/nvm.sh
    nvm install node
fi
if [ "$Target" == "docker" ]; then
    # Docker
    echo "see also snap installation..."
    #DOCKER_VER="docker-17.09.0-ce"
    DOCKER_VER="docker-18.06.1-ce"
    #wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_17.09.0~ce-0~debian_amd64.deb  -O /usr/bin/docker
    wget https://download.docker.com/linux/static/stable/x86_64/$DOCKER_VER.tgz
    tar xzvf $DOCKER_VER.tgz
    sudo cp docker/* /usr/bin/
    rm -r docker/ $DOCKER_VER.tgz
    #wget -O docker_file https://raw.githubusercontent.com/dotcloud/docker/master/contrib/init/sysvinit-debian/docker
    sudo cp ../app/systemd/docker /etc/init.d/docker
    sudo chmod +x /usr/bin/docker /etc/init.d/docker
    sudo addgroup docker
    #update-rc.d -f docker defaults
    sudo cat << EOF > /etc/default/docker
    DOCKER_OPTS="-H 127.0.0.1:4243 -H unix:///var/run/docker.sock"
EOF
    sudo usermod -aG docker $USER
    sudo update-rc.d docker start
fi
if [ "$Target" == "crystal" ]; then
    curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
    echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
    sudo apt-get update
    # Dependencies
    apt install libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libz-dev
    sudo apt install crystal
fi

