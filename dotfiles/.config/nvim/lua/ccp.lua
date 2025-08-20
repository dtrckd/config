--
-- Enable tree-sitter
--
---@diagnostic disable
require("nvim-treesitter.configs").setup({
    -- graphql is unmaintained
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "cpp", "json", "toml", "yaml", "go", "rust", "tsx", "typescript", "elm", "css", "html" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    highlight = {
        enable = true, -- `false` will disable the whole extension
        additional_vim_regex_highlighting = false,
    },
})
---@diagnostic enable

require("img-clip").setup({
    filetypes = {
        codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
        }
    }
})

require("mcphub").setup({
    config = vim.fn.expand("~/.config/mcphub/servers.json"),
    auto_approve = false,
})


--
-- Enable Code-Companion
--
local ccp = require("codecompanion").setup({
    -- Default config in: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    strategies = {
        chat = {
            adapter = "anthropic",
            tools = {
                groups = {
                    ["context7"] = {
                        description = "Search in official api and lib documentation and snippets",
                        tools = {
                            "context7__get-library-docs",
                            "context7__resolve-library-id",
                            "get-library-docs",
                            "resolve-library-id",
                        },
                        opts = {
                            collapse_tools = true,
                        }
                    },
                },
                opts = {
                    wait_timeout = 300000, -- How long to wait for user input before timing out (milliseconds)
                }
            },
        },
        inline = {
            adapter = "openai",
        },
        cmd = {
            adapter = "openai",
        },
        agent = {
            adapter = "anthropic",
        },
    },
    adapters = {
        openai = function()
            return require("codecompanion.adapters").extend("openai", {
                schema = {
                    model = { default = "gpt-4.1" },
                },
            })
        end,
        anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
                schema = {
                    model = { default = "claude-3-7-sonnet-20250219" },
                    extended_thinking = { default = false },
                },
            })
        end,
        anthropic_thinking = function()
            return require("codecompanion.adapters").extend("anthropic", {
                schema = {
                    model = { default = "claude-3-7-sonnet-20250219" },
                    extended_thinking = { default = true },
                },
            })
        end,
        anthropic4 = function()
            return require("codecompanion.adapters").extend("anthropic", {
                schema = {
                    model = { default = "claude-opus-4-20250514" },
                    extended_thinking = { default = false },
                },
            })
        end,
        anthropic_thinking4 = function()
            return require("codecompanion.adapters").extend("anthropic", {
                schema = {
                    model = { default = "claude-opus-4-20250514" },
                    extended_thinking = { default = true },
                },
            })
        end,
    },

    extensions = {
        mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
                show_result_in_chat = true, -- Show mcp tool results in chat
                make_vars = true,           -- Convert resources to #variables
                make_slash_commands = true, -- Add prompts as /slash commands
            }
        },
        history = {
            enabled = true,
            opts = {
                expiration_days = 45,
                delete_on_clearing_chat = false,
            }
        },
    },
    opts = {
        system_prompt = function(opts)
            if opts.adapter == "code_chat" then
                return "You are an helpfull code assistant."
            else
                return "You are an helpfull code assistant."
                -- @DEBUG: the following doesn't work :'(
                -- return opts.system_prompt
            end
        end,
    },

})
