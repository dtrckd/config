#!/bin/bash

Verbose="$1"
Help='-v verbose \n
-e edit with vimdiff \n
* help...'

if [ "$Verbose" == "-v" ]; then
    # Show all files that differs (all depth)
    for _f in $(find dotfiles/ -type f); do
        diff -q $_f ${HOME}${_f#dotfiles}
    done
elif [ "$Verbose" == "-e" ]; then
    # Edit files that differs (first depth)
    files=$(find dotfiles/ -maxdepth 1 -type f -exec \
        sh -c 'diff -q {} ${HOME}/$(basename {})' \; | sed 's/ /\n/g' |  grep  '\.')
    if [ ! -z "$files" ]; then
        vimdiff $files
    fi
elif [ -z $Verbose ]; then
    # Show files that differs (first depth)
    find dotfiles/ -maxdepth 1 -type f -exec \
        sh -c 'diff -q {} ${HOME}/$(basename {})' \;
else
    echo "$Help"
fi

