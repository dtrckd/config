#############
### ENV
#############

# Env variables variable are got from bash definition

stty -ixon # disable <C-s> freeze in vim (who waits a <C-q> signal !)
setxkbmap -option "nbsp:none" # disable non-breaking space, accidently genrated when typing <ALTGR>+<SPACE>
alias to_qwerty='setxkbmap us' # QWERTY
alias to_azerty='setxkbmap fr' # AZERTY

# Thefuck
function fuck -d "Correct your previous console command"
  set -l fucked_up_command $history[1]
  env TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command | read -l unfucked_command
  if [ "$unfucked_command" != "" ]
	eval $unfucked_command
	builtin history delete --exact --case-sensitive -- $fucked_up_command
	builtin history merge ^ /dev/null
  end
end

# Zoxyde
if type -q zoxide
    zoxide init fish | source
end

# Direnv
if type -q direnv
   direnv hook fish | source
end

# Kitty...
export TERM="xterm-kitty"

# Aichat command auto-completion
function _aichat_fish
    set -l _old (commandline)
    if test -n $_old
        echo -n "⌛"
        commandline -f repaint
        commandline (aichat -e $_old)
    end
end
bind \ee _aichat_fish

#############
### ENV
#############

function serve
    # see caddy instead !
    if test (count $argv) -ge 1
        if python -c 'import sys; sys.exit(sys.version_info[0] != 3)'
            /bin/sh -c "(cd $argv[1] && python -m http.server)"
        else
            /bin/sh -c "(cd $argv[1] && python -m SimpleHTTPServer)"
        end
    else
        python -m SimpleHTTPServer
    end
end

#set LS_COLORS dxfxcxdxbxegedabagacad

# basic
alias gf="fg"
alias diff='diff -u'
alias tree='tree -C'
alias less='less -S -R'
alias df='df -Th'
alias dff='df -TH | grep -vE "loop|squashfs"'
#alias du="du -sch"
alias g='grep'
alias lsd='lsd -l'
alias ls='ls --group-directories-first -p --color=always'
alias l='ls'
alias lq='ls'
alias sls='ls'
alias sl='ls'
alias ll='ls -lh'
alias la='ls -A'
alias lr='ls -R'
alias lmd='ls *.md'
alias mkdit='mkdir'
function lla
    if test (count $argv) -ge 1
        pushd $argv[1]
    end
    find -maxdepth 2 -mindepth 1  -not -name "." | cut -d/ -f2 | uniq -c | sort -nr | awk  '{rc=system("ls --color -pldh " $2 " | tr -d \"\n\""); print  " \t "  $1-1 }'
    if test (count $argv) -ge 1
        popd
    end
end
function lsth
    set P (string trim -r --chars "/" $argv[1])
    if [ -z "$P" ]
        set P "."
    end
    echo $P
    command ls -th "$P" | sed "s/^/$P\//" | xargs du -sh
end

if test -x /bin/exa
    alias e="exa -l"
    alias exa="exa --group-directories-first"
    alias lt="exa -T"
    alias ll="exa -l"
end

if test -x /bin/batcat
    alias cat="batcat"
    alias bcat="batcat"
    alias mdcat="mdcat -p"
end

