#!/usr/bin/env bash
# Markdown (file, stdin, or clipboard) -> rich text on the clipboard, ready to
# paste into Thunderbird or any HTML-aware editor, or -> an HTML/PDF file. Fully offline.
set -euo pipefail

usage() {
    cat <<'EOF'
usage: md2clip [-c] [-o FILE] [FILE...]
       cat notes.md | md2clip

  -c, --clipboard    read the markdown from the clipboard instead of FILE/stdin
  -o, --output FILE  write FILE instead of the clipboard; the extension picks
                     the format: .html (standalone page) or .pdf (needs weasyprint)

Default: markdown -> HTML (pandoc), copied to the clipboard as rich text
(text/html, xclip). Paste it with Ctrl+V into a rich-text editor (Thunderbird,
LibreOffice, webmail): bold, headings, lists and tables are kept.
Plain-text targets (terminal, text editor, Clipman) see an empty clipboard.
EOF
}

from_clipboard=false
out=
files=()
while (($#)); do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -c | --clipboard) from_clipboard=true ;;
        -o | --output)
            if (($# < 2)); then
                echo "md2clip: $1 needs a file name" >&2
                exit 2
            fi
            out=$2
            shift
            ;;
        -?*)
            echo "md2clip: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
        *) files+=("$1") ;;
    esac
    shift
done

if $from_clipboard && ((${#files[@]})); then
    echo "md2clip: -c reads the clipboard, it cannot be combined with FILE" >&2
    exit 2
fi
if [[ $out == *.pdf ]] && ! command -v weasyprint >/dev/null; then
    echo "md2clip: PDF output needs weasyprint: pip install weasyprint (or: sudo apt install weasyprint)" >&2
    exit 1
fi

# Read first: a failed or empty read must not overwrite the clipboard or the output file
if $from_clipboard; then
    md=$(xclip -o -selection clipboard)
else
    md=$(cat "${files[@]}")
fi
if [[ -z $md ]]; then
    echo "md2clip: nothing to convert, the input is empty" >&2
    exit 1
fi

if [[ -z $out ]]; then
    pandoc -f gfm -t html <<<"$md" | xclip -selection clipboard -t text/html
    cat >&2 <<'EOF'
md2clip: rich text (HTML) copied to the clipboard.
  Paste with Ctrl+V into a rich-text editor (Thunderbird, LibreOffice, webmail).
  Terminals, text editors and Clipman will show it as empty.
  Want a file instead? Use -o FILE.html or -o FILE.pdf.
EOF
    exit 0
fi

# Print CSS: pandoc's screen layout (36em column, block tables) clips wide tables on paper
pandoc -f gfm -s --metadata pagetitle="$(basename "${out%.*}")" \
    --pdf-engine=weasyprint --pdf-engine-opt=--quiet \
    -V 'header-includes=<style>@media print{@page{margin:1.5cm}html{font-size:10pt}body{max-width:none;padding:0}table{display:table}}</style>' \
    -o "$out" <<<"$md"
echo "md2clip: wrote $out" >&2
