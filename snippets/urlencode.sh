#!/bin/bash

url="$1"
urlquote="$2"

if [ "$url" == "-x" ]; then
      echo "$urlquote" | python3 -c 'import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))'
else
      echo "$url" | python3 -c 'import sys,urllib.parse;sys.stdout.write(urllib.parse.quote_plus(sys.stdin.read()))'
      echo
fi

