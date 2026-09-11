--
-- Enable tree-sitter (nvim-treesitter `main` branch, Neovim 0.12+)
--
-- Usage cheatsheet:
--   :checkhealth nvim-treesitter   -- verify CLI + parser status
--   :Inspect                        -- show TS node + highlight under cursor
--   :InspectTree                    -- open the parse tree for the buffer
--   :TSInstall <lang>               -- install a parser
--   :TSUpdate                       -- rebuild all installed parsers
--   :TSUninstall <lang>             -- remove a parser
-- Toggle highlighting for current buffer:
--   :lua vim.treesitter.stop()      -- disable TS on current buffer
--   :lua vim.treesitter.start()     -- re-enable TS on current buffer
require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Neovim 0.12 ships bundled parsers for: bash, c, diff, html, lua, markdown,
-- query, vim, vimdoc. The list below covers the rest.
-- `markdown_inline` is an injection parser (not a filetype) — install it,
-- but do NOT add it to any FileType autocmd pattern.
local ts_parsers = {
    "c", "lua", "vim", "vimdoc", "query",
    "markdown", "markdown_inline",
    "python", "cpp", "json", "toml", "yaml",
    "go", "rust", "tsx", "typescript",
    "elm", "css", "html",
}

local have = require("nvim-treesitter.config").get_installed()
local missing = vim.tbl_filter(function(p)
    return not vim.tbl_contains(have, p)
end, ts_parsers)
if #missing > 0 then
    require("nvim-treesitter").install(missing)
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

-- Re-start TS on BufEnter so injections (fenced markdown blocks, etc.) survive
-- `:e` and buffer reloads. See neovim/neovim#37552.
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

-- This module is loaded via MiniDeps.later(): buffers opened during startup
-- fired their FileType event before the autocmds above existed, so start
-- treesitter on them now.
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
        pcall(vim.treesitter.start, buf)
    end
end

