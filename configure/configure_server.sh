#!/bin/bash

# cat configure_server.sh | ssh user@remote_adrr

USERNAME="admin"
##################################
###### Install Base Package ######
##################################
apt-get update
apt-get upgrade -y

apt-get install -y htop git make psmisc vim mc rsync tmux ranger curl wget # basic
apt-get install -y net-tools # network
apt-get install -y vim  mc rsync tmux ranger curl wget # edition
apt-get install -y python3-setuptools python-pip python3-pip # python
apt-get autoclean -y
apt-get autoremove -y
apt-get clean -y

#pip3 install -U pip setuptools wheel
#pip3 install -U cython

##################################
###### fix Hostnames        ######
##################################
# Fix hostname in hosts (sudo failed with unable to resolve host plus potiential other errors)
grep -q  $(cat /etc/hostname) /etc/hosts || echo "127.0.0.1 $(cat  /etc/hostname)" >> /etc/hosts

# Setup some cron taks
cat > /etc/cron.weekly/aptupgrade <<END
#!/bin/sh
apt-get update
apt-getp upgrade -y >> /var/log/aptupgrade
apt-get autoclean -y
apt-get clean -y

systemctl reload nginx
END

#
# |adduser user| from script ??
#

##################################
###### Add New User Programmatically
##################################
useradd --create-home -d /home/$USERNAME --shell /bin/bash  $USERNAME -p $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-64} | head -n 1)
usermod -aG sudo $USERNAME

HOMEUSER=$(getent passwd $USERNAME | cut -d: -f6) # === /home/USER/

cp -r ~/.ssh $HOMEUSER/
chown -R $USERNAME:$USERNAME $HOMEUSER/.ssh/

cat >> $HOMEUSER/.bashrc << EOF
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi
EOF

su - admin

# Authorize github
ssh-keyscan github.com >> ~/.ssh/known_hosts
#ssh-keygen -lf githubKey

##################################
###### Setup New User Programmatically
##################################
git clone https://github.com/dtrckd/config.git src/config
cd src/config/
make configure_server