### Utility commands
alias c="command"
alias fuk='fuck'
alias please='sudo (fc -ln -1)'
alias so='source ~/.config/fish/config.fish'
alias cleancolors="sed -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g' $1"
alias python="python -O" # basic optimizatio (ignore assert, ..)
alias ipython="ipython --colors linux"
alias ipython_dev="ipython --profile dev"
alias py='python'
alias py3='python3'
alias xback='xbacklight'
alias octave='octave --silent'
alias ai="ai -s"
alias aic="command ai"
alias aicc="command ai -c"
alias ai4c='command ai -m openai:gpt-4'
alias air='ai -r'
alias ai4='ai -m openai:gpt-4'
alias ai3='ai -m openai:gpt-3.5-turbo'
alias mongoshell="docker exec -it mongodb mongo"
alias docker_inspect_cmd="docker inspect --format '{{.Config.Cmd}}'"
alias docker_inspect_env="docker inspect --format '{{ json .Config.Env }}'"
alias dps='docker ps --format "{{.ID}}  {{.Names}}\n\t\t\t\t\t\t{{.Ports}}\n\t\t\t\t\t\t{{.Status}}"'
alias lzg="lazygit"
alias lzd="lazydocker"
alias station="ferdi &"
alias bb="tmux ls 1>/dev/null 2>/dev/null && tmux attach || tmux"
alias j=jobs
alias tu="htop -u $USER"
alias iotop="sudo TERM=xterm iotop -o -a -d 2 -h"
alias diffd="diff -rq $argv[1] $argv[2]" # show difference files between dir$1 and dir$2
alias mvspace="rename 's/ /_/g'"
alias torb="sh -c \"$HOME/src/config/app/tor-browser_en-US/Browser/start-tor-browser\" --detach"
function pdf; atril $argv[1] 2>/dev/null &; end # evince
function pdfo; okular $argv[1] 2>/dev/null &; end
alias v="vim (fzf --height 40%)"
alias vls="vim" # use when using with "C-A" and quicly change ls to vls for openin vim
alias vcd="vim" # use when using with "C-A" and quicly change cd to vcd for openin vim
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
alias t="thunar"
alias vimake="vim Makefile"
alias vimk="vim Makefile"
alias vk="vim Makefile"
alias vime="vim (find . -maxdepth 1 -iname 'readme*' -print -quit)"

alias vim='nvim'
alias vi='vim'
alias ci='vim'
alias bi='vim'
alias vcal='vim -c "Calendar -view=month"' # get calendar
alias vitodo='vim -p (find -iname todo -type f)'

set _PWD "/home/ama/adulac/main/thesis/repo/ml/"
set _NDL "$HOME/src/config/configure/nodeslist"
alias para="parallel -u --sshloginfile $_NDL --workdir $_PWD -C ' ' --eta --progress --env OMP_NUM_THREADS {}"


