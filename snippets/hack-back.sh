#!/bin/bash

DDD='home/dtrckd'

# Opera
OperaBack="opera6.adr operaprefs.ini bookmarks.adr notes.adr search.ini speeddial.ini wand.dat\
    keyboard menu styles toolbar skin sessions"

for f in $FBACK; do
    cp -rv "$f" ${DDD}/.opera/
done

# Icedove
IcedoveBack="Cache ImapMail Mail OfflineCache content-perfs.sqlite directoryTree.json folderTree.json prefs.js"

for f in $IcedoveBack; do
    cp -rv "$f" ${DDD}/.icedove/
done

# Mc
McBack="ini bindings menu"

for f in $McBack; do
    cp -rv "$f" ${DDD}/.config/.mc/
done

