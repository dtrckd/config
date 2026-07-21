-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local api = require("nvim-tree.api")

local focused = {}

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

---@class (exact) FocusedBufferDecorator: nvim_tree.api.Decorator
---@field private icon nvim_tree.api.highlighted_string
local FocusedBufferDecorator = api.Decorator:extend()

function FocusedBufferDecorator:new()
  self.enabled = true
  self.highlight_range = "none"
  self.icon_placement = "before"
  self.icon = { str = "➜", hl = { "NvimTreeOpenedHL" } }
end

---@param node nvim_tree.api.Node
---@return nvim_tree.api.highlighted_string[]?
function FocusedBufferDecorator:icons(node)
  if node.absolute_path == focused.path then
    return { self.icon }
  end
end

local function focus_last_buffer()
  if focused.winid and vim.api.nvim_win_is_valid(focused.winid)
      and vim.api.nvim_win_get_buf(focused.winid) == focused.bufnr then
    vim.api.nvim_set_current_win(focused.winid)
    return
  end

  if not focused.bufnr or not vim.api.nvim_buf_is_valid(focused.bufnr) then
    return
  end

  for _, winid in ipairs(vim.fn.win_findbuf(focused.bufnr)) do
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_set_current_win(winid)
      return
    end
  end
end

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
      "Git",
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

local focus_group = vim.api.nvim_create_augroup("NvimTreeFocusHistory", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = focus_group,
  callback = function(event)
    remember_focused_buffer(event.buf)
  end,
})
remember_focused_buffer(vim.api.nvim_get_current_buf())
