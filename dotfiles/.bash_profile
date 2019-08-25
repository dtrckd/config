############################
### Shell Configuration, fancy
###########################

### How to setup
# end of .bashrc
#if [ -f ~/.bash_profile ]; then
#    . ~/.bash_profile
#fi


function _PWD  {
    if [ "$(pwd)" == $HOME ]; then
        echo "~/"
    else
        pwd | awk -F\/ '{print $(NF-1)"\057"$(NF)}'
    fi
}

### Prompt

# Root
#PROMPTL='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(_PWD)\[\033[00m\]\$ '

# Remote
#PROMPTL='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;33m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;33m\]@\h\[\033[00m\]:\[\033[01;34m\]$(_PWD)\[\033[00m\]\$ '

# Local
PROMPTL='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(_PWD)\[\033[00m\]\$ '
alias prompt_long="PS1='$PROMPTL'"
alias prompt_short="PS1='$PROMPTS'"
if [ -x "$PS1" ]; then
    prompt_short
    #prompt_long
fi
prompt_short
#prompt_long

#### Colors results
if [ -x /usr/bin/dircolors ]; then
    COLOR_OPT='always'
    COLOR_OPT='auto'
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=$COLOR_OPT -p --group-directories-first"
    alias dir='dir --color=$COLOR_OPT'
    alias vdir='vdir --color=$COLOR_OPT'
    alias grep='grep --color=$COLOR_OPT'
    alias fgrep='fgrep --color=$COLOR_OPT'
    alias egrep='egrep --color=$COLOR_OPT'
    alias watch='watch --color'
fi

alias less='less -S -R'

alias l='ls'
alias lq='ls'
alias sls='ls'
alias sl='ls'
alias ll='ls -l'
alias la='ls -A'
alias lr='ls -R'
alias lmd='ls *.md'
alias mkdit='mkdir'

### Utility commands
alias please='sudo $(fc -ln -1)'
alias so='source ~/.bashrc'
alias whoisssd='lsblk  -d -o name,rota'
alias python="python -O" # basic optimizatio (ignore assert, ..)
#alias ipython="python -m IPython"
alias ipython="ipython --colors linux"
alias py='python'
alias py3='python3'
alias pynotebook="jupyter-notebook --ip 127.0.0.1"
alias ppath_python='export PYTHONPATH=$PYTHONPATH:$(pwd)'
alias xback='xbacklight'
alias bb="[ -f tmux.sh ] && ./tmux.sh || tmux ls 1>/dev/null 2>/dev/null && tmux attach || byobu"
alias cc="cat"
alias vdiff='vimdiff'
alias evc="evince"
alias tu="htop -u $USER"
alias t="htop"
alias diffd="diff -rq $1 $2" # show difference files between dir$1 and dir$2
alias mvspace="rename 's/ /_/g'"
function pdf(){ evince $1 2>/dev/null & }
function pdfo(){ okular $1 2>/dev/null & }

function make_doc_python(){
    if [ -z "$1" ]; then echo "give a repo to analyse"; return 2; fi
    REPO="$1"
    FN="_doc-$1"
    if [ -d "$FN" ]; then echo "file \`$FN\' already exists"; return 2; fi
    pdoc -f --html --output-dir "$FN" "$REPO"
}

function make_graph_python(){
    # install pylint
    if [ -z "$1" ]; then echo "give a repo to analyse"; return 2; fi
    REPO="$1"
    FN="_graph-$1"
    if [ -e "$FN" ]; then echo "file \`$FN\' already exists"; return 2; fi
    mkdir "$FN"
    pushd $FN
    pyreverse ../"$REPO" -A -S -p "$FN"
    for f in *.dot; do
        dot -K circo -T png  "$f" > ${f%%.dot}.png
    done
    popd
}

alias vib="vim ~/.bash_profile"
alias vimrc="vim ~/.vimrc"

_PWD="/home/ama/adulac/workInProgress/networkofgraphs/process/pymake/repo/ml/"
_NDL="$HOME/src/config/configure/nodeslist"
alias para="parallel -u --sshloginfile $_NDL --workdir $_PWD -C ' ' --eta --progress --env OMP_NUM_THREADS {}"

