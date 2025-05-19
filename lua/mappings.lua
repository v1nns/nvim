require "nvchad.mappings"

local map = vim.keymap.set

-- session management
map("n", "<A-r>", function()
  require("resession").load(nil, { dir = "dirsession" })
end, { desc = "session recent folders" })

-- navigation
map("n", "j", "gj", { desc = "navigation move cursor to line downward" })
map("n", "k", "gk", { desc = "navigation move cursor to line upward" })
map("n", "<A-j>", "5gj", { desc = "navigation move cursor to line 5x downward" })
map("n", "<A-k>", "5gk", { desc = "navigation move cursor to line 5x upward" })
map("n", "<A-h>", "b", { desc = "navigation move cursor back a word" })
map("n", "<A-l>", "w", { desc = "navigation move cursor forward a word" })

map("v", "j", "gj", { desc = "navigation move cursor to line downward" })
map("v", "k", "gk", { desc = "navigation move cursor to line upward" })

-- jumplist
map("n", "<A-Left>", "<C-O>zz", { desc = "jumplist move back" })
map("n", "<A-Right>", "<C-I>zz", { desc = "jumplist move forward" })
-- map("n","<A-h>", "<C-O>zz", {desc ="move back" })
-- map("n","<A-l", "<C-I>zz", {desc ="move forward" })

-- buffer
map("n", "<C-n>", "<cmd> enew <CR>", { desc = "buffer new buffer" })
map("n", "<Tab>", "<cmd> bnext <CR>", { desc = "buffer focus next buffer" })
map("n", "<S-Tab>", "<cmd> bprev <CR>", { desc = "buffer focus previous buffer" })
map("n", "<leader>x", "<cmd> CloseBuffer <CR>", { desc = "buffer close current buffer" })
map("n", "<C-w>a", "<cmd> CloseAllBuffers <CR>", { desc = "buffer close all buffers" })
map("n", "<leader>cb", "<cmd> ZenMode <CR>", { desc = "buffer center current buffer" })

-- window adjusts (for kitty)
-- TODO: create function for width based on window position
map("n", "<C-S-w>", "<cmd> winc > <CR>", { desc = "resize increase width" })
map("n", "<C-S-x>", "<cmd> winc < <CR>", { desc = "resize decrease width" })
map("n", "<C-S-y>", "<cmd> winc - <CR>", { desc = "resize increase height" })
map("n", "<C-S-z>", "<cmd> winc + <CR>", { desc = "resize decrease height" })

-- window adjusts (for neovim-qt)
-- TODO: create function for width based on window position
map("n", "<C-S-Right>", "<cmd> winc > <CR>", { desc = "resize increase width" })
map("n", "<C-S-Left>", "<cmd> winc < <CR>", { desc = "resize decrease width" })
map("n", "<C-S-Up>", "<cmd> winc - <CR>", { desc = "resize increase height" })
map("n", "<C-S-Down>", "<cmd> winc + <CR>", { desc = "resize decrease height" })

-- window resize
map("n", "<C-w>r", "<cmd> winc = <CR>", { desc = "resize resize windows equally" })

-- window focus
map("n", "<C-1>", "<cmd> :1wincmd w <CR>", { desc = "window focus window 1" })
map("n", "<C-2>", "<cmd> :2wincmd w <CR>", { desc = "window focus window 2" })
map("n", "<C-3>", "<cmd> :3wincmd w <CR>", { desc = "window focus window 3" })
map("n", "<C-4>", "<cmd> :4wincmd w <CR>", { desc = "window focus window 4" })
map("n", "<C-5>", "<cmd> :5wincmd w <CR>", { desc = "window focus window 5" })
map("n", "<C-6>", "<cmd> :6wincmd w <CR>", { desc = "window focus window 6" })
map("n", "<C-7>", "<cmd> :7wincmd w <CR>", { desc = "window focus window 7" })
map("n", "<C-8>", "<cmd> :8wincmd w <CR>", { desc = "window focus window 8" })
map("n", "<C-9>", "<cmd> :9wincmd w <CR>", { desc = "window focus window 9" })
map("n", "<C-0>", "<cmd> :0wincmd w <CR>", { desc = "window focus window 10" })

map("n", "<leader><leader>", function()
  require("configs.windowpicker").pick_window()
end, { desc = "window select window via picker" })

