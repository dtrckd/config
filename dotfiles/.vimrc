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
Plugin 'preservim/tagbar'
Plugin 'preservim/nerdcommenter'
"Plugin 'preservim/nerdtree'
Plugin 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plugin 'gotcha/vimpdb'
"Plugin 'ludovicchabant/vim-gutentags'


" File and code Search
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'mileszs/ack.vim'
"Plugin 'alok/notational-fzf-vim'

" Git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" Linting / LSP
"Plugin 'dense-analysis/ale'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'mozilla/doctorjs'
Plugin 'neovim/nvim-lspconfig'

" Code completion
Plugin 'ms-jpq/coq_nvim', {'branch': 'coq'}
" 9000+ Snippets
Plugin 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plugin 'ms-jpq/coq.thirdparty', {'branch': '3p'}
" --
"Plugin 'ycm-core/YouCompleteMe'
"Plugin 'ajh17/VimCompletesMe'
""Plugin 'maxboisvert/vim-simple-complete'
"Plugin 'ervandew/supertab'
Plugin 'rstacruz/vim-closer'
"--
Plugin 'godlygeek/tabular'
"Plugin 'honza/vim-snippets'
"Plugin 'L3MON4D3/LuaSnip', {'tag': 'v1', 'do': 'make install_jsregexp'} " Replace <CurrentMajor> by the latest released major (first number of latest release)

" File Format / Extra Language
"Plugin 'posva/vim-vue' 
"Plugin 'elmcast/elm-vim'  "https://github.com/elm-tooling/elm-vim
Plugin 'zaptic/elm-vim' 
Plugin 'rhysd/vim-crystal' 
Plugin 'jparise/vim-graphql'
Plugin 'plasticboy/vim-markdown'


" Fold and docstring
"Plugin 'Konfekt/FastFold'
"Plugin 'tmhedberg/simpylfold'
"Plugin 'yhat/vim-docstring'

" Session
Plugin 'mhinz/vim-startify'
"Plugin 'romgrk/vim-session'
Plugin 'dhruvasagar/vim-zoom'
"Plugin 'troydm/zoomwintab.vim'

" Misc
Plugin 'itchyny/calendar.vim'
Plugin 'ciaranm/detectindent'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'psliwka/vim-smoothie'
"Plugin 'rargo/vim-line-jump'
"Plugin 'rstacruz/sparkup'  # Zn writing HTLM
"Plugin 'jceb/vim-orgmode'

" Gpt
Plugin 'nvim-lua/plenary.nvim'
Plugin 'MunifTanjim/nui.nvim'
Plugin 'dpayne/CodeGPT.nvim'

" Theme
Plugin 'uguu-org/vim-matrix-screensaver'
Plugin 'dracula/vim'
"Plugin 'darkburn'
"Plugin 'jnurmine/zenburn'
"Plugin 'rakr/vim-one'
"Plugin 'sonph/onehalf', { 'rtp': 'vim' }

Plugin 'ryanoasis/vim-devicons'
"""""""""""""""""""""""""""
""" Plugin conf
"""""""""""""""""""""""""""

""" Editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

""" go-vim
" intall dependancuse with (if not it stucks!)  :GoInstallBinaries
let g:go_fmt_command = "goimports"

""" YCM Autocompletion
" --
""let g:loaded_youcompleteme = 1
"let g:ycm_show_diagnostics_ui = 1
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 0
"
"let g:SuperTabNoCompleteAfter = ['^', '\s', '#', "'", '"', '%', '/']
"let g:SuperTabClosePreviewOnPopupClose = 1
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_auto_hover = ''  " Disable auto tooltip preview 
"nnoremap <space> <plug>(YCMHover)
"" Disable preview window popping up: https://github.com/ycm-core/YouCompleteMe/issues/2015
"set completeopt-=preview  "let g:ycm_add_preview_to_completeopt = 0
""let g:ycm_disable_signature_help=1
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " more general but wont be able to switch/scroll the preview...
"autocmd FileType vim let b:vcm_tab_complete = 'vim'
"let g:ycm_semantic_triggers = { 'elm' : ['.'], }

