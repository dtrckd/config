--
-- CodeCompanion config — DISABLED, not required from main.lua.
-- (treesitter setup moved to lua/treesitter.lua)
--

require("img-clip").setup({
    filetypes = {
        codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
        }
    }
})

-- @STALE
--require("mcphub").setup({
--    config = vim.fn.expand("~/.config/mcphub/servers.json"),
--    auto_approve = false,
--})

--
-- Enable Code-Companion
--
local ccp = require("codecompanion").setup({
    -- Default config in: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
    rules = {
        -- Check examples at https://github.com/olimorris/codecompanion.nvim/tree/main/.codecompanion
        default = {
            files = {
                "AGENTS.md",
                { path = "CLAUDE.md",       parser = "claude" },
                { path = "CLAUDE.local.md", parser = "claude" },
                { path = "~/AGENTS.md" },
            },
        },
    },
    interactions = {
        diff = {
            providers = "split", -- inline|split|mini_diff
        },
        chat = {
            --adapter = "anthropic_sonnet",
            adapter = "claude_code",
            tools = {
                groups = {
                    ["dev"] = {
                        description = "Edit files with access to current buffer context",
                        prompt = "I'm giving you access to ${tools} to help you edit file, and in particular the current buffer #{buffer}.",
                        system_prompt = "When editing files, always use the insert_edit_into_file tool.",
                        tools = {
                            "insert_edit_into_file",
                        },
                        opts = {
                            collapse_tools = true,
                            require_approval_before = true,
                        },
                    },
                    ["reader"] = {
                        description = "Search files, fetch webpages, and grep through codebase",
                        prompt = "I'm giving you access to ${tools} to help you search and explore the codebase.",
                        system_prompt = "Use file_search to find files by name, grep_search to search file contents, and fetch_webpage to retrieve web content.",
                        tools = {
                            "fetch_webpage",
                            "read_file",
                            "file_search",
                            "grep_search",

                        },
                        opts = {
                            collapse_tools = true,
                            require_approval_before = false,
                        },
                    },
                },
                opts = {
                    wait_timeout = 300000, -- How long to wait for user input before timing out (milliseconds)
                    default_tools = {
                        --"fetch_webpage",
                        --"read_file",
                    },
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
            --adapter = "anthropic_haiku",
            adapter = "claude_code",
        },
        cmd = {
            --adapter = "anthropic_haiku",
            adapter = "claude_code",
        },
        agent = {
            --adapter = "anthropic_sonnet",
            adapter = "claude_code",
        },
    },
    adapters = {
        acp = {
            claude_code = function()
                return require("codecompanion.adapters").extend("claude_code", {
                    env = {
                        CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
                        -- blank the key so claude-agent-acp falls back to OAuth
                        -- (function form: a plain "" resolves to the whole adapter table)
                        ANTHROPIC_API_KEY = function() return "" end,
                    },
                })
            end,
        },
        http = {
            opts = {
                show_model_choices = false,
            },
            openai = function()
                return require("codecompanion.adapters").extend("openai", {
                    schema = {
                        model = { default = "gpt-5.6-sol" },
                    },
                })
            end,
            anthropic_haiku = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-haiku-4-5" },
                        extended_thinking = { default = false },
                    },
                })
            end,
            anthropic_sonnet = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-sonnet-5" },
                        extended_thinking = { default = false },
                    },
                })
            end,
            anthropic_sonnet_thinking = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-sonnet-5" },
                        extended_thinking = { default = true },
                    },
                })
            end,
            anthropic_opus = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-opus-5" },
                        extended_thinking = { default = false },
                    },
                })
            end,
            anthropic_opus_thinking = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    schema = {
                        model = { default = "claude-opus-5" },
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
                    --name = "anthropic_opus",
                    name = "claude_code",
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
        -- @STALE
        --mcphub = {
        --    callback = "mcphub.extensions.codecompanion",
        --    opts = {
        --        show_result_in_chat = true, -- Show mcp tool results in chat
        --        make_vars = true,           -- Convert resources to #variables
        --        make_slash_commands = true, -- Add prompts as /slash commands
        --    }
        --},
        history = {
            enabled = false, -- wiring it to claude-acp is not supported
            opts = {
                expiration_days = 45,
                delete_on_clearing_chat = true,
                --picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
                title_generation_opts = {
                    ---Number of user prompts after which to refresh the title (0 to disable)
                    refresh_every_n_prompts = 2, -- e.g., 3 to refresh after every 3rd user prompt
                    ---Maximum number of times to refresh the title (default: 3)
                    max_refreshes = 1,
                    adapter = "anthropic_haiku",
                }
            }
        },
    },

})

-- mcphub's variables.lua calls `config.interactions.chat.variables` which no longer exists:
--   v19:  interactions.chat.variables      → interactions.chat.editor_context
--   v20+: interactions.chat.editor_context → interactions.shared.editor_context
-- Alias the current location back to the old key so mcphub doesn't blow up with nil pairs().
-- @STALE
--local ok, cc_config = pcall(require, "codecompanion.config")
--if ok and cc_config.interactions and cc_config.interactions.chat
--    and not cc_config.interactions.chat.variables then
--    cc_config.interactions.chat.variables =
--        (cc_config.interactions.shared or {}).editor_context or {}
--end