alias psa="ps -aux | grep -i --color"
alias pstree='pstree -h'
alias rmf='shred -zuv -n1' # find <directory> -depth -type f -exec shred -v -n 1 -z -u {} \;
alias latex2html='latex2html -split 0 -show_section_numbers -local_icons -no_navigation'
alias eog='ristretto'
ff () { find -name "*$1*"; }
alias jerr='journalctl -p err -b'
### Net
alias curlH='curl -I'
alias myip='nmap -sC -p80 -n -Pn --script=http-title www.showmemyip.com | grep -i "my IP" | cut -d: -f3 | tr -d " \n" |  xclip -selection clipboard && xclip -o -selection clipboard && echo'
alias nmapw='nmap -sT -P0 -sV -p80,443 --script=http-headers'
alias nmapRdWeb='nmap -Pn -sS -p 80 -T2 -iR 0 --open'
#alias netl='netstat -taupen'
alias netl='netstat -plant'
alias netp='netstat -plant | grep -i stab | awk -F/ "{print \$2 \$3}" | sort | uniq'
alias fetch_debian='wget https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-xfce-CD-1.iso'
# Fuzz
alias xagrep='find -type f -print0 | xargs -0  grep --color'
alias grepr='grep -R'
alias grepy='find -iname "*.py" | xargs grep --color -n'
alias grepyx='find -iname "*.pyx" | xargs grep --color -n'
alias grepxd='find -iname "*.pxd" | xargs grep --color -n'
function grepyf(){ find -iname "*.py" |xargs grep --color -m1 "$1" |cut -d: -f1; } # don work :(
alias grepall='find -type f | xargs grep --color'
# Snap Alias
alias ag="ag-mcphail.ag --color-path 32"
alias agpy='ag --py'
alias fzf='fzf-slowday.fzf'
### XFCE
#alias locks='s2ram -f -m'
#alias dodo='s2disk'
alias ctr='systemctl'
alias locks='systemctl suspend -i'
alias dodo='systemctl hibernate'
alias halt='systemctl poweroff'
alias ls-service='ctr -t service --state running'
alias ls-masked-unit='ctr --state masked' # systemctl list-unit-files | grep masked
alias ls-failed-unit='ctr --state failed' # systemctl --failed

### VIM
alias vim='vim.nox'
alias vi='vim'
alias vcal='vim -c "Calendar -view=month"' # get calendar
#alias vcal='vim -c Calendar -c on' # Matsumoto calendar
#alias vcal='vim -c "Calendar -view=year" -c tabe -c "Calendar -view=month"' # get calendar
alias ci='vim'
alias vitodo='vim -p $(find -iname todo -type f)'
### Octave
alias octave='octave --silent'
function vims() {
    SessionID="$(basename $(dirname $PWD))-$(basename $PWD)"
    if [ -f "$HOME/.vim/sessions/${SessionID}.vim" ]; then
        vim -c "OpenSession ${SessionID}"
    else
        echo "no vim session file found for ${SessionID}."
    fi
}
#function vims() {
#    file=".session.vim"
#    if [ -n "$1" ]; then
#        file=.$1${file}
#    fi
#    vim -c "source $file" -S ~/.vimrc
#}

function upgrademe() {
    aptitude update && aptitude upgrade
    brew update && brew upgrade
    pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    npm update
    vim -c "UpdatePlugin"
}
# Show hold/held package
#alias apt-mark showhold

### GIT
alias gitupdate='git remote update'
alias gitg='gitg --all 1>/dev/null &'
alias gitk='gitk &'
alias gitb='git branch -av'
alias gits='git status -sb'
alias gitr='git remote -v'
gitcpush () { git commit -am "$1" && git push; }
alias lsgit='for d in $(find -type d -name ".git" | sed "s/\.git$//" );do  echo $d; git -C "$d" status -svb; echo; done'
alias gitamend='git commit -a --amend'
alias gitcommit='git commit -am'
alias gitl="git log --format='%C(yellow)%d%Creset %Cgreen%h%Creset %Cblue%ad%Creset %C(cyan)%an%Creset  : %s  ' --graph --date=short  --all"
alias gitll="git log --format='%C(yellow)%d%Creset %Cgreen%h%Creset %Cblue%ad%Creset %C(cyan)%an%Creset  : %s  ' --graph --date=short"
alias gitlt="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitfilelog="git log --pretty=oneline -u dotfiles/.vimrc"
alias gitstash="git stash list"
alias git_excludf='git update-index --assume-unchanged'
function gitls() {
    branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ -n "$1" ]; then
        branch="$1"
    fi
    git ls-tree -r ${branch} --name-only
}
function  gitchecklasttag() {
    # Get new tags from the remote
    git fetch --tags

    # Get the latest tag name
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)

    # Checkout the latest tag
    git checkout $latestTag
}
# Output current git branch, echo $(curbr)
function curbr() {
    git rev-parse --abbrev-ref HEAD
}
# Diff between $1 past commit of $2 file. Nice.
function gitdiff() {
    git diff  HEAD~$1..HEAD -- $2
}
# Show fat file in history
function git_fatfiles() {
    git rev-list --all --objects | \
        sed -n $(git rev-list --objects --all | \
        cut -f1 -d' ' | \
        git cat-file --batch-check | \
        grep blob | \
        sort -n -k 3 | \
        tail -n40 | \
        while read hash type size; do
        echo -n "-e s/$hash/$size/p ";
        done) | \
        sort -n -k1
}

