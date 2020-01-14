#https://docs.bytemark.co.uk/article/how-to-setup-a-gitlab-server-using-docker/


#!/bin/sh
export DEBIAN_FRONTEND=noninteractive

# Wait for apt-get to be available.
while ! apt-get -qq check; do sleep 1s; done

# Install docker-ce and docker-compose.
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian `lsb_release -cs` stable"
apt-get update
apt-get install -y docker-ce
curl -fsSL https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Check for security updates every night and install them.
apt-get install -y unattended-upgrades

# Retrieve configuration files. Lots of explanatory comments inside!
# If you'd rather inspect and install these files yourself, see:
# https://github.com/BytemarkHosting/configs-gitlab-docker
mkdir -p /root/compose
curl -fsSL https://raw.githubusercontent.com/BytemarkHosting/configs-gitlab-docker/master/docker-compose.yml -o /root/compose/docker-compose.yml
curl -fsSL https://raw.githubusercontent.com/BytemarkHosting/configs-gitlab-docker/master/.env -o /root/compose/.env

# Use server hostname as the domain.
# This can be changed later in the /root/compose/.env file.
DOMAIN="`hostname -f`"
sed -i -e "s|^GITLAB_DOMAIN=.*|GITLAB_DOMAIN=$DOMAIN|" /root/compose/.env

# Change SSH port to 2222, so that GitLab can use port 22.
sed -i -e "s|^#Port 22|Port 2222|" /etc/ssh/sshd_config
systemctl restart sshd.service

# Start our containers.
cd /root/compose
docker-compose up -d

