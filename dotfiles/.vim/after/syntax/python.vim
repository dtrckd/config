"syn region pythonString
"      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend fold
"      \ contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell
"syn region pythonRawString
"      \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend fold
"      \ contains=pythonSpaceError,pythonDoctest,@Spell


"hi Folded NONE
"hi link Folded pythonString 
hi Folded ctermfg=228 ctermbg=234
"hi Folded ctermfg=blue ctermbg=234

" let's fold docstrings
"syn region pythonString start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell fold
syn region pythonDoc start=+^\s*\z('''\|"""\)+ end="\z1" keepend contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell fold
hi def link pythonDoc String

function! DocstringFold()
    let first_line = getline(v:foldstart)
    let second_line = getline(v:foldstart + 1)

    " if the first line is empty...
    if first_line =~ '^\s*"""\s*$' || first_line =~ '^\s*'"\'\'\'\'"'\s*$'
        let doc_txt = substitute(second_line, '^\s*', '', 'g')
    else
        let doc_txt = substitute(first_line, '^\s*"""\s*', '', 'g')
        doc_txt = substitute(doc_text, "^\s*\'\'\'s*", '', 'g')
    endif

    let indent_len = indent(v:foldstart)
    let folded_lines = v:foldend-v:foldstart
    let indent = repeat(' ', indent_len)
    let prefix = first_line
    let end_filler = ' (+'. folded_lines . ')  '
    let offset = 4
    let max_len = winwidth(0) - (indent_len + len(prefix) + len(end_filler) + offset)
    let text =  doc_txt[:max_len]
    let filler = repeat(' ', winwidth(0) - indent_len - len(prefix) - len(end_filler) - len(text) - offset + 1)
    return indent . prefix . text . filler . end_filler
endfunction
setlocal foldtext=DocstringFold()