function gitsearch() {
    git log -S "$1" --source --all
}

# Git init
function gitinit_dd() {
    git init
    git config user.name "dtrckd"
    git config user.email "ddtracked@gmail.com"
    git add .gitignore
    git commit -m 'init'
}
# Git init
function gitinit_dd_config() {
    git config user.name "dtrckd"
    git config user.email "ddtracked@gmail.com"
}
# Git Permission Reset
function git_reset_permissions() {
    git diff -p \
        | command grep -E '^(diff|old mode|new mode)' \
        | sed -e 's/^old/NEW/;s/^new/old/;s/^NEW/new/' \
        | git apply
}

function ssh_init() {
    eval `ssh-agent`
    ssh-add
}

function convert_grey() {
gs \
 -sOutputFile=${1%%.pdf}_grey.pdf \
 -sDEVICE=pdfwrite \
 -sColorConversionStrategy=Gray \
 -dProcessColorModel=/DeviceGray \
 -dCompatibilityLevel=1.4 \
 -dNOPAUSE \
 -dBATCH \
 $1
}

restore_alsa() {
    while [ -z "$(pidof pulseaudio)" ]; do
        sleep 0.5
    done
    alsactl -f /var/lib/alsa/asound.state restore
}

restore_pulseaudio() {
    pulseaudio -kv && sudo alsabat force-reload && pulseaudio -Dv
}

alias sshb='autossh -D 1080 -p 24 vpn@vpn.vapwn.fr'
alias sshtmr='autossh -D 1090 vpn@163.172.45.128'
alias sshmachine='autossh green@82.251.4.205'
alias sshchocobo='autossh bomberman@51.15.89.180'

alias tmr='python3 -m tm manager'

### cd alias
alias xs='cd'
PX="${HOME}/workInProgress"
webApp="webuser"
alias iu="cd $PX"
alias iuc="cd $HOME/src/config/"
alias iucc="cd $PX/BaseDump/bots/skopai/common/"
alias ium="cd $HOME/Music/"
alias iud="cd $PX/networkofgraphs/process/pymake/repo/ml/data/"
alias iuf="cd $PX/networkofgraphs/process/pymake/repo/ml/data/reports/figs/"
alias iup="cd $PX/networkofgraphs/process/pymake/pymake/"
alias iupp="cd $PX/networkofgraphs/process/pymake/repo/ml/"
alias iudoc="cd $PX/networkofgraphs/process/pymake/repo/docsearch/"
alias iut="cd $PX/networkofgraphs/papers/personal/relational_models/"
alias iutt="cd $PX/networkofgraphs/papers/personal/relational_models/thesis/manuscript/source/"
alias iub="cd $PX/BaseBlue/"
alias iubb="cd $PX/BaseBlue/bhp/bhp"
alias iudd="cd $PX/BaseBlue/bhp/data"
alias iuww="cd $PX/BaseBlue/bhp/wiki"
alias iuds="cd $PX/BaseBlue/designspec/"
alias iutm="cd $PX/BaseBlue/tmr/tm"
alias iug="cd $PX/BaseBlue/grator/pnp"
alias iux="cd $PX/BaseDump/bots/skopai/skopy"
alias iubg="cd $PX/BaseDump/bots/skopai/bigbangsearch"
alias iuw="cd $PX/webmain/"
alias iumd="cd $PX/webmain/mixtures/md"
alias iumm="cd $HOME/src/config/app/mm/ && set +o history && unset HISTFILE"
alias iuscrapy="cd $HOME/.local/lib/python3.7/site-packages/scrapy/"
alias cdoc="cd ~/SC/Projects/hack-dir/doc"
alias cdia2="cd ~/SC/Projects/hack-dir/IA"
alias cdd="cd $PX/PlanD/"
alias cdia="cd $PX/networkofgraphs/papers"
alias cdwww="cd ~/SC/Projects/Informatique/Reseau/www"
alias cdsys="cd ~/SC/Projects/Informatique/System"
alias cdrez="cd ~/SC/Projects/Informatique/Reseau/"
alias cdid="cd ~/SC/Papiers/idh/id_ad/"
alias xrandr_setup="xrandr --output LVDS-1 --right-of VGA-1"
cdlk () { cd $(dirname $(readlink $1)); }
grepurl () { cat $1 | grep -o '[hrefHREF]=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^[hrefHREF]=["'"'"']//' -e 's/["'"'"']$//'; }
alias mean="awk '{s+=$1}END{print \"ave:\",s/NR}' RS=\" \""

