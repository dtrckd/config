function serve
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
alias tree="tree -C"
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
alias please='sudo (fc -ln -1)'
alias so='source ~/.config/fish/config.fish'
alias whoisssd='lsblk  -d -o name,rota'
alias python="python -O" # basic optimizatio (ignore assert, ..)
#alias ipython="python -m IPython"
alias ipython="ipython --colors linux"
alias ipython_dev="ipython --colors linux --profile dev"
alias py='python'
alias py3='python3'
alias nb="jupyter-notebook --ip 127.0.0.1"
alias nb_np='jupyter-notebook --ip 127.0.0.1 ~/Desktop/workInProgress/networkofgraphs/process/notebook/ '
alias ppath_python='export PYTHONPATH=$PYTHONPATH:(pwd)'
alias xback='xbacklight'
alias bb="[ -f tmux.sh ] && ./tmux.sh || tmux ls 1>/dev/null 2>/dev/null && tmux attach || tmux"
alias cc="cat"
alias vdiff='vimdiff'
alias vidiff='vimdiff'
alias vid='vimdiff'
alias vip='vim -p'
alias vis='vim -S'  
alias evc="evince"
alias tu="htop -u $USER"
alias t="htop"
alias diffd="diff -rq $1 $2" # show difference files between dir$1 and dir$2
alias mvspace="rename 's/ /_/g'"
alias torb="sh -c \"$HOME/src/config/app/tor-browser_en-US/Browser/start-tor-browser\" --detach"
function pdf; evince $argv[1] 2>/dev/null &; end
function pdfo; okular $argv[1] 2>/dev/null &; end
alias vib="vim ~/.bash_profile"
alias vif="vim ~/.config/fish/aliases.fish"
alias vimrc="vim ~/.vimrc"
alias vimtmux="vim ~/.tmux.conf"

alias vi='vim'
alias ci='vim'
alias vcal='vim -c "Calendar -view=month"' # get calendar
alias vitodo='vim -p (find -iname todo -type f)'

set _PWD "/home/ama/adulac/workInProgress/networkofgraphs/process/repo/ml/"
set _NDL "$HOME/src/config/configure/nodeslist"
alias para="parallel -u --sshloginfile $_NDL --workdir $_PWD -C ' ' --eta --progress --env OMP_NUM_THREADS {}"


alias psa="ps -aux | grep -i --color"
alias pstree='pstree -h'
alias rmf='shred -zuv -n1'
alias latex2html='latex2html -split 0 -show_section_numbers -local_icons -no_navigation'
alias eog='ristretto'
function f; find -name "*$argv[1]*"; end # fuzzy match
function ff; find -name "$argv[1]"; end # exact match
alias jerr='journalctl -p err -b'
alias curlH='curl -I'
alias myip='curl https://tools.aquilenet.fr/ip/ && echo'
alias netl='netstat -plant'
alias netp='netstat -plant | grep -i stab | awk -F/ "{print \$2 \$3}" | sort | uniq'
alias fetch_debian='wget https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-xfce-CD-1.iso'
alias grepr='grep -R'
alias grepy='find -iname "*.py" | xargs grep --color -n'
alias grepyx='find -iname "*.pyx" | xargs grep --color -n'
alias grepxd='find -iname "*.pxd" | xargs grep --color -n'
alias ag='ag-mcphail.ag --color-path 32 --color-match "1;40;36"'
alias agy='ag --py'
alias ago='ag --go'
alias agj='ag --js --ignore node_modules/'
alias fzf='fzf-slowday.fzf'
alias ctr='systemctl'
alias locks='systemctl suspend -i'
alias dodo='systemctl hibernate'
alias halt='systemctl poweroff'
alias ls-service='ctr -t service --state running'
alias ls-masked-unit='ctr --state masked' # systemctl list-unit-files | grep masked
alias ls-failed-unit='ctr --state failed' # systemctl --failed
alias octave='octave --silent'

