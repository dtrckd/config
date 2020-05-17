#!/bin/bash

Verbose="$1"
Help='-v verbose \n
-e edit with vimdiff \n
* help...'

if [ "$Verbose" == "-v" ]; then
    # Show all files that differs (all depth)
    for _f in $(find dotfiles/ -type f); do
        diff -q ${HOME}${_f#dotfiles} $_f
    done
elif [ "$Verbose" == "-e" ]; then
    # Edit files that differs (first depth)
    files=$(find dotfiles/ -maxdepth 1 -type f -exec \
        sh -c 'diff -q {} ${HOME}/$(basename {})' \; | sed 's/ /\n/g' |  grep  '\.')
    if [ ! -z "$files" ]; then

        if [ ! -z "$2" ]; then
            vimdiff $(echo $files | cut -d' ' -f$2,$(($2+1)) )
        else
            vimdiff $files
        fi
    fi
elif [ -z $Verbose ]; then
    # Show files that differs (first depth)
    find dotfiles/ -maxdepth 1 -type f -exec \
        sh -c 'diff -q ${HOME}/$(basename {}) {}' \;
else
    echo "$Help"
fi

