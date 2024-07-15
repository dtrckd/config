#!/bin/bash

# Parse command-line options
USAGE="$(cat <<EOF
Usage: $(basename "$0") [options]

Reset allowed direnv folder

Options:
  -h, --help            Show this help
  -s, --simulate        Dry-run

EOF
)"
Help () {
    echo "$USAGE"
    exit 0
}

DRYRUN=0
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            Help
            exit 0 ;;
        -s|--simulate)
            DRYRUN=1
            shift ;;
        *)
            echo "Invalid option: $1" >&2
            Help
            exit 1 ;;
    esac
done


# Main
for f in $(find -type f -name .envrc); do
    if [ $DRYRUN == 1 ]; then
        echo $(dirname $f)
        continue
    fi

    echo "going to " $(dirname $f)
    cd $(dirname $f)
    rm -rf .direnv
    export PYTHONPATH=
    eval $(direnv export bash)
    #eval $(direnv reload)
    direnv status | grep "allowed true" -q
    if [ $? -ne 0 ]; then
        continue
    fi
    pip install -U . || pip install -U -r requirements.txt
    cd ~/main/missions/
done
