require "nvchad.mappings"

local map = vim.keymap.set

-- delete previous word
map("i", "<C-BS>", "<C-W>", { desc = "delete previous word" })

-- session management
map("n", "<A-r>", function()
  require("resession").load(nil, { dir = "dirsession" })
end, { desc = "recent folders" })

-- navigation
map("n", "<leader>w", "<cmd> HopWord <CR>", { desc = "word motion" })
map("n", "<A-j>", "5gj", { desc = "move lines 5x downwards" })
map("n", "<A-k>", "5gk", { desc = "move lines 5x upwards" })
map("n", "<A-h>", "b", { desc = "move back a word" })
map("n", "<A-l>", "w", { desc = "move forward a word" })

-- jumplist
map("n", "<A-Left>", "<C-O>zz", { desc = "move back" })
map("n", "<A-Right>", "<C-I>zz", { desc = "move forward" })
-- map("n","<A-h>", "<C-O>zz", {desc ="move back" })
-- map("n","<A-l", "<C-I>zz", {desc ="move forward" })

-- move lines
map("n", "<A-Down>", "<cmd> :m .+1<CR>==", { desc = "move line upwards" })
map("n", "<A-Up>", "<cmd> :m .-2<CR>==", { desc = "move line downwards" })

-- buffer
map("n", "<C-n>", "<cmd> enew <CR>", { desc = "new buffer" })
map("n", "<Tab>", "<cmd> bnext <CR>", { desc = "focus next buffer" })
map("n", "<S-Tab>", "<cmd> bprev <CR>", { desc = "focus previous buffer" })
map("n", "<leader>x", "<cmd> CloseBuffer <CR>", { desc = "close current buffer" })
map("n", "<C-w>a", "<cmd> CloseAllBuffers <CR>", { desc = "close all buffers" })

-- window adjusts (for kitty)
-- TODO: create function for width based on window position
map("n", "<C-S-w>", "<cmd> winc > <CR>", { desc = "increase width" })
map("n", "<C-S-x>", "<cmd> winc < <CR>", { desc = "decrease width" })
map("n", "<C-S-y>", "<cmd> winc - <CR>", { desc = "increase height" })
map("n", "<C-S-z>", "<cmd> winc + <CR>", { desc = "decrease height" })

-- window adjusts (for neovim-qt)
-- TODO: create function for width based on window position
map("n", "<C-S-Right>", "<cmd> winc > <CR>", { desc = "increase width" })
map("n", "<C-S-Left>", "<cmd> winc < <CR>", { desc = "decrease width" })
map("n", "<C-S-Up>", "<cmd> winc - <CR>", { desc = "increase height" })
map("n", "<C-S-Down>", "<cmd> winc + <CR>", { desc = "decrease height" })

-- window focus
map("n", "<C-1>", "<cmd> :1wincmd w <CR>", { desc = "focus window 1" })
map("n", "<C-2>", "<cmd> :2wincmd w <CR>", { desc = "focus window 2" })
map("n", "<C-3>", "<cmd> :3wincmd w <CR>", { desc = "focus window 3" })
map("n", "<C-4>", "<cmd> :4wincmd w <CR>", { desc = "focus window 4" })
map("n", "<C-5>", "<cmd> :5wincmd w <CR>", { desc = "focus window 5" })
map("n", "<C-6>", "<cmd> :6wincmd w <CR>", { desc = "focus window 6" })
map("n", "<C-7>", "<cmd> :7wincmd w <CR>", { desc = "focus window 7" })
map("n", "<C-8>", "<cmd> :8wincmd w <CR>", { desc = "focus window 8" })
map("n", "<C-9>", "<cmd> :9wincmd w <CR>", { desc = "focus window 9" })
map("n", "<C-0>", "<cmd> :0wincmd w <CR>", { desc = "focus window 10" })

-- center focused buffer
map("n", "<leader>cb", "<cmd> ZenMode <CR>", { desc = "center current buffer" })

-- tab navigation
map("n", "<leader>ta", "<cmd> $tabnew <CR>", { desc = "add new tab" })
map("n", "<leader>tc", "<cmd> tabclose <CR>", { desc = "close tab" })
map("n", "<leader>to", "<cmd> tabonly <CR>", { desc = "close other tabs except current" })
map("n", "<leader>tn", "<cmd> tabn <CR>", { desc = "focus next tab" })
map("n", "<leader>tp", "<cmd> tabp <CR>", { desc = "focus previous tab" })

-- tab control
map("n", "<leader>1", "<cmd> tabn 1 <CR>", { desc = "go to tab 1" })
map("n", "<leader>2", "<cmd> tabn 2 <CR>", { desc = "go to tab 2" })
map("n", "<leader>3", "<cmd> tabn 3 <CR>", { desc = "go to tab 3" })
map("n", "<leader>4", "<cmd> tabn 4 <CR>", { desc = "go to tab 4" })
map("n", "<leader>5", "<cmd> tabn 5 <CR>", { desc = "go to tab 5" })
map("n", "<leader>6", "<cmd> tabn 6 <CR>", { desc = "go to tab 6" })
map("n", "<leader>7", "<cmd> tabn 7 <CR>", { desc = "go to tab 7" })
map("n", "<leader>8", "<cmd> tabn 8 <CR>", { desc = "go to tab 8" })
map("n", "<leader>9", "<cmd> tabn 9 <CR>", { desc = "go to tab 9" })
map("n", "<leader>0", "<cmd> tabn 0 <CR>", { desc = "go to tab 0" })

