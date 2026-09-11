-- Memory management: Lua GC tuning, LSP idle stop, nvim tree self-monitor.
-- Loaded by lua/main.lua. Replaces the monitor formerly in lua/basics.lua.
--
-- Origin: high RSS was first blamed on LSP leaks, but most of it was uncollected
-- Lua garbage (peaks >1GB, a full GC reclaims to ~20MB) plus one LSP server set
-- per nvim instance. Strategy: cap the Lua heap (GC tuning + threshold collect),
-- stop LSP clients that are idle or unfocused so only the project in use keeps
-- servers, and keep the RSS monitor as a last-resort net.
--
--   :MemoryStatus -- Lua heap, tree RSS, LSP client state

local M = {}

local defaults = {
  gc_pause = 130,                  -- LuaJIT default 200: lower = smaller heap peaks, more GC work
  gc_stepmul = 300,                -- LuaJIT default 200
  idle_gc_kb = 300 * 1024,         -- full collect on idle above this Lua heap (measured ~36ms at 1.1GB)
  gc_min_interval_ms = 60 * 1000,  -- never full-collect more often than this
  lsp_idle_ms = 15 * 60 * 1000,    -- stop a client whose buffers stayed invisible this long (0 = off)
  lsp_unfocus_ms = 15 * 60 * 1000, -- stop all clients after nvim lost focus this long (0 = off)
  lsp_check_ms = 60 * 1000,
  monitor_ms = 120 * 1000,
  warn_mb = 2000,                  -- GC, then stop LSP clients above this tree RSS
  kill_mb = 7000,                  -- save and quit above this
}

local cfg = vim.deepcopy(defaults)
local started = false
local stopped = {}   -- client name -> filetypes, while stopped by us
local last_seen = {} -- client id -> hrtime ns of last visible check
local unfocused_since ---@type integer?
local last_gc_at = 0
local monitor_timer, lsp_timer

local function now_ns() return vim.uv.hrtime() end
local function heap_kb() return math.floor(collectgarbage('count')) end

-- A full collect on a big heap is a tens-of-ms pause at worst (see idle_gc_kb).
local function gc_if_big()
  if heap_kb() < cfg.idle_gc_kb then return end
  local now = now_ns()
  if now - last_gc_at < cfg.gc_min_interval_ms * 1e6 then return end
  last_gc_at = now
  collectgarbage('collect')
end

local function rss_kb(pid)
  local f = io.open(('/proc/%d/status'):format(pid))
  if not f then return 0 end
  local kb = 0
  for line in f:lines() do
    local v = line:match('^VmRSS:%s+(%d+)')
    if v then
      kb = tonumber(v)
      break
    end
  end
  f:close()
  return kb
end

-- Total RSS of pid plus all descendants (LSP servers run as children).
local function tree_rss_kb(pid)
  local total = rss_kb(pid)
  for _, child in ipairs(vim.api.nvim_get_proc_children(pid)) do
    total = total + tree_rss_kb(child)
  end
  return total
end

--
-- LSP idle management
--

