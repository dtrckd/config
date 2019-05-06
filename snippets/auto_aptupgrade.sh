#!/bin/bash

cat << EOF > /etc/cron.weekly/aptupgrade
#!/bin/bash
apt-get update
apt-get upgrade -y >> /var/log/aptupgrade
apt-get autoclean
EOF

chmod 755 /etc/cron.weekly/aptupgrade

cat << EOF > /etc/logrotate.d./aptupgrade
/var/log/aptupgrade {
    rotate 2
    weekly
    size 300k
    compress
    notifempty
}
EOF
