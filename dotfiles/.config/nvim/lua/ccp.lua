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

require("markview").setup({
    preview = {
        filetypes = { "markdown", "codecompanion" },
        icon_provider = "internal", -- "internal", "mini" or "devicons"
        ignore_buftypes = {},
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

vim.api.nvim_set_hl(0, "MarkviewHeading1", { bg = "#3d2a4d", fg = "#ff79c6", bold = true }) -- Purple/Pink
vim.api.nvim_set_hl(0, "MarkviewHeading2", { bg = "#2d3a4d", fg = "#bd93f9", bold = true }) -- Light Purple
vim.api.nvim_set_hl(0, "MarkviewHeading3", { bg = "#2a3d4d", fg = "#8be9fd", bold = true }) -- Cyan
vim.api.nvim_set_hl(0, "MarkviewHeading4", { bg = "#2a4d3d", fg = "#50fa7b", bold = true }) -- Green
vim.api.nvim_set_hl(0, "MarkviewHeading5", { bg = "#2a3d2d", fg = "#f1fa8c", bold = true }) -- Yellow
vim.api.nvim_set_hl(0, "MarkviewHeading6", { bg = "#2d2d2d", fg = "#6272a4", bold = true }) -- Muted Gray
vim.api.nvim_set_hl(0, "MarkviewHyperlink", { fg = "#8be9fd", underline = true })  -- blue like
vim.api.nvim_set_hl(0, "MarkviewCode", { bg = "#1f2128" }) -- stealther background

--
-- Enable Code-Companion
--
local ccp = require("codecompanion").setup({
    -- Default config in: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    --rules = {
    -- Check examples at https://github.com/olimorris/codecompanion.nvim/tree/main/.codecompanion
    --    opts = {
    --        chat = { enabled = true, },
    --    },
    --},
    interactions = {
        chat = {
            adapter = "anthropic_sonnet",
            tools = {
                opts = {
                    wait_timeout = 300000, -- How long to wait for user input before timing out (milliseconds)
                }
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
            }
        },
        inline = {
            adapter = "anthropic_haiku",
        },
        cmd = {
            adapter = "anthropic_haiku",
        },
        agent = {
            adapter = "anthropic_sonnet",
        },
    },
    adapters = {
        http = {
            opts = {
                show_model_choices = false,
            },
            openai = function()
                return require("codecompanion.adapters").extend("openai", {
                    schema = {
                        model = { default = "gpt-4.1" },
                    },
                })
            end,
            anthropic_haiku = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-haiku-4-5-20251001" },
                        extended_thinking = { default = false },
                    },
                })
            end,
            anthropic_sonnet = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-sonnet-4-5-20250929" },
                        extended_thinking = { default = false },
                    },
                })
            end,
            anthropic_sonnet_thinking = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-sonnet-4-5-20250929" },
                        extended_thinking = { default = true },
                    },
                })
            end,
            anthropic_opus = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-opus-4-5-20251101" },
                        extended_thinking = { default = false },
                    },
                })
            end,
            anthropic_opus_thinking = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-opus-4-5-20251101" },
                        extended_thinking = { default = true },
                    },
                })
            end,
        }
    },

    prompt_library = {
        ["Short Answer Role"] = {
            strategy = "chat",
            description = "Provides short and direct answers without explanations",
            opts = {
                short_name = "short",
            },
            prompts = {
                {
                    role = "system",
                    content =
                    "You are a direct and concise AI assistant. Provide short, direct answers only. No explanations unless explicitly asked. No elaboration or additional context. Get straightto the point. Use minimal words to convey the answer.",
                },
                {
                    role = "user",
                    content = "",
                    opts = {
                        auto_submit = false,
                    },
                },
            },
        },
        ["Inline Hard"] = {
            strategy = "inline",
            description = "Modify selected code with custom prompt",
            opts = {
                mapping = "<LocalLeader>ih", -- Optional: add a keybinding
                modes = { "v" },             -- Only show in visual mode
                user_prompt = true,          -- This will ask for input before submitting
                auto_submit = true,          -- Auto-submit after getting user input
                placement = "replace",       -- Replace the selected text with the response
                adapter = {
                    name = "anthropic_opus",
                },
            },
            prompts = {
                {
                    role = "system",
                    content = function(context)
                        return "You are an expert "
                            .. context.filetype
                            .. " developer. Modify the code according to the user's request. Return only the modified code without markdown codeblocks or explanations."
                    end,
                },
                {
                    role = "user",
                    content = function(context)
                        local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                        return "I have the following code:\n\n```"
                            .. context.filetype
                            .. "\n"
                            .. text
                            .. "\n```\n\n<user_prompt></user_prompt>"
                    end,
                    opts = {
                        contains_code = true,
                    },
                },
            },
        },
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
                delete_on_clearing_chat = true,
                --picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
            }
        },
    },

})
