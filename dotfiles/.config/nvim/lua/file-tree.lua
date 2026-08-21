-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local api = require("nvim-tree.api")
-- internal, no public getter for the runtime filter state
local core = require("nvim-tree.core")

local focused = {}

-- Tracks the last edited real buffer (path + window) so the tree can mark
-- it and J can jump back to it; reloads the tree to refresh the mark.
local function remember_focused_buffer(bufnr)
  if vim.api.nvim_get_option_value("buftype", { buf = bufnr }) ~= "" then
    return
  end

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return
  end

  local changed = focused.path ~= path
  focused.bufnr = bufnr
  focused.path = path
  focused.winid = vim.api.nvim_get_current_win()

  if changed and api.tree.is_visible() then
    vim.schedule(api.tree.reload)
  end
end

---Custom decorator: prepends a green arrow on the tree node of the last
---focused buffer.
---@class (exact) FocusedBufferDecorator: nvim_tree.api.Decorator
---@field private icon nvim_tree.api.highlighted_string
local FocusedBufferDecorator = api.Decorator:extend()

vim.api.nvim_set_hl(0, "NvimTreeFocusedBuffer", { fg = "#0aca56" })

function FocusedBufferDecorator:new()
  self.enabled = true
  self.highlight_range = "none"
  self.icon_placement = "before"
  self.icon = { str = "➜", hl = { "NvimTreeFocusedBuffer" } }
end

---@param node nvim_tree.api.Node
---@return nvim_tree.api.highlighted_string[]?
function FocusedBufferDecorator:icons(node)
  if node.absolute_path == focused.path then
    return { self.icon }
  end
end

-- Make the focused file visible in the tree: re-root when it lies outside
-- the current root, unhide dotfiles when it is filtered, then reveal it.
local function sync_tree_to_focused()
  local path = focused.path
  if not path or not api.tree.is_visible() then
    return
  end

  local root = api.tree.get_nodes().absolute_path
  if root ~= "/" and not vim.startswith(path, root .. "/") then
    local grandparent = vim.fn.fnamemodify(path, ":h:h")
    if vim.fn.isdirectory(grandparent) == 1 then
      api.tree.change_root(grandparent)
      root = grandparent
    end
  end

  local explorer = core.get_explorer()
  if explorer and explorer.filters.enabled and explorer.filters.state.dotfiles then
    local rel = path:sub(#root + 2)
    for segment in string.gmatch(rel, "[^/]+") do
      if segment:sub(1, 1) == "." then
        api.filter.dotfiles.toggle()
        break
      end
    end
  end

  api.tree.find_file({ buf = path })
end

-- J: jump back to the window showing the last edited buffer, falling back
-- to any window displaying it, then sync the tree onto it.
local function focus_last_buffer()
  if focused.winid and vim.api.nvim_win_is_valid(focused.winid)
      and vim.api.nvim_win_get_buf(focused.winid) == focused.bufnr then
    vim.api.nvim_set_current_win(focused.winid)
    sync_tree_to_focused()
    return
  end

  if not focused.bufnr or not vim.api.nvim_buf_is_valid(focused.bufnr) then
    return
  end

  for _, winid in ipairs(vim.fn.win_findbuf(focused.bufnr)) do
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_set_current_win(winid)
      sync_tree_to_focused()
      return
    end
  end
end

-- <C-p>: toggle the tree and sync it onto the last edited buffer, so opening
-- from a file outside the root doesn't leave the cursor stale.
vim.keymap.set("n", "<C-p>", function()
  local was_visible = api.tree.is_visible()
  api.tree.toggle()
  if not was_visible then
    sync_tree_to_focused()
  end
end, { desc = "nvim-tree: toggle + sync" })

local function on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.map.on_attach.default(bufnr)
  vim.keymap.set("n", "<Space>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "C", api.tree.collapse_all, opts("Collapse All"))
  vim.keymap.set("n", "U", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "u", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "J", focus_last_buffer, opts("Last Focused Buffer"))
  vim.keymap.set("n", "F", sync_tree_to_focused, opts("Find Focused Buffer"))
  vim.keymap.set("n", "x", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
end

---@type nvim_tree.config
local config = {
  on_attach = on_attach,
  sort = {
    --sorter = "case_sensitive",
  },
  view = {
    width = 25,
  },
  renderer = {
    group_empty = true,
    decorators = {
      -- "Git",
      "Open",
      "Hidden",
      "Modified",
      "Bookmark",
      "Diagnostics",
      "Copied",
      FocusedBufferDecorator,
      "Cut",
    },
  },
  update_focused_file = {
    enable = true,
  },
  filters = {
    dotfiles = true,
    git_ignored = false,
  },
}
require("nvim-tree").setup(config)

-- On session load, restore the tree only when it was open at save time.
-- mksession writes the NvimTree_* buffer into the session; detect its presence
-- to distinguish "tree was open" from "tree was closed".
vim.api.nvim_create_autocmd("User", {
  pattern = "StartifyAllBuffersOpened",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_name(buf):match("NvimTree_") then
        api.tree.open()
        return
      end
    end
  end,
})

-- Keep the focused-buffer record up to date on every buffer/window switch.
local focus_group = vim.api.nvim_create_augroup("NvimTreeFocusHistory", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = focus_group,
  callback = function(event)
    remember_focused_buffer(event.buf)
  end,
})
remember_focused_buffer(vim.api.nvim_get_current_buf())
