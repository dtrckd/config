runtime! debian.vim
let mapleader = ','


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
Plugin 'majutsushi/tagbar'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'gotcha/vimpdb'
"Plugin 'yhat/vim-docstring'
"Plugin 'mozilla/doctorjs' " for javascript

" File and code Search
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'mileszs/ack.vim'
"Plugin 'alok/notational-fzf-vim'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Linting
Plugin 'dense-analysis/ale'
"Plugin 'vim-syntastic/syntastic'

" Code completion
Plugin 'ycm-core/YouCompleteMe'
"Plugin 'ajh17/VimCompletesMe'
""Plugin 'maxboisvert/vim-simple-complete'
"Plugin 'ervandew/supertab'

" File Format / Extra Language
Plugin 'posva/vim-vue' " syntaxic coloration for Vue.js
Plugin 'elmcast/elm-vim' " Vim plugin for Elm
Plugin 'rhysd/vim-crystal' " Vim plugin for Crystal
Plugin 'jparise/vim-graphql'
"Plugin 'fatih/vim-go' " use ale and revivre instead

" fix markdown highlight
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Misc
Plugin 'xolox/vim-session'
Plugin 'itchyny/calendar.vim'
"Plugin 'troydm/zoomwintab.vim'
Plugin 'dhruvasagar/vim-zoom'
Plugin 'ciaranm/detectindent'
Plugin 'editorconfig/editorconfig-vim' " Read .editorconfig in project
"Plugin 'jceb/vim-orgmode'
"Plugin 'cskeeters/vim-smooth-scroll'   " interesting scroll property
"Plugin 'rargo/vim-line-jump'
"Plugin 'sirver/ultisnips' ' py >=2.7
"Plugin rstacruz/sparkup  # Zn writing HTLM
"msanders/snipmate.vim  # tons of snippet

" Theme
Plugin 'darkburn'
Plugin 'uguu-org/vim-matrix-screensaver'
Plugin 'jnurmine/zenburn'
Plugin 'dracula/vim'
Plugin 'rakr/vim-one'

"""""""""""""""""""""""""""
"""" Plugin conf
"""""""""""""""""""""""""""

""" Editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

""" go-vim
" intall dependancuse with (if not it stucks!)  :GoInstallBinaries
let g:go_fmt_command = "goimports"

""" Autocompletion
"let g:loaded_youcompleteme = 1
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
"
let g:SuperTabNoCompleteAfter = ['^', '\s', '#', "'", '"', '%', '/']
let g:SuperTabClosePreviewOnPopupClose = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
" Disable popu preview (dont fakin work !)
"let g:ycm_auto_hover = ""
"let g:ycm_add_preview_to_completeopt = 0
"set completeopt-=preview
"let g:ycm_disable_signature_help=1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " more general but wont be able to switch/scroll the preview...
autocmd FileType vim let b:vcm_tab_complete = 'vim'
let g:ycm_semantic_triggers = { 'elm' : ['.'], }

""" ctags
let g:easytags_updatetime_min = 180000
let g:easytags_auto_update = 0

""" NerdTree
:let g:NERDTreeWinSize=22
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.swp$']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"let NERDTreeMinimalUI = 1
"let NERDTreeDirArrows = 1
"let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
"let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
"let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
"let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
"autocmd FileType nerdtree setlocal signcolumn=no

""" Similar behaviour than ToggleTagBar
function! NERDTreeToggleFind()
    if g:NERDTree.IsOpen()
        execute ':NERDTreeClose'
    else
        execute ':NERDTreeFind'
    endif
endfunction

"noremap <TAB><TAB> :NERDTreeToggle<CR> " Problem with <C-i> that get map and delayed
nnoremap <C-p> :call NERDTreeToggleFind()<cr>
noremap <leader>f :NERDTreeFind<cr>


""" ACK/AG (use AG!)
let g:ackprg = 'ag --smart-case'
cnoreabbrev ag Ack
cnoreabbrev ack Ack
"noremap <leader>s :Ack! "<cword>"<cr>
nnoremap <silent> <Leader>z :Ack <C-R><C-W><CR>

