set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua require("basics")
lua require("goto-preview").setup {}
lua require("lsp_config")
lua require("code_gpt")
lua require('neoscroll').setup({easing="quadratic"})
