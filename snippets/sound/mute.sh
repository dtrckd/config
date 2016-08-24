#!/bin/bash

Sinks=$(pactl list sinks short | grep -o  ^[0-9])
for s in $Sinks; do
    pactl set-sink-mute $s true
done
