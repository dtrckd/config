#! /bin/bash

# ######################### Firewall (fw) ########################
#
# This is a basic /sbin/iptables firewall script.
#
# Usage:
# ./fw {start|stop|restart|save|restore}
#
# Notes:
# 1. Comment or uncomment the firewall rules below according to your
#    needs.
# 2. For convenience, add this script to your /usr/bin or alike with
#    chmod +x permissions.
# 2. License: MIT
# 3. Author: dth at dthlabs dot com
#    Site:   https://dthlabs.com
#    github: https://github.com/xdth
#
# Brussels, Jan 23, 2018
# note: https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
# #######################################################################


# #######################################################################
# ## Rules function -- edit this according to your needs

function fw_rules {
  # Block everything
  /sbin/iptables -t filter -P INPUT DROP
  #/sbin/iptables -t filter -P FORWARD DROP
  /sbin/iptables -t filter -P OUTPUT DROP

  # Don't break established connections
  /sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  /sbin/iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

  # Authorize loopback (127.0.0.1)
  /sbin/iptables -t filter -A INPUT -i lo -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -o lo -j ACCEPT

  # ICMP (ping)
  /sbin/iptables -t filter -A INPUT -p icmp -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p icmp -j ACCEPT

  # SSH in/out
  /sbin/iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
  # special ssh ports
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 29418 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 29418 -j ACCEPT

  # DNS in/out
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

  # DHCP
  /sbin/iptables -t filter -A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
  /sbin/iptables -t filter -A INPUT  -p udp --dport 67:68 --sport 67:68 -j ACCEPT

  # NTP Out
  /sbin/iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

  # HTTP + HTTPS Out
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 8080 -j ACCEPT

  # HTTP + HTTPS In
  /sbin/iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 8080 -j ACCEPT

  # FTP Out
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT

  # FTP In
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Mail SMTP
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 587 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 587 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 465 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 465 -j ACCEPT

  # Mail IMAP:143
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

  # Mail POP3:110
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

  # Mail POP3S:995
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT

  # Node exporter
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 9100 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 9100 -j ACCEPT

  # OpenVZ Web Pannel
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 3000 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 3000 -j ACCEPT

  # Allow WMs
  # /sbin/iptables -P FORWARD ACCEPT
  # /sbin/iptables -F FORWARD

  # Saltstack
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 4505 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 4505 -j ACCEPT
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 4506 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 4506 -j ACCEPT

  # Block UDP attack
  # /sbin/iptables -A INPUT -m state --state INVALID -j DROP

}


# #######################################################################
# ## Other functions

function fw_help {
  echo "Firewall usage: ./fw {start|stop|restart|save|restore}"
  exit 1
}

function fw_reset {
  /sbin/iptables -F
  /sbin/iptables -X
  /sbin/iptables -t nat -F
  /sbin/iptables -t nat -X
  /sbin/iptables -t mangle -F
  /sbin/iptables -t mangle -X
  /sbin/iptables -P INPUT ACCEPT
  /sbin/iptables -P FORWARD ACCEPT
  /sbin/iptables -P OUTPUT ACCEPT
  /sbin/iptables -t filter -F
  /sbin/iptables -t filter -X
}

function fw_start {
  echo "     > Starting Firewall..."
  fw_rules
  echo "     > Firewall started"
}

function fw_stop {
  echo "     > Stopping Firewall..."
  fw_reset
  echo "     > Firewall stopped"
}

function fw_restart {
  echo "     > Starting Firewall..."
  fw_reset
  echo "     > Loading the rules..."
  fw_rules
  echo "     > Rules loaded"
  echo "     > Firewall started"
}

function fw_save {
  echo "     > Saving Firewall..."
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
  mkdir -p /etc/iptables
  /sbin/iptables-save > /etc/iptables/rules.v4
  /sbin/ip6tables-save > /etc/iptables/rules.v6
  echo "     > Firewall saving"
}

function fw_restore {
  /sbin/iptables-restore /etc/iptables/rules.v4
  /sbin/ip6tables-restore /etc/iptables/rules.v6
  echo "     > Firewall restored"
}


# #######################################################################
# ## Main

case "$1" in
  start)
  fw_start
  ;;
  stop)
  fw_stop
  ;;
  restart)
  fw_restart
  ;;
  save)
  fw_save
  ;;
  restore)
  fw_restore
  ;;
  *)
  fw_help
  exit 1
  ;;
esac

exit 0