""" Rainbow colors
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
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
" wget the dict at http://ftp.vim.org/vim/runtime/spell/
""" Activate vim-docstring
"autocmd FileType python PyDocHide

""" vim-session
" Don't save hidden and unloaded buffers in sessions.
set sessionoptions-=buffers
set sessionoptions-=help " dont want help windows to be restored
let g:session_autoload = 'yes' " see https://github.com/xolox/vim-session
let g:session_autosave = 'no' " save on quit
let g:session_autosave_periodic = 120 " minutes
let g:session_autosave_silent = 1 " true
let g:session_default_overwrite = 1 " every Vim instance without an explicit session loaded will overwrite the 'default' session (the last Vim instance wins).

"" Compilation & Tagbar ! Great
let g:easytags_cmd = '/usr/bin/ctags'
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_WinWidth = 30
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
noremap <Leader>to :TlistAddFiles %<CR>
noremap <C-n> :TlistToggle<CR>
noremap <C-m> :TagbarToggle<CR>
noremap <Leader>tup :TlistUpdate<CR>
noremap <Leader>mctags :!/usr/bin/ctags -R  --fields=+iaS --extra=+q .<CR>
noremap <Leader>mctags :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" tagbar of taglist, ???
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_singleclick = 1
let g:tagbar_autofocus = 1
nnoremap tf :TlistShowTag<CR>
nnoremap tc :TagbarShowTag<CR>

" Markdown tagbar
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : $HOME.'/.local/bin/markdown2ctags',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" Makefile tagbar
let g:tagbar_type_make = { 'kinds':[ 'm:macros', 't:targets' ] }


"let g:tagbar_type_javascript = {
"      \ 'ctagstype': 'javascript',
"      \ 'kinds': [
"      \ 'A:arrays',
"      \ 'P:properties',
"      \ 'T:tags',
"      \ 'O:objects',
"      \ 'G:generator functions',
"      \ 'F:functions',
"      \ 'C:constructors/classes',
"      \ 'M:methods',
"      "\ 'V:variables',
"      \ 'I:imports',
"      \ 'E:exports',
"      \ 'S:styled components'
"      \ ]}

" Elm tagbar
let g:tagbar_type_elm = {
      \ 'kinds' : [
      \ 'f:function:0:0',
      \ 'm:modules:0:0',
      \ 'i:imports:1:0',
      \ 't:types:1:0',
      \ 'a:type aliases:0:0',
      \ 'c:type constructors:0:0',
      \ 'p:ports:0:0',
      \ 's:functions:0:0',
      \ ]
      \}

" CSS tagbar
let g:tagbar_type_scss = {
      \ 'kinds' : [
      \ 'f:function:0:0',
      \ 'm:mixin:0:0',
      \ 't:tag:0:0',
      \ 'i:id:0:0',
      \ 'c:class:0:0',
      \ ]
      \}

" Git/Fugitive
set diffopt+=vertical
nnoremap <leader>gd :Gdiff<CR>
nnoremap <space>ga :Git add %<CR><CR>
com! Gadd :Git add %
"nnoremap <space>gs :Gstatus<CR>
"nnoremap <space>gc :Gcommit -v -q<CR>
"nnoremap <space>gt :Gcommit -v -q %:p<CR>
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

" git-gutter
let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 1
set updatetime=4000 " 4 sec
nmap <leader>d :GitGutterToggle<CR>
nmap <leader>n :set invnumber<CR>
let g:gitgutter_override_sign_column_highlight = 0


" Linting
let g:ale_enabled = 1
" lint after save only
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

" fix after save
let g:ale_fix_on_save = 1

" prettier
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
"hi ALEWarning ctermbg=236
hi ALEStyleWarningSign ctermbg=235
hi ALEStyleErrorSign ctermbg=235

""" Python @depends: pylint, autopep8
" see ~/.vim/bundle/ale/autoload/ale/linter.vim
let g:ale_fixers = {
      \   'go': ['gofmt', 'golint', 'go vet'],
      \}
