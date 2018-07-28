#!/bin/bash

Verbose="$1"
Help='-v verbose \n
-e edit with vimdiff \n
* help...'

if [ "$Verbose" == "-v" ]; then
    # Show all files that differs (all depth)
    for _f in $(find etc/ -type f); do
        diff -q $_f /etc/${_f#etc}
    done
elif [ "$Verbose" == "-e" ]; then
    # Edit files that differs (first depth)
    files=$(find etc/ -maxdepth 3 -type f -exec \
        sh -c 'diff -q {} /{}' \; | sed 's/ /\n/g' |  grep  '\.')
    if [ ! -z "$files" ]; then

        if [ ! -z "$2" ]; then
            vimdiff $(echo $files | cut -d' ' -f$2,$(($2+1)) )
        else
            vimdiff $files
        fi
    fi
elif [ -z $Verbose ]; then
    # Show files that differs (first depth)
    find etc/ -maxdepth 3 -type f -exec \
        sh -c 'diff -q {} /{}' \;
else
    echo "$Help"
fi

