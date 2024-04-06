require "nvchad.options"

-- to enable cursorline!
vim.o.cursorlineopt = 'both'

-- enable title
vim.opt.title = true

-- show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars = { trail = "~", tab = "» " }

-- change character and highlight group for git diff view
vim.opt.fillchars = { eob = " ", diff = "⣿" }

-- change character for indent_blankline, to use a 6-dot braille cell
vim.g.indent_blankline_char = "▏"
-- vim.g.indent_blankline_char = "⡇"
-- vim.g.indent_blankline_context_char = "⣿"

-- set info to be saved with the underlying :mksession
vim.opt.sessionoptions =
"buffers,tabpages,globals,curdir,folds,globals,help,tabpages,terminal,winsize"

-- allow virtual editing in all modes
vim.opt.virtualedit = "all"

-- to stabilize buffer content on windows (this change breaks :Telescope highlight)
-- vim.opt.splitkeep="screen"

-- to debug lspconfig, use this below and :LspLog
-- vim.lsp.set_log_level("debug")

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.o.guifont = "Hack Nerd Font Mono:h10:#h-normal"
  vim.g.neovide_refresh_rate = 144

  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 0
  vim.g.neovide_padding_left = 0
end