""" Snippets completion
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
"-->inoremap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
"-->inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

"-->snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
"-->snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
"inoremap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
"smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

""" COQ autocompletion
" --
" Autostart
let g:coq_settings = {
      \ 'auto_start': 'shut-up', 
      \ 'keymap.eval_snips': '<leader>j',
      \ 'clients.tabnine.enabled': v:false,
      \}


""" Fix vim-closer imcompatibility with COQ
"https://github.com/rstacruz/vim-closer/issues/37
" DO NOT wORK
inoremap <expr> <cr> pumvisible() ? '<c-y>' : '<cr>'
"function! HandleCRKey() abort
"  return pumvisible() ? "\<C-E>\n" : "\n"
"endfunction
"" vim-closer can extend this correctly
"inoremap <silent> <CR> <C-R>=HandleCRKey()<CR>

""" ctags
let g:easytags_updatetime_min = 180000
let g:easytags_auto_update = 0
let g:easytags_cmd = '/usr/bin/ctags'
let g:gutentags_cache_dir = "~/.cache/gutentags/"

""" NerdTree
:let g:NERDTreeWinSize=22
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.swp$']
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
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

"nnoremap <C-p> :call NERDTreeToggleFind()<cr>
""noremap <TAB><TAB> :NERDTreeToggle<CR> " Problem with <C-i> that get map and delayed

" ChadTree
" @requirement:
" install nerdfont ```
" mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
" curl -fLo "Droid Sans Mono Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf 
" fc-cache -fv # try opening a new terminal if you don't see anything
" ```
nnoremap <C-p> <cmd>CHADopen<cr>
autocmd bufenter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif
let g:chadtree_settings = {
      \  'options.polling_rate': 1900,
      \  'view': {'width': 26},
      \  'keymap': {
      \    'v_split': ["v"],
      \    'h_split': ["s"],
      \    'tertiary': ["<m-enter>", "<middlemouse>", "t"],
      \    'new': ["a", "n"],
      \    'copy': ["p", "c"],
      \    'cut': ["x", "m"],
      \    'delete': ["d"],
      \    'trash': [],
      \    'open_sys': ["o"],
      \    'collapse': ["`", "s-o", "C"],
      \    'select': ["<space>"],
      \    'change_focus': ["b"],
      \    'change_focus_up': ["u"],
      \    'change_dir': ["w"],
      \    'toggle_follow': ["U"],
      \    'toggle_hidden': [".", "h"],
      \  },
      \  'ignore': {
      \    'name_exact': [".DS_Store", ".directory", "thumbs.db", ".git"],
      \    'name_glob': ['*.pyc$', '*.pyo$', '*.swp$'],
      \  },
      "\ 'theme.icon_glyph_set': 'ascii',
      \}




" Use ripgrep for searching ⚡️
" Options include:
" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
" Fix ack output leaks to the terminal https://github.com/mileszs/ack.vim/issues/18
set shellpipe=>

" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1  " You can alos use :cclose

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!
"cnoreabbrev Ack Ack!
"cnoreabbrev ag Ack
"cnoreabbrev ack Ack
""" Fuzzy search > fzf, ack, ag, ripgrep familly !
noremap F :FZF<cr>
noremap ! :FZF<cr>
" Search the word under cursor
noremap <leader>a :Ack! "<cword>"<cr>
" Maps <leader>/ so we're ready to type the search keyword
nnoremap <Leader>/ :Ack!<Space>


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
let g:session_autoload = 'no' " see https://github.com/xolox/vim-session
let g:session_autosave = 'no' " save on quit
let g:session_autosave_periodic = 120 " minutes
let g:session_autosave_silent = 1 " true
let g:session_default_overwrite = 1 " every Vim instance without an explicit session loaded will overwrite the 'default' session (the last Vim instance wins).

" See available kinds: ctags --list-kinds=<language_name>
"noremap <Leader>mctags :!/usr/bin/ctags -R  --fields=+iaS --extra=+q .<CR>
"noremap <Leader>mctags :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
noremap <C-m> :TagbarToggle<CR>
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_singleclick = 1
let g:tagbar_autofocus = 1
nnoremap tc :TagbarShowTag<CR>
"" ctags alias
" Ctrl+\ - Open the definition in a new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Alt+] - Open the definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>


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


