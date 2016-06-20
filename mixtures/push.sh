#!/bin/bash

echo "md2web..."/md2web.sh
./md2web.py

echo "Copying files..."
cp -vr  * /media/Synology/home/www/mixtures/


