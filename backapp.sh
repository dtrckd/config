#!/bin/bash

RSYNC_ARGS="--stats --progress"
mkdir -p app/

if [ "$1" == '-s' ];then
    RSYNC_ARGS="${RSYNC_ARGS} --dry-run"
fi

### Create bin.txt
ll $HOME/bin | grep '>' |cut -d'>' -f2 > configure/bin.txt

### BACKUP __THUNDERBIRD/ICEDOVE__
ICEDOVE_ID="uamyifs0"
#find $HOME/.icedove/$ICEDOVE_ID.default/ -name "*.dat" -o -name "*.json" | sed "s~$HOME/~~g" | xargs -I{} rsync -R {} app/
find $HOME/.icedove/$ICEDOVE_ID.default/ -name "*.dat" -o -name "*.json" |xargs -I{} rsync $RSYNC_ARGS -R {} app/

