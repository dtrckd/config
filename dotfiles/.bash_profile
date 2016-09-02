############################
### Shell Configuration, fancy
###########################
### Prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ' # root
#PROMPT1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;33m\]@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ' # remote
PROMPT1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
PROMPT2='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
alias prompt_short="PS1='$PROMPT1'"
alias  prompt_long="PS1='$PROMPT2'"
if [ -x "$PS1" ]; then
    prompt_long
fi
prompt_long

#### Colors results
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -p --group-directories-first'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias watch='watch --color'
fi

### Utility commands
alias python="python -O" # basic optimizatio (ignore assert, ..)
alias ipython="ipython --colors linux"
alias pynotebook="jupyter --ip 127.0.0.1"
alias xback='xbacklight'
alias bb="byobu"
alias cc="cat"
alias vdiff='vimdiff'
alias evc="evince"
# Enable mouse scroll
# ctrl-s : <set -g mouse on>
alias psg="ps -ef | grep -i --color"
alias pstree='pstree -h'
alias rmf='shred -zu'
alias dicten='dict enfr'
alias latex2html='latex2html -split 0 -show_section_numbers -local_icons -no_navigation'
alias eog='ristretto'
ff () { find -name "*$1*"; }
### Net
alias curlH='curl -I'
alias myip='nmap -sC -p80 -n -Pn --script=http-title www.KissMyIp.com whatismyip.com.au' #myip.is
alias nmapw='nmap -sT -P0 -sV -p80,443 --script=http-headers'
alias nmapRdWeb='nmap -Pn -sS -p 80 -T2 -iR 0 --open'
alias netl='netstat -taupen'
# Fuzz
alias xagrep='find -type f -print0 | xargs -0  grep --color'
alias grepi='find -iname "*.py" | xargs grep --color -ni'
alias agpy='ag --py'
### XFCE
#alias locks='s2ram -f -m'
#alias dodo='s2disk'
alias locks='systemctl suspend'
alias dodo='systemctl hibernate'

### VIM
alias vcal='vim -c "Calendar -view=month"' # get calendar
#alias vcal='vim -c Calendar -c on' # Matsumoto calendar
#alias vcal='vim -c "Calendar -view=year" -c tabe -c "Calendar -view=month"' # get calendar
alias ci='vim'
alias vitodo='vim -p $(find -iname todo -type f)'
### Octave
alias octave='octave --silent'
#alias vims='vim -c "source .session.vim" -S ~/.vimrc'
function vims() {
    file=".session.vim"
    if [ -n "$1" ]; then
        file=.$1${file}
    fi
    vim -c "source $file" -S ~/.vimrc
}
function upgrademe() {
    aptitude update && aptitude upgrade
    brew update && brew upgrade
    pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    npm update
    vim -c "UpdatePlugin"
}

### ls alias
alias l='ls'
alias lq='ls'
alias sls='ls'
alias sl='ls'
alias ll='ls -l'
alias la='ls -A'
alias lr='ls -R'
alias lmd='ls *.md'