-- tab navigation
map("n", "<leader>ta", "<cmd> $tabnew <CR>", { desc = "tab add new tab" })
map("n", "<leader>tc", function()
  -- vim.cmd "windo bd"
  vim.cmd "tabclose"
end, { desc = "tab close tab" })
map("n", "<leader>to", "<cmd> tabonly <CR>", { desc = "tab close other tabs except current" })
map("n", "<leader>tn", "<cmd> tabn <CR>", { desc = "tab focus next tab" })
map("n", "<leader>tp", "<cmd> tabp <CR>", { desc = "tab focus previous tab" })
map("n", "<leader>1", "<cmd> tabn 1 <CR>", { desc = "tab go to tab 1" })
map("n", "<leader>2", "<cmd> tabn 2 <CR>", { desc = "tab go to tab 2" })
map("n", "<leader>3", "<cmd> tabn 3 <CR>", { desc = "tab go to tab 3" })
map("n", "<leader>4", "<cmd> tabn 4 <CR>", { desc = "tab go to tab 4" })
map("n", "<leader>5", "<cmd> tabn 5 <CR>", { desc = "tab go to tab 5" })
map("n", "<leader>6", "<cmd> tabn 6 <CR>", { desc = "tab go to tab 6" })
map("n", "<leader>7", "<cmd> tabn 7 <CR>", { desc = "tab go to tab 7" })
map("n", "<leader>8", "<cmd> tabn 8 <CR>", { desc = "tab go to tab 8" })
map("n", "<leader>9", "<cmd> tabn 9 <CR>", { desc = "tab go to tab 9" })
map("n", "<leader>0", "<cmd> tabn 0 <CR>", { desc = "tab go to tab 0" })

-- git integration
map("n", "<C-g>b", "<cmd> Gitsigns toggle_current_line_blame <CR>", { desc = "git toggle blame" })
map("n", "<C-g>s", "<cmd> Gitsigns preview_hunk <CR>", { desc = "git show current hunk" })
map("n", "<C-g>p", "<cmd> Gitsigns prev_hunk <CR>", { desc = "git go to previous hunk" })
map("n", "<C-g>n", "<cmd> Gitsigns next_hunk <CR>", { desc = "git go to next hunk" })
map("n", "<C-g>u", "<cmd> Gitsigns reset_hunk <CR>", { desc = "git undo current hunk" })
map("n", "<C-g>a", "<cmd> Gitsigns stage_hunk <CR>", { desc = "git stage current hunk" })
map("n", "<C-g>r", "<cmd> Gitsigns undo_stage_hunk <CR>", { desc = "git unstage current hunk" })
map("n", "<C-g>d", "<cmd> Gitsigns diffthis <CR>", { desc = "git show diff on current buffer" })
map("n", "<C-g>m", "<cmd> GitMessenger <CR>", { desc = "git show commit message from current line" })
map("n", "<leader>g", function()
  local lib = require "diffview.lib"
  local view = lib.get_current_view()
  if view then
    -- Current tabpage is a Diffview; close it
    vim.cmd ":DiffviewClose"
  else
    -- No open Diffview exists: open a new one
    vim.cmd ":DiffviewOpen"
  end
end, { desc = "git toggle diff view" })

-- LSP
map("n", "<F2>", function()
  require "ui.renamer"()
end, { desc = "LSP rename symbol" })
map("n", "<leader>ld", function()
  vim.diagnostic.enable(false)
end, { desc = "LSP disable lsp diagnostics" })
map("n", "<leader>le", function()
  vim.diagnostic.enable()
end, { desc = "LSP enable lsp diagnostics" })
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "LSP format code" })
map("v", "<leader>fm", "gq", { desc = "LSP format code selection" })
map("n", "<C-S-o>", "<cmd> Telescope lsp_document_symbols <CR>", { desc = "LSP list all symbols " })

-- Trouble
map("n", "<leader>cd", "<cmd> Trouble diagnostics toggle <CR>", { desc = "trouble show diagnostics" })
map(
  "n",
  "<leader>cD",
  "<cmd> Trouble diagnostics toggle filter.buf=0 pinned=true <CR>",
  { desc = "trouble show diagnostics per buffer" }
)
map(
  "n",
  "<leader>cs",
  "<cmd> Trouble symbols toggle focus=true pinned=true <CR>",
  { desc = "trouble lsp show symbols" }
)
map(
  "n",
  "<leader>cr",
  "<cmd> Trouble lsp_references toggle focus=true pinned=true <CR>",
  { desc = "trouble list all symbol references" }
)
map(
  "n",
  "<leader>cl",
  "<cmd> Trouble lsp toggle focus=true pinned=true win.position=right <CR>",
  { desc = "trouble toggle lsp menu" }
)
map("n", "<leader>co", "<cmd> Trouble loclist toggle <CR>", { desc = "trouble show location list" })
map("n", "<leader>cq", "<cmd> Trouble qflist toggle <CR>", { desc = "trouble show quickfix list" })

-- search utils
map(
  "n",
  "n",
  "<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>",
  { desc = "search repeat last search" }
)
map(
  "n",
  "N",
  "<cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
  { desc = "search repeat last search (in opposite direction)" }
)

