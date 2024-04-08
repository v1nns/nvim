local map = vim.keymap.set

local function apply(curr, win)
  local new_name = vim.trim(vim.fn.getline ".")
  vim.api.nvim_win_close(win, true)

  if #new_name > 0 and new_name ~= curr then
    local params = vim.lsp.util.make_position_params()
    params.newName = new_name

    vim.lsp.buf_request(0, "textDocument/rename", params)
  end
end

return function()
  local curr_name = vim.fn.expand "<cword>" .. " "

  local win = require("plenary.popup").create(curr_name, {
    title = "",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "RenamerBorder",
    titlehighlight = "RenamerTitle",
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  vim.cmd "normal A"
  vim.cmd "startinsert"

  map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })

  map({ "i", "n" }, "<CR>", function()
    apply(curr_name, win)
    vim.cmd.stopinsert()
  end, { buffer = 0 })
end
