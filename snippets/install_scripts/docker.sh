#!/bin/bash

#
#
# Docker and docker-compose
#
#

# wait for dpkg to come available
while ! apt-get -qq check; do sleep 1; done

# Tools to install Docker and configure XFS
apt-get install -yq apt-transport-https ca-certificates curl software-properties-common xfsprogs apg apache2-utils

# Add Docker security keys
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

# Add Docker repository
add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
$(lsb_release -cs) \
stable"

# Finally install Docker and git
apt-get update
apt-get install -yq docker-ce git

# Not sure why this is necessary for Docker
sleep 5
apt-get -f install
apt-get -f install

# install only depenencies for docker-compose...
apt-get install -yq $(apt-cache depends docker-compose | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ' | sed -e "s/.*ends:\ //" -e 's/<[^>]*>//g')

# ...then install latest from github
curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