local function client_visible(client)
  local attached = client.attached_buffers or {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if attached[vim.api.nvim_win_get_buf(win)] then
      return true
    end
  end
  return false
end

local function stop_client(client)
  stopped[client.name] = (client.config and client.config.filetypes) or true
  last_seen[client.id] = nil
  client:stop(2000)
end

local function stop_idle_clients()
  local now = now_ns()

  if cfg.lsp_idle_ms > 0 then
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client_visible(client) then
        last_seen[client.id] = now
      else
        local seen = last_seen[client.id]
        if seen == nil then
          last_seen[client.id] = now -- start the clock on the first check
        elseif now - seen >= cfg.lsp_idle_ms * 1e6 then
          stop_client(client)
        end
      end
    end
  end

  if cfg.lsp_unfocus_ms > 0 and unfocused_since and now - unfocused_since >= cfg.lsp_unfocus_ms * 1e6 then
    for _, client in ipairs(vim.lsp.get_clients()) do
      stop_client(client)
    end
  end

  -- Prune exited clients; keep stopped names until a matching buffer resumes.
  local ids = {}
  for _, c in ipairs(vim.lsp.get_clients()) do ids[c.id] = true end
  for id in pairs(last_seen) do
    if not ids[id] then last_seen[id] = nil end
  end
end

local function restart_for_buffer(bufnr)
  local bt = vim.bo[bufnr].buftype
  if bt ~= '' and bt ~= 'help' then return end
  local ft = vim.bo[bufnr].filetype
  if ft == '' then return end

  local resume = false
  for name, fts in pairs(stopped) do
    if fts == true or vim.tbl_contains(fts, ft) then
      -- ponytail: resume forgets other projects using this name; track roots for independent resumes.
      stopped[name] = nil
      resume = vim.lsp.is_enabled(name) or resume
    end
  end
  if resume then
    -- Neovim's internal group preserves native root resolution without waking hidden buffers.
    vim.api.nvim_exec_autocmds('FileType', {
      group = 'nvim.lsp.enable',
      buffer = bufnr,
      modeline = false,
    })
  end
end

--
-- Monitor
--

local function check_memory()
  gc_if_big()

  local mb = math.floor(tree_rss_kb(vim.fn.getpid()) / 1024)
  if mb >= cfg.kill_mb then
    monitor_timer:stop()
    vim.notify(('nvim tree using %dMB — force quitting!'):format(mb), vim.log.levels.ERROR)
    vim.cmd('silent! noautocmd wall') -- noautocmd: skip BufWritePre format-on-save
    vim.defer_fn(function() vim.cmd('qa!') end, 2000)
  elseif mb >= cfg.warn_mb then
    collectgarbage('collect') -- Lua garbage is the usual bulk; reclaim before acting
    local after = math.floor(tree_rss_kb(vim.fn.getpid()) / 1024)
    if after >= cfg.warn_mb then
      local clients = vim.lsp.get_clients()
      for _, client in ipairs(clients) do stop_client(client) end
      vim.notify(('nvim tree using %dMB after GC — stopped %d LSP client(s)'):format(after, #clients),
        vim.log.levels.WARN)
    end
  end
end

function M.setup(opts)
  cfg = vim.tbl_deep_extend('force', vim.deepcopy(defaults), opts or {})

  collectgarbage('setpause', cfg.gc_pause)
  collectgarbage('setstepmul', cfg.gc_stepmul)

  if started then -- re-arm timers with the new periods; callbacks re-read cfg
    lsp_timer:stop()
    lsp_timer:start(cfg.lsp_check_ms, cfg.lsp_check_ms, vim.schedule_wrap(stop_idle_clients))
    monitor_timer:stop()
    monitor_timer:start(cfg.monitor_ms, cfg.monitor_ms, vim.schedule_wrap(check_memory))
    return M
  end
  started = true

  local group = vim.api.nvim_create_augroup('MemoryManager', { clear = true })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    callback = function(args) restart_for_buffer(args.buf) end,
  })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = group,
    callback = gc_if_big,
  })
  vim.api.nvim_create_autocmd('FocusLost', {
    group = group,
    callback = function()
      unfocused_since = now_ns()
      gc_if_big()
    end,
  })
  vim.api.nvim_create_autocmd('FocusGained', {
    group = group,
    callback = function()
      unfocused_since = nil
      restart_for_buffer(vim.api.nvim_get_current_buf())
    end,
  })

  lsp_timer = vim.uv.new_timer()
  lsp_timer:start(cfg.lsp_check_ms, cfg.lsp_check_ms, vim.schedule_wrap(stop_idle_clients))

  monitor_timer = vim.uv.new_timer()
  monitor_timer:start(cfg.monitor_ms, cfg.monitor_ms, vim.schedule_wrap(check_memory))

  vim.api.nvim_create_user_command('MemoryStatus', function()
    print(('memory: heap=%dMB tree=%dMB lsp=%d stopped=%d unfocused=%s'):format(
      heap_kb() / 1024,
      tree_rss_kb(vim.fn.getpid()) / 1024,
      #vim.lsp.get_clients(),
      vim.tbl_count(stopped),
      unfocused_since and 'yes' or 'no'
    ))
  end, { desc = 'Show nvim Lua heap, tree RSS and LSP idle state' })

  return M
end

M.setup()
return M
