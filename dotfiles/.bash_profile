############################
### Shell Configuration, fancy
###########################

### How to setup
# Put this at the enb of your ~/.bashrc
#
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
# @ROOT
#PROMPTL='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# @ROOT
#PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(_PWD)\[\033[00m\]\$ '

# Remote
# @SERVER
#PROMPTL='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;33m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# @SERVER
#PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;33m\]@\h\[\033[00m\]:\[\033[01;34m\]$(_PWD)\[\033[00m\]\$ '

# Local
# @LOCAL
PROMPTL='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
# @LOCAL
PROMPTS='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$(_PWD)\[\033[00m\]\$ '
alias prompt_long="PS1='$PROMPTL'"
alias prompt_short="PS1='$PROMPTS'"
if [ -x "$PS1" ]; then
    prompt_short
    #prompt_long
fi
prompt_short
#prompt_long

alias t="thunar"
alias gf="fg"
alias diff='diff -u'
alias tree='tree -C'
alias less='less -S -R'
alias df='df -TH'
alias dff='df -TH | grep -vE "loop|squashfs"'
#alias du='du -csh'
alias g="grep"
alias lsd='lsd -l'
alias l='ls'
alias lq='ls'
alias sls='ls'
alias sl='ls'
alias ll='ls -lh'
alias la='ls -A'
alias lr='ls -R'
alias lmd='ls *.md'
alias mkdit='mkdir'

function lla() {
    if [ ! -z $1 ]; then
        pushd "$1" >/dev/null
    fi
    find -maxdepth 2 -mindepth 1  -not -name "." | cut -d/ -f2 | uniq -c | sort -nr | awk  '{rc=system("ls --color -pldh " $2 " | tr -d \"\n\""); print  " \t "  $1-1 }'
    if [ ! -z $1 ]; then
        popd >/dev/null
    fi
}
function lsth() {
    P="${1%/}"
    if [ -z "$P" ]; then
        P="."
    fi
    command ls -th "$P" | sed "s/^/$P\//" | xargs du -sh
}

if [ -x /usr/bin/dircolors ]; then
    # Colors results
    #COLOR_OPT="auto"
    COLOR_OPT="always"
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=$COLOR_OPT -p --group-directories-first"
    alias dir="dir --color=$COLOR_OPT"
    alias vdir="vdir --color=$COLOR_OPT"
    alias grep="grep --color=$COLOR_OPT"
    alias fgrep="fgrep --color=$COLOR_OPT"
    alias egrep="egrep --color=$COLOR_OPT"
    alias watch="watch --color"
    alias tree="tree -C"
fi

if [ -x /bin/exa ]; then
    alias e="exa -l"
    alias exa="exa --group-directories-first"
    alias lt="exa -T"
    alias ll="exa -l"
fi

if [ -x /bin/batcat ]; then
    alias cat="batcat"
    alias bcat="batcat"
    alias mdcat="mdcat -p"
fi

complete -f l
complete -f lla

### Utility commands
alias sudo="sudo " # hack to get alias passed
alias c="command"
alias fuk='fuck'
alias please='sudo $(fuck -ln -1)'
alias so='source ~/.bashrc'
alias cleancolors="sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g' $1"
#alias python="python -O" # basic optimization (ignore assert, ..)
alias ipython="ipython --colors linux"
alias ipython_dev="ipython --profile dev"
alias py='python3'
alias xback='xbacklight'
alias bb="tmux ls 1>/dev/null 2>/dev/null && tmux attach || tmux"
alias j=jobs
alias tu="htop -u $USER"
alias iotop="sudo TERM=xterm iotop -o -a -d 2 -h"
alias diffd="diff -rq $1 $2" # show difference files between dir$1 and dir$2
alias mvspace="rename 's/ /_/g'"
alias torb="sh -c \"$HOME/src/config/app/tor-browser_en-US/Browser/start-tor-browser\" --detach"
function pdf(){ atril $1 2>/dev/null & }   # evince
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

