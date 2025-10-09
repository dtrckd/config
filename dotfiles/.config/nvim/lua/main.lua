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
require("ccp")
