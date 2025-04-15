set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Minideps dependencies...
lua require("minideps")

" Base Plugin initialization
lua require("goto-preview").setup {}
lua require("neoscroll").setup({easing="quadratic"})

" Custom Plugins
lua require("basics")
lua require("lsp_configs")
lua require("ccp")