alias psa="ps -aux --sort=-start_time | grep -i --color"
alias pstree='pstree -h'
alias ps_vi='echo "mem% for vim+lsp" && ps aux --sort=-%mem | grep -iE "copilot|vim|lsp|gopls" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias ps_firefox='echo "mem% for firefox" && ps aux --sort=-%mem | grep -iE "firefox" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias ps_thunderbird='echo "mem% for thunderbird" && ps aux --sort=-%mem | grep -iE "thunderbird" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias ps_python='echo "mem% for python" && ps aux --sort=-%mem | grep -iE "python" | sort -nrk4 | awk '\''NR<=100 {print $0}'\''  | awk '\''{sum+=$4} END {print sum}'\''' 
alias pstop='ps aux --sort=-%cpu | awk '\''{print "CPU: "$3"%", "MEM: "$4"%", "CMD: "$11}'\'' | head -n 11'
alias memtop='ps aux --sort=-%mem | awk '\''{print "CPU: "$3"%", "MEM: "$4"%", "CMD: "$11}'\'' | head -n 11'
alias lsoftop='sudo lsof | awk '\''{print $1 " " $2}'\'' | sort | uniq -c | sort -n -k1'
alias riprm='shred -zuv -n1'
alias latex2html='latex2html -split 0 -show_section_numbers -local_icons -no_navigation'
alias eog='ristretto'
alias f='fzf' # fuzzy match
function ff; find -iname "*$argv[1]*" ; end # wide match
function fff; find -iname "$argv[1]" ; end # exact match
alias jerr='journalctl -r -p err -b'
function clipboard; command cat $argv[1] |string trim -c "\n" | xsel -bi; end
alias curlH='curl -I'
alias myip='curl https://tools.aquilenet.fr/ip/ && echo'
alias vpn_aqui='sudo openvpn /etc/openvpn/aqn.conf'                                      
alias pvpn="protonvpn-cli"
alias nmapw='nmap -sT -P0 -sV -p80,443 --script=http-headers'
alias nmapRdWeb='nmap -Pn -sS -p 80 -T2 -iR 0 --open'
alias ntop="/home/dtrckd/.linuxbrew/bin/bandwhich" 
alias netl='netstat -plant'
alias netp='netstat -plant | grep -i stab | awk -F/ "{print \$argv[2] \$argv[3]}" | sort | uniq'
alias fetch_debian='wget https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-xfce-CD-1.iso'
alias ip="ip --color"
alias ip4="ip -4 -br a"
alias ip6="ip -6 -br a"
alias fail2ban-ls='sudo fail2ban-client status | sed -n "s/,//g;s/.*Jail list://p" | xargs -n1 sudo fail2ban-client status'
alias xagrep='find -type f -print0 | xargs -0  grep --color'
alias grepr='grep -R --exclude-dir={.git,node_modules,elm-stuff,vendor}' # see also rg
alias rg="rg --hidden -g '!.git/' -g '!vendor/' -g '!node_modules/' -g '!elm-stuff/' -g '!venv/' -g '!.tags'"
alias rgi="rg -i"
alias grepi="grep -i"
alias grepy='find -iname "*.py" | xargs grep --color -n'
alias grepyx='find -iname "*.pyx" | xargs grep --color -n'
alias grepxd='find -iname "*.pxd" | xargs grep --color -n'
alias ag='ag --color-path 32 --color-match "1;40;36"'
alias agy='ag -i --py'
alias ago='ag -i --go'
alias agj='ag -i --js --ignore node_modules/'
alias sys='systemctl'
alias locks='systemctl suspend -i'
alias dodo='systemctl hibernate'
alias halt='systemctl poweroff'
alias ls-service='systemctl -t service --state running'
alias ls-masked-unit='systemctl --state masked' # systemctl list-unit-files | grep masked
alias ls-failed-unit='systemctl --state failed' # systemctl --failed
alias ls-ssd='lsblk  -d -o name,rota'
alias ls-marked="apt-mark showhold"
alias ls-ppa="apt-cache policy | grep http | awk '{print $2 $3}' | sort -u"
alias go-outdated="go list -mod=readonly -u -m -f '{{if not .Indirect}}{{if .Update}}{{.}}{{end}}{{end}}' all"

function show
    functions $argv[1] | grep "^ "
end

function fetch_gitignore
    curl -sL https://www.gitignore.io/api/$argv[1] > .gitignore
end

function vims
    # VIM
    #set CONFDIR "$HOME/.vim/session"
    # NEOVIM
    set CONFDIR "$HOME/.local/share/nvim/session"

    set SessionID (basename (dirname $PWD))-(basename $PWD)
    #### vim-session way
    #if [ -f "$CONFDIR/$SessionID.vim" ]
    #    vim -c "OpenSession $SessionID"
    #### vim-startify way
    if [ -f "$CONFDIR/$SessionID" ]
        vim -c "SLoad $SessionID"
    else
        echo "no vim session file found for $SessionID."
    end
end

# Old vims but still useful
function vimss
    set file ".session.vim"
    if [ -n "$argv[1]" ]
        set file .$argv[1]$file
    end
    if [ -f "$file" ]
        vim -c "source $file" -S ~/.vimrc 
    else
        echo "no vim session file found for $file."
    end
end

function upgrademe
    sudo aptitude update && sudo aptitude upgrade
    sudo snap refresh
    npm update -g
    brew update && brew upgrade
    vim -c "PluginUpdate"
    #pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
end

function upgradevim
    vim -c "PluginUpdate"
end

alias gitupdate='git remote update'
alias gitg="gitg --all 1>/dev/null &"
alias gitk='gitk &'
alias gitamend='git commit --amend'
alias gitcommit='git commit'
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
function gip
    for f in (string split ' ' 'status labels authorEmail participants')
        echo "$f:"  (git bug show -f $f $argv[1] )
    end
