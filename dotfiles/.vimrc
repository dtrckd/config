runtime! debian.vim

""""""""""""""""""""""""""""""
""" Vundle
""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
call vundle#end()            " required
filetype plugin indent on    " required
""" Plugin
Plugin 'tpope/vim-surround'
Plugin 'luochen1990/rainbow'
Plugin 'a.vim'
Plugin 'Align'
Plugin 'taglist.vim'
Plugin 'mileszs/ack.vim'
"Plugin 'rargo/vim-line-jump'
"Plugin 'sirver/ultisnips' ' py >=2.7
"Plugin rstacruz/sparkup  # Zn writing HTLM
"msanders/snipmate.vim  # tons of snippet
Plugin 'majutsushi/tagbar'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'troydm/zoomwintab.vim'
Plugin 'gotcha/vimpdb'
Plugin 'itchyny/calendar.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plugin 'klen/python-mode'
"Plugin 'cecutil'
Plugin 'TeTrIs.vim'
Plugin 'uguu-org/vim-matrix-screensaver'
Plugin 'darkburn'
Plugin 'dracula/vim'
Plugin 'jnurmine/zenburn'
"Plugin 'yhat/vim-docstring'
"Plugin 'mozilla/doctorjs' " for javascript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:easytags_updatetime_min = 180000
let g:easytags_auto_update = 0
let g:SuperTabNoCompleteAfter = ['^', '\s', '#', "'", '"', '%', '/']
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:ackprg = 'ag --vimgrep'
" wget the dict at http://ftp.vim.org/vim/runtime/spell/
""" Activate vim-docstring
"autocmd FileType python PyDocHide
let g:rainbow_conf = {
            \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
            \   'ctermfgs': ['white','lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
            \   'operators': '_,_',
            \   'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
            \   'separately': {
            \       '*': {},
            \       'lisp': {
            \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
            \           'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan', 'darkred', 'darkgreen'],
            \       },
            \       'vim': {
            \           'parentheses': [['fu\w* \s*.*)','endfu\w*'], ['for','endfor'], ['while', 'endwhile'], ['if','_elseif\|else_','endif'], ['(',')'], ['\[','\]'], ['{','}']],
            \       },
            \       'tex': {
            \           'parentheses': [['(',')'], ['\[','\]'], ['\\begin{.*}','\\end{.*}']],
            \       },
            \       'html': {
            \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
            \       },
            \       'css': 0,
            \       'stylus': 0,
            \   }
            \}

"" Compilation & Taglist ! Great
let g:easytags_cmd = '/usr/bin/ctags'
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_WinWidth = 30
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
noremap <Leader>to :TlistAddFiles %<CR>
noremap <C-p> :TlistToggle<CR>
noremap <C-m> :TagbarToggle<CR>
noremap <Leader>tup :TlistUpdate<CR>
noremap <Leader>mctags :!/usr/bin/ctags -R  --fields=+iaS --extra=+q .<CR>
noremap <Leader>mctags :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>


"" fugitive git bindings
"nnoremap <space>ga :Git add %:p<CR><CR>
"nnoremap <space>gs :Gstatus<CR>
"nnoremap <space>gc :Gcommit -v -q<CR>
"nnoremap <space>gt :Gcommit -v -q %:p<CR>
nnoremap <leader>gd :Gdiff<CR>
"nnoremap <space>ge :Gedit<CR>
"nnoremap <space>gr :Gread<CR>
"nnoremap <space>gw :Gwrite<CR><CR>
"nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
"nnoremap <space>gp :Ggrep<Space>
"nnoremap <space>gm :Gmove<Space>
"nnoremap <space>gb :Git branch<Space>
"nnoremap <space>go :Git checkout<Space>
"nnoremap <space>gps :VimProcBang git push<CR>
"nnoremap <space>gpl :VimProcBang git pull<CR>


function! GitBranch()
    let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    if branch != ''
        return ' ' . substitute(branch, '\n', '', 'g')
    en  
    return ''
endfunction

function! LastDir()
    let dir = split(getcwd(), '/')[-1]
    return dir
endfunction

""""""""""""""""""""""""""""""
""" General / Interface
""""""""""""""""""""""""""""""
syntax on
"set clipboard=unnamed " dont support C-S V
"set title "update window title for X and tmux
set ruler		"show current position 
set laststatus=2
set statusline=%{LastDir()}/%f%m\ %r\ %h\ %w\%{GitBranch()}\ %=%l/%L:%c\ %015(%p%%%)%<
"set statusline=%<%f%m\ %r\ %h\ %w\%{GitBranch()}\ %=%l/%L:%c\ %015(%p%%%)
set mat=1 "How many tenths of a second to blink
set vb                                  " no beep, visualbell
set showcmd                             " Show (partial) command in status line.
set showmatch                           " Show matching brackets
set wildmenu                            " show list instead of just completing
set hlsearch                            " hilighting resarch matches
                                        " hi Search ctermfg=10 ctermbg=Black            " comment