" Elm tagbar (old)
"let g:tagbar_type_elm = {
"      \ 'kinds' : [
"      \ 'f:function:1:0',
"      \ 'm:modules:0:0',
"      \ 'i:imports:0:0',
"      \ 't:types:1:0',
"      \ 'a:type aliases:0:0',
"      \ 'c:type constructors:0:0',
"      \ 'p:ports:0:0',
"      \ 's:functions:0:0',
"      \ ]
"      \}
" Elm tagbar
" see https://github.com/preservim/tagbar/wiki#elm
" for the script elmtags.py (WARN: It has been customized)
let g:tagbar_type_elm = {
          \   'ctagstype':'elm'
          \ , 'kinds':['h:header', 't:type', 'f:function']
          \ , 'sro':'&&&'
          \ , 'kind2scope':{ 'h':'header', 'i':'import'}
          \ , 'sort':0
          \ , 'ctagsbin':$HOME.'/.local/bin/elmtags.py'
          \ , 'ctagsargs': ''
          \ }

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

" Makefile tagbar
let g:tagbar_type_make = { 'kinds':[ 'm:Macros', 't:Targets' ] }

" Graphql tagbar
let g:tagbar_type_graphql = { 'kinds':[ 't:Types', 'e:Enums' ] }


" JS tagbar
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

" Git/Fugitive
set diffopt+=vertical
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ga :Git add %<CR><CR>
" log of the current file
nnoremap <leader>gl :Git log %<CR><CR>
" Browsing through the history of a file (:lnext :lprev to navigate)
nnoremap <leader>gL :0Gllog<CR><CR>
com! Gadd :Git add %
"nnoremap <leader>gp :Ggrep<Space>
" Other cool stuff :
" - https://jeancharles.quillet.org/posts/2022-03-02-Practical-introduction-to-fugitive.html
" - https://github.com/tpope/vim-fugitive

" git-gutter
let g:gitgutter_enabled = 0
let g:gitgutter_map_keys = 1
set updatetime=4000 " 4 sec
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <leader>n :set invnumber<CR>
let g:gitgutter_override_sign_column_highlight = 0


