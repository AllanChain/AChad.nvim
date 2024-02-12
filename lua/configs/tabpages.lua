-------------------------------------------------
--       Overwrite bufferline's tabpage        --
-------------------------------------------------
local lazy = require "bufferline.lazy"
local config = lazy.require "bufferline.config" ---@module "bufferline.config"
local constants = lazy.require "bufferline.constants" ---@module "bufferline.constants"
local utils = lazy.require "bufferline.utils" ---@module "bufferline.utils"

local M = {}

local padding = constants.padding

local function tab_click_component(num)
  return "%" .. num .. "T"
end

local function format_tabpage(tabnr)
  local cwd = vim.fn.getcwd(-1, tabnr)
  local parts = vim.split(cwd, '/')
  local name = parts[#parts]
  return name:sub(1, 2):upper()
end

local function render(tabpage, is_active, style, highlights)
  local h = highlights
  local hl = is_active and h.tab_selected.hl_group or h.tab.hl_group
  local separator_hl = is_active and h.tab_separator_selected.hl_group or h.tab_separator.hl_group
  local chars = constants.sep_chars[style] or constants.sep_chars.thin
  local name = padding .. format_tabpage(tabpage.tabnr) .. padding
  local char_order = ({ thick = { 1, 2 }, thin = { 1, 2 } })[style] or { 2, 1 }
  return {
    { highlight = separator_hl, text = chars[char_order[1]] },
    {
      highlight = hl,
      text = name,
      attr = { prefix = tab_click_component(tabpage.tabnr) },
    },
    { highlight = separator_hl, text = chars[char_order[2]] },
  }
end

function M.get()
  local tabs = vim.fn.gettabinfo()
  local current_tab = vim.fn.tabpagenr()
  local highlights = config.highlights
  local style = config.options.separator_style
  return utils.map(function(tab)
    local is_active_tab = current_tab == tab.tabnr
    local components = render(tab, is_active_tab, style, highlights)
    return {
      component = components,
      id = tab.tabnr,
      windows = tab.windows,
    }
  end, tabs)
end

return M
