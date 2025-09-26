require "nvchad.options"

-- to enable cursorline!
vim.opt.cursorlineopt = "both"

-- enable title
vim.opt.title = true

-- set window border
vim.opt.winborder = "rounded"

-- show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars = { trail = "~", tab = "» " }

-- change character and highlight group for git diff view
vim.opt.fillchars = { eob = " ", diff = "⣿", foldopen = "", foldclose = "" }

-- set info to be saved with the underlying :mksession
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"

-- allow virtual editing in all modes
vim.opt.virtualedit = "all"

-- use built-in LSP folding
-- vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"

-- enable treesitter-based folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldnestmax = 3

-- custom UI for folding column (to hide folding level)
local function get_fold(lnum)
  local fn = vim.fn
  local fc = vim.opt.fillchars:get()

  if fn.foldlevel(lnum) <= fn.foldlevel(lnum - 1) then
    return " "
  end
  return fn.foldclosed(lnum) == -1 and fc.foldopen or fc.foldclose
end

_G.get_statuscol = function()
  if vim.opt_local.signcolumn:get() == "yes" then
    return "%s%l%= " .. get_fold(vim.v.lnum) .. " "
  else
    return ""
  end
end

-- to enable this custom UI, change foldcolumn to 1 and uncomment opt.statuscolumn
vim.opt.foldcolumn = "0"
-- vim.opt.statuscolumn = "%!v:lua.get_statuscol()"

-- use system clipboard via OSC52 (even in remote SSH session)
-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end
--
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = paste,
--     ["*"] = paste,
--   },
-- }

vim.opt.clipboard = "unnamedplus"

-- syntax highlight config files
vim.filetype.add {
  pattern = {
    ["*.*conf*"] = "dosini",
  },
}

-- syntax highlight rofi theme files
vim.filetype.add {
  extension = {
    rasi = "css",
  },
}

-- syntax highlight for zsh files
vim.filetype.add {
  extension = {
    zsh = "sh",
    sh = "sh",
  },
  filename = {
    [".zshrc"] = "sh",
    [".zshenv"] = "sh",
  },
}

-- syntax highlight for txt files
vim.filetype.add {
  extension = {
    txt = "log",
  },
}

-- OLD CONFIG
-- highlight c++ files
-- autocmd(
--     { "BufEnter", "BufRead" },
--     {
--         pattern = { "*.cc", "*.h", "*.cpp" },
--         command = "setf cpp | setlocal spell spelllang=en_us",
--     }
-- )

-- to stabilize buffer content on windows (this change breaks :Telescope highlight)
-- vim.opt.splitkeep="screen"

-- to debug lspconfig, use this below and :LspLog
-- vim.lsp.set_log_level("debug")

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.opt.guifont = "JetBrainsMono NF:h9"
  vim.g.neovide_refresh_rate = 144

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_font_hinting = "none"
  vim.g.neovide_font_edging = "subpixelantialias"
end
