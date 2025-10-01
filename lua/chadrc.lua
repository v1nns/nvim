-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

-- Path to override theme and highlights files
local highlights = require "highlights"

--@type ChadrcConfig
local M = {}

M.ui = {
  lsp_semantic_tokens = true,

  telescope = { style = "borderless" }, -- borderless / bordered

  statusline = require "ui.statusline",

  tabufline = {
    enabled = false,
    order = { "treeOffset", "buffers", "tabs" },
    modules = {
      -- TODO: move to separate file and create logic to control tab naming
      tabs = function()
        local result, tabs = "", vim.fn.tabpagenr "$"
        local btn = require("nvchad.tabufline.utils").btn

        if tabs > 1 then
          for nr = 1, tabs, 1 do
            local tab_hl = "TabO" .. (nr == vim.fn.tabpagenr() and "n" or "ff")
            result = result .. btn(" " .. nr .. " ", tab_hl, "GotoTab", nr)
          end

          local tabstoggleBtn = btn(" TABS ", "TabTitle", "ToggleTabs")
          local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")

          return vim.g.TbTabsToggled == 1 and small_btn or tabstoggleBtn .. result
        end

        return ""
      end,
    },
  },
}

M.base46 = {
  theme = "tokyonight",

  hl_add = highlights.add,
  hl_override = highlights.override,
  changed_themes = highlights.changed_themes,

  integrations = { "navic" },
}

M.nvdash = require "ui.nvdash"

return M
