#!/bin/bash

# Get the list of window IDs, filtering sticky windows
window_ids=$(wmctrl -l | awk '$2!="-1"' | awk '{print $1}')

# Loop through each window ID and unmaximze then maximize it
for id in $window_ids; do
   wmctrl -i -r $id -b remove,maximized_vert,maximized_horz
   wmctrl -i -r $id -b add,maximized_vert,maximized_horz
done
