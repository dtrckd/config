#!/bin/bash

# exec as sudo

##################################
###### Install Base Package ######
##################################
apt-get update
apt-get upgrade -y
apt-get install -y aptitude htop wget make tmux fail2ban

##################################
###### fix Hostnames        ######
##################################
# Fix hostname in hosts (sudo failed with unable to resolve host plus potiential other errors)
grep -q  $(cat /etc/hostname) /etc/hosts || echo "127.0.0.1 $(cat  /etc/hostname)" >> /etc/hosts

# Setup some cron taks
cat > /etc/cron.weekly/aptupgrade <<END
#!/bin/sh
apt-get update
apt-get upgrade -y >> /var/log/aptupgrade
apt-get autoclean -y
apt-get clean -y

# If nginx
#systemctl reload nginx
END

