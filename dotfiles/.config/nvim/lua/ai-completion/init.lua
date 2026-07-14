-- ai-completion: manual, self-contained AI ghost-text completion.
-- Never registers as an LSP client. Trigger with <C-^>, accept with <C-p>.
local config = require("ai-completion.config")
local context = require("ai-completion.context")
local client = require("ai-completion.client")
local ghost = require("ai-completion.ghost")

local M = {}

M.active = false

-- Set true while we perform the accept insertion so the dismiss autocmds
-- (TextChangedI/CursorMovedI) do not clear the ghost mid-insert.
local accepting = false

-- Autocmd group for the dismiss handlers.
local augroup = vim.api.nvim_create_augroup("AICompletion", { clear = true })

-- Trigger a completion request at the current cursor position.
local function trigger()
    ghost.clear()

    if not config.token or config.token == "" then
        vim.notify("ai-completion: TABBY_API_TOKEN is not set", vim.log.levels.ERROR)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)

    local payload = context.build(bufnr)
    client.complete(payload, function(text)
        if not text then return end

        -- Discard stale responses: buffer, cursor, and edits must be unchanged.
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        if vim.api.nvim_get_current_buf() ~= bufnr then return end
        if vim.api.nvim_buf_get_changedtick(bufnr) ~= tick then return end
        local now = vim.api.nvim_win_get_cursor(0)
        if now[1] ~= cursor[1] or now[2] ~= cursor[2] then return end

        ghost.show(bufnr, cursor[1] - 1, cursor[2], text)
    end)
end

-- Accept a pending suggestion, or fall back to real <C-p> keyword completion.
local function accept()
    local pending = ghost.pending
    if not pending then
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-p>", true, false, true),
            "n", false
        )
        return
    end

    accepting = true
    local lines = vim.split(pending.text, "\n", { plain = true })
    -- Literal WYSIWYG insertion at the cursor, no autoindent.
    vim.api.nvim_put(lines, "c", false, true)
    ghost.clear()
    -- Release the gate after the self-inflicted TextChangedI has fired.
    vim.schedule(function() accepting = false end)
end

-- Dismiss the ghost on any user edit/movement (unless we are accepting).
local function dismiss()
    if accepting then return end
    if ghost.pending then ghost.clear() end
end

function M.enable()
    if M.active then return end
    M.active = true

    vim.keymap.set("i", config.keymaps.trigger, trigger,
        { silent = true, desc = "ai-completion: trigger" })
    vim.keymap.set("i", config.keymaps.accept, accept,
        { silent = true, desc = "ai-completion: accept" })

    vim.api.nvim_create_autocmd({ "TextChangedI", "CursorMovedI", "InsertLeave" }, {
        group = augroup,
        callback = dismiss,
    })
end

function M.disable()
    if not M.active then return end
    M.active = false

    client.cancel()
    ghost.clear()
    pcall(vim.keymap.del, "i", config.keymaps.trigger)
    pcall(vim.keymap.del, "i", config.keymaps.accept)
    vim.api.nvim_clear_autocmds({ group = augroup })
end

function M.toggle()
    if M.active then M.disable() else M.enable() end
    vim.notify("ai-completion: " .. (M.active and "enabled" or "disabled"))
end

function M.setup(opts)
    for k, v in pairs(opts or {}) do
        config[k] = v
    end

    -- Explicit grey, not linked to Comment.
    vim.api.nvim_set_hl(0, "AICompletionGhost", { fg = "#808080" })

    vim.api.nvim_create_user_command("AICompletionToggle", function()
        M.toggle()
    end, { desc = "Toggle ai-completion" })

    if config.enabled then
        M.enable()
    end
end

return M