function vims
    set SessionID (basename (dirname $PWD))-(basename $PWD)
    if [ -f "$HOME/.vim/sessions/$SessionID.vim" ]
        vim -c "OpenSession $SessionID"
    else
        echo "no vim session file found for $SessionID."
    end
end

# Old vims but still useful
function vimss
    set file ".session.vim"
    if [ -n "$argv[1]" ]
        file=.$argv[1]$file
    end
    vim -c "source $file" -S ~/.vimrc 
end

function upgrademe
    aptitude update && aptitude upgrade
    brew update && brew upgrade
    pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
    npm update
    vim -c "UpdatePlugin"
end

alias gitupdate='git remote update'
alias gitg='/bin/gitg --all 1>/dev/null &'
alias gitk='/bin/gitk &'
alias gitb='git branch -av'
alias gits='git status -sb'
alias gitr='git remote -v'
alias gitamend='git commit -a --amend'
alias gitcommit='git commit -am'
alias gitl="git log --format='%C(yellow)%d%Creset %Cgreen%h%Creset %Cblue%ad%Creset %C(cyan)%an%Creset  : %s  ' --graph --date=short  --all"
alias gitll="git log --format='%C(yellow)%d%Creset %Cgreen%h%Creset %Cblue%ad%Creset %C(cyan)%an%Creset  : %s  ' --graph --date=short"
alias gitlt="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitfilelog="git log --pretty=oneline -u dotfiles/.vimrc"
alias gitstash="git stash list"
alias git_excludf='git update-index --assume-unchanged'
function gitcpush; git commit -am $argv[1] && git push; end
function lsgit 
    for d in (find -type d -name ".git" | sed 's/\.git$//' );
        echo $d
        git -C "$d" status -svb
        echo
    end
end
function gitls
    set branch (git rev-parse --abbrev-ref HEAD)
    if [ -n $argv[1] ]
        set branch $argv[1]
    end
    git ls-tree -r $branch --name-only
end

function  gitchecklasttag
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
    git diff  HEAD~$argv[1]..HEAD -- $2
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
    File="$argv[1]"
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

function convert_grey
    gs \
        -sOutputFile=(string split '.pdf' $argv[1]).pdf \
    -sDEVICE=pdfwrite \
    -sColorConversionStrategy=Gray \
    -dProcessColorModel=/DeviceGray \
    -dCompatibilityLevel=1.4 \
    -dNOPAUSE \
    -dBATCH \
    $argv[1]
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

alias sshb='autossh -D 1080 -p 24 vpn@vpn.vapwn.fr'
alias sshtmr='autossh -D 1090 vpn@163.172.45.128'
alias sshmachine='autossh green@82.251.4.205'
alias sshchocobo='autossh bomberman@51.15.89.180'

if [ -d $HOME/src/config/credentials/ ]; 
    alias neocities="env NEOCITIES_KEY=(cat $HOME/src/config/credentials/adrien-dulac.neocities) neocities"
    #alias neocities="NEOCITIES_KEY=(cat $HOME/src/config/credentials/pymake.neocities) neocities"
end

alias tmr='python3 -m tm manager'