function spinner() {
    while :; do for x in '/' '-' '\' '|'; do sleep 0.2; echo -en "\b\b $x"; done; done
}

alias v="vim (fzf --height 40%)"
alias vls="vim" # use when using with "C-A" and quicly change ls to vls for openin vim
alias vcd="vim" # use when using with "C-A" and quicly change cd to vcd for openin vim
alias vimdiff='vimdiff --noplugin'
alias vd='vimdiff'
alias vip='vim -p'
alias vis='vim -S'
alias vib="vim ~/.bash_profile"
alias vif="vim ~/.config/fish/aliases.fish"
alias vimrc="vim ~/.vimrc"
alias vilua="vim ~/.config/nvim/init.vim"
alias vilsp="vim ~/.config/nvim/lua/lsp_config.lua"
alias vimtmux="vim ~/.tmux.conf"
alias vig="vim ~/.gitconfig"
alias vign="vim .gitignore"
alias vikitty="vim ~/.config/kitty/kitty.conf"
alias vimake="vim Makefile"
alias vimk="vim Makefile"
alias vk="vim Makefile"
alias vime="vim $(find . -maxdepth 1 -iname 'readme*' -print -quit)"

_PWD="/home/ama/adulac/main/thesis/repo/ml/"
_NDL="$HOME/src/config/configure/nodeslist"
alias para="parallel -u --sshloginfile $_NDL --workdir $_PWD -C ' ' --eta --progress --env OMP_NUM_THREADS {}"