let g:ale_fixers = { 'python': ['autopep8' ] }
let g:ale_python_pylint_options = '--rcfile ~/src/config/configure/linters/.pylintrc'
let g:ale_python_autopep8_options = '--global-config ~/src/config/configure/linters/.pycodestyle'
let g:ale_python_autopep8_global = 1
let g:ale_python_mypy_options = '--ignore-missing-imports'

""" Elm @depends: elm-format
"let g:elm_format_autosave = 0

" Go @depends: go get github.com/mgechev/revive
" * Don't work, watch PR on ALE about revive
" * diable golint ?
call ale#linter#Define('go', {
      \   'name': 'revive',
      \   'output_stream': 'both',
      \   'executable': 'revive',
      \   'read_buffer': 0,
      \   'command': 'revive ~/src/config/configure/linters/.golint_revive_config.toml %t',
      \   'callback': 'ale#handlers#unix#HandleAsWarning',
      \})

nmap <leader>e :ALEToggle<CR>
nmap <leader>en :ALENext<CR>
nmap <leader>ep :ALEPrevious<CR>

" #######################################
" #######################################
" #######################################

"""""""""""""""""""""""""""
"""" Helper Functions
"""""""""""""""""""""""""""

" remove trainling newline ans spaces
function! Chomp(string)
  if strlen(a:string) > 0
    return substitute(a:string, '[\n\s]\+$', '', '')
  else
    return ''
  endif
endfunction

function! CurrDir()
    let dir = split(getcwd(), '/')[-1]
    return dir
endfunction

function! LastDir()
    let dir = split(path, '/')[-2]
    return dir
endfunction

function! Last2Dir()
    let dir = split(getcwd(), "/")[-2]
    let dir .= "-". split(getcwd(), "/")[-1]
    return dir
endfunction

function! GitBranch()
  let branch = Chomp(system("git -C ".shellescape(expand('%:p:h'))." rev-parse --abbrev-ref HEAD 2>/dev/null"))
  return branch
endfunction

function! GitStatus()
  let status = Chomp(system("git -C ".shellescape(expand('%:p:h'))." status --porcelain -b ".shellescape(expand('%:p'))))
  let status = strpart(get(split(status,'\n'),1, ''),1,1)
  return status
endfunction

function! StatuslineGit()
  let branchname = GitBranch()
  let status = GitStatus()
  let g:gitbranch = strlen(branchname) > 0 ? '  '.branchname.' ' : ''
  let g:gitstatus = strlen(status) > 0 ? '('.status.')' : ''
endfunction

""""""""""""""""""""""""""""""
""" General / Interface
""""""""""""""""""""""""""""""
syntax on
set backspace=indent,eol,start
set noequalalways  "prevent automatically resizing windows
set tabpagemax=50
set pastetoggle=£ " toggle paste mode
"set clipboard=unnamed " dont support C-S V
"set title "update window title for X and tmux
"set autochdir " set current cwd to the current file
set ruler   "show current position
set laststatus=2
set mat=1 "How many tenths of a second to blink
set novb                                  " no beep, visualbell
set showcmd                             " Show (partial) command in status line.
set showmatch                           " Show matching brackets
set wildmenu                            " show list instead of just completing
set hlsearch                            " hilighting resarch matches
set incsearch                           " Incremental search
set ignorecase                          " Do case insensitive matching
set fileignorecase                      " see also wildignorecase
set smartcase                           " sensitive if capital letter
set report=0                            " show number of modification if they are
"set nu                                  " View numbers lines
set cursorline                          " hilight current line - cul
"set autowrite                          " Automatically save before commands like :next and :make
"set hidden                             " Hide buffers when they are abandoned
"set mouse=a                            " Enable mouse usage (all modes) in terminals
"set textwidth=0                         " disable textwith
"set fo+=1cro fo-=t tw=0 " break comment at tw $size
set fo+=1ro fo-=tc tw=0 " break comment at tw $size
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
"nnoremap Q gq
""" Last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""" Refresh options
"set ttimeoutlen=10
set ttyfast
"set lazyredraw " weird behavious (statuslines is black...)

" unmap K
map <S-k> <Nop>

"""
""" Terminal hacks
"""

