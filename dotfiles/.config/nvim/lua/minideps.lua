-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
vim.g.gitbranch = "@DEBUGME not defined yet ?!"
vim.g.gitstatus = "@DEBUGME not defnined yet !?"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })


-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
    --vim.o.termguicolors = true
    --vim.cmd('colorscheme randomhue')
end)



later(function()
    --
    -- Blink.cmp
    --
    add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets", "bydlw98/blink-cmp-env", },
        checkout = "v1.0.0", -- check releases for latest tag
    })

    require('blink.cmp').setup({
        fuzzy = {
            prebuilt_binaries = { force_version = "v1.0.0" }
        },
        -- Filetype to work on
        enabled = function() return not vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype) end,

        -- default mappings: https://cmp.saghen.dev/configuration/keymap#presets
        keymap = {
            ['<Esc>'] = { 'hide', 'fallback' },
            --['<Tab>'] = {}
            ['<Tab>'] = { 'select_and_accept', 'fallback' },
            --function(cmp)
            --    if cmp.snippet_active() then
            --        return cmp.accept()
            --    else
            --        return cmp.select_and_accept()
            --    end
            --end,
            ['<C-n>'] = { 'snippet_forward', 'fallback' },
        },


        -- Provider sources
        sources = {
            default = function(ctx)
                -- Dynamically picking providers by treesitter node/filetype
                -- see https://cmp.saghen.dev/recipes.html#sources
                local success, node = pcall(vim.treesitter.get_node)
                if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                    return { 'buffer', 'path', 'env', 'omni' }
                elseif vim.tbl_contains({ "markdown", "text", "conf", "json", "yaml" }, vim.bo.filetype) then
                    return { 'buffer', 'path', 'env', 'omni' }
                else
                    return { 'buffer', 'path', 'env', 'omni', 'lsp', 'snippets' }
                end
            end,
            providers = {
                buffer = {
                    opts = {
                        -- get all buffers, even ones like neo-tree (see doc to filter "normal" buffer)
                        get_bufnrs = vim.api.nvim_list_bufs,
                    }
                },
                env = {
                    name = "Env",
                    module = "blink-cmp-env",
                    --- @type blink-cmp-env.Options
                    opts = {
                        item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
                        show_braces = false,
                        show_documentation_window = true,
                    },
                }

            }
        },

        -- Completion config
        completion = {
            list = { max_items = 20, },
            menu = {
                border = 'single',
                draw = {
                    --columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                },
            },
            documentation = { window = { border = 'double' } },
        },

        -- Signature config
        signature = {
            enabled = true,
            window = { border = 'rounded' },
        },

        -- Documentation config


        -- Commandline config
        cmdline = { enabled = false },

    })
end)