set incsearch                           " Incremental search
set ignorecase                          " Do case insensitive matching
set smartcase                           " sensitive if capital letter
set report=0                            " show number of modification if they are
"set nu                                  " View numbers lines
set cursorline                         " hilight current line - cul
"set autowrite                          " Automatically save before commands like :next and :make
"set hidden                             " Hide buffers when they are abandoned
"set mouse=a                            " Enable mouse usage (all modes) in terminals
"set textwidth=0                         " disable textwith
set fo+=1cro fo-=t tw=70 " break comment at tw $size
"set colorcolumn=-1
set scrolloff=4                         " visible line at the top or bottom from cursor
set linebreak                           " don't wrap word
"set nowrap                             " don't wrap line too long
set nostartofline                       " try keep the column with line moves
set whichwrap=<,>,[,]                   " enable line return with pad
"set ff=unix                            " remove ^M
"set termencoding=UTF-8
set encoding=utf-8
" Don't use Ex mode, use Q for formatting
map Q gq
""" Last position
if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""""""""""""""""""""""""""""""
""" Tabulations / Indentation
""""""""""""""""""""""""""""""
set expandtab
set softtabstop=4 
set shiftwidth=4
set tabstop=4
"set preserveindent " ?
set smarttab " trivial

set autoindent "keep indentation over line
set cindent 
set smartindent 

set foldmethod=indent 
set nofen               " open all folds. see z[mn] command

""""""""""""""""""""""""""""""
""" Mapping / MOVES
""""""""""""""""""""""""""""""
""" general
imap <C-L> <Esc>
"nnoremap ; : 
let mapleader = ','
""" Saving
"nnoremap <C-u> :w<CR>
"imap <C-u> <C-o><C-u>
""" Navigate
noremap <F4> :tabe %<CR>
""" Folding
"noremap zR " Open all folds
"noremap zM " close all folds
"" Window
nnoremap <S-UP> <C-W>k
nnoremap <S-DOWN> <C-W>j
nnoremap <S-LEFT> <C-W>h
nnoremap <S-RIGHT> <C-W>l
noremap <A-UP> <C-W>10+
noremap <A-DOWN> <C-W>10-
noremap <A-LEFT> <C-W>10<
noremap <A-RIGHT> <C-W>10>
"set <Debut>=^[[1;5D
"set <FIN>=^[[1;5C
"map <DEBUT> 8<UP>
"map <FIN> 8<DOWN>
"nnoremap <S-PageUp> <C-W>k " can't work...
"nnoremap <S-PageDown> <C-W>j
" TAB
nnoremap <C-UP> gT
noremap <C-DOWN> <ESC>:tabn<CR>
noremap <C-DOWN> <ESC>:tabN<CR>
nnoremap <C-DOWN> gt
""" Insert Mode
imap <C-a> <Esc>^^i
imap <C-e> <Esc>$a
""" Command Mode
cnoremap $h e ~/
cnoremap $e e %:p:h
cnoremap $t tabe %:p:h
cnoremap $s split %:p:h
cnoremap $v vs %:p:h
""" Mouse map
"nnoremap <2-LeftMouse> //
"cno sm set mouse=
"""" Edit
nmap <silent> dw diwi
nmap <silent> da diWa
" indent under block, and come back (zo?)
noremap <Tab>= <S-v>)=''    
""" Info Tag
nnoremap tf :TlistShowTag<CR>
nnoremap tc :TagbarShowTag<CR>
" toggle wrap line
nmap <leader>, :windo set wrap!<CR> 
" save session
nmap <leader>ss :mks! .session.vim<CR> 

" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


""""""""""""""""""""""""""""""
"""" => Conf Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.*rc set tw=0
""""""""""""""""""""""""""""""
""" => Makefile
""""""""""""""""""""""""""""""
au Filetype tex map <leader>m :!make<cr>
au Filetype make map <leader>m :!make<cr>
""""""""""""""""""""""""""""""
"""" => Python Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
au BufNewFile,BufRead *.py set formatoptions-=tc " prevent inserting \n. Where does it come from ????

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
" for tab invisible bug (caused by set paste); try :%retab

" manage indentation error...
" set list (list!) " see the tabulation ^I
" retab " move tab in space according to tabstop

"au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod u+x <afile> | endif | endif
au BufNewFile,BufWritePost *.sh,*.py,*.m,*.gnu,*.nse silent !chmod u+x <afile>
autocmd BufNewFile,BufRead *.nse set filetype=lua    
""""""""""""""""""""""""""""""
"""" => Latex Files
""""""""""""""""""""""""""""""
au Filetype tex set mouse=a
au Filetype tex set wrap
au BufRead,BufNewFile *.md set filetype=markdown 
au BufRead,BufNewFile *.md set mouse=
au BufRead,BufNewFile *.md set wrap

