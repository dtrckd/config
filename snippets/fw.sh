#! /bin/bash

# ######################### qFirewall (qfw) 0.1 ########################
#
# This is a basic /sbin/iptables firewall script.
#
# Usage:
# ./fw {restart|stop|save|restore}
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

function qfw_rules {
  # Block everything
  /sbin/iptables -t filter -P INPUT DROP
  #/sbin/iptables -t filter -P FORWARD DROP
  /sbin/iptables -t filter -P OUTPUT DROP
  echo "     > Block everything"

  # Don't break established connections
  /sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  /sbin/iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  echo "     > Don't break established connections"

  # Authorize loopback (127.0.0.1)
  /sbin/iptables -t filter -A INPUT -i lo -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -o lo -j ACCEPT
  echo "     > Authorize Loopback"

  # ICMP (ping)
  /sbin/iptables -t filter -A INPUT -p icmp -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p icmp -j ACCEPT
  echo "     > Authorize ICMP (ping)"

  # SSH in/out
  /sbin/iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p tcp --dport 9000 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 9000 -j ACCEPT
  # special ssh ports
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 29418 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 29418 -j ACCEPT
  echo "     > Authorize SSH"

  # DNS in/out
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
  echo "     > Authorize DNS"

  # DHCP
  /sbin/iptables -t filter -A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
  /sbin/iptables -t filter -A INPUT  -p udp --dport 67:68 --sport 67:68 -j ACCEPT
  echo "     > Authorize DHCP"

  # NTP Out
  /sbin/iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
  echo "     > Authorize NTP outbound"

  # HTTP + HTTPS Out
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
  /sbin/iptables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 8080 -j ACCEPT

  # HTTP + HTTPS In
  /sbin/iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
  /sbin/iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 8080 -j ACCEPT
  echo "     > Authorize http and https"

  ## FTP Out
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT

  ## FTP In
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  #echo "     > Authorize FTP"

  # Mail SMTP
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 587 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 587 -j ACCEPT
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 465 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 465 -j ACCEPT

  ## Mail POP3:110
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

  ## Mail IMAP:143
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

  ## Mail POP3S:995
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT
  #echo "     > Authorize mail"

  # Node exporter
  #/sbin/iptables -t filter -A INPUT -p tcp --dport 9100 -j ACCEPT
  #/sbin/iptables -t filter -A OUTPUT -p tcp --dport 9100 -j ACCEPT
  #echo "     > Authorize Node exporter"

  # OpenVZ Web Pannel
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 3000 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 3000 -j ACCEPT
  # echo "     > Authorize OpenVZ panel"

  # Allow WMs
  # /sbin/iptables -P FORWARD ACCEPT
  # /sbin/iptables -F FORWARD
  # echo "WMs ok"
  # echo "     > Authorize WMs"

  # Saltstack
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 4505 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 4505 -j ACCEPT
  # /sbin/iptables -t filter -A OUTPUT -p tcp --dport 4506 -j ACCEPT
  # /sbin/iptables -t filter -A INPUT -p tcp --dport 4506 -j ACCEPT
  # echo "     > Authorize Saltstack"

  # Block UDP attack
  # /sbin/iptables -A INPUT -m state --state INVALID -j DROP
  # echo "     > Block UDP attack"

}


# #######################################################################
# ## Other functions

function qfw_help {
  echo "qFirewall usage: ./fw {restart|stop|save|restore}"
  exit 1
}

function qfw_seeya {
  echo "     > Thanks for using qFirewall (fw) v2. Have a good day."
  echo ""
}


function qfw_reset {
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

function qfw_restart {
  echo "     > Starting qFirewall..."
  qfw_clean
  echo "     > Loading the rules..."
  qfw_rules
  echo "     > Rules loaded"
  echo "     > qFirewall started"
}

function qfw_clean {
  echo "     > Cleaning rules..."
  qfw_reset
  echo "     > Rules cleaned"
}

function qfw_stop {
  echo "     > Stopping qFirewall..."
  qfw_clean
  echo "     > qFirewall stopped"
}

function qfw_save {
  echo "     > Saving qFirewall..."
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
  mkdir -p /etc/iptables
  /sbin/iptables-save > /etc/iptables/rules.v4
  /sbin/ip6tables-save > /etc/iptables/rules.v6
  echo "     > qFirewall saving"
}

function qfw_restore {
  /sbin/iptables-restore /etc/iptables/rules.v4
  /sbin/ip6tables-restore /etc/iptables/rules.v6
  echo "     > qFirewall restored"
}


# #######################################################################
# ## Main

case "$1" in
  restart)
  qfw_restart
  ;;
  stop)
  qfw_stop
  ;;
  save)
  qfw_save
  ;;
  restore)
  qfw_restore
  ;;
  *)
  qfw_help
  exit 1
  ;;
esac

qfw_seeya
exit 0
