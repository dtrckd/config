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
require("lsp_configs")
-- Markview config must apply BEFORE its autocmds attach to startup buffers,
-- otherwise the first render uses the default config (see markview-conf.lua).
-- Its setup() is a cheap table merge, so it stays synchronous.
require("markview-conf")

-- Heavy plugins (treesitter setup, codecompanion, mcphub, img-clip)
-- are deferred past startup for a faster launch.
MiniDeps.later(function() require("ccp") end)
