#!/bin/bash

# A bit too agresive..
# --
# wget -r -k -np -p -nc --wait=0.1
#wget --recursive \
#         --convert-links \
#         --no-parent \
#         --page-requisites \
#         --no-clobber \
#         --wait=0.1 \
#         $1
#
# See -m /mirror?

# Download all pdf a page
#wget -r -A "*.pdf" "http://blabla.."


USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Safari/605.1.15"
    "Mozilla/5.0 (X11; Linux x86_64) Firefox/121.0"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
)

RANDOM_UA=${USER_AGENTS[$RANDOM % ${#USER_AGENTS[@]}]}
RANDOM_WAIT=$(awk 'BEGIN{srand(); print 0.5+rand()*1.0}')

wget --recursive \
     --convert-links \
     --no-parent \
     --page-requisites \
     --no-clobber \
     --random-wait \
     --wait=$RANDOM_WAIT \
     --limit-rate=500k \
     --user-agent="$RANDOM_UA" \
     --referer="https://www.google.com/" \
     --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
     --header="Accept-Language: en-US,en;q=0.9" \
     --tries=3 \
     --timeout=15 \
     --level=10 \
     $1
