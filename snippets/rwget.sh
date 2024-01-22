#!/bin/bash

# wget -r -k -np -p -nc --wait=0.1
wget --recursive \
         --convert-links \
         --no-parent \
         --page-requisites \
         --no-clobber \
         --wait=0.1 \
         $1

# See -m /mirror?

# Download all pdf a page
#wget -r -A "*.pdf" "http://blabla.."

