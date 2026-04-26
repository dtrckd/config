-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        -- Uncomment next line to use 'stable' branch
        -- '--branch', 'stable',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    --vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
require('mini.pick').setup()
local diff = require('mini.diff')
diff.setup({
    source = diff.gen_source.none(),
})

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
    --vim.o.termguicolors = true
    --vim.cmd('colorscheme randomhue')
end)



-- blink.cmp is loaded via `now()` (synchronous) because lsp_configs.lua
-- requires it at startup; `later()` would defer past that require and crash.
now(function()
    --
    -- Blink.cmp
    --
    add({
        source = "saghen/blink.cmp",
        depends = { "rafamadriz/friendly-snippets" },
        --depends = { "rafamadriz/friendly-snippets", "bydlw98/blink-cmp-env" },
        checkout = "v1.10.2", -- check releases for latest tag
    })

    require('blink.cmp').setup({
        fuzzy = {
            -- Rust fuzzy backend: the stock prebuilt binary crashes nvim 0.12 on
            -- first keystroke for all blink.cmp releases beyond v1.6.0 — upstream
            -- bug https://github.com/Saghen/blink.cmp/issues/2429 (unresolved).
            -- Workaround: pin the prebuilt binary to the last known-good v1.6.0.
            -- If this ever breaks, flip `implementation` back to "lua".
            implementation = "prefer_rust",
            prebuilt_binaries = {
                force_version = "v1.6.0",
            },

            sorts = {
                function(a, b)
                    if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
                        return
                    end
                    if (b.client_name == 'Tabby') then
                        return false
                    end
                end,
                -- default sorts
                'exact',
                'score',
                'sort_text',
            },

        },
        -- Filetype to work on
        --enabled = function() return not vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype) end,

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
            ['<C-N>'] = { 'snippet_backward', 'fallback' },
            ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
            ['<C-J>'] = { 'show_documentation', 'hide_documentation' },
        },


        -- Provider sources
        sources = {
            min_keyword_length = 3,
            -- v2: `default` must be a list(string). Dynamic selection is done via
            -- per-provider `enabled` functions on `snippets` and `omni` below.
            -- v1 function (kept for reference):
            -- default = function(ctx)
            --     local success, node = pcall(vim.treesitter.get_node)
            --     if vim.tbl_contains({ "markdown", "text", "conf", "json", "yaml", "codecompanion" }, vim.bo.filetype) then
            --         return { 'buffer', 'path', 'omni', 'lsp', 'env' }
            --     elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            --         return { 'buffer', 'path', 'omni', 'lsp', 'env' }
            --     else
            --         return { 'buffer', 'path', 'lsp', 'env', 'snippets' }
            --     end
            -- end,
            default = { 'buffer', 'path', 'lsp', 'env', 'snippets', 'omni' },
            providers = {
                lsp = {
                    async = true,
                },
                snippets = {
                    enabled = function()
                        if vim.tbl_contains({ "markdown", "text", "conf", "json", "yaml", "codecompanion" }, vim.bo.filetype) then
                            return false
                        end
                        local ok, node = pcall(vim.treesitter.get_node)
                        if ok and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                            return false
                        end
                        return true
                    end,
                },
                omni = {
                    enabled = function()
                        if vim.tbl_contains({ "markdown", "text", "conf", "json", "yaml", "codecompanion" }, vim.bo.filetype) then
                            return true
                        end
                        local ok, node = pcall(vim.treesitter.get_node)
                        if ok and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
                            return true
                        end
                        return false
                    end,
                },
                buffer = {
                    opts = {
                        -- Default to all visible buffers
                    }
                },
                path = {
                    opts = {
                        -- https://cmp.saghen.dev/recipes#path-completion-from-cwd-instead-of-current-buffer-s-directory
                        get_cwd = function(_) return vim.fn.getcwd() end,
                    },
                },
                env = {
                    name = "Env",
                    module = "blink-cmp-env",
                    --- @type blink-cmp-env.Options
                    opts = {
                        item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
                        show_braces = false,
                        show_documentation_window = false,
                    },
                }

            }
        },

        -- Completion config
        completion = {
            trigger = {
            },
            list = { max_items = 20, },
            menu = {
                border = 'single',
                draw = {
                    --columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                },
            },
            documentation = {
                auto_show = false,
                auto_show_delay_ms = 10000,
                window = { border = 'double' }
            },
            ghost_text = { enabled = false },
        },

        -- Signature config
        signature = {
            enabled = false,
            window = { border = 'rounded' },
        },

        -- Documentation config


        -- Commandline config
        cmdline = { enabled = false },

    })
end)

-- change default ghost color
vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#999999", bg = "NONE" })