end
alias gia="git bug add"
function girm
    set bugid  (git bug ls-id $argv[1])
    rm .git/refs/bugs/$bugid
    rm .git/git-bug/bug-cache
end
alias gila="git bug label add"
alias gilrm="git bug label rm"
alias gic="git bug comment add"
alias gibo="git bug status open"
alias gibc="git bug status close"
function gi_clean_local_bugs
    git for-each-ref refs/bugs/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    git for-each-ref refs/remotes/origin/bugs/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    rm -f .git/git-bug/bug-cache
end
function  gi_clean_remote_bugs
    git ls-remote origin "refs/bugs/*" | cut -f 2 | xargs -r git push origin -d
end
function gi_clean_local_identity
    git for-each-ref refs/identities/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    git for-each-ref refs/remotes/origin/identities/ | cut -f 2 | xargs -r -n 1 git update-ref -d
    rm -f .git/git-bug/identity-cache
end
function gi_clean_remote_identity
	git ls-remote origin "refs/identities/*" | cut -f 2 | xargs -r git push origin -d 
end
#alias gi='git issue'
#alias gil='git issue list -l "%i | %T| %D"'
#alias gis='git issue show'
alias gitfilelog="git log --pretty=oneline -u dotfiles/.vimrc"
alias gitstash="git stash list"
alias git_excludf='git update-index --assume-unchanged'
alias gitcount_line='git diff --shortstat (git hash-object -t tree /dev/null)'
alias gitcount_commit='git rev-list --count'
function gitcpush; git commit -am $argv[1] && git push; end
function lsgit 
    for d in (find -maxdepth 2 -type d -name ".git" | sed 's/\.git$//' );
        echo $d
        if [ "$argv[1]" = "-r" ]
            git -C "$d" remote -v
        else if [ "$argv[1]" = "-b" ]
            git -C "$d" branch
        else if [ "$argv[1]" = "-b" ]
        else
            git -C "$d" status -svb
        end
        echo
    end
end
function lsissues
    for d in (find -maxdepth 2 -type d -name ".git" | sed 's/\.git$//' );
        echo $d
        git -C "$d" bug ls
        echo
    end
end
function gitls
    set branch (git rev-parse --abbrev-ref HEAD)
    if [ -n $argv[1] ]
        set branch HEAD
    else
        set branch $argv[1]
    end
    git ls-tree -r $branch --name-only
end
function  gitlasttag
    # Get new tags from the remote
    git fetch --tags
    # Get the latest tag name
    set latestTag (git describe --tags (git rev-list --tags --max-count=1))
    echo $latestTag
end
function  gitcheckoutlasttag
    # Get new tags from the remote
    git fetch --tags
    # Get the latest tag name
    set latestTag (git describe --tags (git rev-list --tags --max-count=1))
    # Checkout the latest tag
    git checkout $latestTag
end

# Output current git branch, echo $(curbr)
function curbr
    git rev-parse --abbrev-ref HEAD
end
# Diff between $1 past commit of $2 file. Nice.
function gitdiff
    if [ -z $argv[1] ]
        git diff HEAD~1
    else
        gitdiff  HEAD~$argv[1]..HEAD -- $argv[2]
    end
end

# Show fat file in history
function git_fatfiles
    git rev-list --all --objects | \
        sed -n (git rev-list --objects --all | \
        cut -f1 -d' ' | \
        git cat-file --batch-check | \
        grep blob | \
        sort -n -k 3 | \
        tail -n40 | \
        while read hash type size;
            echo -n "-e s/$hash/$size/p ";
        end) | \
        sort -n -k1
end

function gitsearch
    git log -S "$argv[1]" --source --all
end

# Git init
function git_config_init
    git config user.name "dtrckd"
    git config user.email "dtrckd@gmail.com"
    git config --global core.excludesfile ~/.gitignore
