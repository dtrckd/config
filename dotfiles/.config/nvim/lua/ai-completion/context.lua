-- Request payload builder. THIS IS THE FILE MEANT TO BE ADAPTED.
--
-- `build(bufnr)` returns the JSON-ready table sent to the completion API:
--   { language = <mapped filetype>,
--     segments = { prefix = ..., suffix = ..., filepath = ... } }
--
-- prefix   = buffer text from start up to the cursor (tail-capped to max_prefix)
-- suffix   = buffer text from the cursor to EOF   (head-capped to max_suffix)
-- filepath = buffer path relative to cwd (nil for unnamed buffers)
--
-- To add extra context (filename, neighboring files, symbols, ...) extend the
-- returned table here — the client/ghost layers do not care about its shape.
local config = require("ai-completion.config")

local M = {}

function M.build(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    -- Cursor position (1-based row, 0-based byte col) in the current window.
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- Everything before the cursor: full lines [1 .. row-1] plus the partial
    -- current line up to `col`.
    local before = vim.api.nvim_buf_get_lines(bufnr, 0, row - 1, false)
    local cur = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1] or ""
    table.insert(before, string.sub(cur, 1, col))
    local prefix = table.concat(before, "\n")

    -- Everything after the cursor: rest of the current line plus lines [row..].
    local after = vim.api.nvim_buf_get_lines(bufnr, row, -1, false)
    table.insert(after, 1, string.sub(cur, col + 1))
    local suffix = table.concat(after, "\n")

    -- Byte caps: keep prefix tail (nearest cursor) and suffix head.
    if #prefix > config.max_prefix then
        prefix = string.sub(prefix, #prefix - config.max_prefix + 1)
    end
    if #suffix > config.max_suffix then
        suffix = string.sub(suffix, 1, config.max_suffix)
    end

    local ft = vim.bo[bufnr].filetype
    local language = config.language_map[ft] or ft

    -- Relative file path (to cwd). vim.json.encode drops nil, so unnamed
    -- buffers simply omit the field.
    local name = vim.api.nvim_buf_get_name(bufnr)
    local filepath = name ~= "" and vim.fn.fnamemodify(name, ":.") or nil

    return {
        language = language,
        segments = { prefix = prefix, suffix = suffix, filepath = filepath },
    }
end

return M
