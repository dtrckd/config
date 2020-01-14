
#!/bin/bash
#
# Enter your email address here
export EMAIL=my.email.address@example.com

# This sets up a Debian host
export DEBIAN_FRONTEND=noninteractive
export HOSTNAME=`hostname -f`

# wait for dpkg to come available
while ! apt-get -qq check; do sleep 1; done

# Tools to install Docker and configure XFS
apt-get install -yq apt-transport-https ca-certificates curl software-properties-common xfsprogs

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

# Install a simple email server - will deliver just fine on
# Bytemark's network, possibly not at all on others.
#
docker run --restart unless-stopped --name mail -d bytemark/smtp

# Download Discourse
mkdir /var/discourse
git clone https://github.com/discourse/discourse_docker.git /var/discourse

# Put configuration file in place
cd /var/discourse
egrep "^# Discourse config" $0 -A99999 | \
  envsubst "\${EMAIL} \${HOSTNAME}" | \
  tee containers/app.yml
./launcher rebuild app
exit

# Discourse config
env:
  DISCOURSE_HOSTNAME: $HOSTNAME
  DISCOURSE_DEVELOPER_EMAILS: $EMAIL
#  LETSENCRYPT_ACCOUNT_EMAIL: $EMAIL
  LANG: en_GB.UTF-8
  UNICORN_WORKERS: 4
  DISCOURSE_SMTP_ADDRESS: smtp
  DISCOURSE_SMTP_PORT: 25
templates:
  - "templates/postgres.template.yml"
  - "templates/redis.template.yml"
  - "templates/web.template.yml"
  - "templates/web.ratelimited.template.yml"
#  - "templates/web.ssl.template.yml"
#  - "templates/web.letsencrypt.ssl.template.yml"
expose:
  - "80:80"
  - "443:443"
params:
  db_default_text_search_config: "pg_catalog.english"
  db_shared_buffers: "256MB"
volumes:
  - volume:
      host: /var/discourse/shared/standalone
      guest: /shared
  - volume:
      host: /var/discourse/shared/standalone/log/var-log
      guest: /var/log
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/discourse/docker_manager.git
run:
  - exec: echo "Beginning of custom commands"
  - exec: echo "End of custom commands"