end
# Git Permission Reset
function git_reset_permissions
    git diff -p \
        | command grep -E '^(diff|old mode|new mode)' \
        | sed -e 's/^old/NEW/;s/^new/old/;s/^NEW/new/' \
        | git apply
end

# Remove permanently file and purge whole history.
# Tell collaborators to do `git pull --rebase` # to avoid messy merge.
function git_eradicate_purge
    # alternative: bfg --delete-files YOUR-FILE-WITH-SENSITIVE-DATA
    set File "$argv[1]"
    git filter-branch --force --index-filter \
        "git rm --force --cached --ignore-unmatch \"$File\"" \
        --prune-empty --tag-name-filter cat -- --all

    # Dereferenced objects and garbage collect
    rm -Rf .git/refs/original
    git reflog expire --expire=now --all
    git gc --prune=now --aggressive
    #git push origin master --force
end

function ssh_init
    eval (ssh-agent -c)
    ssh-add
end

#function git-dowloadfolder
#    set a $1
#    svn checkout ${a/tree\/master/trunk}
#end

function restore_alsa
    while [ -z (pidof pulseaudio) ];
        sleep 0.5
    end
    alsactl -f /var/lib/alsa/asound.state restore
end

function restore_pulseaudio
    pulseaudio -kv && sudo alsabat force-reload && pulseaudio -Dv
end

if [ -d $HOME/src/config/credentials/ ]; 
    alias neocities="env NEOCITIES_KEY=(cat $HOME/src/config/credentials/adrien-dulac.neocities) neocities"
    #alias neocities="NEOCITIES_KEY=(cat $HOME/src/config/credentials/pymake.neocities) neocities"
end

alias tmr='python3 -m tm manager'

function unindent_text
    set line ''
    set line ''
    set indent ''
    set lines

    # Read input line by line
    while read -l line
        set indent (string match -r '^\s*' $line)
        set indent (string match -r '^\s*' $line)

        # Update the minimum indent if necessary
        if test -z "$min_indent"; or test (string length "$indent") -lt (string length "$min_indent")
            set min_indent "$indent"
        end
        # Store the line in an array
        set lines $lines "$line"
    end

    # Remove the minimum indentation from each line and output
    for line in $lines
        echo (string sub -s (math (string length "$min_indent") + 1) "$line")
    end
end

alias cleanpaste="xsel -bo | sed 's/ *\$//' | xsel -bi"
alias unindentpaste="xsel -bo | unindent_text | xsel -bi"

### cd alias