### cd alias
set PX "$HOME/workInProgress"
alias xs='cd'
alias cdp="cd $HOME/workInProgress/webmain/web/go/fractal"
alias iu="cd $PX"
alias ium="cd $HOME/Music/"
alias iuc="cd $HOME/src/config/"
alias iucs="cd $HOME/src/config/snippets"
alias iut="cd $HOME/Desktop/tt/"
alias iuk="cd $PX/networkofgraphs/missions" # mission / kaggle / etc
alias iunb="cd $PX/networkofgraphs/process/notebook/"
alias iup="cd $PX/networkofgraphs/process/pymake/pymake/"
alias iurp="cd $PX/networkofgraphs/process/repo/"
alias iupp="cd $PX/networkofgraphs/process/repo/ml/"
alias iudoc="cd $PX/networkofgraphs/process/repo/docsearch/"
alias iutt="cd $PX/networkofgraphs/papers/personal/relational_models/thesis/manuscript/source/"
alias iub="cd $PX/BaseBlue/"
alias iubb="cd $PX/BaseBlue/bhp/bhp"
alias iudd="cd $PX/BaseBlue/bhp/data"
alias iuww="cd $PX/BaseBlue/bhp/wiki"
alias iuds="cd $PX/BaseBlue/designspec/"
alias iutm="cd $PX/BaseBlue/tmr/tm"
alias iug="cd $PX/BaseBlue/grator/pnp"
alias iucm="cd $PX/BaseDump/bots/skopai/common/"
alias iux="cd $PX/BaseDump/bots/skopai/skopy"
alias iubg="cd $PX/BaseDump/bots/skopai/bigbangsearch"
alias iuw="cd $PX/webmain/"
alias iumd="cd $PX/webmain/mixtures/md"
alias iuscrapy="cd $HOME/.local/lib/python3.7/site-packages/scrapy/"
alias cdoc="cd $PX/SC/Projects/hack-dir/doc"
alias cdia="cd $PX/SC/Projects/hack-dir/IA"
alias iud="cd $PX/PlanD/"
alias cdpapers="cd $PX/networkofgraphs/papers"
alias cdwww="cd $PX/SC/Projects/Informatique/Reseau/www"
alias cdsys="cd $PX/SC/Projects/Informatique/System"
alias cdrez="cd $PX/SC/Projects/Informatique/Reseau/"
alias cdid="cd $PX/SC/Papiers/idh/id_ad/"
alias xrandr_setup="xrandr --output LVDS-1 --right-of VGA-1"
function cdlk;  cd (dirname (readlink $argv[1])); end
function grepurl; cat $argv[1] | grep -o '[hrefHREF]=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^[hrefHREF]=["'"'"']//' -e 's/["'"'"']$//'; end
alias mean="awk '{s+=$1}END{print \"ave:\",s/NR}' RS=\" \""

alias amatop='elinks http://zombie-dust.imag.fr:8000/'
#alias amatop='w3m http://zombie-dust.imag.fr:8000/'
alias grid='elinks http://localhost/grid.html'
alias gg="grid"

function pdfjoin
    pdftk "$argv[1]" "$2" cat output (basename $argv[1] .pdf)(basename $2 .pdf).pdf
end

alias x='xmms2'
alias xinfo='xmms2 info'
alias xl='xmms2 list'
alias xls='xmms2 list | command grep --color -C 15 "\->"'
alias xrm='xmms2 remove (xmms2 list | grep "\->"| grep -o "\[.*/" | grep -wo "[0-9]*") && xmms2 next'
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
alias xadd='xmms2 add "`xmms2 info | grep file:// | cut -d: -f2  | xargs -0 dirname`"'
alias xcd='cd (xmms2 info | grep file:// |cut -d: -f2  |xargs -0 dirname |python3 -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")'
alias xll='ls (xmms2 info | grep file:// |cut -d: -f2  |xargs -0 dirname |python3 -c "import sys,urllib.parse;sys.stdout.write(urllib.parse.unquote_plus(sys.stdin.read()))")'
function xshuff
    # Add random files in xmms2
    if [ "$argv[1]" = "" ]
        set NB 50
        set Path "$HOME/Music/"
    else if [ -d "$argv[1]" ]
        set NBF 50
        set Path "$argv[1]"
    else
        set NBF $argv[1]
        set Path "$HOME/Music/"
    end

    set fls (find "$Path" -type f -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.mp3" -o -iname "*.flac")
    set NB (printf '%s\n' $fls | wc -l)

    set RANDL (python3 -c "import sys;import random;\
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

alias katai-struct-compiler='kaitai-struct-compiler -no-version-check'

alias to_qwerty='setxkbmap us' # QWERTY
alias to_azerty='setxkbmap fr' # AZERTY

alias bash='command env BASH_EXECUTION_STRING=1 bash'
alias iumm='bash --init-file (echo "source ~/.bash_profile; cd $HOME/src/config/app/mm/ && set +o history && unset HISTFILE"|psub)'
alias mc='bash -c "mc"'
