--
-- LSP/COQ config
--

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--local use = require('packer').use
--require('packer').startup(function()
--  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
--  use { 'ms-jpq/coq_nvim', run = 'python3 -m coq deps' }
--  use 'ms-jpq/coq.artifacts'
--  use 'ms-jpq/coq.thirdparty'
--end)

local lspconfig = require('lspconfig')
local coq = require('coq')

-- Global Client configuration
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Set virtual text
        virtual_text = {
            severity = 'Error',
        },

        -- Set signs
        signs = {
            severity = 'Error',
        },

        severity_sort = true,
        update_in_insert = false,
    }
)

--do -- Tame diagnostics (https://github.com/neovim/nvim-lspconfig/issues/127)
--    local default_callback = vim.lsp.handlers["textDocument/publishDiagnostics"]
--    local err, method, params, client_id
--
--    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
--        err, method, params, client_id = ...
--        if vim.api.nvim_get_mode().mode ~= "i" and vim.api.nvim_get_mode().mode ~= "ic" then
--            publish_diagnostics()
--        end
--    end
--
--    function publish_diagnostics()
--        default_callback(err, method, params, client_id)
--    end
--end

-- Enable some language servers, see
-- * https://microsoft.github.io/language-server-protocol/implementors/servers/
-- * https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
    'bashls',
    'dockerls',
    'elmls',
    'gopls',
    'golangci_lint_ls',
    'jsonls',
    'lua_ls',
    'pylsp',
    'pyright',
    'tsserver',
    'yamlls',
}

local configs = {
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
        --
        on_attach = function(client, bufnr)
            --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            -- Language specific LSP client config
            --vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            --    vim.lsp.diagnostic.on_publish_diagnostics, {
            --    }
            --)
            -- Trying to fix erratic behavior with elm-format, on save...
            --if client.config.flags then
            --    client.config.flags.allow_incremental_sync = true
            --end
            -- Auto format on save
            -- @DEBUG: still use zaptic/elm-format becaus format with lsp is so slow :(
            --vim.cmd [[autocmd BufWritePre *.elm lua vim.lsp.buf.format()]]
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
            },
        },
        --
        on_attach = function(client, bufnr)
            -- Auto format on save
            vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.format()]]
            --vim.api.nvim_create_autocmd('BufWritePre',
            --    { pattern = '*.go', callback = function() vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true }) end })
        end
    },
    golangci_lint_ls = {
        root_dir = lspconfig.util.root_pattern('.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json', 'go.work', 'go.mod', '.git'),
        command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" },
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
        --
        on_attach = function(client, bufnr)
            -- Auto format on save
            vim.cmd [[autocmd BufWritePre *.lua lua vim.lsp.buf.format()]]
        end
    },
    -- Python
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    --autopep8 = { enabled = true },
                    pycodestyle = {
                        ignore = { 'w391', "e401", "e124", "e26", "e265", "e731", "e226", "e402" },
                        maxlinelength = 125
                    },
                    flake8 = {},
                }
            }
        }
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    --reportGeneralTypeIssues = "off", no...
                    diagnosticSeverityOverrides = {
                        reportGeneralTypeIssues = "warning", -- or anything
                        reportOptionalMemberAccess = "warning",
                    },
                }
            }
        }
    },
    -- Typescript/Javascript
    --tsserver = { },
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup(coq.lsp_ensure_capabilities(
        configs[lsp]
    ))
end

-- shows on BufWrite for all clients attached to current buffer, where virtual_text is false, but underline and signs default true
--vim.cmd[[autocmd BufWrite * :call timer_start(500, { -> v:lua.vim.lsp.diagnostic.show_buffer_diagnostics()})]]

-- Make the LSP client use FZF instead of the quickfix list
--local lspfuzzy = require('lspfuzzy')
--lspfuzzy.setup {}


-- Toggle the diagnostics virtual text
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = false,
            }
        )
        print('Diagnostics are hidden')
    else
        vim.g.diagnostics_visible = true
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
            }
        )
        --vim.diagnostic.reset()
        --vim.diagnostic.enable()
        print('Diagnostics are visible')
    end
end

-- Toggle the Warning diagnostics
vim.g.warning_diagnostics_visible = false
function _G.toggle_warning_diagnostics()
    if vim.g.warning_diagnostics_visible then
        vim.g.warning_diagnostics_visible = false
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = { severity = 'Error' },
                signs = { severity = 'Error' },
            }
        )
        print('Warning Diagnostics are hidden')
    else
        vim.g.warning_diagnostics_visible = true
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = { severity = 'Warn' },
                signs = { severity = 'Warn' },
            }
        )
        --vim.diagnostic.reset()
        --vim.diagnostic.enable()
        print('Warning Diagnostics are visible')
    end
end

-- LSP mappings
vim.keymap.set('n', '<leader>e', vim.diagnostic.enable)
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.disable)
vim.keymap.set('n', '<leader>el', vim.diagnostic.setloclist)
vim.api.nvim_set_keymap('n', '<leader>ez', ':call v:lua.toggle_diagnostics()<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ew', ':call v:lua.toggle_warning_diagnostics()<CR>', { silent = true, noremap = true })
map('n', '<leader>en', '<cmd>lua vim.diagnostic.goto_next({severity="Error"})<CR>')
map('n', '<leader>ep', '<cmd>lua vim.diagnostic.goto_prev({severity="Error"})<CR>')
map('n', '<leader>eN', '<cmd>lua vim.diagnostic.goto_prev({severity="Error"})<CR>')
map('n', '<leader>eh', '<cmd>lua vim.diagnostic.open_float()<CR>')
map('n', '<leader>x', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>v', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>b', '<cmd>belowright split | lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>t', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>')
map('n', '<leader>D', '<cmd>lua vim.lsp.buf.declaration()<CR>')
--map('n', 'gd'         , '<cmd>lua vim.lsp.buf.definition()<CR>')
--map('n', 'gD'         , '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<leader>s', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<leader>i', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<leader>ii', '<cmd>lua vim.lsp.buf.implementation()<CR>')
map('n', '<leader>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>l', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({async=true})<CR>')
map('n', '<leader>a', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<leader>S', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
