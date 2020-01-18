# Automatif fundle install
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

fundle plugin 'edc/bass'
fundle plugin 'danhper/fish-fastdir'

fundle init

set -x EDITOR "vim"
set -x VISUAL "vim"
set -x TERM xterm-256color

# colors
set fish_color_command 005fd7 --bold
set fish_color_cancel -o

# Delete welcome message
set -e fish_greeting

. ~/.config/fish/aliases.fish
if test -e ~/.bash_aliases
    . ~/.bash_aliases
end

#stty -ixon # disable <C-s> freeze in vim (who waits a <C-q> signal !)
#setxkbmap -option "nbsp:none" # disable non-breaking space, accidently genrated when typing <ALTGR>+<SPACE>
##stty werase undef
##bind '\C-w:unix-filename-rubout'
#
#export HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "
#export EDITOR="/usr/bin/vim"
#export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/lib:/usr/lib32"
#export LD_RUN_PATH="/usr/local/lib:/usr/lib:/usr/lib32"
#export PATH="/usr/local/bin:$HOME/.local/bin:$HOME/bin:/bin:/sbin:/usr/sbin:/opt/bin:/usr/bin"
#
#set cppversion (g++ -dM -E -x c++  /dev/null | grep -F __cplusplus)
#set pythonversion (python --version 2>&1| cut -d ' ' -f 2 | grep -oE '[0-9]\.[0-9]')
#
## Python
#export PYTHONPATH "$PX/BaseDump/bots/skopai/common/"
#export PYTHONPATH "$PYTHONPATH:$PX/networkofgraphs/process/pymake"
#
## Numpy
#export OMP_NUM_THREADS=1  # Number of thread used by numpy
#
## GOLANG
#export GOPATH=$HOME/.go
#export PATH="$GOPATH/bin:/usr/local/go/bin:$PATH:"
#
## SNAP
#export PATH="/snap/bin:$PATH"

thefuck --alias | source