"--
"-- ALE config
"--
"let g:ale_enabled = 1
"let g:ale_lint_on_save = 1
"let g:ale_fix_on_save = 0
"" lint after save only
"let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_insert_leave = 0
"let g:ale_lint_on_enter = 0
"" prettier
"let g:ale_sign_error = '●'
"let g:ale_sign_warning = '.'
""hi ALEWarning ctermbg=236
"hi ALEStyleWarningSign ctermbg=235
"hi ALEStyleErrorSign ctermbg=235
"
"""" Ale language conf
"" see ~/.vim/bundle/ale/autoload/ale/linter.vim
"" see also [FIX conf !] ~/.config/nvim/lua/init.lua
"let g:ale_fixers = { 
"      \  'python': ['autopep8'],
"      \  'go': [],
"      \}
"
"" Python 
"" @requirements: pylint, autopep8
"let g:ale_python_pylint_options = '--rcfile ~/src/config/configure/linters/.pylintrc'
"let g:ale_python_autopep8_options = '--global-config ~/src/config/configure/linters/.pycodestyle'
"let g:ale_python_autopep8_global = 1
"let g:ale_python_mypy_options = '--ignore-missing-imports'
"
"" Golang
"" @requirements: go get github.com/mgechev/revive
"" * Don't work, watch PR on ALE about revive
"" * diable golint ?
"call ale#linter#Define('go', {
"      \   'name': 'revive',
"      \   'output_stream': 'both',
"      \   'executable': 'revive',
"      \   'read_buffer': 0,
"      \   'command': 'revive ~/src/config/configure/linters/.golint_revive_config.toml %t',
"      \   'callback': 'ale#handlers#unix#HandleAsWarning',
"      \})
"
"""" Elm 
""let g:elm_format_autosave = 0
""let g:elm_make_show_warnings = 0
"
"""" ALE Mappings
"nnoremap <leader>e :ALEToggle<CR>
"nnoremap <leader>en :ALENext<CR>
"nnoremap <leader>eN :ALEPrevious<CR>
"nnoremap <leader>ep :ALEPrevious<CR>


"
" FastFold and symply fold
"
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:php_folding = 1

" Disabled vim-smoothie
"let g:smoothie_enabled = 0


" #######################################
" #### PLugin ends
" #######################################

"""""""""""""""""""""""""""
""" Helper Functions
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

function! AleStatus()
  " https://github.com/benknoble/Dotfiles/blob/3a55b757e4eafb8b33a00c0336f6ddf20ce463a7/links/vim/vimrc#L198
  let ale = ale#statusline#Count(bufnr('%'))
  let g:error_len = ale.error > 0 ? 'E:'.ale.error : ''
  let g:warning_len = ale.warning > 0 ? 'W:'.ale.warning : ''
endfunction


""""""""""""""""""""""""""""""
""" General configuration
""""""""""""""""""""""""""""""
syntax on
set backspace=indent,eol,start
set tabpagemax=50                  " Maximum of opened tab
set noequalalways                  " Prevent automatically resizing windows
set pastetoggle=£                  " Toggle paste mode
"set clipboard=unnamed             " Dont support C-S V
"set title                         " Update window title for X and tmux
"set autochdir                     " Set current cwd to the current file
set ruler                          " Show current position
set laststatus=2                   " Always show the statusline
set mat=1                          " How many tenths of a second to blink
set novb                           " No beep, visualbell
set showcmd                        " Show (partial) command in status line.
set showmatch                      " Show matching brackets
set wildmenu                       " Show list instead of just completing
set hlsearch                       " Hilighting resarch matches
set incsearch                      " Incremental search
set ignorecase                     " Do case insensitive matching
set fileignorecase                 " See also wildignorecase
set smartcase                      " Sensitive if capital letter
set report=0                       " Show number of modification if they are
"set nu                            " View numbers lines
set cursorline                     " Hilight current line - cul
"set autowrite                     " automatically save before commands like :next and :make
"set hidden                        " Hide buffers when they are abandoned
set mouse=a                        " Enable mouse usage (all modes) in terminals
"set textwidth=0                   " Disable textwith
set fo+=1ro fo-=tc tw=0            " Break comment at tw $size
"set fo+=1cro fo-=t tw=0           " Break comment at tw $size
"set colorcolumn=-1
set scrolloff=4                    " Line of context: mininum visible lines at the top or bottom of the screen.
set sidescrolloff=8                " Columns of context
set linebreak                      " Don't wrap word
set nowrap                         " Don't wrap line too long
set nostartofline                  " Try keep the column with line moves
set whichwrap=<,>,[,]              " Enable line return with pad
"set ff=unix                       " Remove ^M
set encoding=UTF-8
set nohidden                       " Do not keep a buffer open (swp file) if the file is not open in a window.
" Fix for color syntax highlighting breaks for big file after jump or search 
" https://github.com/vim/vim/issues/2790
syntax sync minlines=2000
" manually fix :syntax sync fromstart
""" Last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""" Refresh options
"set ttimeoutlen=10
set ttyfast
"set lazyredraw " weird behavious (statuslines is black...)

""" Tabulations / Indentation
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

"" Magic pasting
"" Toggle paste/nopaste automatically when copy/paste with right click in insert mode:
"let &t_SI .= "\<Esc>[?2004h"
"let &t_EI .= "\<Esc>[?2004l"
set t_BE=  " disable bracketed paste mode.  https://gitlab.com/gnachman/iterm2/issues/5698


""""""""""""""""""""""""""""""
""" MAPPING
""""""""""""""""""""""""""""""

