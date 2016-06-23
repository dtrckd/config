# Setup fzf
# ---------
if [[ ! "$PATH" == */home/joker/src/fzf/bin* ]]; then
export PATH="$PATH:/home/joker/src/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */home/joker/src/fzf/man* && -d "/home/joker/src/fzf/man" ]]; then
export MANPATH="$MANPATH:/home/joker/src/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/joker/src/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/joker/src/fzf/shell/key-bindings.bash"

# fd - cd to selected directory
fd() {
    local dir
    dir=$(find ${1:-*} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
}

# gg - vi to a grep match
gg() {
    local file
    file=$(grep --line-buffered --color=never -r "" * | fzf -e +i +m) &&
        vim "$(echo $file | cut -d: -f1)"
}

# fzg - ag to a code match
alias fag='ag --nobreak --nonumbers --noheading . | fzf -e +i'

