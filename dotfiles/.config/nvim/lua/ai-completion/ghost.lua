-- Extmark-based ghost (shadow) text rendering.
local M = {}

local ns = vim.api.nvim_create_namespace("ai_completion_ghost")

-- Currently displayed suggestion, for the accept handler.
-- { bufnr, row (0-based), col (0-based), text }
M.pending = nil

-- show(bufnr, row, col, text): render `text` starting at (row, col).
-- First line inline at the cursor; remaining lines below via virt_lines.
function M.show(bufnr, row, col, text)
    M.clear(bufnr)

    local lines = vim.split(text, "\n", { plain = true })
    local first = lines[1]

    local opts = {
        virt_text = { { first, "AICompletionGhost" } },
        virt_text_pos = "inline",
        hl_mode = "combine",
    }

    if #lines > 1 then
        local virt_lines = {}
        for i = 2, #lines do
            virt_lines[#virt_lines + 1] = { { lines[i], "AICompletionGhost" } }
        end
        opts.virt_lines = virt_lines
    end

    vim.api.nvim_buf_set_extmark(bufnr, ns, row, col, opts)
    M.pending = { bufnr = bufnr, row = row, col = col, text = text }
end

-- clear(bufnr): remove ghost text and drop the stored suggestion.
function M.clear(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    M.pending = nil
end

return M