alias psa="ps -aux --sort=-start_time | grep -i --color"
alias pstree='pstree -h'
alias ps_vi='echo "mem% for vim+lsp" && ps aux --sort=-%mem | grep -iE "copilot|vim|lsp|gopls" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias ps_firefox='echo "mem% for firefox" && ps aux --sort=-%mem | grep -iE "firefox" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias ps_thunderbird='echo "mem% for thunderbird" && ps aux --sort=-%mem | grep -iE "thunderbird" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias ps_python='echo "mem% for python" && ps aux --sort=-%mem | grep -iE "python" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias lsoftop='sudo lsof | awk '\''{print $1 " " $2}'\'' | sort | uniq -c | sort -n -k1'
alias pstop='ps aux --sort=-%cpu | awk '\''{print "CPU: "$3"%", "MEM: "$4"%", "CMD: "$11}'\'' | head -n 11'
alias memtop='ps aux --sort=-%mem | awk '\''{print "CPU: "$3"%", "MEM: "$4"%", "CMD: "$11}'\'' | head -n 11'
alias riprm='shred -zuv -n1' # find <directory> -depth -type f -exec shred -v -n 1 -z -u {} \;
alias latex2html='latex2html -split 0 -show_section_numbers -local_icons -no_navigation'
alias eog='ristretto'
alias f='fzf' # fuzzy match
ff () { find -iname "*$1*"; } # wide match
fff () { find -iname "$1"; } # exact match
alias jerr='journalctl -r -p err -b'
clipboard() { command cat "$0" | xsel -bi; }
### Network
alias curlH='curl -I'
# curl ip.appspot.com'
# curl https://tools.aquilenet.fr/ip/
# curl ifconfig.io
# curl ifconfig.me
alias myip='curl https://tools.aquilenet.fr/ip/ && echo' 
alias vpn_aqui='sudo openvpn /etc/openvpn/aqn.conf'                                      
alias pvpn="protonvpn-cli"
alias nmapw='nmap -sT -P0 -sV -p80,443 --script=http-headers'
alias nmapRdWeb='nmap -Pn -sS -p 80 -T2 -iR 0 --open'
alias ntop="/home/dtrckd/.linuxbrew/bin/bandwhich"
#alias netl='netstat -taupen'
alias netl='netstat -plant'
alias netp='netstat -plant | grep -i stab | awk -F/ "{print \$2 \$3}" | sort | uniq'
alias fetch_debian='wget https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-xfce-CD-1.iso'
alias ip="ip --color"
alias ip4="ip -4 -br a"
alias ip6="ip -6 -br a"
alias fail2ban-ls='sudo fail2ban-client status | sed -n "s/,//g;s/.*Jail list://p" | xargs -n1 sudo fail2ban-client status'
# App
alias mongoshell="docker exec -it mongodb mongo"
alias station="ferdi &"
alias youtube-dl="yt-dlp"
alias docker_inspect_cmd="docker inspect --format '{{.Config.Cmd}}'"
alias docker_inspect_env="docker inspect --format '{{ json .Config.Env }}'"
alias dps='docker ps --format "{{.ID}}  {{.Names}}\n\t\t\t\t\t\t{{.Ports}}\n\t\t\t\t\t\t{{.Status}}"'
alias lzg="lazygit"
alias lzd="lazydocker"
# Fuzz
alias xagrep='find -type f -print0 | xargs -0  grep --color'
alias grepr='grep -R --exclude-dir={.git,node_modules,elm-stuff,vendor}' # see also rg
alias rg="rg --hidden -g '!.git/' -g '!vendor/' -g '!node_modules/' -g '!elm-stuff/' -g '!venv/' -g '!.tags'"
alias rgi="rg -i"
alias grepi="grep -i"
alias grepy='find -iname "*.py" | xargs grep --color -n'
alias grepyx='find -iname "*.pyx" | xargs grep --color -n'
alias grepxd='find -iname "*.pxd" | xargs grep --color -n'
function grepyf(){ find -iname "*.py" |xargs grep --color -m1 "$1" |cut -d: -f1; } # don work :(
alias grepall='find -type f | xargs grep --color'
alias show="command -v"
# Ag Alias
alias ag='ag --color-path 32 --color-match "1;40;36"'
alias agy='ag -i --py'
alias ago='ag -i --go'
alias agj='ag -i --js --ignore node_modules/'
### XFCE
#alias locks='s2ram -f -m'
#alias dodo='s2disk'
alias sys='systemctl'
complete -f sys
alias locks='systemctl suspend -i'
alias dodo='systemctl hibernate'
alias halt='systemctl poweroff'
### List utils
alias ls-service='systemctl -t service --state running'
alias ls-masked-unit='systemctl --state masked' # systemctl list-unit-files | grep masked
alias ls-failed-unit='systemctl --state failed' # systemctl --failed
alias ls-ssd='lsblk  -d -o name,rota'
alias ls-marked="apt-mark showhold"
alias ls-ppa="apt-cache policy | grep http | awk '{print $2 $3}' | sort -u"
### Dev
alias go-outdated="go list -mod=readonly -u -m -f '{{if not .Indirect}}{{if .Update}}{{.}}{{end}}{{end}}' all"

### VIM
#alias vim='vim.nox'
# @LOCAL
alias vim='nvim'
alias vi='vim'
alias ci='vim'
alias bi='vim'
alias vcal='vim -c "Calendar -view=month"' # get calendar
#alias vcal='vim -c Calendar -c on' # Matsumoto calendar
#alias vcal='vim -c "Calendar -view=year" -c tabe -c "Calendar -view=month"' # get calendar
alias vitodo='vim -p $(find -iname todo -type f)'
### Octave
alias octave='octave --silent'
alias ai="ai -s"
alias aic="command ai"
alias aic="command ai -c"
alias air='ai -r'
alias ai4='ai -m openai:gpt-4'
alias ai3='ai -m openai:gpt-3.5-turbo'

function vims() {
    # VIM
    #CONFDIR="$HOME/.vim/session"
    # NEOVIM
    CONFDIR="$HOME/.local/share/nvim/session"

    SessionID="$(basename $(dirname $PWD))-$(basename $PWD)"
    # vim-session way
    #if [ -f "$CONFDIR/$SessionID.vim" ]
    #    vim -c "OpenSession $SessionID"
    # vim-startify way
    if [ -f "$CONFDIR/$SessionID" ]; then
        vim -c "SLoad $SessionID"
    else
        echo "no vim session file found for ${SessionID}."
    fi
}
# Old vims but still useful
function vimss() {
    file=".session.vim"
    if [ -n "$1" ]; then
        file=.$1${file}
    fi
    if [ -f "$file" ]; then
        vim -c "source $file" -S ~/.vimrc 
    else
        echo "no vim session file found for $file."
    fi
}

