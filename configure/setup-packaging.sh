#!/bin/bash

# Golang
GOTARGET="go1.9.1.linux-amd64.tar.gz "
wget https://storage.googleapis.com/golang/$GOTARGET
sudo tar -zxvf  $GOTARGET -C /usr/local/
rm $GOTARGET
mkdir -p $HOME/.go

# NPM
git clone https://github.com/creationix/nvm.git $HOME/.nvm
. $HOME/.nvm/nvm.sh
nvm install node

# Docker
DOCKER_VER="docker-17.09.0-ce"
#wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_17.09.0~ce-0~debian_amd64.deb  -O /usr/bin/docker
wget https://download.docker.com/linux/static/stable/x86_64/$DOCKER_VER.tgz
tar xzvf $DOCKER_VER.tgz
cp docker/* /usr/bin/
rm -r docker/ $DOCKER_VER.tgz
curl -o /etc/init.d/docker https://raw.githubusercontent.com/dotcloud/docker/master/contrib/init/sysvinit-debian/docker
chmod +x /usr/bin/docker /etc/init.d/docker
addgroup docker
#update-rc.d -f docker defaults
cat << EOF > /etc/default/docker
DOCKER_OPTS="-H 127.0.0.1:4243 -H unix:///var/run/docker.sock"
EOF
usermod -aG docker dtrckd
service docker start


