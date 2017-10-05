#!/bin/bash

# -- Personnal Distribution --
#
#   Unofficial Useful Packages
#
#

# docker
DOCKER_VER="docker-17.09.0-ce"
#wget https://download.docker.com/linux/debian/dists/stretch/pool/stable/amd64/docker-ce_17.09.0~ce-0~debian_amd64.deb  -O /usr/bin/docker
wget https://download.docker.com/linux/static/stable/x86_64/$DDOCKER_VER.tgz
tar xzvf $DOCKER_VER.tar.gz
cp docker/* /usr/bin/
rm -r docker/ $DOCKER_VER.tar.gz
curl -o /etc/init.d/docker https://raw.githubusercontent.com/dotcloud/docker/master/contrib/init/sysvinit-debian/docker
chmod +x /usr/bin/docker /etc/init.d/docker
addgroup docker
#update-rc.d -f docker defaults
cat << EOF > /etc/default/docker
DOCKER_OPTS="-H 127.0.0.1:4243 -H unix:///var/run/docker.sock"
EOF
usermod -aG docker dtrckd
service docker start

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


