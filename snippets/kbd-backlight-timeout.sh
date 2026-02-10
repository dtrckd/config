#!/bin/bash

TIMEOUT_MS=20000
KBD_LED="/sys/class/leds/platform::kbd_backlight"

[ ! -d "$KBD_LED" ] && exit 1

MAX_BRIGHTNESS=1
IS_ON=1

get_active_user() {
    # Try multiple methods to find the active graphical user
    local user=""

    # Method 1: loginctl (most reliable for systemd systems)
    user=$(loginctl list-sessions --no-legend | grep "seat0" | grep -v "lightdm" | head -1 | awk '{print $3}')

    # Method 2: fallback to 'who'
    if [ -z "$user" ]; then
        user=$(who | grep ":0" | grep -v "^lightdm" | head -1 | awk '{print $1}')
    fi

    echo "$user"
}

while true; do
    CURRENT_USER=$(get_active_user)

    # If no user is logged in, turn off backlight and skip
    if [ -z "$CURRENT_USER" ]; then
        if [ $IS_ON -eq 1 ]; then
            echo 0 > "$KBD_LED/brightness"
            IS_ON=0
        fi
        sleep 2
        continue
    fi

    IDLE_MS=$(sudo -u "$CURRENT_USER" env DISPLAY=:0 XAUTHORITY=/home/"$CURRENT_USER"/.Xauthority xprintidle 2>/dev/null || echo 0)

    if [[ $IS_ON -eq 1 && $IDLE_MS -gt $TIMEOUT_MS ]]; then
        echo 0 > "$KBD_LED/brightness"
        IS_ON=0
    elif [[ $IS_ON -eq 0 && $IDLE_MS -lt $TIMEOUT_MS ]]; then
        echo "$MAX_BRIGHTNESS" > "$KBD_LED/brightness"
        IS_ON=1
    fi

    sleep 2
done
