--
-- NVIM basics / General config
--

-- Briefly highlight yanked text
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}' -- disabled in visual mode


--
-- Enable tree-sitter
--
--local ts = require 'nvim-treesitter.configs'
--ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

--
-- Fish autocompletion <enter> input like in commands suggestion popup
--
vim.keymap.set("c", "<cr>", function()
    if vim.fn.pumvisible() == 1 then
        return '<c-y>'
    end
    return '<cr>'
end, { expr = true })

--
-- Fish autompletation moves input like in commands suggestion popup
--
vim.keymap.set("c", "<down>", function()
    if vim.fn.pumvisible() == 1 then
        return '<right>'
    end
    return '<down>'
end, { expr = true })
vim.keymap.set("c", "<up>", function()
    if vim.fn.pumvisible() == 1 then
        return '<left>'
    end
    return '<up>'
end, { expr = true })
