#!/bin/bash

# First argument is the interface that triggered the event
interface=$1
# Second argument is the action (up/down)
action=$2

# List of WG_IPV4_INTERFACES that should trigger IPv6 disable/enable
WG_IPV4_INTERFACES="pvpn-NL-138"

# Check if any of the listed interfaces are up (excluding the current one if it's going down)
any_wg_interface_up() {
    for wg_interface in $WG_IPV4_INTERFACES; do
        # Skip the current interface if it's going down
        if [ "$wg_interface" = "$interface" ] && [ "$action" = "down" ]; then
            continue
        fi

        if [ -e "/sys/class/net/$wg_interface/operstate" ]; then
            wg_state=$(cat "/sys/class/net/$wg_interface/operstate")
            if [ "$wg_state" = "up" ] || [ "$wg_state" = "unknown" ]; then
                return 0  # True, at least one interface is up
            fi
        fi
    done
    return 1  # False, no interface is up
}

# Check if the current interface is in our list of WG interfaces
is_wg_interface() {
    for wg_interface in $WG_IPV4_INTERFACES; do
        if [ "$interface" = "$wg_interface" ]; then
            return 0  # True
        fi
    done
    return 1  # False
}

# Disable IPv6
disable_ipv6() {
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
    sysctl -w net.ipv6.conf.lo.disable_ipv6=1
}

# Enable IPv6
enable_ipv6() {
    sysctl -w net.ipv6.conf.all.disable_ipv6=0
    sysctl -w net.ipv6.conf.default.disable_ipv6=0
    sysctl -w net.ipv6.conf.lo.disable_ipv6=0
}

# Main logic
if is_wg_interface; then
    case "$action" in
        up)
            # Disable IPv6 when a WG interface comes up
            disable_ipv6
        ;;
        down)
            # Only enable IPv6 if no other WG interfaces are up
            if ! any_wg_interface_up; then
                enable_ipv6
            fi
        ;;
    esac
elif any_wg_interface_up; then
    # If any WG interface is up, disable IPv6 on other interfaces that come up
    if [ "$action" = "up" ]; then
        sysctl -w net.ipv6.conf."$interface".disable_ipv6=1
    fi
fi
