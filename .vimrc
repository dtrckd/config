" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.

""""""""""""""""""""""""""""""
""" General / Interface
""""""""""""""""""""""""""""""
set ruler		"show current position 
set laststatus=2
set statusline=%<%f%m\ %r\ %h\ %w\ %=%l/%L:%c\ %015(%p%%%)
"set statusline=%F\%m\ %r\ %h\ %w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ %=[LEN=%L] 
set mat=1 "How many tenths of a second to blink
set vb " no beep, visualbell
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets
set wildmenu		" show list instead of just completing
set hlsearch		"hilighting resarch matches
"hi Search ctermfg=10 ctermbg=Black " comment
hi Search ctermfg=7 ctermbg=3
hi Comment guifg=DarkGrey ctermfg=brown "like; green, white, brown, cyan(=string)
set incsearch		" Incremental search
set ignorecase		" Do case insensitive matching
set smartcase		" sensitive if capital letter
set report=0		"show number of modification if they are
"set number		" View numbers lines
"set cursorline         "hilight current line
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes) in terminals
"set textwidth      " set nb cgaracter before backofline
set scrolloff=3         "visible line at the top or bottom from cursor
set linebreak           "don't wrap word
"set nowrap		"don't wrap line too long
set nostartofline       "try keep the column with line moves
set whichwrap=<,>,[,]   "enable line return with pad
"set ff=unix             "remove ^M
"set termencoding=UTF-8
set encoding=utf-8
hi TabLineSel  ctermbg=Green
hi TabLine ctermfg=0 ctermbg=7
" Don't use Ex mode, use Q for formatting
map Q gq

""""""""""""""""""""""""""""""
""" Tabulations / Indentation
""""""""""""""""""""""""""""""
set expandtab
set softtabstop=4 
set shiftwidth=4
set tabstop=4
"set preserveindent      "don't realy know but seems soo good (pythyon)
set smarttab " trivial

set autoindent "keep indentation over line
set smartindent 
set cindent 

noremap <Tab>= <S-v>)=''    " indent under block, and come back (zo?)
set foldmethod=indent 
set nofen               " open all folds. see z[mn] command

" Rainbow Parenthesis
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

""""""""""""""""""""""""""""""
"" Mapping
""""""""""""""""""""""""""""""
" Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift
nnoremap ; : 
let mapleader = ','
"saving
nnoremap <C-u> :w<CR>
imap <C-u> <C-o><C-u>
"navigate
map <F4> :tabe %<CR>
" Folding
"noremap zR " Open all folds
"noremap zM " close all folds
"" TAB
noremap <C-UP> gT
imap <C-UP> <ESC>:tabn<CR>
imap <C-DOWN> <ESC>:tabN<CR>
noremap <C-DOWN> gt
"" WINDOW
"nnoremap <S-PageUp> <C-W>k
"nnoremap <S-PageDown> <C-W>j
nnoremap <S-UP> <C-W>k
nnoremap <S-DOWN> <C-W>j
nnoremap <S-LEFT> <C-W>h
nnoremap <S-RIGHT> <C-W>l
noremap <A-UP> <C-W>10+
noremap <A-DOWN> <C-W>10-
noremap <A-LEFT> <C-W>10<
noremap <A-RIGHT> <C-W>10>
"" Insert Mode
imap <C-a> <Esc>^^i
imap <C-e> <Esc>$a
""" Command Mode
cmap $h e ~/
cmap $e e %:p:h
cmap $t tabe %:p:h
cmap $s split %:p:h
cmap $v vs %:p:h
"""" Mouse map
"nnoremap <2-LeftMouse> //
cno sm set mouse=

"" Compilation & Taglist ! Great
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 30
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
noremap <Leader>to :TlistAddFiles %<CR>
noremap <Leader>t :TlistToggle<CR>
noremap <Leader>tup :TlistUpdate<CR>
noremap <Leader>mctags :!/usr/bin/ctags -R  --fields=+iaS --extra=+q .<CR>
noremap <Leader>ct :tab split<CR>:exec("tag ".expand("<cword>"))<CR>:TlistToggle<CR>
noremap <Leader>mctags :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

noremap <Leader>e <ESC>:! ./%<CR>

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
""""""""""""""""""""""""""""""
"""" => Filetype Custom and hilight
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""

"au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod u+x <afile> | endif | endif
au BufNewFile,BufWritePost *.sh,*.py,*.m,*.gnu,*.nse silent !chmod u+x <afile>
autocmd BufNewFile,BufRead *.nse set filetype=lua    

""""""""""""""""""""""""""""""
"""" => Latex section
""""""""""""""""""""""""""""""
au Filetype tex set wrap
au Filetype tex map <leader>m :!make<cr>
au BufRead,BufNewFile *.md set filetype=markdown 
au BufRead,BufNewFile *.md set mouse=a
au BufRead,BufNewFile *.md set wrap

""""""""""""""""""""""""""""""
"""" => Gnuplot section
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.plt,*.gnuplot,*.gnu set filetype=gnuplot
"au BufNewFile,BufRead *.gnu set filetype=gnuplot


""""""""""""""""""""""""""""""
"""" => C, Java section
""""""""""""""""""""""""""""""
au filetype java  set ts=8 sts=8 sw=8
"au filetype java set fdm=syntax