# Replace cd with pushd https://gist.github.com/mbadran/130469 | fish compatible
function _cd
    if [ -z "$argv[1]" ]
        # typing just `_cd` will take you $HOME ;)
        if [ "$PWD" != "$HOME" ]
            _cd "$HOME"
        end
    else if [ "$argv[1]" = "-" ]
        # use `_cd -` to visit previous directory
        if [ (_cd -p | wc -l) -gt 1 ]
            set current_dir "$PWD"
            popd > /dev/null
            set -g dirstack $current_dir $dirstack
            #pushd $current_dir > /dev/null
        else if [ -n "$OLDPWD" ]
            builtin cd -;
        end

    else if [ "$argv[1]" = "-p" ]
        # list stack
        dirs | tr ' ' '\n' | grep -v "^\$"
    else if [ "$argv[1]" = "-l" ]
        # use `_cd -l` to print current stack of folders
        # remove duplicate dir
        set dirstack (echo $dirstack | tr ' ' '\n' | awk '!seen[$0]++')
        set bold (tput bold)
        set normal (tput sgr0)
        dirs | tr ' ' '\n' | grep -v "^\$" | awk -v normal=$normal -v bold=$bold '{print  "\033[1;32m" NR-1 "\033[0m"  "  " bold $0 normal}' | tac | tail -n 20
    else if [ "$argv[1]" = "-c" ]
        # clear stack
        dirs -c

    else if [ "$argv[1]" = "-g" ] && string match -arq "^[0-9]+\$" "$argv[2]"
        # use `_cd -g N` to go to the Nth directory in history (pushing)
        set indexed_path (_cd -p | sed -n (math $argv[2]+1)p | string replace "~" "$HOME")
        _cd $indexed_path
    else if string match -arq -- "^-[0-9]+\$" "$argv[1]"
        # use `_cd -N` to go to the Nth directory in history (swapping)
        set n (string sub -s2 -l1 -- $argv[1])
        set indexed_path (_cd -p | sed -n (math $n+1)p | string replace "~" "$HOME")
        # remove this occurrence
        set dirstack (echo $dirstack | tr ' ' '\n' | sed (string join "" $n "d"))
        # move
        _cd $indexed_path
    else if string match -arq -- "^\+[0-9]+\$" "$argv[1]"
        # use `_cd +N` to go n directories back in history (popping)
        for i in (seq 1 (string sub -s 2 -- $argv[1]))
            popd > /dev/null
        end

    else if [ "$argv[1]" = "..." ]
        builtin cd ..
        builtin cd ..;

    else if [ "$argv[1]" = "--" ]
        # use `_cd -- <path>` if your path begins with a dash
        pushd -- "$argv[2]" > /dev/null;
    else
        # basic case: move to a dir and add it to history
        if [ $argv[1] != '.' -a $argv[1] != $PWD -a -d $argv[1] ]
            pushd "$argv" > /dev/null;
        else
            builtin cd "$argv"
        end

    end
end

# replace standard `cd` with enhanced version, ensure tab-completion works
# FIX: replace "cd" in /usr/share/fish/functions/{popd,pushd}.fish by "builtin cd"
alias cd=_cd
complete -c _cd -w cd

alias xs='cd'
alias cdl='cd -l'
alias d='cd -l'
alias cd-='cd -'

set PX "$HOME/main"
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
function cdlk;  cd (dirname (readlink $argv[1])); end
function grepurl; sed -e  's/.*[hH][rR][eE][fF]=['\"''\'']\([^'\"''\'']*\)['\"''\''].*/\1/' $argv[1]; end
alias mean="awk '{s+=$argv}END{print \"ave:\",s/NR}' RS=\" \""

function r
    # Check for minimum number of arguments
    if test (count $argv) -lt 1
        echo "Usage: r <remote_destination> [rsync_options]"
        return 1
    end

    # Extract the destination, which is the last argument
    set -l destination $argv[-1]

    # Validate the destination format
    if not string match -q '*@*:*' $destination
        echo "Invalid remote destination format. It should contain '@' and ':' characters."
        return 1
    end

    # Remove the destination from the arguments list to isolate rsync options
    set -e argv[-1]

    # Build the rsync command with optional parameters
    rsync -avz --delete --exclude-from=".gitignore" --exclude="*.swp" --exclude "venv/**" --exclude "data/**" --exclude "results/**" $argv (pwd) $destination
end

#alias xrandr_setup="xrandr --output LVDS-1 --right-of VGA-1"
#alias xrandr_setup="xrandr --output HDMI-2 --left-of eDP-1"
alias xrandr_setup="xrandr --output DP-2-1 --left-of eDP-1"

alias amatop='elinks http://zombie-dust.imag.fr:8000/'
#alias amatop='w3m http://zombie-dust.imag.fr:8000/'
alias grid='elinks http://localhost/grid.html'
alias gg="grid"

function pdfcut
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    command gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
        -dFirstPage=$argv[1] \
        -dLastPage=$argv[2] \
        -sOutputFile=(string split '.pdf' $argv[3])_p$argv[1]-p$argv[2].pdf \
        $argv[3]
end

function pdfjoin
    pdftk "$argv[1]" "$argv[2]" cat output (basename $argv[1] .pdf)(basename $argv[2] .pdf).pdf
end