### GIT
alias gitupdate="git remote update"
alias gitg='gitg --all 1>/dev/null &'
alias gitb='git branch -av'
alias gits='git status -sb'
alias gitr='git remote -v'
alias lsgit='for d in $(find -type d -name ".git" | sed "s/\.git$//" );do  echo $d; git -C "$d" status -svb; echo; done'
alias gitamend='git commit -a --amend'
alias gitcommit='git commit -am'
alias gitl="git log --format='%Cgreen%h%Creset %Cblue%ad%Creset %C(cyan)%an%Creset: %s' --graph --date=short"
alias gitlt="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitls='git ls-tree -r master --name-only'
alias gitstash="git stash list"
alias git_excludf='git update-index --assume-unchanged'
# Output current git branch, echo $(curbr)
function curbr() {
    git rev-parse --abbrev-ref HEAD
}
# Diff between $1 past commit of $2 file. Nice.
function gitdiff() {
    git diff  HEAD~$1..HEAD -- $2
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

### cd alias
alias xs='cd'
MAGMAHR="~/Desktop/workInProgress/magma_hr"
PX="~/Desktop/workInProgress/"
PXX="~/Desktop/workInProgress/networkofgraphs/"
webApp="webuser"
alias iu="cd $PX"
alias ius="cd $PX/networkofgraphs/process/PyNPB/src"
alias iud="cd $PX/networkofgraphs/process/PyNPB/data"
alias iup="cd $PX/networkofgraphs/papers"
alias iug="cd $PX/networkofgraphs/papers/personal/relational_models"
alias iuc="cd $HOME/src/config"
alias iut="cd ${MAGMAHR}/code/tools"
alias iupx="cd $PX/PX"
alias iupp="cd $PX/CREA/PP"
alias iuw="cd ${PX}/webmain/"
alias iumd="cd ${PX}/webmain/mixtures/md"
alias iupython="cd /usr/local/lib/python2.7/dist-packages/"
alias iuscrapy="cd /usr/local/lib/python2.7/dist-packages/scrapy/"
alias cdoc="cd ~/Projets/hack-dir/doc-lib"
alias cdhack="cd ~/Projets/hack-dir/Linux/commandes"
alias cdwww="cd ~/Projets/Informatique/Reseau/www"
alias cdsys="cd ~/Projets/Informatique/System"
alias cdrez="cd ~/Projets/Informatique/Reseau/"
cdlk () { cd $(dirname $(readlink $1)); }

### PDF Manip
function pdfpages() {
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
function pdffusion() {
    outname="$(basename $1 .pdf)$(basename $2 .pdf)"
    outname="fusion_${outname}.pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=${outname} ${1} ${2}
}

# Music player
#alias mute='amixer set Master mute'
#alias unmute='amixer set Master unmute'
#alias mute_toggle='amixer set Master toggle'
alias x='xmms2'
alias xx='xmms2'
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
alias xadd='xmms2 add "`xx info | grep file:// | cut -d: -f2  | xargs -0 dirname`"'
alias xll='ls "`xx info | grep file:// | cut -d: -f2  | xargs -0 dirname`"'
xrand () { 
    if [ "$1" == "" ]; then NBF=50 ;else NBF=$1 ;fi
    if [ -e "$NBF" -o "$NBF" == "." ]; then
        cd $NBF
        NB=`locate --regex "$(pwd)/.*\.(mp3|wav|wma|ogg|flac|mpc|m4a)" | wc -l`
        fls=`locate --regex "$(pwd)/.*\.(mp3|wav|wma|ogg|flac|mpc|m4a)"`
        NBF=50
        cd -
    else
        NB=`locate --regex "/home/$(whoami)/Music/.*\.(mp3|wav|wma|ogg|flac|mpc|m4a)" | wc -l`
        fls=`locate --regex "/home/$(whoami)/Music/.*\.(mp3|wav|wma|ogg|flac|mpc|m4a)"`
    fi
    if [ $NB -le $NBF ]; then
        NBF=$NB
    fi
    #NB=`/usr/bin/find ~/Music -type f -exec sh -c "/usr/bin/file -b \"{}\" | /bin/grep -qi 'audio'" \; -print | wc -l`
    #random=$(od -N1 -An -i /dev/urandom)
    RANDL=`python -c "import sys;import random;\
        sys.stdout.write(' '.join(map(str, random.sample(xrange(1,$NB+1),$NBF))))"`
    RANDN=""
    for i in $RANDL; do
        RANDN="${i}p;${RANDN}"
    done
    Songs=`echo "$fls" | sed -n "$RANDN"`
    #Songs=`find ~/Music -type f | sed -n $RANDN`
    xx playlist switch temp
    xmms2 clear
    echo -e "$Songs" | xargs -I {} -d "\n" xmms2 add "{}" 
}

# Shell Global Variable
#shopt -s extglob
#setterm -blength 0 # Disable console beep
HISTSIZE=1000
HISTFILESIZE=2000
export HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "
export EDITOR="/usr/bin/vim"
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/opt/bin"
export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/lib:/usr/lib32"
export LD_RUN_PATH="/usr/local/lib:/usr/lib:/usr/lib32"
Python_version=$(python --version 2>&1| cut -d ' ' -f 2 | grep -oE '[0-9]\.[0-9]')
export PYTHONPATH="/opt/lib/pythy:$HOME/lib/pythy:$HOME/Documents/workInProgress/networkofgraphs/process/PyNPB/src" #:$HOME/.local/lib/:/usr/local/lib:/usr/lib"
export OMP_NUM_THREADS=1  # Number of thread used by numpy

#### Man Pages
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

### IF XFCE4
printf "\e[?2004l" # to avoid Copy-Paste in xfce4-terminal adds 0~ and 1~
### For vim color
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi
export TERM='xterm-256color'

IGNOREEOF=3   # Shell only exists after the 3th consecutive Ctrl-d

### Intall Vundle
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
### Install Brew
# git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
export PATH="$PATH:$HOME/.linuxbrew/bin"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# To work with opencv and cam
#LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so

### Fuzzy
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

### How to setup
# end of .bashrc
#if [ -f ~/.bash_profile ]; then
#    . ~/.bash_profile
#fi