function upgrademe() {
    sudo aptitude update && sudo aptitude upgrade
    sudo snap refresh
    npm update -g
    brew update && brew upgrade
    vim -c "PluginUpdate"
    #pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
}
function upgradevim() {
    vim -c "PluginUpdate"
}

function ssh_init() {
    eval `ssh-agent`
    ssh-add
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

unindent_text() {
  min_indent=''
  line=''
  indent=''

  # Read input line by line
  while IFS= read -r line; do
    # Count the number of leading spaces
    indent="${line%%[! ]*}"

    # Update the minimum indent if necessary
    if [[ -z "$min_indent" ]] || (( ${#indent} < ${#min_indent} )); then
      min_indent="$indent"
    fi

    # Store the line in an array
    lines+=("$line")
  done

  # Remove the minimum indentation from each line and output
  for line in "${lines[@]}"; do
    echo "${line#$min_indent}"
  done
}


alias cleanpaste="xsel -bo | sed 's/ *$//' | xsel -bi"
alias unindentpaste="xsel -bo | unindent_text | xsel -bi"

### GIT
alias gitupdate='git remote update'
alias gitg='gitg --all 1>/dev/null &'
alias gitk='gitk &'
alias lsgit='for d in $(find -maxdepth 2 -type d -name ".git" | sed "s/\.git$//" );do  echo $d; git -C "$d" status -svb; echo; done'
alias lsissues='for d in $(find -maxdepth 2 -type d -name ".git" | sed "s/\.git$//" );do  echo $d; git -C "$d" bug ls; echo; done'
alias gitamend='git commit --amend'
alias git-ls-tag="git tag -l --sort=-creatordate --format='%(creatordate:short): %(objectname:short) - %(refname:short)'"
alias gtl='git-ls-tag'
alias gm='git commit -m'
alias gr='git remote -v'
alias gb='git branch -v'
alias gp='git push'
alias gd='git diff'
alias gdc='git diff --cached'
alias gs='git status -sb'
alias ga="git add"
alias gl="git log --oneline --decorate --color"
alias gll="git log --pretty='%C(blue)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset %C(magenta)%an%Creset' --graph --date=relative --abbrev-commit"
alias gla="git log --format='%C(blue)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr)%Creset %C(magenta)%an%Creset' --graph --date=relative --abbrev-commit --all"
alias gsl="git stash list"
alias ggk="git checkout"
alias gi="git bug"
alias gil="git bug ls -s open"
alias gilc="git bug ls -s closed"
alias gilb="git bug ls-label"
alias gilid="git bug ls-id"
alias gir="gi bridge auth"
alias gis="git bug show"
function gip() {
    for f in $(echo "status labels authorEmail participants"|tr " " "\n"); do
        echo "$f:"  $(git bug show -f $f $1 )
    done
}
alias gia="git bug add"
function girm(){
    bugid=$(git bug ls-id $1)
    rm .git/refs/bugs/$bugid
    rm .git/git-bug/bug-cache
}
alias gila="git bug label add"
alias gilrm="git bug label rm"
alias gic="git bug comment add"
alias gibo="git bug status open"
alias gibc="git bug status close"
function gi_clean_local_bugs() {
    git for-each-ref refs/bugs/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    git for-each-ref refs/remotes/origin/bugs/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    rm -f .git/git-bug/bug-cache
}
function gi_clean_remote_bugs() {
    git ls-remote origin "refs/bugs/*" | cut -f 2 | xargs -r git push origin -d
}
function gi_clean_local_identity() {
    git for-each-ref refs/identities/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    git for-each-ref refs/remotes/origin/identities/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    rm -f .git/git-bug/identity-cache
}
function gi_clean_remote_identity() {
	git ls-remote origin "refs/identities/*" | cut -f 2 | xargs -r git push origin -d 
}
#alias gi='git issue'
#alias gil='git issue list -l "%i | %T| %D"'
#alias gis='git issue show'
alias gitfilelog="git log --pretty=oneline -u dotfiles/.vimrc"
alias git_excludf='git update-index --assume-unchanged'
gitcpush () { git commit -am "$1" && git push; }
alias gitcount_line='git diff --shortstat (git hash-object -t tree /dev/null)'
alias gitcount_commit='echo "$(git rev-list --count master) commits"'
function gitls() {
    branch="$(git rev-parse --abbrev-ref HEAD)"
    if [ -z "$1" ]; then
        branch="HEAD"
    else
        branch="$1"
    fi
    git ls-tree -r ${branch} --name-only
}
function gitlasttag() {
    # Get new tags from the remote
    git fetch --tags
    # Get the latest tag name
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    echo $latestTag
}
function gitcheckoutlasttag() {
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
    if [ -z "$1" ]; then
        git diff HEAD~1
    else
        git diff HEAD~$1..HEAD -- $2
    fi
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
function git_config_init() {
    git config user.name "dtrckd"
    git config user.email "dtrckd@gmail.com"
    git config --global core.excludesfile ~/.gitignore
}
# Git Permission Reset
function git_reset_permissions() {
    git diff -p \
        | command grep -E '^(diff|old mode|new mode)' \
        | sed -e 's/^old/NEW/;s/^new/old/;s/^NEW/new/' \
        | git apply
}

# Remove permanently file and purge whole history.
# Tell collaborators to do `git pull --rebase` # to avoid messy merge.
function git_eradicate_purge() {
    # alternative: bfg --delete-files YOUR-FILE-WITH-SENSITIVE-DATA
    File="$1"
    git filter-branch --force --index-filter \
        "git rm --force --cached --ignore-unmatch \"$File\"" \
        --prune-empty --tag-name-filter cat -- --all

    # Dereferenced objects and garbage collect
    rm -Rf .git/refs/original
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
    #git push origin master --force
}

if [ -d $HOME/src/config/credentials/ ]; then
    alias neocities="NEOCITIES_KEY=$(cat $HOME/src/config/credentials/adrien-dulac.neocities) neocities"
    #alias neocities="NEOCITIES_KEY=$(cat $HOME/src/config/credentials/pymake.neocities) neocities"
fi

alias tmr='python -m tm manager'

### cd alias
# Replace cd with pushd https://gist.github.com/mbadran/130469 
function _cd() {
  if [ -z "$1" ]; then
      # typing just `_cd` will take you $HOME ;)
      if [ ! "$PWD" == "$HOME" ]; then
        _cd "$HOME"
      fi

  elif [ "$1" == "-" ]; then
      # use `_cd -` to visit previous directory
    if [ "$(_cd -p | wc -l)" -gt 1 ]; then
      current_dir="$PWD"
      popd > /dev/null
      pushd -n $current_dir > /dev/null
    elif [ -n "$OLDPWD" ]; then
      _cd $OLDPWD
    fi

  elif [ "$1" == "-p" ]; then
      # list stack
      dirs | tr ' ' '\n' | grep -v "^\$"
  elif [ "$1" == "-l" ]; then
      # use `_cd -l` to print current stack of folders
      # remove duplicate dir
      # @debug: no distack in bash
      #dirstack="$(echo $dirstack | tr ' ' '\n' | awk '!seen[$0]++')"
      bold=$(tput bold)
      normal=$(tput sgr0)
      dirs | tr ' ' '\n' | grep -v "^$" | awk -v normal=$normal -v bold=$bold '{print  "\033[1;32m" NR-1 "\033[0m"  "  " bold $0 normal}' | tac | tail -n 20
  elif [ "$1" == "-c" ]; then
      # clear stack
      dirs -c

  elif [ "$1" == "-g" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
      # use `_cd -g N` to go to the Nth directory in history (swapping)
      indexed_path=$(_cd -p | sed -n $(($2+1))p | sed -e "s;~;$HOME;g")
      _cd $indexed_path

  elif [[ "$1" =~ ^-[0-9]+$ ]]; then
      # use `_cd -N` to go to the Nth directory in history (swapping)
      n=${1:1:2}
      indexed_path=$(_cd -p | sed -n $(($n+1))p | sed -e "s;~;$HOME;g")
      # remove this occurrence
      #set dirstack (echo $dirstack | tr ' ' '\n' | sed (string join "" $n "d"))
      popd -n -$(($n-1)) > /dev/null
      # move
      _cd $indexed_path

  elif [[ "$1" =~ ^\+[0-9]+$ ]]; then
      # use `_cd +N` to go n directories back in history (popping)
      for i in $(seq 1 ${1/+/}); do
          popd > /dev/null
      done


  elif [ "$1" == "..." ]; then
      cd ..
      cd ..

  elif [ "$1" == "--" ]; then
      # use `_cd -- <path>` if your path begins with a dash
    shift
    pushd -- "$@" > /dev/null

  else
    # basic case: move to a dir and add it to history
    if [ "$1" != "." ] && [ "$1" != "$PWD" ] && [ -d $1 ]; then
        pushd "$@" > /dev/null
    else
        command cd "$@"
    fi
  fi

}

# replace standard `cd` with enhanced version, ensure tab-completion works
alias cd=_cd
complete -f cd

alias xs='cd'
alias cdl='cd -l'
alias d='cd -l'
alias cd-='cd -'

PX="${HOME}/main"
alias cdf="cd $HOME/main/missions/fractale/"
alias iu="cd $PX"
alias ium="cd $HOME/Music/"
alias iuc="cd $HOME/src/config/"
alias iucs="cd $HOME/src/config/snippets"
alias iut="cd $HOME/Desktop/tt/"
alias iupm="cd $PX/thesis/pymake/"
alias iunb="cd $PX/thesis/notebook/"
alias iurp="cd $PX/thesis/repo/"
alias iuds="cd $PX/thesis/repo/docsearch/"
alias iub="cd $PX/Blue/"
alias iup="cd $PX/papers"
alias iud="cd $PX/planD/"
alias iudoc="cd $PX/planD/doc"
alias iuw="cd $PX/webmain/"
alias iumd="cd $PX/webmain/mixtures/md"
alias iubb="cd $PX/Blue/bhp/bhp"
alias iudd="cd $PX/Blue/bhp/data"
alias iuww="cd $PX/Blue/bhp/wiki"
alias iuds="cd $PX/Blue/designspec/"
alias iutm="cd $PX/Blue/tmr/tm"
alias iug="cd $PX/Blue/grator/pnp"
alias iubots="cd $PX/BaseDump/bots/"
alias iucm="cd $PX/BaseDump/bots/skopai/common/"
alias iux="cd $PX/BaseDump/bots/skopai/skopy"
alias iubg="cd $PX/BaseDump/bots/skopai/bigbangsearch"
alias iuscrapy="cd $HOME/.local/lib/python3.7/site-packages/scrapy/"
alias cdwww="cd $PX/perso/Projects/Informatique/Reseau/www"
alias cdsys="cd $PX/perso/Projects/Informatique/System"
alias cdrez="cd $PX/perso/Projects/Informatique/Reseau/"
alias cdid="cd $PX/perso/Papiers/me/"
alias cdp="cd $PX/perso/Papiers/"
alias cdai="cd ~/.config/aichat/sessions"
alias cdm="cd $PX/missions" # mission / kaggle / etc
cdlk () { cd $(dirname $(readlink $1)); }
grepurl () { sed -e  's/.*[hH][rR][eE][fF]=['\"''\'']\([^'\"''\'']*\)['\"''\''].*/\1/' $1; }
alias mean="awk '{s+=$1}END{print \"ave:\",s/NR}' RS=\" \""

#alias xrandr_setup="xrandr --output LVDS-1 --right-of VGA-1"
#alias xrandr_setup="xrandr --output HDMI-2 --left-of eDP-1"
alias xrandr_setup="xrandr --output DP-2-1 --left-of eDP-1"

#alias grepurl='xidel --extract "//a/@href"'

alias amatop='elinks http://zombie-dust.imag.fr:8000/'
#alias amatop='w3m http://zombie-dust.imag.fr:8000/'
alias grid='elinks http://localhost/grid.html'
alias gg="grid"

# PDF Cut
function pdfcut() {
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    command gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
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

function pdfgrey() {
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

function pdfcompress {
    command gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${1%%.pdf}_compressed.pdf ${1}
}


# Music player
#alias mute='amixer set Master mute'
#alias unmute='amixer set Master unmute'
#alias mute_toggle='amixer set Master toggle'
alias x='xmms2'
alias xl='xmms2 list'
alias xls='xmms2 list | command grep --color -C 15 "\->"'
#xls () {
#    if [ -z "$1" ]; then
#        xmms2 list | command grep --color -C 15 "\->"
#    else
#        xmms2 list | command grep $1 | command grep --color -C 15 "\->"
#    fi
#}
alias xrm='xmms2 remove $(xmms2 list | grep --color=never "\->"| grep --color=never -o "\[.*/" | grep -wo "[0-9]*") && xmms2 next'
alias xp='xmms2 toggle'
alias xn='xmms2 next'
alias xj='xmms2 jump'
alias xpl='xmms2 playlist list'
xplc () { xmms2 playlist create $1 && xmms2 playlist switch $1; }
xpll () { xmms2 playlist switch $1 && xj 1; }
alias xseek='xmms2 seek'
alias xs='xmms2 seek +25'
alias xss='xmms2 status'
alias xrpone='xmms2 server config playlist.repeat_one 1'
alias xrpall='xmms2 server config playlist.repeat_all 1'
alias xrpclr='xmms2 server config playlist.repeat_one  0; xmms2 server config playlist.repeat_all 0'
alias xcd='cd "$(xmms2 info | command grep file:// |cut -d: -f2  |xargs -0 dirname |python -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")"'
alias xll='ls "$(xmms2 info | command grep file:// |cut -d: -f2  |xargs -0 dirname |python -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")"'
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

    RANDL=`python -c "import sys, random, time;\
        random.seed(int(time.time()));\
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

function fip() {
    vlc -I curses "https://stream.radiofrance.fr/fip/fip_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipjazz/fipjazz_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fiphiphop/fiphiphop_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipelectro/fipelectro_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipreggae/fipreggae_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipgroove/fipgroove_hifi.m3u8?id=radiofrance"
}
function fip2 {
    ## National
    #https://stream.radiofrance.fr/fip/fip_hifi.m3u8?id=radiofrance
    ##FIP Rock
    #http://direct.fipradio.fr/live/fip-webradio1.mp3
    ##FIP Jazz
    #http://direct.fipradio.fr/live/fip-webradio2.mp3
    ##FIP Groove
    #http://direct.fipradio.fr/live/fip-webradio3.mp3
    ##FIP Monde
    #http://direct.fipradio.fr/live/fip-webradio4.mp3
    ##FIP Nouveautés
    #http://direct.fipradio.fr/live/fip-webradio5.mp3
    ##FIP Reggae
    #http://direct.fipradio.fr/live/fip-webradio6.mp3
    ##FIP Pop
    #http://direct.fipradio.fr/live/fip-webradio7.mp3
    ##FIP Electro
    #http://direct.fipradio.fr/live/fip-webradio8.mp3
    vlc -I curses "https://stream.radiofrance.fr/fip/fip_hifi.m3u8?id=radiofrance" "http://direct.fipradio.fr/live/fip-webradio1.mp3" "http://direct.fipradio.fr/live/fip-webradio2.mp3" "http://direct.fipradio.fr/live/fip-webradio3.mp3" "http://direct.fipradio.fr/live/fip-webradio4.mp3" "http://direct.fipradio.fr/live/fip-webradio5.mp3" "http://direct.fipradio.fr/live/fip-webradio6.mp3" "http://direct.fipradio.fr/live/fip-webradio7.mp3" "http://direct.fipradio.fr/live/fip-webradio8.mp3"
}

alias katai-struct-compiler='kaitai-struct-compiler -no-version-check'

#############
### ENV
#############
export TZ="Europe/Paris"
# Change the sorting behaviour with ls
export LC_COLLATE=C

### Shell Global Variable
#shopt -s extglob
#setterm -blength 0 # Disable console beep
stty -ixon # disable <C-s> freeze in vim (who waits a <C-q> signal !)

# X Keyboard Mapping
# @LOCAL
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

# Bind is akin to write in the .inputrc file)
# Tab completion features
bind "TAB:menu-complete" # auto complete menu TAV
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on" # tape twice to complete on ambiguous
bind '"\e[Z": menu-complete-backward' # shift tab cycles backward
bind "Control-q: complete" # stop to cycling and seek take the next key
bind 'set completion-ignore-case on' # Case insensitive when tab completing

HISTSIZE=2000
HISTFILESIZE=2000
IGNOREEOF=1   # Shell only exists after the nth consecutive Ctrl-d

export HISTTIMEFORMAT="%d/%m/%Y %H:%M:%S "
export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/lib:/usr/lib32"
export LD_RUN_PATH="/usr/local/lib:/usr/lib:/usr/lib32"
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:/opt/bin:/usr/bin:/usr/sbin:/bin:/sbin"
if [ -f /usr/bin/nvim ]; then
    export EDITOR="/usr/bin/nvim"
    export GIT_EDITOR="/usr/bin/nvim"
else
    export EDITOR="/usr/bin/vim"
    export GIT_EDITOR="/usr/bin/vim"
fi

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

### IF XFCE4 (@debug Kitty)
#printf "\e[?2004l" # to avoid Copy-Paste in xfce4-terminal adds 0~ and 1~
#### For vim color
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
else
    export TERM='xterm-color'
fi

# C
cppversion='g++ -dM -E -x c++  /dev/null | grep -F __cplusplus'

# Python
if [ -x $(which python) ]; then
    pythonversion=$(python --version 2>&1| cut -d ' ' -f 2 | grep -oE '[0-9]\.[0-9]')
    export PYTHONPATH="$PX/BaseDump/bots/skopai/common/"
    export PYTHONPATH="$PYTHONPATH:$PX/thesis/pymake"

    # Numpy
    export OMP_NUM_THREADS=1  # Number of thread used by numpy
fi

# GOLANG
if [ -x "$(which go)" ]; then
    export GOPATH=$HOME/.go
    export PATH="$(go env GOROOT)/bin:$PATH"
    export PATH="$(go env GOPATH)/bin:$PATH"
fi

# RUST
if [ -x "$(which rustc)" -o -x "${HOME}/.cargo/bin/rustc" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# SNAP
if [ -x "$(which snap)" ]; then
    export PATH="/snap/bin:$PATH"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Vundle
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Tmux Plugin
#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Brew
#git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
if [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    export PATH="$HOME/.linuxbrew/bin:$PATH"
    export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# Poetry
export PATH="$HOME/.poetry/bin:$PATH"

# Kitty
if [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then
    export PATH=$PATH:$HOME/.local/kitty.app/bin
	export TERM='xterm-kitty'
fi

# Thefuck
if [ -x "$(which thefuck)" ]; then
    eval "$(thefuck --alias)"
    alias fk="fuck"
fi

# Zoxide
if [ -x "$(which zoxide)" ]; then
    eval "$(zoxide init bash)"
fi

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

if [ -z "$BASH_EXECUTION_STRING" ]; then
    which fish 1>/dev/null
    if [ $? == 0 ]; then
        exec fish
    fi
fi

