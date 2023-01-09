-- Fish autocompletion <enter> input like
vim.keymap.set("c", "<cr>", function()
    if vim.fn.pumvisible() == 1 then
        return '<c-y>'
    end
    return '<cr>'
end, { expr = true })

-- Fish autompletatino moves input like
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
    return '<down>'
end, { expr = true })