-- text actions
map("n", "<A-Down>", "<cmd> :m .+1 <CR>==", { desc = "text move line upwards" })
map("n", "<A-Up>", "<cmd> :m .-2 <CR>==", { desc = "text move line downwards" })
map("n", "<leader>fw", "<cmd> WrapTextAtColumn <CR>", { desc = "text wrap paragraph" })
map("v", "<leader>fw", "<cmd> WrapTextAtColumn <CR>", { desc = "text wrap text selection" })
map("n", "<leader>tt", "<cmd> Twilight <CR>", { desc = "text toggle code dimming" })
map("i", "<C-BS>", "<C-W>", { desc = "text delete previous word" })

-- neotree
-- map("n", "<leader>e", "<cmd> Neotree filesystem toggle left <CR>", { desc = "neotree toggle file tree" })
-- map("n", "<leader>b", "<cmd> Neotree buffers toggle left <CR>", { desc = "neotree toggle buffer tree" })
-- map("n", "<leader>g", "<cmd>Neotree git_status toggle left <CR>", { desc = "neotree toggle git status tree" })

-- nvim-tree
map("n", "<leader>e", "<cmd> NvimTreeFindFileToggle <CR>", { desc = "nvim-tree toggle file tree" })

-- telescope
map(
  "n",
  "<A-o>",
  "<cmd> Telescope file_browser path=$HOME prompt_title=Open\\ folder <CR>",
  { desc = "telescope open folder" }
)
map("n", "<A-p>", "<cmd> Telescope find_files prompt_title=Open\\ file <CR>", { desc = "telescope open file" })
map("n", "<C-S-b>", "<cmd> Telescope marks <CR>", { desc = "telescope open bookmarks" })
map("n", "<C-S-f>", "<cmd> Telescope live_grep prompt_title=Search\\ all <CR>", { desc = "telescope search all" })
map(
  "n",
  "<leader>b",
  "<cmd> Telescope buffers show_all_buffers=true sort_mru=true<CR>",
  { desc = "telescope find buffers" }
)
map("v", "<C-S-f>", "<cmd> SearchForTextSelection <CR>", { desc = "telescope search all" })
map("n", "<C-g>c", "<cmd> Telescope git_commits <CR>", { desc = "telescope git show commits" })
map("n", "<C-g>t", "<cmd> Telescope git_status <CR>", { desc = "telescope git show status" })
map(
  "n",
  ";",
  "<cmd> MarksListAll <CR><cmd>lcl<CR><cmd>Telescope loclist prompt_title=Marks<CR>",
  { desc = "telescope show all marks" }
)

-- comment divider
map("n", "<A-y>", "<cmd> InsertCommentDivider <CR>", { desc = "divider add line" })
map("i", "<A-y>", "<ESC><cmd> InsertCommentDivider <CR>", { desc = "divider add line" })
map("v", "<A-y>", "<cmd> InsertCommentDivider <CR>", { desc = "divider add line" })

-- word wrap
map("n", "<leader>we", "<cmd> set wrap <CR>", { desc = "util enable word wrapping" })
map("n", "<leader>wd", "<cmd> set nowrap <CR>", { desc = "util disable word wrapping" })

-- dismiss any noice popup
map("n", "<Esc>", function()
  vim.cmd "NoiceDismiss"
  vim.cmd "nohlsearch"
  vim.cmd "CloseTelescope"
end, { desc = "noice dismiss popups" })

-- code assistant
map("n", "<leader>cc", "<cmd> CodeCompanionChat toggle <CR>", { desc = "code toggle code assistant chat" })

-- disable mappings
local nomap = vim.keymap.del
-- nomap("n", "<leader>b")

nomap("n", "<C-c>") -- disable default keybind from NvChad
map("n", "<C-c>", function()
  local mode = vim.api.nvim_get_mode().mode

  -- do not copy on terminal buffer
  if mode ~= "nt" and mode ~= "ntT" and mode ~= "t" and mode ~= "!" then
    vim.cmd "%y+"
  end
end, { desc = "general copy whole file" })

-- disable default keybind from NvChad for cursor navigation
nomap("i", "<C-b>")

map("i", "<C-b>", "<C-o>^", { desc = "navigation move beginning of line" })
map("v", "<C-b>", "^", { desc = "navigation move beginning of line" })
map("v", "<C-e>", "<End>", { desc = "navigation move end of line" })

-- mapping based on filetype
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    map(
      "n",
      "<C-n>",
      "<cmd>cn | wincmd p<CR>",
      { desc = "navigation move to next reference", buffer = event.buf, silent = true }
    )
    map(
      "n",
      "<C-p>",
      "<cmd>cN | wincmd p<CR>",
      { desc = "navigation move to previous reference", buffer = event.buf, silent = true }
    )
  end,
})