#alias grepurl='xidel --extract "//a/@href"'

alias amatop='elinks http://zombie-dust.imag.fr:8000/'
#alias amatop='w3m http://zombie-dust.imag.fr:8000/'
alias grid='elinks http://localhost/grid.html'
alias jupyter_net='jupyter-notebook --ip 127.0.0.1 ~/Desktop/workInProgress/networkofgraphs/process/notebook/ '
alias gg="grid"

# PDF Cut
function pdfcut() {
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
        -dFirstPage=${1} \
        -dLastPage=${2} \
        -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
        ${3}
}

# PDF Join / Overwrite pdfjoin from texlive-extra-utils
function pdfjoin() {
    pdftk "$1" "$2" cat output "$(basename $1 .pdf)$(basename $2 .pdf).pdf"

    #join jpeg: convert -rotate 90 page1.jpg page2jpg output.pdf

    # Old
    #outname="$(basename $1 .pdf)$(basename $2 .pdf)"
    #outname="fusion_${outname}.pdf"
    #gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=${outname} ${1} ${2}
}

# Music player
#alias mute='amixer set Master mute'
#alias unmute='amixer set Master unmute'
#alias mute_toggle='amixer set Master toggle'
alias x='xmms2'
alias xinfo='xmms2 info'
alias xl='xmms2 list'
alias xls='xmms2 list | command grep --color -C 15 "\->"'
alias xrm='xmms2 remove $(xmms2 list | grep "\->"| grep -o "\[.*/" | grep -wo "[0-9]*") && xmms2 next'
alias xp='xmms2 toggle'
alias xn='xmms2 next'
alias xj='xmms2 jump'
alias xpl='xmms2 playlist list'
xplc () { xmms2 playlist create $1 && xmms2 playlist switch $1; }
alias xpll='xmms2 playlist switch'
alias xseek='xmms2 seek'
alias xs='xmms2 seek +25'
alias xss='xmms2 status'
alias xrpone='xmms2 server config playlist.repeat_one 1'
alias xrpall='xmms2 server config playlist.repeat_all 1'
alias xrpclr='xmms2 server config playlist.repeat_one  0; xmms2 server config playlist.repeat_all 0'
alias xadd='xmms2 add "`xmms2 info | grep file:// | cut -d: -f2  | xargs -0 dirname`"'
alias cdxl='cd "$(xmms2 info | grep file:// |cut -d: -f2  |xargs -0 dirname |python3 -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")"'
alias xll='ls "$(xmms2 info | grep file:// |cut -d: -f2  |xargs -0 dirname |python3 -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")"'
xshuff () {
    # Add random files in xmms2
    if [ "$1" == "" ]; then
        NBF=50
        Path="$HOME/Music/"
    elif [ -d "$1" ]; then
        NBF=50
        Path="$1"
    else
        NBF=$1
        Path="$HOME/MUSIC/"
    fi

    fls=$(find "$Path" -type f -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.mp3" -o -iname "*.flac")
    NB=$(echo "$fls" | wc -l)

    RANDL=`python3 -c "import sys;import random;\
        nbf = min($NB, $NBF);\
        sys.stdout.write(' '.join(map(str, random.sample(range(1,$NB+1), nbf))))"`
    RANDN=""
    for i in $RANDL; do
        RANDN="${i}p;${RANDN}"
    done
    Songs=`echo "$fls" | sed -n "$RANDN"`
    xmms2 playlist switch temp
    xmms2 clear
    echo -e "$Songs" | xargs -I {} -d "\n" xmms2 add "{}"
    xmms2 jump 1 && xmms2 play
}

alias katai-struct-compiler='kaitai-struct-compiler -no-version-check'

#############
### ENV
#############

### Shell Global Variable
#shopt -s extglob
#setterm -blength 0 # Disable console beep

# X Keyboard Mapping
setxkbmap -option "nbsp:none" # disable non-breaking space, accidently genrated when typing <ALTGR>+<SPACE>
# setxkbmap -option # to reset value
# To find such character:
#   grep  $'\xc2\xa0' filename
# Find all files having such char (except binaries):
#   find -type f ! -iname "*.pyc" -and ! -iname "*.pk" -and ! -path "*/.git/*" -exec grep -Il '.' {} \; |xargs -d '\n' grep -l $'\xc2\xa0'
# To replace inline all bad spaces:
#   xargs sed -i 's/\xc2\xa0/ /g'

# QWERTY
alias to_qwerty='setxkbmap us' # QWERTY
alias to_azerty='setxkbmap fr' # AZERTY

# <C-w> should behave like vim
stty werase undef
bind '\C-w:unix-filename-rubout'

# auto-complete (bind is akin to write in the .inputrc file)
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on" # tape twice to complete on ambiguous
bind '"\e[Z": menu-complete-backward' # shift tab cycles backward
bind "Control-q: complete" # stop to cycling and seek take the next key

HISTSIZE=2000
HISTFILESIZE=2000
IGNOREEOF=3   # Shell only exists after the 3th consecutive Ctrl-d

export HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "
export EDITOR="/usr/bin/vim"
export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/lib:/usr/lib32"
export LD_RUN_PATH="/usr/local/lib:/usr/lib:/usr/lib32"
export PATH="/bin:/sbin:/usr/sbin:/opt/bin:/usr/bin:/usr/local/bin:$HOME/.local/bin:$HOME/bin"

### Man Pages
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# To work with opencv and cam
#LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so

### IF XFCE4
printf "\e[?2004l" # to avoid Copy-Paste in xfce4-terminal adds 0~ and 1~
### For vim color
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
export TERM='xterm-256color'

# C
cppversion='g++ -dM -E -x c++  /dev/null | grep -F __cplusplus'

# Python
pythonversion=$(python --version 2>&1| cut -d ' ' -f 2 | grep -oE '[0-9]\.[0-9]')
export PYTHONPATH="$PX/BaseDump/bots/skopai/common/"
export PYTHONPATH="$PYTHONPATH:$PX/networkofgraphs/process/pymake"

# Numpy
export OMP_NUM_THREADS=1  # Number of thread used by numpy

# GOLANG
export GOPATH=$HOME/.go
export PATH="$PATH:$GOPATH/bin:/usr/local/go/bin"

# SNAP
export PATH="$PATH:/snap/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


### Vundle
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

### Tmux Plugin
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### Brew
#git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
#export PATH="$PATH:$HOME/.linuxbrew/bin"
#export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
#export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

if [ -x $(echo $TMUX |cut -d',' -f1 ) ]; then

    ### FZF
    [ -f ~/.fzf.bash -a -d ~/.linuxbrew/Cellar/fzf ] && source ~/.fzf.bash

    ### Tmux git prompt
    # git clone git://github.com/drmad/tmux-git.git ~/.tmux-git
    if  [[ ! -z $TMUX && -f ~/.tmux-git/tmux-git.sh ]]; then source ~/.tmux-git/tmux-git.sh; fi
fi


if [ -d $HOME/.bash_completion.d ]; then
    if [ ! -z $(ls $HOME/.bash_completion.d) ]; then
        for bcfile in $HOME/.bash_completion.d/*; do
            . $bcfile
        done
    fi
fi

if [ -f /etc/profile.d/bash_completion.sh ]; then
    # Enable systemctl completion notably
    . /etc/profile.d/bash_completion.sh
fi


