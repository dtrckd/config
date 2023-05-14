set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua require("basics")
lua require("lsp_config")
lua require("code_gpt")

lua require("autocop_coq")
