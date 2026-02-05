#!/bin/bash

TIMEOUT_MS=20000
CURRENT_USER=$(who | grep -E "tty[0-9]|:0" | head -1 | awk '{print $1}')
KBD_LED="/sys/class/leds/platform::kbd_backlight"

[ ! -d "$KBD_LED" ] && exit 1

#MAX_BRIGHTNESS=$(cat "$KBD_LED/max_brightness")
MAX_BRIGHTNESS=1
IS_ON=1

while true; do
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
