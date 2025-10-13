--
-- LSP / codecompanion config
--

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


local blink = require('blink.cmp')

-- Get base capabilities from blink.cmp and add position encoding support
local base_capabilities = blink.get_lsp_capabilities()
base_capabilities.general = base_capabilities.general or {}
base_capabilities.general.positionEncodings = { 'utf-16' }  -- Force UTF-16 for all clients

--
-- Tabby configuration
--  @DEBUG: To workaround the self-certificate issue: sudo cp /home/dtrckd/main/missions/fractale/src/ansible-fractale/roles/endpoints/ai/tabby.crt /usr/local/share/ca-certificates/tabby.crt
--
vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--stdio" }
vim.g.tabby_inline_completion_trigger = "manual"
vim.g.tabby_inline_completion_keybinding_accept = "<C-p>" -- overwrite the initial mapping :/ (C-Enter, C-*, do not work; workaround ?)
vim.g.tabby_inline_completion_keybinding_trigger_or_dismiss = "<C-^>"
--vim.g.tabby_inline_completion_insertion_leading_key = "<C-R><C-O>="

-- Disable vim-tabby's automatic LSP setup (we manage it ourselves below)
-- @DEBUG: vim-tabby overwritten
vim.g.tabby_disable_lsp_setup = true

vim.api.nvim_create_user_command('TabbyToggle', function()
    local clients = vim.lsp.get_clients({ name = 'tabby' })
    if #clients > 0 then
        vim.lsp.stop_client(clients[1].id)
        print("Tabby disabled")
    else
        vim.cmd('LspStart tabby')
        print("Tabby enabled")
    end
end, {})

-- Stop Tabby LSP after Vim finishes starting
-- @DEUBG: fix for for https://github.com/TabbyML/vim-tabby/issues/35 and https://github.com/Saghen/blink.cmp/issues/2093
--vim.api.nvim_create_autocmd("VimEnter", {
--    callback = function()
--        vim.defer_fn(function()
--            local clients = vim.lsp.get_clients({ name = 'tabby' })
--            for _, client in ipairs(clients) do
--                vim.lsp.stop_client(client.id)
--            end
--        end, 1000) -- Delay to ensure LSP has started
--    end
--})

-- Make the LSP client use FZF instead of the quickfix list
--local lspfuzzy = require('lspfuzzy')
--lspfuzzy.setup {}


--
-- Global LSP client diagnostic configuration
--
vim.diagnostic.config({
    signs = { severity = { min = vim.diagnostic.severity.ERROR } },
    virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
    --virtual_lines = { severity = { min = vim.diagnostic.severity.ERROR } },
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    float = {
        border = "rounded",
    }
})

-- Log level in :LspLog
vim.lsp.set_log_level("error")


--
-- Enable some language servers
--
-- * https://microsoft.github.io/language-server-protocol/implementors/servers/
-- * https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
    'bashls',
    'elmls',
    'gopls',
    'golangci_lint_ls',
    'lua_ls',
    'pylsp',
    'ruff',
    --'pyright',
    --'ts_ls',
    'yamlls',
    'dockerls',
    'rust_analyzer',
    'tabby',
}

