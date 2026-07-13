-- Markview configuration.
--
-- Loaded SYNCHRONOUSLY from main.lua (not deferred via MiniDeps.later):
-- markview is managed by Vundle, so its plugin/ autocmds attach to markdown
-- buffers during startup. setup() must run before that attach or the first
-- render uses the default config (signs visible, wrong icons) and glitches.
-- setup() is cheap (a table merge into markview.spec), so this costs nothing.

require("markview").setup({
    preview = {
        filetypes = { "markdown", "codecompanion" },
        icon_provider = "internal", -- "internal", "mini" or "devicons"
        ignore_buftypes = {},
        map_gx = false,
    },
    markdown = {
        list_items = {
            indent_size = 1,
            shift_width = 1,
        },
        headings = {
            heading_1 = { sign = "" },
            heading_2 = { sign = "" },
            heading_3 = { sign = "" },
            heading_4 = { sign = "" },
            heading_5 = { sign = "" },
            heading_6 = { sign = "" },
            setext_1 = { sign = "" },
            setext_2 = { sign = "" },
            setext_3 = { sign = "" },
            setext_4 = { sign = "" },
        },
        code_blocks = { sign = false },
    },
    markdown_inline = {
        hyperlinks = {
            default = {
                icon = "",
            },
        },
        internal_links = {
            default = {
                icon = "",
            },
        },
        uri_autolinks = {
            default = {
                icon = "",
            },
        },
    },
})

vim.api.nvim_set_hl(0, "MarkviewHeading1", { bg = "#251e2a", fg = "#ff79c6", bold = true }) -- Purple/Pink
vim.api.nvim_set_hl(0, "MarkviewHeading2", { bg = "#1e2229", fg = "#bd93f9", bold = true }) -- Light Purple
vim.api.nvim_set_hl(0, "MarkviewHeading3", { bg = "#1c2328", fg = "#8be9fd", bold = true }) -- Cyan
vim.api.nvim_set_hl(0, "MarkviewHeading4", { bg = "#1c2820", fg = "#50fa7b", bold = true }) -- Green
vim.api.nvim_set_hl(0, "MarkviewHeading5", { bg = "#1e221c", fg = "#f1fa8c", bold = true }) -- Yellow
vim.api.nvim_set_hl(0, "MarkviewHeading6", { bg = "#1e1e1e", fg = "#6272a4", bold = true }) -- Muted Gray
vim.api.nvim_set_hl(0, "MarkviewHyperlink", { fg = "#8be9fd", underline = true })           -- blue like
vim.api.nvim_set_hl(0, "MarkviewCode", { bg = "#1f2128" })                                  -- stealther background
