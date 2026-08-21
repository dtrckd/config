#!/usr/bin/env bash
# Markdown (file, stdin, or clipboard) -> rich text on the clipboard, ready to
# paste into Thunderbird or any HTML-aware editor. Fully offline.
set -euo pipefail

usage() {
    cat <<'EOF'
usage: md2clip [FILE...]
       md2clip -c | --clipboard    convert the markdown already on the clipboard
       cat notes.md | md2clip

Converts markdown to HTML (pandoc) and puts it on the clipboard with the
text/html target (xclip), so pasting keeps bold, headers, lists and tables.
EOF
}

case "${1-}" in
    -h | --help)
        usage
        exit 0
        ;;
    -c | --clipboard) src=(xclip -o -selection clipboard) ;;
    *) src=(cat "$@") ;;
esac

"${src[@]}" | pandoc -f markdown -t html | xclip -selection clipboard -t text/html