"" Magic pasting
"" Toggle paste/nopaste automatically when copy/paste with right click in insert mode:
"let &t_SI .= "\<Esc>[?2004h"
"let &t_EI .= "\<Esc>[?2004l"
set t_BE=  " disable bracketed paste mode.  https://gitlab.com/gnachman/iterm2/issues/5698

map <Esc>[B <Down>

""""""""""""""""""""""""""""""
""" Tabulations / Indentation
""""""""""""""""""""""""""""""
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
"set preserveindent " ?
set smarttab " trivial

set autoindent "keep indentation over line

"set smartindent " <= mess up indent !
" replacement:
set cindent
set cinkeys-=0#
set indentkeys-=0#

set foldmethod=indent
set nofen               " open all folds. see z[mn] command
set nofoldenable

""""""""""""""""""""""""""""""
""" Mapping / MOVES
""""""""""""""""""""""""""""""
""" general
imap <C-L> <Esc>
" remap C-w to cut the word before the cursor
imap <C-w> <C-[>diwi
" remap C-w to cut the word after the cursor
inoremap <C-s> <C-o>diw 
nnoremap ; :
nnoremap <Esc> :noh<cr>
" vertical help
"cabbrev vh vert h
cnoreabbrev vh vert h
""" Saving
"nnoremap <C-u> :w<CR>
"imap <C-u> <C-o><C-u>
""" Navigate
noremap <F4> :tabe %<CR>
""" Folding
"noremap zR " Open all folds
"noremap zM " close all folds
""" Window moves
nnoremap <S-UP>    <C-W>k
nnoremap <S-DOWN>  <C-W>j
nnoremap <S-LEFT>  <C-W>h
nnoremap <S-RIGHT> <C-W>l
nnoremap à <C-W>w
nnoremap ù <C-W>W
""" Window Zoom
nnoremap <C-W>z :call zoom#toggle()<cr>
""" windows resize
nnoremap <C-k> <C-W>10+
nnoremap <C-j> <C-W>10-
nnoremap <C-h> <C-W>10<
"nnoremap <C-l> <C-W>10>
noremap <C-S-UP>    :resize -3<cr>
noremap <C-S-DOWN>  :resize +3<cr>
noremap <C-S-LEFT>  :vertical resize -3<cr>
noremap <C-S-RIGHT> :vertical resize +3<cr>
"keycode 113 = Alt_R
"add mod1 = Alt_R
"keycode 116 = Meta_R
"add mod4 = Meta_R
"Mod1 Mod4 h :HorizontalDecrement
""" Move between Tab
nnoremap <C-UP> gT
nnoremap <C-DOWN> gt
" @debug: don't work !
"nnoremap <C-Home-LEFT> :tabn1<cr>
"nnoremap <C-End-RIGHT> :tabn$<cr>
""" Move Tab
nnoremap <C-S-PageUp> :tabm-<cr>
nnoremap <C-S-PageDown> :tabm+<cr>
""" Insert Mode
imap <C-a> <Esc>^^i
imap <C-e> <Esc>$a
"imap <C-s> <Esc>:w<CR> " don't work ?
""" Command Mode
cnoremap $h e ~/
cnoremap $e e %:p:h
cnoremap $t tabe %:p:h
cnoremap $s split %:p:h
cnoremap $v vs %:p:h
cnoremap cwd lcd %:p:h  "change current working directory(cwd) to the dir of the currenet file
noremap <Leader>s :split<cr>
noremap <Leader>v :vs<cr>
noremap <Leader>t :tabe %<cr>
noremap <Leader>r :reg<cr>
""" Mouse map
"nnoremap <2-LeftMouse> //
"cno sm set mouse=
"""" Edit
nnoremap <silent> dw diwi
nnoremap <silent> da diWa
nnoremap <silent> da diw"0p

" indent under block, and come back (zo?)
"noremap <TAB>) m9<S-v>)='9  " Equal to '=)'

""" Remap unsefull one that get remap (if <TAB> get mapped)
"unmap <C-i>
"unmap <C-i><C-i>

""" Format Json
noremap <Leader>jf :%!jq .<CR>


" Jump to the next or previous line that has the same level or a lower                     
" level of indentation than the current line.                                              
" https://vi.stackexchange.com/a/12870/23459                                               
                                                                                           
function! GoToNextIndent(inc)                                                              
    " Get the cursor current position                                                      
    let currentPos = getpos('.')                                                           
    let currentLine = currentPos[1]                                                        
    let matchIndent = 0                                                                    
                                                                                           
    " Look for a line with the same indent level whithout going out of the buffer          
    while !matchIndent && currentLine != line('$') + 1 && currentLine != -1                
        let currentLine += a:inc                                                           
        let matchIndent = indent(currentLine) == indent('.')                               
    endwhile                                                                               
                                                                                           
    " If a line is found go to this line                                                   
    if (matchIndent)                                                                       
        let currentPos[1] = currentLine                                                    
        call setpos('.', currentPos)                                                       
    endif                                                                                  
endfunction                                                                                
                                                                                           
nnoremap <silent> ] :call GoToNextIndent(1)<CR>                                            
nnoremap <silent> [ :call GoToNextIndent(-1)<CR>                                           
                                                                                           
func! CurrentFileDir(cmd)                                                                  
  return a:cmd . " " . expand("%:p:h") . "/"                                               
endfunc                                                                                    
                                                                                           
                                                                                           
""""""""""""""""""""""""""""""                                                             
"""" => Extra Filetype                                                                     
""""""""""""""""""""""""""""""                                                             
au BufNewFile,BufRead *.md set filetype=markdown                                           
au BufNewFile,BufRead *.load set filetype=html                                             
au BufNewFile,BufRead *.css,*.scss,*.sass,*.less setf scss                                 
au BufNewFile,BufRead *.prisma,*.graphql,*.gql setf graphql                                
au BufNewFile,BufRead *.nomad,*.consul,*.toml,*.yaml setf conf                             
au BufNewFile,BufRead *.fish set filetype=sh                                               
au BufNewFile,BufRead *.nse set filetype=lua                                               
au BufNewFile,BufRead *.elm set filetype=elm                                               
au BufNewFile,BufRead *.vue set filetype=vue                                               
au BufNewFile,BufRead *.cr set filetype=crystal                                            
au BufNewFile,BufRead *.plt,*.gnuplot,*.gnu set filetype=gnuplot                           
au BufWritePost *.sh,*.py,*.m,*.gnu,*.nse silent !chmod u+x "<afile>"                      

""""""""""""""""""""""""""""""
"""" => Conf Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.*rc set tw=0
au filetype vim set ts=2 sts=2 sw=2

""""""""""""""""""""""""""""""
"""" => Python Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
au BufNewFile,BufRead *.py set formatoptions-=tc " prevent inserting \n. Where does it come from ????

""" Search moves
au BufNewFile,BufRead *.py\> nnoremap _ ?<C-R>='__init__('<CR><CR>
au BufNewFile,BufRead *.pyx nnoremap _ ?<C-R>='__cinit__('<CR><CR>
au BufNewFile,BufRead *.go nnoremap _ ?<C-R>='func '<CR><CR>

""" Docstrings
" To toggle the docstrings in the whole buffer you can use zR and zM, to toggle a single docstring,
" use za (I also mapped <space> to za, so I can toggle it pressing the space bar in normal mode)
" Note that this code should be only triggered when editing a Python buffer (autocommand python call ...).
autocmd FileType python setlocal foldenable foldmethod=syntax
nnoremap <space> za

func! DeleteTrailingWS()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunc

autocmd BufWrite *.py,*.pyx,*.pyd,*.c,*.cpp,*.h,*.sh,*.txt,*.js,*.html,*.css :call DeleteTrailingWS()
" for tab invisible bug (caused by set paste); try :%retab


""""""""""""""""""""""""""""""
"""" => Latex Files
""""""""""""""""""""""""""""""
au filetype tex set ts=2 sts=2 sw=2
au Filetype tex set wrap tw=90
au Filetype tex set indentkeys="    "
"au BufRead,BufNewFile *.md set mouse=
au BufRead,BufNewFile *.md set wrap tw=0


""""""""""""""""""""""""""""""
"""" => C, C++, Java Files
""""""""""""""""""""""""""""""
"au filetype cpp, java  set ts=8 sts=8 sw=8
au filetype cpp set fdm=syntax
"au filetype cpp set cinoptions=>s,e0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,U0,w0,j0,)20,*30

""""""""""""""""""""""""""""""
"""" => HTML Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead  *.html,*.css set tabstop=2 softtabstop=2 shiftwidth=2 nowrap

" Multiple code (web2py...)
au Filetype html :call TextEnableCodeSnip('python', '{{#py', '}}', 'SpecialComment')
au Filetype html :call TextEnableCodeSnip('python', '<script>', '</script>', 'SpecialComment')

" Comment / filtetype named doesnt work!
au BufNewFile,BufRead *.html  noremap # :s/\([^ ].*\)$/<!--\1-->/<CR>:noh<CR>
au BufNewFile,BufRead *.html  noremap ~ :s/<!--\(.*\)-->/\1/<CR>:noh<CR>
au BufNewFile,BufRead *.css   noremap # :s/\([^ ].*\)$/\/\*\1\*\//<CR>:noh<CR>
au BufNewFile,BufRead *.css   noremap ~ :s/\/\*\(.*\)\*\//\1/<CR>:noh<CR>
au BufNewFile,BufRead *.js    noremap # :s/\([^ ].*\)$/\/\*\1\*\//<CR>:noh<CR>
au BufNewFile,BufRead *.js    noremap ~ :s/\/\*\(.*\)\*\//\1/<CR>:noh<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Spell checking
""" get dict from : ftp://ftp.vim.org/pub/vim/runtime/spell/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
noremap <leader>ss :setlocal spell! spelllang=en<CR>
noremap <leader>ssfr :setlocal spell! spelllang=fr<CR>

" Shortcuts using <leader>
noremap z] ]s
noremap z[ [s
noremap <leader>sa zg
noremap <leader>s? z=

"""
""" Other Leader Map
"""
noremap <leader>e :!. % &<CR>
"""switch header <-> .c # or a.vim
noremap <Leader>h <ESC>:AV<CR>
noremap <Leader>ht <ESC>:AT<CR>
"noremap <leader>h :vs %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
" toggle wrap line
nnoremap <leader>, :set wrap!<CR>
" save session
nnoremap <leader>w :mks! .session.vim<CR>
""" set mouse mode
nnoremap <leader>m :set mouse=a<CR>
nnoremap <leader>mm :set mouse=<CR>
""" Copy current line to clipboard
nnoremap <leader>c :.w !xclip -selection clipboard<CR>
""" Copy all file to clipboard
nnoremap <leader>cf :%w !xclip -selection clipboard<CR>


autocmd BufNewFile,BufRead,BufEnter *.md :syn match markdownIgnore "\$.*_.*\$"
"autocmd BufNewFile,BufRead,BufEnter *.md :syn match markdownIgnore "\\begin.*\*.*\\end" " don't work?


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Calendar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Setup
""" Itchyny Calendar
let CALENDARDIR = '~/.cache/calendar.vim'
let g:calendar_diary = expand(CALENDARDIR)
let g:calendar_cache_directory = expand(CALENDARDIR)
let g:calendar_first_day = 'monday'
"let g:calendar_google_calendar = 1
"let g:calendar_google_task = 1

" Week's day colors
"autocmd FileType calendar call calendar#color#syntax('Saturday', has('gui') ? '#ff0000' : 'blue', 'black', '')
"autocmd FileType calendar call calendar#color#syntax('Sunday', has('gui') ? '#ff0000' : 196, 'black', '')
"autocmd FileType calendar hi! link CalendarSunday Normal
"autocmd FileType calendar hi! link CalendarTodaySunday Normal
" Color Workaround
"autocmd FileType calendar if !has('gui_running') | set t_Co=256 | endif

""""""""""""""""""""""""""""""
"""" => Snippet & Commands
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

" ===============
" Switch between header and code
" from: https://github.com/ericcurtin/CurtineIncSw.vim
" ===============

function! FindSw(com)
  let dirname=fnamemodify(expand("%:p"), ":h")
  let target_file=b:inc_sw
  let cmd="find " . dirname . " . -type f -iname \"" . target_file . "\" -print -quit"
  let find_res=system(cmd)
  if filereadable(find_res)
    return 0
  endif

  exe a:com.' ' find_res
endfun


function! HeadSwitch(com)

  if match(expand("%"), '\.c') > 0
    let b:inc_sw=substitute(expand("%:t"), '\.c\(.*\)', '.h*', "")
  elseif match(expand("%"), "\\.h") > 0
    let b:inc_sw=substitute(expand("%:t"), '\.h\(.*\)', '.c*', "")
  elseif match(expand("%"), '\.pyx') > 0
    let b:inc_sw=substitute(expand("%:t"), '\.pyx\(.*\)', '.pxd*', "")
  elseif match(expand("%"), "\\.pxd") > 0
    let b:inc_sw=substitute(expand("%:t"), '\.pxd\(.*\)', '.pyx*', "")
  endif

  call FindSw(a:com)
endfun

" C/Cython Header find/open
nmap <leader>h :call HeadSwitch('tabe')<CR>


" use `ctags -R -f .tags` to create ctags file.
set tags=./.tags;\

fu! DoCtags()
  let cmd = 'ctags --exclude=.git --exclude="*.log" --exclude="*.data" --exclude="*.pk" -R -f .tags'
  let res=system(cmd)
endfunction
com! Ctags :call DoCtags()


""" Workaround for the refresh problem (partial)!
fu! RedrawTab()
    execute  'redraw'
endfunction
com! RedrawTab :call RedrawTab()

fu! MkSession()
    execute 'SaveSession '. Last2Dir()

""" Old
"bufdo execute 'NERDTreeClose'
"bufdo execute 'TagbarClose'
"execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction
com! MkSession :call MkSession()



""""""""""""""""""""""""""""""
""" Theme/Colors
""""""""""""""""""""""""""""""
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
"set term=xterm-256color

" Vim TMUX
"set t_8b=^[[48;2;%lu;%lu;%lum
"set t_8f=^[[38;2;%lu;%lu;%SignColumn

"colorscheme default " Utiliser le jeu de couleurs standard"
"colo zenburn
"colo darkburn
colo dracula
"colo one

""" Custom Colors & Highlights

hi Title ctermfg=39  " affect the number of windows in the tabline and filname in nerdtab
hi Normal ctermbg=233
hi Comment ctermfg=blue
"hi Comment guifg=DarkGrey ctermfg=brown " like; green, white, brown, cyan(=string)
hi Search ctermfg=white ctermbg=105 cterm=NONE
hi SpellBad ctermbg=red cterm=underline
hi StatusLine ctermfg=white ctermbg=25 cterm=bold
hi StatusLineNC ctermfg=black ctermbg=242
hi CursorLine term=underline ctermbg=235
hi TabLine ctermbg=7 ctermfg=black
hi TabLineSel ctermfg=blue ctermbg=green
"hi TabLineSel ctermfg=Blue ctermbg=Green
"hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen

hi ErrorMsg ctermfg=Red ctermbg=None

" Gutter
hi SignColumn ctermbg=235

""" StatusLine
set shortmess-=S " show number of matches
hi GitColor ctermbg=172 ctermfg=black

au BufEnter,BufRead,BufWritePost * call StatuslineGit()

set statusline=""
set statusline+=%#GitColor#%{g:gitbranch}%*
set statusline+=\ %<%f\ %{g:gitstatus}
set statusline+=%m
set statusline+=\ %r
set statusline+=\ %h
set statusline+=\ %w
set statusline+=%=%l/%L:%c\ %05(%p%%%)
set statusline+=\ %{\zoom#statusline()}

" Column viewer
"highlight ColorColumn ctermbg=gray
nnoremap <silent> <leader>c :execute "set colorcolumn="
      \ . (&colorcolumn == "" ? "80" : "")<CR>



"set background=dark
noh

" Unbind <TAB> and <C-O
let &t_TI = "\<Esc>[>4;2m"
let &t_TE = "\<Esc>[>4;m"

