#!/bin/bash
set -e

# Main
COMMAND="diff"
LINE="1"
DEEPNESS="-maxdepth 1"
export ORIGIN="$HOME"
export TARGET="dotfiles"

# Usage / Help
USAGE="$(cat <<EOF
Usage: $(basename "$0") [options]

Diff and backup operation of dotfiles.
With no options, just show the file in dotfiles/ that has been modifiate in HOME.

Options:
  -h, --help        Show this help
  -v, --verbose     Show all file, not just a depth 1
  -e LINE           Vimdiff the two file (at line N)
  -c, --sync        copy all file that are different into dotfiles
  --etc             Compare etc/ folder insteado of dotfile

EOF
)"
Help () {
    echo "$USAGE"
    exit 0
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            Help
            exit 0 ;;
        -v|--verbose)
            DEEPNESS=""
            shift ;;
        -c|--sync)
            COMMAND="copy"
            shift ;;
        -e|--edit)
            COMMAND="edit"
            if [[ -n "$2" ]] && [[ "$2" != -* ]]; then
                LINE="$2"
                shift 2
            else
                shift
            fi
            ;;
        --etc)
            ORIGIN="/etc"
            TARGET="etc"
            shift ;;
        *)
            echo "Invalid option: $1" >&2
            Help
            exit 1 ;;
    esac
done


if [ "$COMMAND" == "diff" ]; then
    # Show files that differs (first depth)
    find $TARGET $DEEPNESS -type f -print0 \
        | xargs -0 -I{} sh -c 'diff -q "${ORIGIN}/${1#$TARGET/}" "$1"' -- {}
elif [ "$COMMAND" == "edit" ]; then
    # Edit files that differs (first depth)
    files=$(find $TARGET $DEEPNESS -type f -print0 \
        | xargs -0 -I{} sh -c 'diff -q "${ORIGIN}/${1#$TARGET/}" "$1"' -- {} \
        | grep -v "^diff:" \
        | cut -d" " -f2,4)

    if [ ! -z "$files" ]; then
        # Puer vim
        #vimdiff $(echo "$files" | sed -n "${LINE}p")
        # Neovim
        vim -d $(echo "$files" | sed -n "${LINE}p")
    fi
elif [ "$COMMAND" == "copy" ]; then
    # Copy files that differs (first depth), into TAREGT (backup)
    files=$(find $TARGET $DEEPNESS -type f -print0 \
        | xargs -0 -I{} sh -c 'diff -q "${ORIGIN}/${1#$TARGET/}" "$1"' -- {} \
        | grep -v "^diff:" \
        | cut -d" " -f2,4)

    if [ ! -z "$files" ]; then
        # @IMPROVE: manage space in files !?
        echo "$files" | while IFS= read -r line; do
            cp -v $line
        done
    fi
else
    echo "$USAGE"
fi