"""""""Maybe good, but make lagging some reapint key, shit
"" Javadoc comments (/** and */ pairs) and code sections (marked by {} pairs)
"" mark the start and end of folds.
"" All other lines simply take the fold level that is going so far.
"function! MyFoldLevel( lineNumber )
"  let thisLine = getline( a:lineNumber )
"  " Don't create fold if entire Javadoc comment or {} pair is on one line.
"  if ( thisLine =~ '\%(\%(/\*\*\).*\%(\*/\)\)\|\%({.*}\)' )
"    return '='
"  elseif ( thisLine =~ '\%(^\s*/\*\*\s*$\)\|{' )
"    return "a1"
"  elseif ( thisLine =~ '\%(^\s*\*/\s*$\)\|}' )
"    return "s1"
"  endif
"  return '='
"endfunction
"au filetype java setlocal foldexpr=MyFoldLevel(v:lnum)
"au filetype java setlocal foldmethod=expr


au filetype cpp set fdm=syntax
au filetype cpp  set ts=8 sts=8 sw=8
"au filetype cpp set cinoptions=>s,e0,f0,{0,}0,^0,:s,=s,l0,gs,hs,ps,ts,+s,c3,C0,(2s,us,U0,w0,j0,)20,*30

"""
"switch header <-> .c # or a.vim
"""
map <Leader>h <ESC>:AV<CR>
map <Leader>ht <ESC>:AT<CR>
"map <leader>h :vs %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

""""""""""""""""""""""""""""""
"""" => Python section
""""""""""""""""""""""""""""""
"let python_highlight_all = 0
"au filetype python  set ts=4 sts=4 sw=4
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix
" for tab invisible bug; try :%retab

"au FileType python syn keyword pythonDecorator True None False self
"
"au BufNewFile,BufRead *.html set syntax=web2py
"au BufNewFile,BufRead *.jinja set syntax=htmljinja
"au BufNewFile,BufRead *.mako set ft=mako
"
"au FileType python inoremap <buffer> $r return
"au FileType python inoremap <buffer> $i import
"au FileType python inoremap <buffer> $p print
"au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
"au FileType python map <buffer> <leader>1 /class
"au FileType python map <buffer> <leader>2 /def
"au FileType python map <buffer> <leader>C ?class
"au FileType python map <buffer> <leader>D ?def

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" manage indentation error...
" set list (list!) " see the tabulation ^I
" retab " move tab in space according to tabstop

""""""""""""""""""""""""""""""
"""" => Snippet/template section
""""""""""""""""""""""""""""""
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

 
""""""""""""""""""""""""""""""
"""" => HTML section
""""""""""""""""""""""""""""""
autocmd BufNewFile,BufRead *.load set filetype=html    
au Filetype html :call TextEnableCodeSnip('python', '{{#py', '}}', 'SpecialComment')
" Comment 
au Filetype html nmap # :s/\([^ ].*\)$/<!--\1-->/<CR>:noh<CR>
au Filetype html nmap ~ :s/<!--\(.*\)-->/\1/<CR>:noh<CR>
au BufNewFile,BufRead *.css nmap # :s/\([^ ].*\)$/\/\*\1\*\//<CR>:noh<CR>
au BufNewFile,BufRead *.css nmap ~ :s/\/\*\(.*\)\*\//\1/<CR>:noh<CR>
au filetype html set ts=2 sts=2 sw=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
map <leader>ssfr :setlocal spell! spelllang=fr<cr>

"Shortcuts using <leader>
nmap z] ]s
nmap z[ [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Calendar, thanks Yasuhiro Matsumot, ichiny, vim-jp !
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Setup
"let g:calendar_monday = 1
"let g:calendar_diary = '~/.diary'
""" Itchyny Calendat
let pp = '~/Desktop/workInProgress/.diary/'
let g:calendar_cache_directory = expand(pp)
let g:calendar_first_day = 'monday'
let g:calendar_google_calendar = 1
"let g:calendar_google_task = 1

" Week's day colors
autocmd FileType calendar call calendar#color#syntax('Saturday', has('gui') ? '#ff0000' : 'blue', 'black', '')
autocmd FileType calendar call calendar#color#syntax('Sunday', has('gui') ? '#ff0000' : 196, 'black', '')
"autocmd FileType calendar hi! link CalendarSunday Normal
"autocmd FileType calendar hi! link CalendarTodaySunday Normal

"" Color Workaround
autocmd FileType calendar if !has('gui_running') | set t_Co=256 | endif

" Source a global configuration file if available
" XXX Deprecated, please move your changes here in /etc/vim/vimrc
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


" " =================================================================="

"""""""""" ron et default ++
"colorscheme blue " Jeu de couleurs avec un fond bleu (mcedit)"
"colorscheme darkblue " Jeu de couleurs employant un fond bordeau"
"colorscheme default " Utiliser le jeu de couleurs standard"
"colorscheme delek " Jeu de couleurs employant un fond bordeau"
"colorscheme desert " Jeu de couleurs ayant un fond noir"
"colorscheme elflord " Jeu de couleurs ayant un fond noir"
"colorscheme evening " jeu de couleurs similaire au modèle standard"
"colorscheme koehler " jeu de couleurs similaire au modèle standard"
"colorscheme morning " Jeu de couleurs ayant un fond gris ( elinks)**"
"colorscheme murphy " Jeu de couleurs employant un fond bordeau"
"colorscheme pablo " jeu de couleurs similaire au modèle standard"
"colorscheme peachpuff " Jeu de couleurs ayant un fond noir ( lynx )"
"colorscheme ron " jeu de couleurs similaire au modèle standard"
"colorscheme shine " Jeu de couleurs ayant un fond gris ( elinks)"
"colorscheme sukria
"colorscheme torte " Jeu de couleurs ayant un fond noir ( lynx )"
"colorscheme zellner
"colorscheme 256-grayvim
"colorscheme sunburst "to test

" " =================================================================="


" "Remove email bit in from line."
"map ,w 1G:s/^From:\(.*\) $/From:\1 /$

map <Esc>[B <Down>

noh


