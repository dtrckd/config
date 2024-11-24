#!/bin/bash


show_csv() {
    local file=""
    local primary_key=""
    local secondary_key=""
    local delimiter=","
    local delimiter_option=""

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -k)
                if [[ -z "$primary_key" ]]; then
                    primary_key=$2
                else
                    secondary_key=$2
                fi
                shift 2
                ;;
            -d)
                delimiter=$2
                shift 2
                ;;
            -*)
                echo "Unknown option: $1" >&2
                return 1
                ;;
            *)
                file=$1
                shift
                ;;
        esac
    done

    if [[ -z "$primary_key" ]]; then
        primary_key=1
    fi

    if [[ -z "$file" || -z "$primary_key" ]]; then
        echo "Usage: show_csv <file> -k <primary_key> [-k <secondary_key>] [-d <delimiter>]" >&2
        return 1
    fi

    delimiter_option="-t$delimiter"
    sort_command="sort $delimiter_option -k${primary_key},${primary_key}"

    if [[ -n "$secondary_key" ]]; then
        sort_command+=" -k${secondary_key},${secondary_key}"
    fi

    cat "$file" | eval "$sort_command" | column -t -s"$delimiter"
}

show_csv "$@"