""" NORMAL MAP
map <Esc>[B <Down>
inoremap <C-L> <Esc>
nnoremap ; /
nnoremap <silent> <Esc> :noh<cr>
" Close preview & quickfix list
nnoremap <silent> q :pclose<cr>
"nnoremap <silent> q :pclose \| cclose <cr>
autocmd FileType qf nnoremap <buffer> q :cclose<cr>
" unmap K
map <S-k> <Nop>
""" Window moves
nnoremap <S-UP>    <C-W>k
nnoremap <S-DOWN>  <C-W>j
nnoremap <S-LEFT>  <C-W>h
nnoremap <S-RIGHT> <C-W>l
nnoremap à <C-W>w
nnoremap ù <C-W>W
""" Window Zoom
nnoremap <C-W>z :call zoom#toggle()<cr>
nnoremap <C-W>o :call zoom#toggle()<cr>
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
inoremap <C-a> <Esc>^^i
inoremap <C-e> <Esc>$a
"inoremap <C-s> <Esc>:w<CR> " don't work ?
" Format Json
noremap <Leader>je :%!sed 's/\\n/\n/g'<CR>
noremap <Leader>fj :%!jq %<CR>
noremap <Leader>fx :%!xmllint --format %<CR>

""" VISUAL MAP
" Paste in Clipboard in mouse=a mode
" https://stackoverflow.com/questions/4608161/copying-text-outside-of-vim-with-set-mouse-a-enabled
" Note: it seems that with "nore" mapping is slightly slower.
vnoremap <C-c> "+y
vnoremap <C-x> "+x
inoremap <C-v> <C-[>"+pa

" Word delete
nnoremap <silent> dw ciw
" remap C-w to cut the word before the cursor
inoremap <C-w> <C-[>dawa
" remap C-w to cut the word after the cursor
inoremap <C-s> <C-o>diw 
" Prevent delay when using <C-w> in normal mode
"tno <c-w><c-w> <c-w><c-w>
" breaks window movement
"nmap <C-w> daw

""" Surround
nnoremap <silent> ys ysiw

""" COMMAND MAP
cnoremap $h e ~/
cnoremap $e e %:p:h
cnoremap $t tabe %:p:h
cnoremap $s split %:p:h
cnoremap $v botright vs %:p:h
cnoremap cwd lcd %:p:h  "change current working directory(cwd) to the dir of the currenet file
" vertical help
cnoreabbrev vh vert h
cnoreabbrev vs botright vs
command T tabe
" print the current buffer number
command Bufno :echo bufnr('%') 

" Fix the issue: enter in quifix list open tagbartoggle instead of file (lsp references)
" see also :tab copen
" qf == quickfix
autocmd FileType qf nnoremap <buffer> <Enter> <C-W><Enter><C-W>T
"set switchbuf+=newtab
" Ensure we go to the last active after closing a tab
autocmd TabClosed * tabprevious

" Insert and jump to newline before the cursor, in insert mode
inoremap <A-Enter> <Esc>O


""""""""""""""""""""""""""""""
""" Filetypes
""""""""""""""""""""""""""""""

au BufNewFile,BufRead *.md set filetype=markdown                                           
au BufNewFile,BufRead *.load set filetype=html                                             
au BufNewFile,BufRead *.css,*.scss,*.sass,*.less setf scss                                 
au BufNewFile,BufRead *.prisma,*.graphql,*.gql setf graphql                                
au BufNewFile,BufRead *.nomad,*.consul,*.toml,*.yaml,*.yml setf conf                             
au BufNewFile,BufRead *.fish set filetype=sh                                               
au BufNewFile,BufRead *.nse set filetype=lua                                               
au BufNewFile,BufRead *.elm set filetype=elm                                               
au BufNewFile,BufRead *.vue set filetype=vue                                               
au BufNewFile,BufRead *.cr set filetype=crystal                                            
au BufNewFile,BufRead *.plt,*.gnuplot,*.gnu set filetype=gnuplot                           
au BufWritePost *.sh,*.py,*.m,*.gnu,*.nse silent !chmod u+x "<afile>"                      

" prevent changing the indentation when commenting
autocmd FileType yaml,yaml.ansible setlocal indentkeys-=0#

""""""""""""""""""""""""""""""
""" Makefile Files
""""""""""""""""""""""""""""""
au filetype make set noexpandtab softtabstop=0

""""""""""""""""""""""""""""""
""" Conf Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.*rc set tw=0
au filetype vim set ts=2 sts=2 sw=2

""""""""""""""""""""""""""""""
""" Python Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
au BufNewFile,BufRead *.py set formatoptions-=tc " prevent inserting \n. Where does it come from ????

""" Search moves
au BufNewFile,BufRead *.py\> nnoremap _ ?<C-R>='__init__('<CR><CR>
au BufNewFile,BufRead *.pyx nnoremap _ ?<C-R>='__cinit__('<CR><CR>
au BufNewFile,BufRead *.go nnoremap _ ?<C-R>='func '<CR><CR>
au BufNewFile,BufRead *.elm nnoremap _ ?<C-R>='init : '<CR><CR>


func! DeleteTrailingWS()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunc

autocmd BufWrite *.py,*.pyx,*.pyd,*.c,*.cpp,*.h,*.sh,*.txt,*.js,*.html,*.css,*.go,*.graphql :call DeleteTrailingWS()
" for tab invisible bug (caused by set paste); try :%retab

""""""""""""""""""""""""""""""
""" Docstrings
""""""""""""""""""""""""""""""
" To toggle the docstrings in the whole buffer you can use zR and zM, to toggle a single docstring, use za .
au BufNewFile,BufRead *.graphql,*.py setlocal foldenable foldmethod=syntax 

""""""""""""""""""""""""""""""
""" Latex Files
""""""""""""""""""""""""""""""
au filetype tex set ts=2 sts=2 sw=2
au Filetype tex set wrap tw=90
au Filetype tex set indentkeys="    "
au BufRead,BufNewFile *.md set wrap tw=0

""""""""""""""""""""""""""""""
""" C, C++, Java Files
""""""""""""""""""""""""""""""
"au filetype cpp, java  set ts=8 sts=8 sw=8
au filetype cpp set fdm=syntax
"au filetype cpp set cinoptions=>s,e0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,U0,w0,j0,)20,*30

""""""""""""""""""""""""""""""
""" HTML Files
""""""""""""""""""""""""""""""
au BufNewFile,BufRead  *.html,*.css set tabstop=2 softtabstop=2 shiftwidth=2 nowrap

" Multiple code (web2py...)
au Filetype html :call TextEnableCodeSnip('python', '{{#py', '}}', 'SpecialComment')
au Filetype html :call TextEnableCodeSnip('python', '<script>', '</script>', 'SpecialComment')

" Special Comment shortcut
au BufNewFile,BufRead *.html  noremap ## :s/\([^ ].*\)$/<!--\1-->/<CR>:noh<CR>
au BufNewFile,BufRead *.html  noremap ~~ :s/<!--\(.*\)-->/\1/<CR>:noh<CR>
au BufNewFile,BufRead *.css   noremap ## :s/\([^ ].*\)$/\/\*\1\*\//<CR>:noh<CR>
au BufNewFile,BufRead *.css   noremap ~~ :s/\/\*\(.*\)\*\//\1/<CR>:noh<CR>
au BufNewFile,BufRead *.js    noremap ## :s/\([^ ].*\)$/\/\*\1\*\//<CR>:noh<CR>
au BufNewFile,BufRead *.js    noremap ~~ :s/\/\*\(.*\)\*\//\1/<CR>:noh<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Spell checking
""" get dict from : ftp://ftp.vim.org/pub/vim/runtime/spell/
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
noremap <leader>ss :setlocal spell! spelllang=en<CR>
noremap <leader>ssfr :setlocal spell! spelllang=fr<CR>
noremap z] ]s
noremap z[ [s
noremap <leader>sa zg
noremap <leader>s? z=

"""
""" Other Leader Map
"""
"""switch header <-> .c # or a.vim
"noremap <Leader>h <ESC>:AV<CR>
"noremap <Leader>ht <ESC>:AT<CR>
" toggle wrap line
nnoremap <leader>, :set wrap!<CR>
""" set mouse mode
nnoremap <leader>ma :set mouse=a<CR>
nnoremap <leader>mo :set mouse=<CR>
""" Copy current line to clipboard
nnoremap <leader>C :.w !xclip -selection clipboard<CR>
""" Copy all file to clipboard
nnoremap <leader>Cf :%w !xclip -selection clipboard<CR>
""" Execute
"noremap <leader>e :!. % &<CR>

autocmd BufNewFile,BufRead,BufEnter *.md :syn match markdownIgnore "\$.*_.*\$"
"autocmd BufNewFile,BufRead,BufEnter *.md :syn match markdownIgnore "\\begin.*\*.*\\end" " don't work?


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Calendar
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
""" Snippet & Commands
""""""""""""""""""""""""""""""

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
"nnoremap <leader>h :call HeadSwitch('tabe')<CR>


" use `ctags -R -f .tags` to create ctags file.
set tags=./.tags;\

fu! DoCtags()
  let cmd = 'ctags --exclude=.git --exclude="*.log" --exclude="*.data" --exclude="*.pk" -R -f .tags'
  let res=system(cmd)
endfunction
com! Ctags :call DoCtags()


fu! FixSyntax()
  let cmd = 'syntax sync fromstart'
  let res=system(cmd)
endfunction
com! FixSyntax :call FixSyntax()


""" Workaround for the refresh problem (partial)!
fu! RedrawTab()
    execute  'redraw'
endfunction
com! RedrawTab :call RedrawTab()

fu! MkSession()
    "execute 'SaveSession '. Last2Dir()
    execute 'SSave! '. Last2Dir()
endfunction
com! MkSession :call MkSession()
""" Old
"bufdo execute 'NERDTreeClose'
"bufdo execute 'TagbarClose'
"execute 'mksession! ' . getcwd() . '/.session.vim'



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

" https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
let &t_ut=''

" Vim TMUX
"set t_8b=^[[48;2;%lu;%lu;%lum
"set t_8f=^[[38;2;%lu;%lu;%SignColumn

"colorscheme default " Utiliser le jeu de couleurs standard"
"colo zenburn
"colo darkburn
colo dracula
"colo one
"colo onehalfdark

fu! SetHi()
  """ Custom Colors & Highlights
  hi Title ctermfg=39  " affect the number of windows in the tabline and filname in nerdtab
  hi Normal ctermbg=233
  hi Comment ctermfg=blue
  "hi Comment guifg=DarkGrey ctermfg=brown 
  hi CursorLine cterm=none term=underline ctermbg=235
  hi Search ctermfg=white ctermbg=105 cterm=none
  hi SpellBad ctermbg=red cterm=underline
  hi StatusLine ctermfg=white ctermbg=25 cterm=bold
  hi StatusLineNC ctermfg=black ctermbg=245
  hi TabLine ctermfg=black ctermbg=245 cterm=none
  hi TabLineSel ctermfg=white ctermbg=25
  "hi TabLineFill ctermfg=black

  hi ErrorMsg ctermfg=red ctermbg=none

  """ Gutter
  hi SignColumn ctermbg=235

  set shortmess-=S " show number of matches
  hi GitColor ctermbg=172 ctermfg=black
  hi ErrColor ctermfg=red ctermbg=25
  hi WarnColor ctermfg=226 ctermbg=25

  """ StatusLine
  au BufEnter,BufRead,BufWritePost * call StatuslineGit()
  " @DEBUG: how to run this after ale status change ?
  "au BufEnter,BufRead,BufWritePost * call AleStatus()

  set statusline=""
  set statusline+=%#GitColor#%{g:gitbranch}%*
  set statusline+=\ %<%f\ %{g:gitstatus}
  set statusline+=%m
  set statusline+=\ %r
  set statusline+=\ %h
  set statusline+=\ %w
  "set statusline+=\ %#ErrColor#%{g:error_len}%*
  "set statusline+=\ %#WarnColor#%{g:warning_len}%*
  set statusline+=%=%l/%L:%c\ %05(%p%%%)
  set statusline+=\ %{\zoom#statusline()}
endfunction

call SetHi()

" Column viewer
"highlight ColorColumn ctermbg=gray
nnoremap <silent> <leader>c :execute "set colorcolumn="
      \ . (&colorcolumn == "" ? "80" : "")<CR>


" Fix color regression when unzooming with vim-zoom.
augroup Zoom
  au!

  autocmd User ZoomPost call SetHi()
augroup END

"set background=dark
noh

" Unbind <TAB> and <C-O
let &t_TI = "\<Esc>[>4;2m"
let &t_TE = "\<Esc>[>4;m"