""""""""""""""""""""""""""""""
"""" => Gnuplot Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.plt,*.gnuplot,*.gnu set filetype=gnuplot
"au BufNewFile,BufRead *.gnu set filetype=gnuplot

""""""""""""""""""""""""""""""
"""" => C, Java Files
""""""""""""""""""""""""""""""
au filetype cpp, java  set ts=8 sts=8 sw=8
au filetype cpp set fdm=syntax
"au filetype cpp set cinoptions=>s,e0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,U0,w0,j0,)20,*30

"""switch header <-> .c # or a.vim
map <Leader>h <ESC>:AV<CR>
map <Leader>ht <ESC>:AT<CR>
"map <leader>h :vs %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
""""""""""""""""""""""""""""""
"""" => HTML Files
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.load set filetype=html
au Filetype html :call TextEnableCodeSnip('python', '{{#py', '}}', 'SpecialComment')
" Comment 
au Filetype html nmap # :s/\([^ ].*\)$/<!--\1-->/<CR>:noh<CR>
au Filetype html nmap ~ :s/<!--\(.*\)-->/\1/<CR>:noh<CR>
au BufNewFile,BufRead *.css nmap # :s/\([^ ].*\)$/\/\*\1\*\//<CR>:noh<CR>
au BufNewFile,BufRead *.css nmap ~ :s/\/\*\(.*\)\*\//\1/<CR>:noh<CR>
au BufNewFile,BufRead  *.html,*.css set tabstop=2 softtabstop=2 shiftwidth=2 nowrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
map <leader>ssfr :setlocal spell! spelllang=fr<cr>

"Shortcuts using <leader>
"nmap z] ]s
"nmap z[ [s
map <leader>sa zg
map <leader>s? z=
map <leader>w z=  " correct the previous word @TODO

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Calendar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Setup
""" Itchyny Calendar
"let pp = '~/Desktop/workInProgress/.diary/'
"let g:calendar_diary = expand(pp)
"let g:calendar_cache_directory = expand(pp)
let g:calendar_first_day = 'monday'
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1

" Week's day colors
"autocmd FileType calendar call calendar#color#syntax('Saturday', has('gui') ? '#ff0000' : 'blue', 'black', '')
"autocmd FileType calendar call calendar#color#syntax('Sunday', has('gui') ? '#ff0000' : 196, 'black', '')
"
"autocmd FileType calendar hi! link CalendarSunday Normal
"autocmd FileType calendar hi! link CalendarTodaySunday Normal

"" Color Workaround
autocmd FileType calendar if !has('gui_running') | set t_Co=256 | endif

""""""""""""""""""""""""""""""
"""" => Snippet
""""""""""""""""""""""""""""""

""" Template
"http://vim.wikia.com/wiki/Different_syntax_highlighting_within_regions_of_a_file
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

"call TextEnableCodeSnip(  'c',   '@begin=c@',   '@end=c@', 'SpecialComment')
"call TextEnableCodeSnip('cpp', '@begin=cpp@', '@end=cpp@', 'SpecialComment')
"call TextEnableCodeSnip('sql', '@begin=sql@', '@end=sql@', 'SpecialComment')


""" Reset Session
fu! ResetSession()
    if filereadable(getcwd() . '/.session.vim')
        execute 'so ' . getcwd() . '/.session.vim'
        if bufexists(1)
            for l in range(1, bufnr('$'))
                if bufwinnr(l) == -1
                    exec 'sbuffer ' . l
                endif
            endfor
        endif
    endif
    syntax on
endfunction
com! ResetSession :call ResetSession()

""" Workaround for the refresh problem (partial)!
fu! RedrawTab()
    execute  'redraw'
endfunction
com! RedrawTab :call RedrawTab()


"""""""""" Colorized it.
" ~/.vimrc
" Make Vim recognize XTerm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
    " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
    execute "set t_kP=\e[5;*~"
    execute "set t_kN=\e[6;*~"

    " Arrow keys http://unix.stackexchange.com/a/34723
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
if &term =~ '256color'
    "disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif
"set term=rxvt-unicode-256color
"set term=xterm-256color
"set term=screen-256color "TERM=xterm-256color
"set t_Co=256
"
"colorscheme default " Utiliser le jeu de couleurs standard"
"colo 256-grayvim
"colo solarized
"colorscheme molokai
"colo sweyla682066
"colo zenburn
"colo darkburn 
colo dracula
"colo hipster

""" Custom Colors
hi Search guifg=#000000 guibg=#8dabcd guisp=#8dabcd gui=NONE ctermfg=NONE ctermbg=110 cterm=NONE
hi Comment ctermfg=blue
"hi Comment guifg=DarkGrey ctermfg=brown " like; green, white, brown, cyan(=string)

hi TabLineSel ctermfg=Blue ctermbg=Green
hi TabLine ctermfg=0 ctermbg=7

"set background=dark

map <Esc>[B <Down>
noh

""" refresh !?
"set ttimeoutlen=100
set ttyfast
"set lazyredraw