-- git integration
map("n", "<C-g>b", "<cmd> Gitsigns toggle_current_line_blame<CR>", { desc = "toggle git blame" })
map("n", "<C-g>s", "<cmd> Gitsigns preview_hunk<CR>", { desc = "show current hunk" })
map("n", "<C-g>p", "<cmd> Gitsigns prev_hunk<CR>", { desc = "go to previous hunk" })
map("n", "<C-g>n", "<cmd> Gitsigns next_hunk<CR>", { desc = "go to next hunk" })
map("n", "<C-g>u", "<cmd> Gitsigns reset_hunk<CR>", { desc = "undo current hunk" })
map("n", "<C-g>a", "<cmd> Gitsigns stage_hunk<CR>", { desc = "stage current hunk" })
map("n", "<C-g>r", "<cmd> Gitsigns undo_stage_hunk<CR>", { desc = "unstage current hunk" })
map("n", "<C-g>d", "<cmd> Gitsigns diffthis <CR>", { desc = "show git diff on current buffer" })
map("n", "<C-g>m", "<cmd> GitMessenger <CR>", { desc = "show commit message from current line" })

-- LSP config
map("n", "<F2>", function()
  -- TODO: create my own renamer without showing curr_name
  require "nvchad.lsp.renamer" ()
end, { desc = "rename symbol" })

map("n", "gr", "<cmd> TroubleToggle lsp_references<CR>", { desc = "list all symbol references" })
map("n", "<leader>ld", function()
  vim.diagnostic.disable()
end, { desc = "disable lsp diagnostics" })
map("n", "<leader>le", function()
  vim.diagnostic.enable()
end, { desc = "enable lsp diagnostics" })
map("n", "<leader>fm", function()
  require("conform").format { async = true, lsp_fallback = "always" }
end, { desc = "format code" })
map("v", "<leader>fm", "gq", { desc = "format code selection" })

-- search utility
map(
  "n",
  "n",
  "<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>",
  { desc = "repeat last search" }
)
map(
  "n",
  "N",
  "<cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
  { desc = "repeat last search (in opposite direction)" }
)

-- text wrapping
map("n", "<leader>fw", "<cmd> WrapTextAtColumn <CR>", { desc = "wrap paragraph" })
map("v", "<leader>fw", "<cmd> WrapTextAtColumn <CR>", { desc = "wrap text selection" })

map("n", "<leader>tt", "<cmd> Twilight <CR>", { desc = "toggle code dimming" })

-- neotree
map("n", "<leader>e", "<cmd> Neotree filesystem toggle left <CR>", { desc = "toggle file tree" })
map("n", "<leader>b", "<cmd> Neotree buffers toggle left <CR>", { desc = "toggle buffer tree" })
-- map("n", "<leader>g", "<cmd>Neotree git_status toggle left <CR>", { desc = "toggle git status tree" })
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
end, { desc = "toggle git diff view" })

-- telescope - general navigation
map("n", "<A-o>", "<cmd> Telescope file_browser path=$HOME prompt_title=Open\\ folder<CR>", { desc = "open folder" })
map("n", "<A-p>", "<cmd> Telescope find_files prompt_title=Open\\ file<CR>", { desc = "open file" })
map("n", "<C-S-b>", "<cmd> Telescope marks<CR>", { desc = "open bookmarks" })
map("n", "<C-S-f>", "<cmd> Telescope live_grep prompt_title=Search\\ all<CR>", { desc = "search all" })
map("n", "<leader><Tab>", "<cmd> Telescope buffers<CR>", { desc = "find buffers" })
map("v", "<C-S-f>", "<cmd> SearchForTextSelection <CR>", { desc = "search all" })

-- telescope - git
map("n", "<C-g>c", "<cmd> Telescope git_commits <CR>", { desc = "git commits" })
map("n", "<C-g>t", "<cmd> Telescope git_status <CR>", { desc = "git status" })

-- telescope - lsp
map("n", "<C-S-o>", "<cmd> Telescope lsp_document_symbols <CR>", { desc = "show lsp symbols" })

-- telescope - marks
map(
  "n",
  ";",
  "<cmd> MarksListAll <CR><cmd>lcl<CR><cmd>Telescope loclist prompt_title=Marks<CR>",
  { desc = "show all marks" }
)

-- comment
map("n", "<A-y>", "<cmd> InsertCommentDivider <CR>", { desc = "add divider line" })
map("i", "<A-y>", "<ESC><cmd> InsertCommentDivider <CR>", { desc = "add divider line" })
map("v", "<A-y>", "<cmd> InsertCommentDivider <CR>", { desc = "add divider line" })
map(
  "v",
  "gc",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "toggle comment" }
)