function pdfgrey
    command gs \
    -sOutputFile=(string split '.pdf' $argv[1])_grey.pdf \
    -sDEVICE=pdfwrite \
    -sColorConversionStrategy=Gray \
    -dProcessColorModel=/DeviceGray \
    -dCompatibilityLevel=1.4 \
    -dNOPAUSE \
    -dBATCH \
    $argv[1]
end

function pdfcompress 
    command gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=(string split '.pdf' $argv[1])_compressed.pdf $argv[1]
end


alias x='xmms2'
alias xl='xmms2 list'
alias xls='xmms2 list | command grep --color -C 15 "\->"'
alias xrm='xmms2 remove (xmms2 list | grep --color=never "\->"| grep --color=never -o "\[.*/" | grep -wo "[0-9]*") && xmms2 next'
alias xp='xmms2 toggle'
alias xn='xmms2 next'
alias xj='xmms2 jump'
alias xpl='xmms2 playlist list'
function xplc;  xmms2 playlist create $argv[1] && xmms2 playlist switch $argv[1]; end
alias xpll='xmms2 playlist switch'
alias xseek='xmms2 seek'
alias xs='xmms2 seek +25'
alias xss='xmms2 status'
alias xrpone='xmms2 server config playlist.repeat_one 1'
alias xrpall='xmms2 server config playlist.repeat_all 1'
alias xrpclr='xmms2 server config playlist.repeat_one  0; xmms2 server config playlist.repeat_all 0'
alias xcd='cd (xmms2 info | grep file:// |cut -d: -f2  |xargs -0 dirname |python3 -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")'
alias xll='ls (xmms2 info | grep file:// |cut -d: -f2  |xargs -0 dirname |python3 -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")'
alias youtube-dl="yt-dlp"
function xshuff
    # Add random files in xmms2
    if [ "$argv[1]" = "" ]
        set NBF 50
        set Path "$HOME/Music/"
    else if [ -d "$argv[1]" ]
        set NBF 50
        set Path "$argv[1]"
    else
        set NBF $argv[1]
        set Path "$HOME/Music/"
    end

    set fls (find "$Path" -type f -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.mp3" -o -iname "*.flac")
    set NB (string split "\n" -- $fls | count)

    set RANDL (python3 -c "import sys, random, time;\
        random.seed(int(time.time()));\
        nbf = min($NB, $NBF);\
        sys.stdout.write(' '.join(map(str, random.sample(range(1,$NB+1), nbf))))")
    set RANDN ""
    for IR in (string split ' ' $RANDL)
        set RANDN "$IR""p;$RANDN"
    end
    set Songs (printf '%s\n' $fls | sed -n "$RANDN")
    xmms2 playlist switch temp
    xmms2 clear
    printf '%s\n' $Songs | xargs -I {} -d "\n" xmms2 add "{}"
    xmms2 jump 1 && xmms2 play
end

function fip 
    vlc -I curses "https://stream.radiofrance.fr/fip/fip_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipjazz/fipjazz_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fiphiphop/fiphiphop_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipelectro/fipelectro_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipreggae/fipreggae_hifi.m3u8?id=radiofrance" "https://stream.radiofrance.fr/fipgroove/fipgroove_hifi.m3u8?id=radiofrance"
end
function fip2
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
end

alias katai-struct-compiler='kaitai-struct-compiler -no-version-check'

alias bash='command env BASH_EXECUTION_STRING=1 bash'
alias iumm='bash --init-file (echo "source ~/.bash_profile; cd $HOME/src/config/app/mm/ && set +o history && unset HISTFILE"|psub)'
alias mc='bash -c "mc"'

function git_commit_branch_mr
    if test (count $argv) -ne 2
        echo "Usage: git_commit_branch_mr <branch_name> <commit_message>"
        return 1
    end

    set -l branch_name $argv[1]
    set -l commit_message $argv[2]

    git checkout -b (string lower $branch_name) \
        && git commit -am $commit_message \
        && git push origin (string lower $branch_name)
end

setxkbmap -option "nbsp:none"
