#! /bin/bash

# ######################### Firewall (fw) ########################
#
# This is a basic /sbin/ip6tables firewall script.
#
# Usage:
# ./fw6 {start|stop|restart}
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
  /sbin/ip6tables -t filter -P INPUT DROP
  #/sbin/ip6tables -t filter -P FORWARD DROP
  /sbin/ip6tables -t filter -P OUTPUT DROP

  # Don't break established connections
  /sbin/ip6tables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  /sbin/ip6tables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

  # Authorize loopback (127.0.0.1)
  /sbin/ip6tables -t filter -A INPUT -i lo -j ACCEPT
  /sbin/ip6tables -t filter -A OUTPUT -o lo -j ACCEPT

  # ICMP (ping)
  /sbin/ip6tables -t filter -A INPUT -p icmp -j ACCEPT
  /sbin/ip6tables -t filter -A OUTPUT -p icmp -j ACCEPT
  /sbin/ip6tables -t filter -A INPUT -p icmpv6 -j ACCEPT
  /sbin/ip6tables -t filter -A OUTPUT -p icmpv6 -j ACCEPT

  # SSH in/out
  /sbin/ip6tables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
  /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
  # special ssh ports
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 29418 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 29418 -j ACCEPT

  # DNS in/out
  /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 53 -j ACCEPT
  /sbin/ip6tables -t filter -A INPUT -p tcp --dport 53 -j ACCEPT
  /sbin/ip6tables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
  /sbin/ip6tables -t filter -A INPUT -p udp --dport 53 -j ACCEPT

  # DHCP
  /sbin/ip6tables -t filter -A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT
  /sbin/ip6tables -t filter -A INPUT  -p udp --dport 67:68 --sport 67:68 -j ACCEPT

  # NTP Out
  /sbin/ip6tables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT

  # HTTP + HTTPS Out
  /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
  /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 443 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 8080 -j ACCEPT

  # HTTP + HTTPS In
  /sbin/ip6tables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
  /sbin/ip6tables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 8080 -j ACCEPT

  # FTP Out
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 20 -j ACCEPT

  # FTP In
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
  #/sbin/ip6tables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Mail SMTP
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 587 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 587 -j ACCEPT
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 465 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 465 -j ACCEPT

  # Mail IMAP:143
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT

  # Mail POP3:110
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT

  # Mail POP3S:995
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 995 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 995 -j ACCEPT

  # Node exporter
  #/sbin/ip6tables -t filter -A INPUT -p tcp --dport 9100 -j ACCEPT
  #/sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 9100 -j ACCEPT

  # OpenVZ Web Pannel
  # /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 3000 -j ACCEPT
  # /sbin/ip6tables -t filter -A INPUT -p tcp --dport 3000 -j ACCEPT

  # Allow WMs
  # /sbin/ip6tables -P FORWARD ACCEPT
  # /sbin/ip6tables -F FORWARD

  # Saltstack
  # /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 4505 -j ACCEPT
  # /sbin/ip6tables -t filter -A INPUT -p tcp --dport 4505 -j ACCEPT
  # /sbin/ip6tables -t filter -A OUTPUT -p tcp --dport 4506 -j ACCEPT
  # /sbin/ip6tables -t filter -A INPUT -p tcp --dport 4506 -j ACCEPT

  # Block UDP attack
  # /sbin/ip6tables -A INPUT -m state --state INVALID -j DROP

}


# #######################################################################
# ## Other functions

function fw_help {
  echo "Firewall usage: ./fw {start|stop|restart}"
  exit 1
}

function fw_reset {
  /sbin/ip6tables -F
  /sbin/ip6tables -X
  /sbin/ip6tables -t nat -F
  /sbin/ip6tables -t nat -X
  /sbin/ip6tables -t mangle -F
  /sbin/ip6tables -t mangle -X
  /sbin/ip6tables -P INPUT ACCEPT
  /sbin/ip6tables -P FORWARD ACCEPT
  /sbin/ip6tables -P OUTPUT ACCEPT
  /sbin/ip6tables -t filter -F
  /sbin/ip6tables -t filter -X
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
  *)
  fw_help
  exit 1
  ;;
esac

exit 0
