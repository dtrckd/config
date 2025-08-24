#!/bin/bash

# NOTE: see acpi_listen to see the acpi events live !

# Get the currently logged-in user dynamically
CURRENT_USER=$(who | grep -E "tty[0-9]|:0" | head -1 | awk '{print $1}')

# Set display environment
export DISPLAY=:0
export XAUTHORITY=/home/$CURRENT_USER/.Xauthority

# Check if lid is closed
if grep -q "closed" /proc/acpi/button/lid/*/state; then
    su -c "xset dpms force off" $CURRENT_USER
else
    su -c "xset dpms force on" $CURRENT_USER
fi