local server_configs = {
    -- Bash
    bashls = {
        filetypes = { 'zsh', 'bash', 'sh' },
    },
    -- Elmlang
    elmls = {
        init_options = {
            --elmReviewDiagnostics = "error",
            elmAnalyseTrigger = "save",
            onlyUpdateDiagnosticsOnSave = true,
        },
        --handlers = {
        --    -- See https://github.com/elm-tooling/elm-language-server/discussions/961
        --    -- See https://github.com/joakin/nvim/blob/be72c11ff2d2c3ee6d6350f2221aabcca373adae/lua/plugins/lspconfig.lua#L148-L157
        --    ["window/showMessageRequest"] = function(whatever, result)
        --        -- For some reason, the showMessageRequest handler doesn't work with
        --        -- the format failed error. It just hangs on the screen and can't
        --        -- interact with the vim.ui.select thingy. So skip it.
        --        if result.message:find("Running elm-format failed", 1, true) then
        --            print(result.message)
        --            return vim.NIL
        --        end
        --        return vim.lsp.handlers["window/showMessageRequest"](whatever, result)
        --    end,
        --},
        --
        on_attach = function(client, bufnr)
            --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            -- Language specific LSP client config
            --vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            --    vim.lsp.diagnostic.on_publish_diagnostics, {
            --    }
            --)

            -- Trying to fix erratic behavior with elm-format, on save...
            if client.config.flags then
                client.config.flags.allow_incremental_sync = true
            end

            -- Function to check if there are any diagnostics with non-zero severity
            -- TODO: trying to solve the elm-format error log when there is a LSP error !!!
            local function should_format()
                local diagnostics = vim.diagnostic.get(bufnr)
                for _, diagnostic in ipairs(diagnostics) do
                    if diagnostic.severity == vim.diagnostic.severity.ERROR then
                        return false
                    end
                end
                return true
            end

            -- Auto format on save
            vim.cmd [[autocmd BufWritePre *.elm lua vim.lsp.buf.format()]]
            -- Auto format on save if no errors are present (Debug Me)
            --vim.cmd(string.format("autocmd BufWritePre <buffer=%d> lua if should_format() then vim.lsp.buf.format() end", bufnr))

            -- Tame diagnostics (https://github.com/neovim/nvim-lspconfig/issues/127)
            --vim.api.nvim_command [[autocmd InsertLeave <buffer> lua publish_diagnostics()]]
        end
    },
    -- Golang
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    gopls = {
        settings = {
            gopls = {
                analyses = { unusedparams = true, },
                staticcheck = false,
                annotations = { inline = false },
                gofumpt = true,
            },
        },
        --
        on_attach = function(client, bufnr)
            -- Auto format on save
            vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.format()]]
            -- Auto import sort on save
            --vim.api.nvim_create_autocmd('BufWritePre',
            --    { pattern = '*.go', callback = function() vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true }) end })
        end
    },
    golangci_lint_ls = {
        cmd = { "golangci-lint-langserver" },
        init_options = { command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" } },
        root_markers = { '.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json', 'go.work', 'go.mod', '.git' },
    },
    -- Lualang
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = { -- Get the language server to recognize the `vim` global
                    globals = { 'vim', 'require' },
                },
                workspace = { -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        max_line_length = "200",
                        indent_size = "4",
                    }
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },

        --on_attach = function(client, bufnr)
        --    -- Auto format on save
        --    vim.cmd [[autocmd BufWritePre *.lua lua vim.lsp.buf.format()]]
        --end
    },
    -- Python
    ruff = {
        init_options = {
            settings = {
                -- Any extra CLI arguments for `ruff` go here.
                args = { '--ignore-noqa' },
            }
        },

        -- This is grave Bugged. Sometimes remove lines. Do not respect isort.sections...
        --on_attach = function(client, bufnr)
        --    -- Auto import sort on save
        --    vim.api.nvim_create_autocmd('BufWritePre',
        --        { pattern = '*.py', callback = function() vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true }) end })
        --end
    },
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    -- Linting
                    pycodestyle = {
                        enabled = false,
                        ignore = { 'W391', "E401", "E124", "E26", "E265", "E731", "E226", "E402", "E501", "E303" },
                        maxlinelength = 125
                    },
                    flake8 = { enabled = false, maxLineLength = 125 },
                    pylint = { enabled = false },
                    pyflakes = { enabled = false },
                    -- Type checker
                    pylsp_mypy = { enabled = false },
                    -- formating
                    black = { enabled = false, line_length = 125 },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    -- Jedi
                    jedi = { extra_paths = { vim.fn.getcwd() } },
                }
            }
        }
    },
    --pyright = {
    --    settings = {
    --        python = {
    --            analysis = {
    --                --reportGeneralTypeIssues = "off", no...
    --                diagnosticSeverityOverrides = {
    --                    reportGeneralTypeIssues = "warning", -- or anything
    --                    reportOptionalMemberAccess = "warning",
    --                },
    --            }
    --        }
    --    }
    --},
    -- Typescript/Javascript
    ts_ls = {},
    yamlls = {
        settings = {
            schemas = {
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
                ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "k8s/*.{yml,yaml}",
                ["http://json.schemastore.org/composer"] = "composer.{yml,yaml}",
                ["http://json.schemastore.org/circleciconfig"] = ".circleci/config.{yml,yaml}",
            },
        },
    },
    dockerls = {},
    rust_analyzer = {
        -- Server-specific settings. See `:help lspconfig-setup`
        settings = {
            ['rust-analyzer'] = {},
        },
    },
    -- Tabby AI Completion
    tabby = {
        cmd = { "npx", "tabby-agent", "--stdio" },
        --filetypes = { "*" },
        single_file_support = true,
        init_options = {
            clientCapabilities = {
                textDocument = {
                    inlineCompletion = true
                }
            }
        },
        root_dir = vim.env.HOME,
        on_attach = function(client, buf)
            vim.api.nvim_command("doautocmd <nomodeline> User tabby_lsp_on_buffer_attached")
        end
    },

}

