-- All tunables for the ai-completion plugin live here.
local M = {}

-- Completion endpoint (Tabby-compatible request/response shape).
M.url = "https://ai.fractale.co/v1/completions"

-- Bearer token, env-only. No literal fallback so we never leak a key in the
-- config and never silently send unauthenticated requests. If unset/empty the
-- request is skipped with an ERROR notification (handled in init.lua).
M.token = vim.env.TABBY_API_TOKEN

-- curl request timeout.
M.timeout_ms = 8000

-- Byte caps on the payload to keep requests small and fast.
-- Prefix keeps its tail (nearest the cursor); suffix keeps its head.
M.max_prefix = 3000
M.max_suffix = 1000

-- filetype -> API language override. Empty: fall back to `vim.bo.filetype`.
-- Extension point for future per-filetype language names.
M.language_map = {}

-- Insert-mode only keymaps.
M.keymaps = {
    trigger = "<C-^>",
    accept = "<C-p>",
}

-- Whether completions are enabled at startup. Flip with :AICompletionToggle.
M.enabled = true

return M
