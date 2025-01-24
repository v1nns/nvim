require "nvchad.options"

-- to enable cursorline!
vim.o.cursorlineopt = "both"

-- enable title
vim.opt.title = true

-- show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars = { trail = "~", tab = "» " }

-- change character and highlight group for git diff view
vim.opt.fillchars = { eob = " ", diff = "⣿" }

-- set info to be saved with the underlying :mksession
vim.opt.sessionoptions = "buffers,tabpages,globals,curdir,folds,globals,help,tabpages,terminal,winsize"

-- allow virtual editing in all modes
vim.opt.virtualedit = "all"

-- use built-in LSP folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
-- enable treesitter-based folding
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldnestmax = 3

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
  vim.o.guifont = "JetBrainsMono NF:h11.5"
  vim.g.neovide_refresh_rate = 144

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0

  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_font_hinting = "none"
  vim.g.neovide_font_edging = "subpixelantialias"
end