for _, lsp in ipairs(servers) do
    local config = server_configs[lsp] or {}
    config.capabilities = base_capabilities -- Apply capabilities with position encoding to all servers
    vim.lsp.config(lsp, config)
    vim.lsp.enable(lsp)
    -- Prior nvim v0.11
    --vim.lsp.config(server_configs[lsp])
    --local config = server_configs[lsp]
    --config.capabilities = blink.get_lsp_capabilities({})
    --blink.get_lsp_capabilities(config)
end

--
-- Toggle mypy
--

function _G.toggle_pylsp_mypy()
    -- Get the list of LSP clients attached to the current buffer
    local clients = vim.lsp.get_clients() -- Restrict to the current buffer by default
    -- Iterate over the clients to find the pylsp client
    for _, client in pairs(clients) do
        if client.name == 'pylsp' then
            -- Access or initialize the client's settings
            client.config.settings = client.config.settings or {}
            local settings = client.config.settings

            settings.pylsp = settings.pylsp or {}
            settings.pylsp.plugins = settings.pylsp.plugins or {}
            settings.pylsp.plugins.pylsp_mypy = settings.pylsp.plugins.pylsp_mypy or {}

            -- Toggle the 'enabled' setting for pylsp_mypy
            local mypy_settings = settings.pylsp.plugins.pylsp_mypy
            mypy_settings.enabled = not mypy_settings.enabled

            -- Set live_mode to True when enabling pylsp_mypy
            -- * When `live_mode` is set to `True`, `pylsp_mypy` uses the contents of the current buffer (your open file in Neovim) and runs `mypy` only on that code.
            -- * This mode is useful to get quick feedback on the current file without the overhead of checking the entire project.
            if mypy_settings.enabled then
                -- mypy_settings.live_mode = true
            else
                -- mypy_settings.live_mode = false
            end

            -- Notify pylsp of the configuration change
            client.notify('workspace/didChangeConfiguration', { settings = settings })

            -- Provide feedback to the user
            if mypy_settings.enabled then
                print('pylsp_mypy is now **enabled** in the current buffer')
            else
                print('pylsp_mypy is now **disabled** in the current buffer')
            end

            -- Exit the function after modifying the pylsp client
            return
        end
    end

    -- If no pylsp client is found for the current buffer
    print('No pylsp client attached to the current buffer')
end

map('n', '<leader>mypy', '<cmd>lua toggle_pylsp_mypy()<CR>')
vim.api.nvim_create_user_command('ToggleMypy', toggle_pylsp_mypy, {})




