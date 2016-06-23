# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dulac/src/fzf/bin* ]]; then
  export PATH="$PATH:/home/dulac/src/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */home/dulac/src/fzf/man* && -d "/home/dulac/src/fzf/man" ]]; then
  export MANPATH="$MANPATH:/home/dulac/src/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/dulac/src/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/dulac/src/fzf/shell/key-bindings.bash"

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

# utility function used to write the command in the shell
writecmd() {
    perl -e '$TIOCSTI = 0x5412; $l = <STDIN>; $lc = $ARGV[0] eq "-run" ? "\n" : ""; $l =~ s/\s*$/$lc/; map { ioctl STDOUT, $TIOCSTI, $_; } split "", $l;' -- $1
}

# fhe - repeat history edit
fh() {
    ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9:/ ]+\s*//' | writecmd
}


# fzg - ag to a code match
alias fag='ag --nobreak --nonumbers --noheading . | fzf -e +i'

