#!/bin/bash

RSYNC_ARGS="--stats --progress"

if [ "$1" == '-s' ];then
    RSYNC_ARGS="${RSYNC_ARGS} --dry-run"
fi

echo "Instable...exiting"
exit

# Backup app config (.
CONF_APP=$(cat app-config-dirs.txt)
cp -v  $HOME/.gtkrc-2.0  ../dotfiles/
for f in $CONF_APP; do
    cp -rv $(eval echo $f) ../dotfiles/.config/
done

# Thnderbird
THUNDER_ID="l7nymwge"
#find $HOME/.thunderbird/$THUNDER_ID.default/ -name "*.dat" -o -name "*.json" | sed "s~$HOME/~~g" | xargs -I{} rsync -R {} ../app/
#find $HOME/.thunderbird/$THUNDER_ID.default/ -name "*.dat" -o -name "*.json" |xargs -I{} rsync $RSYNC_ARGS -R {} ../app/

# Fireforx bookmakrs (@Debug)
sqlite3 ~/.mozilla/firefox/4z2axixj.default/places.sqlite ".backup /home/dtrckd/Desktop/tt/g/bak"

echo "Please, manually backup your etc files !"
