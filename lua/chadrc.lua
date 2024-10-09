-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

-- Path to override theme and highlights files
local highlights = require "highlights"

--@type ChadrcConfig
local M = {}

M.ui = {
  lsp_semantic_tokens = true,

  statusline = require "ui.statusline",

  tabufline = {
    enabled = false,
    overriden_modules = function()
      require "ui.tabufline"
    end,
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
