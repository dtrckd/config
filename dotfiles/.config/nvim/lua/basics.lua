--
-- NVIM basics / General config
--

-- Briefly highlight yanked text
--vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}' -- disabled in visual mode


-- Predefine clipboard provider to speedup start
vim.g.clipboard = {
  name = "xsel",
  copy = {
    ["+"] = "xsel --nodetach -i -b",
    ["*"] = "xsel --nodetach -i -p",
  },
  paste = {
    ["+"] = "xsel -o -b",
    ["*"] = "xsel -o -b",
  },
  cache_enabled = 1,
}

--
-- Fish autocompletion <enter> input like in commands suggestion popup
--
vim.keymap.set("c", "<cr>", function()
  if vim.fn.pumvisible() == 1 then
    return '<c-y>'
  end
  return '<cr>'
end, { expr = true })

--
-- Fish autompletation moves input like in commands suggestion popup
--
vim.keymap.set("c", "<down>", function()
  if vim.fn.pumvisible() == 1 then
    return '<right>'
  end
  return '<down>'
end, { expr = true })
vim.keymap.set("c", "<up>", function()
  if vim.fn.pumvisible() == 1 then
    return '<left>'
  end
  return '<up>'
end, { expr = true })

--
-- Utils
--
-- Function to check all patterns
_G.match_any_pattern = function(line, patterns)
  for i, pattern in ipairs(patterns) do
    local start_pos, end_pos = string.find(line, pattern)
    if start_pos then
      return start_pos, end_pos
    end
  end
  return nil
end

--
-- Move up to previous function definion
--
_G.move_cursor_up_to_regex = function()
  -- Define the list of regexes for different filetypes
  local regex_dict = {
    javascript = {
      '^%s*function%s+%w+%s*%(',              -- function foo(
      '^%s*%w+%s*=%s*function%s*%(',          -- foo = function(
      '^%s*async%s+function%s+%w+%s*%(',      -- async function foo(
      '^%s*%w+%s*%(',                         -- method shorthand foo(
      '^%s*class%s+%w+',                     -- class Foo
      '^%s*[cvl][aeo][rnt]%s+%w+%s*=%s*async%s*%(', -- const/let/var foo = async (
      '^%s*const%s+%w+%s*=%s*%(',            -- const foo = (
      '^%s*let%s+%w+%s*=%s*%(',              -- let foo = (
      '^%s*var%s+%w+%s*=%s*%(',              -- var foo = (
    },
    elm = {
      '^%s*%w+%s*:%s*.*',           -- type annotations
      '^%s*%w+%s*=.*',              -- function definitions
      '^%s*type%s+alias%s+%u%w*',   -- type alias declarations
      '^%s*type%s+%u%w*',           -- custom type (ADT) declarations
    },
    go = {
      '^%s*func%s+',                   -- func foo( or func (recv) foo(
      '^%s*type%s+%w+%s+struct%s*{',   -- struct type definitions
      '^%s*type%s+%w+%s+interface%s*{', -- interface type definitions
    },
    python = {
      '^%s*def%s+%w+%s*%(',             -- def foo(  (single or multi-line)
      '^%s*async%s+def%s+%w+%s*%(',     -- async def foo(
      '^%s*class%s+%w+',               -- class Foo  (parens optional)
    }
  }

  -- Get the current filetype
  local filetype = vim.bo.filetype

  -- Get the relevant regexes for the current filetype
  local regexes = regex_dict[filetype]

  -- If no regexes are found for the current filetype, return
  if not regexes then
    return
  end

  -- Get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = current_pos[1]

  -- Get all lines in the buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Iterate through the lines above the current position to find the match
  local i = 0
  for line_num = current_line - 1, 1, -1 do
    local line = lines[line_num]
    local start_pos, end_pos = match_any_pattern(line, regexes)
    if start_pos then
      -- Set a mark at the current position to record it in the jump list
      vim.cmd("normal! m'")
      -- Move the cursor to the start position of the match
      vim.api.nvim_win_set_cursor(0, { line_num, start_pos })
      return
    end
    i = i + 1
    if i > 200 then
      return
    end
  end
end

-- Map the function to the _ key in normal mode
vim.api.nvim_set_keymap('n', '_', ':lua move_cursor_up_to_regex()<CR>', { noremap = true, silent = true })


-- Memory self-monitor: restart LSP at WARN_MB, quit nvim at KILL_MB
do
  local WARN_MB     = 4000       -- restart all LSP servers
  local KILL_MB     = 7000       -- hard quit nvim (adjust to your RAM)
  local INTERVAL_MS = 600000     -- check interval in ms (default: 10 min)
  local warned      = false

  local timer       = vim.uv.new_timer()
  timer:start(INTERVAL_MS, INTERVAL_MS, vim.schedule_wrap(function()
    local f = io.open("/proc/self/status", "r")
    if not f then return end
    local rss_kb = 0
    for line in f:lines() do
      local v = line:match("^VmRSS:%s+(%d+)")
      if v then
        rss_kb = tonumber(v)
        break
      end
    end
    f:close()

    local mb = math.floor(rss_kb / 1024)
    if mb >= KILL_MB then
      vim.notify(("nvim using %dMB — force quitting!"):format(mb), vim.log.levels.ERROR)
      vim.defer_fn(function() vim.cmd("qa!") end, 2000)
    elseif mb >= WARN_MB and not warned then
      warned = true
      vim.notify(("nvim using %dMB — restarting LSP servers"):format(mb), vim.log.levels.WARN)
      for _, c in ipairs(vim.lsp.get_clients()) do
        local name = c.name
        c:stop()
        vim.defer_fn(function() vim.lsp.enable(name) end, 200)
      end
      vim.defer_fn(function() warned = false end, 300000)       -- re-arm after 5min
    end
  end))
end

-- Scrolling
--
local neoscroll = require('neoscroll')
local keymap = {
  ["<PageUp>"]   = function() neoscroll.scroll(-30, { duration = 190 }) end,
  ["<PageDown>"] = function() neoscroll.scroll(30, { duration = 190 }) end,
  --["gg"]         = function() neoscroll.scroll(-2 * vim.api.nvim_buf_line_count(0), { duration = 250, easing = "linear" }) end,
  --["G"]          = function() neoscroll.scroll(2 * vim.api.nvim_buf_line_count(0), { duration = 250 }) end,
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
  vim.keymap.set(modes, key, func)
end
