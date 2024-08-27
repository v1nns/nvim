require "nvchad.mappings"

local map = vim.keymap.set

-- session management
map("n", "<A-r>", function()
  require("resession").load(nil, { dir = "dirsession" })
end, { desc = "Session recent folders" })

-- navigation
map("n", "j", "gj", { desc = "Navigation move cursor to line downward" })
map("n", "k", "gk", { desc = "Navigation move cursor to line upward" })
map("n", "<A-j>", "5gj", { desc = "Navigation move cursor to line 5x downward" })
map("n", "<A-k>", "5gk", { desc = "Navigation move cursor to line 5x upward" })
map("n", "<A-h>", "b", { desc = "Navigation move cursor back a word" })
map("n", "<A-l>", "w", { desc = "Navigation move cursor forward a word" })

map("v", "j", "gj", { desc = "Navigation move cursor to line downward" })
map("v", "k", "gk", { desc = "Navigation move cursor to line upward" })

-- jumplist
map("n", "<A-Left>", "<C-O>zz", { desc = "Jumplist move back" })
map("n", "<A-Right>", "<C-I>zz", { desc = "Jumplist move forward" })
-- map("n","<A-h>", "<C-O>zz", {desc ="move back" })
-- map("n","<A-l", "<C-I>zz", {desc ="move forward" })

-- buffer
map("n", "<C-n>", "<cmd> enew <CR>", { desc = "Buffer new buffer" })
map("n", "<Tab>", "<cmd> bnext <CR>", { desc = "Buffer focus next buffer" })
map("n", "<S-Tab>", "<cmd> bprev <CR>", { desc = "Buffer focus previous buffer" })
map("n", "<leader>x", "<cmd> CloseBuffer <CR>", { desc = "Buffer close current buffer" })
map("n", "<C-w>a", "<cmd> CloseAllBuffers <CR>", { desc = "Buffer close all buffers" })
map("n", "<leader>cb", "<cmd> ZenMode <CR>", { desc = "Buffer center current buffer" })

-- window adjusts (for kitty)
-- TODO: create function for width based on window position
map("n", "<C-S-w>", "<cmd> winc > <CR>", { desc = "Resize increase width" })
map("n", "<C-S-x>", "<cmd> winc < <CR>", { desc = "Resize decrease width" })
map("n", "<C-S-y>", "<cmd> winc - <CR>", { desc = "Resize increase height" })
map("n", "<C-S-z>", "<cmd> winc + <CR>", { desc = "Resize decrease height" })

-- window adjusts (for neovim-qt)
-- TODO: create function for width based on window position
map("n", "<C-S-Right>", "<cmd> winc > <CR>", { desc = "Resize increase width" })
map("n", "<C-S-Left>", "<cmd> winc < <CR>", { desc = "Resize decrease width" })
map("n", "<C-S-Up>", "<cmd> winc - <CR>", { desc = "Resize increase height" })
map("n", "<C-S-Down>", "<cmd> winc + <CR>", { desc = "Resize decrease height" })

-- window resize
map("n", "<C-w>r", "<cmd> winc = <CR>", { desc = "Resize resize windows equally" })

-- window focus
map("n", "<C-1>", "<cmd> :1wincmd w <CR>", { desc = "Window focus window 1" })
map("n", "<C-2>", "<cmd> :2wincmd w <CR>", { desc = "Window focus window 2" })
map("n", "<C-3>", "<cmd> :3wincmd w <CR>", { desc = "Window focus window 3" })
map("n", "<C-4>", "<cmd> :4wincmd w <CR>", { desc = "Window focus window 4" })
map("n", "<C-5>", "<cmd> :5wincmd w <CR>", { desc = "Window focus window 5" })
map("n", "<C-6>", "<cmd> :6wincmd w <CR>", { desc = "Window focus window 6" })
map("n", "<C-7>", "<cmd> :7wincmd w <CR>", { desc = "Window focus window 7" })
map("n", "<C-8>", "<cmd> :8wincmd w <CR>", { desc = "Window focus window 8" })
map("n", "<C-9>", "<cmd> :9wincmd w <CR>", { desc = "Window focus window 9" })
map("n", "<C-0>", "<cmd> :0wincmd w <CR>", { desc = "Window focus window 10" })

-- tab navigation
map("n", "<leader>ta", "<cmd> $tabnew <CR>", { desc = "Tab add new tab" })
map("n", "<leader>tc", "<cmd> tabclose <CR>", { desc = "Tab close tab" })
map("n", "<leader>to", "<cmd> tabonly <CR>", { desc = "Tab close other tabs except current" })
map("n", "<leader>tn", "<cmd> tabn <CR>", { desc = "Tab focus next tab" })
map("n", "<leader>tp", "<cmd> tabp <CR>", { desc = "Tab focus previous tab" })
map("n", "<leader>1", "<cmd> tabn 1 <CR>", { desc = "Tab go to tab 1" })
map("n", "<leader>2", "<cmd> tabn 2 <CR>", { desc = "Tab go to tab 2" })
map("n", "<leader>3", "<cmd> tabn 3 <CR>", { desc = "Tab go to tab 3" })
map("n", "<leader>4", "<cmd> tabn 4 <CR>", { desc = "Tab go to tab 4" })
map("n", "<leader>5", "<cmd> tabn 5 <CR>", { desc = "Tab go to tab 5" })
map("n", "<leader>6", "<cmd> tabn 6 <CR>", { desc = "Tab go to tab 6" })
map("n", "<leader>7", "<cmd> tabn 7 <CR>", { desc = "Tab go to tab 7" })
map("n", "<leader>8", "<cmd> tabn 8 <CR>", { desc = "Tab go to tab 8" })
map("n", "<leader>9", "<cmd> tabn 9 <CR>", { desc = "Tab go to tab 9" })
map("n", "<leader>0", "<cmd> tabn 0 <CR>", { desc = "Tab go to tab 0" })