-- Toggle the diagnostics severity level
function _G.toggle_diagnostics(severity)
    local current_config = vim.diagnostic.config()

    -- Determine the new minimum severity
    local current_min_severity = current_config.signs.severity.min
    local new_min_severity

    if current_min_severity == vim.diagnostic.severity.ERROR then
        new_min_severity = severity
        print("Diagnostics: Showing from HINT")
    else
        new_min_severity = vim.diagnostic.severity.ERROR
        print("Diagnostics: Showing only ERROR")
    end

    -- Update just the severity settings in the current config
    current_config.signs.severity.min = new_min_severity
    --current_config.virtual_text.severity.min = new_min_severity
    current_config.virtual_lines.severity.min = new_min_severity

    -- Apply the updated config
    vim.diagnostic.config(current_config)
end

function _G.toggle_virtual_lines()
    local current_config = vim.diagnostic.config()
    local severity = current_config.signs.severity.min
    if current_config.virtual_lines then
        vim.diagnostic.config({
            virtual_lines = false,
            virtual_text = { severity = { min = severity } }
        })
    else
        vim.diagnostic.config({
            virtual_lines = { severity = { min = severity } },
            virtual_text = false
        })
    end
end

-- LSP Diagnostics navigation
map('n', '<leader>e', "<cmd>lua vim.diagnostic.enable()<CR>")
map('n', '<leader>q', "<cmd>lua vim.diagnostic.disable()<CR>")
map('n', '<leader>el', "<cmd>lua vim.diagnostic.setloclist()<CR>")
map('n', '<leader>et', "<cmd>lua toggle_virtual_lines()<CR>")
map('n', '<leader>ew', '<cmd>lua toggle_diagnostics(vim.diagnostic.severity.WARN)<CR>')
map('n', '<leader>ez', '<cmd>lua toggle_diagnostics(vim.diagnostic.severity.HINT)<CR>')
map('n', '<leader>en', '<cmd>lua vim.diagnostic.goto_next({severity={min=vim.diagnostic.config().signs.severity.min}})<CR>')
map('n', '<leader>ep', '<cmd>lua vim.diagnostic.goto_prev({severity={min=vim.diagnostic.config().signs.severity.min}})<CR>')
map('n', '<leader>eN', '<cmd>lua vim.diagnostic.goto_prev({severity={min=vim.diagnostic.config().signs.severity.min}})<CR>')
map('n', '<leader>eh', '<cmd>lua vim.diagnostic.open_float()<CR>')
-- LSP Code navigation
map('n', '<leader>x', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>v', '<cmd>rightbelow vsplit | lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>b', '<cmd>belowright split | lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>t', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>D', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<leader>i', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<leader>ii', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async=true})<CR>')
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<leader>S', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
-- Show definition in a preview dialog
map('n', '<leader>h', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
-- Rename Symbol using LSP
map('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- Rename symbol globally (ack)
function _G.rename_symbol()
    local current_word = vim.fn.expand('<cword>')
    local new_name = vim.fn.input('Rename ' .. current_word .. ' to: ')
    if new_name == '' or new_name == current_word then
        return
    end

    -- Temporarily override ackprg to disable smart-case
    local original_ackprg = vim.g.ackprg
    vim.g.ackprg = 'rg -w -s --vimgrep --type-not sql'
    -- Store the current buffer number
    local original_bufnr = vim.fn.bufnr('%')
    -- Get the directory of the current file
    local current_file_dir = vim.fn.expand('%:p:h')
    -- Use Ack to search in the current file's directory
    vim.cmd('Ack! ' .. current_word .. ' ' .. current_file_dir)
    -- Apply the substitution in the quickfix list
    vim.cmd('cfdo %s/\\V' .. current_word .. '/' .. new_name .. '/gc | update')

    vim.cmd('cclose')                    -- Close the quickfix list
    vim.cmd('buffer ' .. original_bufnr) -- Return to the original buffer
    vim.g.ackprg = original_ackprg       -- Restore the original ackprg
end

-- Change default ghost color
map('n', '<leader>R', '<cmd>lua rename_symbol()<CR>')
