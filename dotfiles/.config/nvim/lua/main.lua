-- Minideps dependencies...
require("minideps-blink")

-- Base Plugin initialization
require("goto-preview").setup {}
require("neoscroll").setup({
    mappings = {
        '<C-u>', '<C-d>',
        '<C-b>', '<C-f>',
        --'<C-y>', '<C-e>',
        'zt', 'zz', 'zb',
    },
    easing = "quadratic",
})

-- Custom Plugins
require("basics")
require("memory") -- GC tuning, LSP idle stop, RSS monitor
require("file-tree")
require("lsp_configs")
require("ai-completion").setup({ enabled = true })
-- Markview config must apply BEFORE its autocmds attach to startup buffers,
-- otherwise the first render uses the default config (see markview-conf.lua).
-- Its setup() is a cheap table merge, so it stays synchronous.
require("markview-conf")

-- @FUTURE
-- Improve gitgutter with navigation and minimap
-- https://github.com/lewis6991/gitsigns.nvim
-- https://github.com/petertriho/nvim-scrollbar
--

-- Heavy plugins are deferred past startup for a faster launch.
MiniDeps.later(function() require("treesitter") end)

-- CodeCompanion stack (codecompanion, mcphub, img-clip config) is disabled;
-- its plugins are commented out in ~/.vimrc.
--MiniDeps.later(function() require("ccp") end)