-- git integration
map("n", "<C-g>b", "<cmd> Gitsigns toggle_current_line_blame <CR>", { desc = "Git toggle blame" })
map("n", "<C-g>s", "<cmd> Gitsigns preview_hunk <CR>", { desc = "Git show current hunk" })
map("n", "<C-g>p", "<cmd> Gitsigns prev_hunk <CR>", { desc = "Git go to previous hunk" })
map("n", "<C-g>n", "<cmd> Gitsigns next_hunk <CR>", { desc = "Git go to next hunk" })
map("n", "<C-g>u", "<cmd> Gitsigns reset_hunk <CR>", { desc = "Git undo current hunk" })
map("n", "<C-g>a", "<cmd> Gitsigns stage_hunk <CR>", { desc = "Git stage current hunk" })
map("n", "<C-g>r", "<cmd> Gitsigns undo_stage_hunk <CR>", { desc = "Git unstage current hunk" })
map("n", "<C-g>d", "<cmd> Gitsigns diffthis <CR>", { desc = "Git show diff on current buffer" })
map("n", "<C-g>m", "<cmd> GitMessenger <CR>", { desc = "Git show commit message from current line" })
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
end, { desc = "Git toggle diff view" })

-- LSP
map("n", "<F2>", function()
  require "ui.renamer"()
end, { desc = "LSP rename symbol" })
map("n", "gr", "<cmd> TroubleToggle lsp_references <CR>", { desc = "LSP list all symbol references" })
map("n", "<leader>ld", function()
  vim.diagnostic.disable()
end, { desc = "LSP disable lsp diagnostics" })
map("n", "<leader>le", function()
  vim.diagnostic.enable()
end, { desc = "LSP enable lsp diagnostics" })
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "LSP format code" })
map("v", "<leader>fm", "gq", { desc = "LSP format code selection" })
map("n", "<leader>q", "<cmd> Trouble diagnostics <CR>", { desc = "LSP show diagnostics" })

-- search utils
map(
  "n",
  "n",
  "<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>",
  { desc = "Search repeat last search" }
)
map(
  "n",
  "N",
  "<cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
  { desc = "Search repeat last search (in opposite direction)" }
)

-- text actions
map("n", "<A-Down>", "<cmd> :m .+1 <CR>==", { desc = "Text move line upwards" })
map("n", "<A-Up>", "<cmd> :m .-2 <CR>==", { desc = "Text move line downwards" })
map("n", "<leader>fw", "<cmd> WrapTextAtColumn <CR>", { desc = "Text wrap paragraph" })
map("v", "<leader>fw", "<cmd> WrapTextAtColumn <CR>", { desc = "Text wrap text selection" })
map("n", "<leader>tt", "<cmd> Twilight <CR>", { desc = "Text toggle code dimming" })
map("i", "<C-BS>", "<C-W>", { desc = "Text delete previous word" })

-- neotree
-- map("n", "<leader>e", "<cmd> Neotree filesystem toggle left <CR>", { desc = "Neotree toggle file tree" })
-- map("n", "<leader>b", "<cmd> Neotree buffers toggle left <CR>", { desc = "Neotree toggle buffer tree" })
-- map("n", "<leader>g", "<cmd>Neotree git_status toggle left <CR>", { desc = "Neotree toggle git status tree" })

-- nvim-tree
map("n", "<leader>e", "<cmd> NvimTreeFindFileToggle <CR>", { desc = "nvim-tree toggle file tree" })

-- telescope
map(
  "n",
  "<A-o>",
  "<cmd> Telescope file_browser path=$HOME prompt_title=Open\\ folder <CR>",
  { desc = "Telescope open folder" }
)
map("n", "<A-p>", "<cmd> Telescope find_files prompt_title=Open\\ file <CR>", { desc = "Telescope open file" })
map("n", "<C-S-b>", "<cmd> Telescope marks <CR>", { desc = "Telescope open bookmarks" })
map("n", "<C-S-f>", "<cmd> Telescope live_grep prompt_title=Search\\ all <CR>", { desc = "Telescope search all" })
map("n", "<leader>b", "<cmd> Telescope buffers <CR>", { desc = "Telescope find buffers" })
map("v", "<C-S-f>", "<cmd> SearchForTextSelection <CR>", { desc = "Telescope search all" })
map("n", "<C-g>c", "<cmd> Telescope git_commits <CR>", { desc = "Telescope git show commits" })
map("n", "<C-g>t", "<cmd> Telescope git_status <CR>", { desc = "Telescope git show status" })
map("n", "<C-S-o>", "<cmd> Telescope lsp_document_symbols <CR>", { desc = "Telescope show lsp symbols" })
map(
  "n",
  ";",
  "<cmd> MarksListAll <CR><cmd>lcl<CR><cmd>Telescope loclist prompt_title=Marks<CR>",
  { desc = "Telescope show all marks" }
)

-- comment divider
map("n", "<A-y>", "<cmd> InsertCommentDivider <CR>", { desc = "Divider add line" })
map("i", "<A-y>", "<ESC><cmd> InsertCommentDivider <CR>", { desc = "Divider add line" })
map("v", "<A-y>", "<cmd> InsertCommentDivider <CR>", { desc = "Divider add line" })

-- word wrap
map("n", "<leader>we", "<cmd> set wrap <CR>", { desc = "Util enable word wrapping" })
map("n", "<leader>wd", "<cmd> set nowrap <CR>", { desc = "Util disable word wrapping" })

-- Disable mappings
local nomap = vim.keymap.del
-- nomap("n", "<leader>b")
nomap("t", "<C-c>")
