#!/bin/bash

mkdir -p app/

### BACKUP __THUNDERBIRD/ICEDOVE__
#find $HOME/.icedove/dqhcjyse.default/ -name "*.dat" | sed "s~$HOME/~~g" | xargs -I{} rsync -R {} app/
#find $HOME/.icedove/dqhcjyse.default/ -name "*.json" | sed "s~$HOME/~~g" | xargs -I{} rsync -R {} app/
find $HOME/.icedove/dqhcjyse.default/ -name "*.dat" |xargs -I{} rsync -R {} app/
find $HOME/.icedove/dqhcjyse.default/ -name "*.json" |xargs -I{} rsync -R {} app/
