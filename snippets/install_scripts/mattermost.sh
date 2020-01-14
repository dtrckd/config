#!/bin/bash
#
# Enter your email address here
export EMAIL=my.email.address@example.com

# This sets up a Debian host
export DEBIAN_FRONTEND=noninteractive
export HOSTNAME=`hostname -f`


# Download Mattermost compose templates
cd /root
git clone https://github.com/mattermost/mattermost-docker.git

# but let's make some alterations
cd mattermost-docker

# set config directory to correct permissions
mkdir -p config
chown 2000:2000 config

# 1. create our config automatically
export DBPASSWORD=`apg -m 25 -n 1`
export TRAEFIK_CONSOLE_PASSWORD=`apg -m 16 -n 1`

echo $TRAEFIK_CONSOLE_PASSWORD >traefik-password

cat >.env <<END
MATTERMOST_DOMAINS=$HOSTNAME TRAEFIK_DOMAINS=$HOSTNAME BASIC_AUTH=`htpasswd -b -n admin $TRAEFIK_CONSOLE_PASSWORD` POSTGRES_USER=mmuser POSTGRES_PASSWORD=$DBPASSWORD POSTGRES_DB=mattermost MM_USERNAME=mmuser MM_PASSWORD=$DBPASSWORD MM_DBNAME=mattermost ACME_EMAIL=$EMAIL
END

# 2. use a v3 docker compose file and traefik
cat >docker-compose.yml <<END
version: "3"
networks:
frontend:
backend:
volumes:
mattermost-db:
mattermost-data:
mattermost-logs:
services:
mail:
labels:
    - "traefik.enable=false"
image: bytemark/smtp restart: always
networks:
    - frontend db: build: db read_only: true restart: always networks: - backend volumes: - mattermost-db:/var/lib/postgresql/data - /etc/localtime:/etc/localtime:ro environment: - POSTGRES_USER - POSTGRES_PASSWORD - POSTGRES_DB app: depends_on: - db - mail build: context: app args: - edition=team restart: always networks: - frontend - backend volumes: - mattermost-data:/mattermost/data:rw - mattermost-logs:/mattermost/logs:rw - ./config:/mattermost/config:rw - /etc/localtime:/etc/localtime:ro environment: - MM_USERNAME - MM_PASSWORD - MM_DBNAME labels: - "traefik.docker.network=frontend" - "traefik.enable=true" - "traefik.frontend.rule=Host:\${MATTERMOST_DOMAINS}" - "traefik.port=8000" - "traefik.protocol=http" traefik: depends_on: - app image: traefik:1.7 command: --api --docker --acme.email="\${ACME_EMAIL}" restart: always networks: - backend - frontend volumes: - /var/run/docker.sock:/var/run/docker.sock # Access to Docker - ./traefik.toml:/traefik.toml # Traefik configuration - ./acme.json:/acme.json # SSL certificates ports: - "80:80" - "443:443" labels: - "traefik.docker.network=frontend" - "traefik.enable=true" - "traefik.frontend.rule=Host:\${TRAEFIK_DOMAINS}; PathPrefixStrip:/traefik" - "traefik.port=8080" - "traefik.protocol=http" # Remove next line to disable login prompt for the dashboard. - "traefik.frontend.auth.basic=\${BASIC_AUTH}"
END

# 3. supply traefik config file
cat >traefik.toml <<END
# Traefik will listen for traffic on both HTTP and HTTPS.
defaultEntryPoints = ["http", "https"]
# Network traffic will be entering our Docker network on the usual web ports
# (ie, 80 and 443), where Traefik will be listening.
[entryPoints]
  [entryPoints.http]
  address = ":80"
  # Comment out the following two lines to redirect HTTP to HTTPS.
  #   [entryPoints.http.redirect]
  #   entryPoint = "https"
  [entryPoints.https]
  address = ":443"
    [entryPoints.https.tls]

# These options are for Traefik's integration with Docker.
[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "docker.localhost"
watch = true
exposedByDefault = false

# These options are for Traefik's integration with Let's Encrypt.
# Your certificates are stored inside /acme.json inside the container,
# which is /root/compose/acme.json on your server.
[acme]
storage = "acme.json"
onHostRule = true
entryPoint = "https"
  [acme.httpChallenge]
  entryPoint = "http"
# https://docs.traefik.io/configuration/logs/
# Comment out the next line to enable Traefik's access logs.
# [accessLog]

END

# 4 - start it up
cd /root/mattermost-docker
docker-compose up -d
