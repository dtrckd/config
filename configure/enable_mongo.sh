# enable_mongo.sh

echo '[Unit]
Description=High-performance, schema-free document-oriented database
After=syslog.target network.target

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongod -f /etc/mongod.conf

[Install]
WantedBy=multi-user.target' > /lib/systemd/system/mongod.service

# Setup the required directories
# mkdir -p /var/run/mongodb/
mkdir -p /var/log/mongodb/
mkdir -p /var/lib/mongodb/

# chown mongodb:mongodb /var/run/mongodb/
chown mongodb:mongodb /var/log/mongodb/
chown mongodb:mongodb /var/lib/mongodb/

# chmod 0755 /var/run/mongodb/
chmod 0755 /var/log/mongodb/
chmod 0755 /var/lib/mongodb/

# Start the new service and enable it on boot
systemctl --system daemon-reload
systemctl enable mongod.service

echo "Starting"
