-- local session = require "resession"

local M = {}

-- Autocommands
M.setup_autocommands = function()
  local autocmd = vim.api.nvim_create_autocmd

  -- automatic commands to execute when neovim is opened
  autocmd({ "VimEnter", "DirChanged" }, {
    callback = function()
      -- setup title string
      -- TODO: show empty when in HOME?
      local cwd = vim.fn.getcwd()
      vim.o.titlestring = vim.fn.fnamemodify(cwd, ":t") .. " - " .. cwd

      -- force highlights reload
      require("base46").load_all_highlights()
    end,
  })

  -- preserve equal size for splitted windows after resize
  autocmd({ "VimResized" }, {
    callback = function()
      local current_tab = vim.api.nvim_get_current_tabpage()
      vim.cmd "tabdo wincmd ="
      vim.api.nvim_set_current_tabpage(current_tab)
    end,
  })

  -- TODO: fix
  -- open dashboard on startup
  -- autocmd({ "UIEnter", "BufDelete" }, {
  --   callback = function()
  --     M.show_dashboard()
  --   end,
  -- })

  -- auto-wrap comments, don't auto insert comment on o/O and enter
  autocmd("FileType", {
    command = "set formatoptions-=cro",
  })

  -- enable line number in telescope previewer
  autocmd("User", { pattern = "TelescopePreviewerLoaded", command = "setlocal number" })

  -- disable a few features for some filetypes
  autocmd("FileType", {
    pattern = {
      "nvdash",
      "nvcheatsheet",
      "packer",
      "*Telescope*",
      "terminal",
      "mason",
      "Trouble",
      "Lazy",
      "DiffviewFiles",
    },
    callback = function()
      if package.loaded["virt-column"] then
        -- disable ruler (aka virtual column)
        require("virt-column").setup_buffer { virtcolumn = "" }
      end

      -- disable quickscope highlight
      vim.b.qs_local_disable = 1
    end,
  })

  -- sadly, git messenger is configured using global variables,
  -- and that's why this autocmd is necessary
  autocmd("FileType", {
    pattern = { "gitmessengerpopup" },
    callback = function()
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_floating_win_opts = { border = "single" }
      vim.g.git_messenger_popup_content_margins = false
    end,
  })

  -- show cursor line only in active window
  autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
      if vim.w.auto_cursorline then
        vim.wo.cursorline = true
        vim.w.auto_cursorline = nil
      end
    end,
  })

  -- hide cursor in unfocused window
  autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
      if vim.wo.cursorline then
        vim.w.auto_cursorline = true
        vim.wo.cursorline = false
      end
    end,
  })

  -- enable window keybindings on terminal pt1
  autocmd({ "TermOpen" }, {
    pattern = { "*" },
    callback = function(event)
      vim.opt_local.cursorline = false
      local code_term_esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)
      for _, key in ipairs { "h", "j", "k", "l" } do
        vim.keymap.set("t", "<C-" .. key .. ">", function()
          local code_dir = vim.api.nvim_replace_termcodes("<C-" .. key .. ">", true, true, true)
          vim.api.nvim_feedkeys(code_term_esc .. code_dir, "t", true)
        end, { noremap = true })
      end
      if vim.bo.filetype == "" then
        vim.api.nvim_set_option_value("filetype", "terminal", { buf = event.buf })
        if vim.g.catgoose_terminal_enable_startinsert == 1 then
          vim.cmd.startinsert()
        end
      end
    end,
  })

  -- enable window keybindings on terminal pt2
  autocmd({ "WinEnter" }, {
    pattern = { "*" },
    callback = function()
      if vim.bo.filetype == "terminal" and vim.g.catgoose_terminal_enable_startinsert then
        vim.cmd.startinsert()
      end
    end,
  })

  -- fix scrolloff on EOF
  autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
    callback = function()
      if vim.api.nvim_win_get_config(0).relative ~= "" then
        return -- Ignore floating windows
      end

      local win_height = vim.fn.winheight(0)
      local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
      local visual_distance_to_eof = win_height - vim.fn.winline()

      if visual_distance_to_eof < scrolloff then
        local win_view = vim.fn.winsaveview()
        vim.fn.winrestview { topline = win_view.topline + scrolloff - visual_distance_to_eof }
      end
    end,
  })

  -- keep the cursor position when yanking
  local cursorPreYank

  vim.keymap.set({ "n", "x" }, "y", function()
    cursorPreYank = vim.api.nvim_win_get_cursor(0)
    return "y"
  end, { expr = true })

  vim.keymap.set("n", "Y", function()
    cursorPreYank = vim.api.nvim_win_get_cursor(0)
    return "yg_"
  end, { expr = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator == "y" and cursorPreYank then
        vim.api.nvim_win_set_cursor(0, cursorPreYank)
      end
    end,
  })

  -- code companion
  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequest*",
    callback = function(request)
      if request.match == "CodeCompanionRequestStarted" then
        _G.processing_llm = true
      elseif request.match == "CodeCompanionRequestStreaming" then
        _G.processing_llm = false
      end
    end,
  })
end

-- Commands
M.setup_commands = function()
  local cmd = vim.api.nvim_create_user_command

  -- close all opened buffers
  cmd("CloseAllBuffers", function()
    vim.cmd "NvimTreeClose"

    local count = #vim.api.nvim_list_tabpages()
    if count == 1 then
      vim.cmd "%bd"
      M.show_dashboard()
    else
      vim.cmd "windo bd"
    end
  end, {})

  -- remove trailing spaces from current buffer
  cmd("RemoveTrailingSpace", function()
    vim.cmd [[%s/\s\+$//e | nohlsearch]]
  end, {})

  -- yank current text selection on visual mode
  cmd("SearchForTextSelection", function()
    -- get selected text from visual mode
    vim.cmd 'noau normal! "vy"'
    local text = vim.fn.getreg "v"

    -- run live_grep picker from telescope
    require("telescope.builtin").live_grep {
      prompt_title = "Search all",
      default_text = text,
    }
  end, {})

  -- wrap text at column X (or value is asked)
  cmd("WrapTextAtColumn", function(opts)
    local column = tonumber(opts.args) or tonumber(vim.fn.input "Column to wrap: ")
    if column == nil then
      return
    end

    -- set maximum text width
    vim.o.textwidth = column

    -- based on current mode, use different motion to apply word wrap
    local mode = vim.fn.mode()
    if mode == "n" then
      vim.api.nvim_feedkeys("gwap", "n", false)
    elseif mode == "v" then
      vim.api.nvim_feedkeys("gq", "v", false)
    end
  end, { nargs = "?" })

  -- create command for comment divider snippets
  -- TODO: maybe split to another lua file like utils or something like that
  cmd("InsertCommentDivider", function()
    local mapped = {
      ["n"] = function()
        local line = vim.api.nvim_get_current_line()
        local empty = true and line == nil or line == "" or false

        -- format new line
        if empty == true then
          -- get current cursor position
          table.unpack = table.unpack or unpack
          local _, _, _, _, cursor_position = table.unpack(vim.fn.getcurpos())
          cursor_position = cursor_position - 1

          -- quantity of ASCII characters for comment divider
          local size = 94

          if cursor_position > 0 then
            size = size - cursor_position
            line = string.rep(" ", cursor_position)
              -- TODO: replace '/*' with info from vim.bo.comments
              .. "/* "
              .. string.rep("-", size)
              .. " */"
          else
            line = "/* " .. string.rep("*", size) .. " */"
          end
        else
          -- trim all the whitespaces
          line = line:gsub("^%s*(.-)%s*$", "%1")

          -- length of current buffer line
          local line_length = line:len()

          -- calculate how many characters are needed for minimum seperator
          -- /* - text - */
          local delimiter_length = (92 - line_length) / 2

          -- create left separator
          local left = string.rep("-", delimiter_length)

          -- if final string won't fill entire line (100 columns)
          -- fix it by adding another delimiter to right side
          if 96 > (line_length + 2 * delimiter_length) then
            delimiter_length = delimiter_length + 1
          end

          -- create right separator
          local right = string.rep("-", delimiter_length)

          line = "/* " .. left .. " " .. line .. " " .. right .. " */"
        end

        vim.api.nvim_set_current_line(line)
      end,

      ["v"] = function()
        -- TODO: implement...
        -- local vstart = vim.fn.getpos("'<")
        -- local vend = vim.fn.getpos("'>")
        --
        -- local line_start = vstart[2]
        -- local line_end = vend[2]
        --
        -- -- or use api.nvim_buf_get_lines
        -- local lines = vim.fn.getline(line_start, line_end)
      end,
    }

    local mode = vim.fn.mode()

    if mapped[mode] then
      mapped[mode]()
    end
  end, {})

  -- copy relative path from current buffer
  cmd("CopyRelativePath", function()
    local path = vim.fn.expand "%"
    vim.fn.setreg("+", path)
    vim.notify("Copied path to clipboard (" .. path .. ")")
  end, {})

  -- install LSP dependencies
  cmd("MasonInstallAll", function()
    -- TODO: maybe run this command by default on first init
    require("nvchad.mason").install_all()
  end, {})

  -- clear all swap files associated with current project
  cmd("ClearSwapFiles", function()
    -- Get default swap directory
    local swap_dir = vim.fn.stdpath "state" .. "/swap/"

    -- Get current working directory and convert path to swap file format
    local project_dir = vim.fn.getcwd()
    local pattern = project_dir:gsub("/", "\\%%")

    -- Construct find command to locate and delete matching swap files
    local command = 'silent !find "' .. swap_dir .. '" -type f -name "*' .. pattern .. '*.sw[klmnop]" -delete'
    vim.cmd(command)
    print(string.format("Deleted swap files for project: %s", project_dir))
  end, {})

  -- Close telescope buffer in the current tab
  cmd("CloseTelescope", function()
    local wins = vim.api.nvim_tabpage_list_wins(0)

    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

      -- Telescope buffers typically have 'TelescopePrompt' or 'TelescopeResults' filetype
      if string.find(filetype, "Telescope") then
        vim.cmd [[buf.."bd"]]
      end
    end
  end, {})

  -- Show all open buffers in a floating window
  cmd("BufferList", function()
    -- Get all listed buffers
    local buffers = vim.api.nvim_list_bufs()
    local buffer_list = {}

    for _, buf in ipairs(buffers) do
      if vim.fn.buflisted(buf) == 1 then
        local name = vim.api.nvim_buf_get_name(buf)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
        local modified = vim.api.nvim_get_option_value("modified", { buf = buf })

        -- Format buffer name
        local display_name = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"

        -- Add buffer info to list
        table.insert(buffer_list, {
          bufnr = buf,
          name = display_name,
          filetype = filetype,
          modified = modified,
          current = buf == vim.api.nvim_get_current_buf(),
        })
      end
    end

    if #buffer_list == 0 then
      vim.notify("No buffers open", vim.log.levels.INFO)
      return
    end

    -- Create buffer for floating window
    local float_buf = vim.api.nvim_create_buf(false, true)

    -- Define letters for quick access
    local letters = "abcdefghijklmnopqrstuvwxyz"
    local letter_map = {}

    -- Format buffer list lines
    local lines = {}
    for i, buf_info in ipairs(buffer_list) do
      local modified_mark = buf_info.modified and " [+]" or ""
      local letter = i <= #letters and letters:sub(i, i) or tostring(i)

      -- Store letter to buffer mapping
      letter_map[letter] = buf_info.bufnr

      local line = string.format(" [%s] %s%s", letter, buf_info.name, modified_mark)
      table.insert(lines, line)
    end

    -- Set buffer content
    vim.api.nvim_buf_set_lines(float_buf, 1, -1, false, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = float_buf })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = float_buf })

    -- Calculate window size
    local max_width = 0
    for _, line in ipairs(lines) do
      max_width = math.max(max_width, #line)
    end

    local width = math.min(max_width + 4, vim.o.columns - 10)
    local height = math.min(#lines + 2, vim.o.lines - 10)

    -- Calculate window position (bottom right)
    local row = vim.o.lines - height - 3
    local col = vim.o.columns - width - 4

    vim.o.termguicolors = true
    vim.api.nvim_set_hl(0, "Cursor", { blend = 100 })
    vim.g.guicursor_tmp = vim.o.guicursor
    vim.o.guicursor = vim.o.guicursor .. "a:Cursor/lCursor"

    -- Create floating window and focus it for buffer-local keymaps
    local win = vim.api.nvim_open_win(float_buf, true, {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
      title = " Buffer List ",
      title_pos = "left",
      noautocmd = true,
    })

    -- Set window options
    vim.api.nvim_set_option_value("winblend", 0, { win = win })

    -- Buffer-local keymaps (only work in this buffer)
    local opts = { noremap = true, silent = true, buffer = float_buf }

    -- Function to clean up and close window
    local function cleanup()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      vim.cmd [[hi Cursor blend=0]]
      vim.o.guicursor = vim.g.guicursor_tmp
    end

    -- Close window with q or Esc
    vim.keymap.set("n", "q", cleanup, opts)
    vim.keymap.set("n", "<Esc>", cleanup, opts)

    -- Create keybinds for each letter
    for letter, bufnr in pairs(letter_map) do
      vim.keymap.set("n", letter, function()
        cleanup()
        vim.cmd("buffer " .. bufnr)
      end, opts)
    end

    -- Catch-all: close window on any other key press
    -- stylua: ignore start
    local all_keys = {
      "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
      "<Space>", "<CR>", "<Tab>", "<BS>",
      "<Up>", "<Down>", "<Left>", "<Right>",
      "<C-h>", "<C-j>", "<C-k>", "<C-l>",
      "<C-w>", "<C-u>", "<C-d>", "<C-b>", "<C-f>",
      ":", "/", "?", ".", ",", ";", "'", "\"",
      "[", "]", "{", "}", "(", ")", "<", ">",
      "-", "_", "=", "+", "|", "\\", "`", "~",
      "!", "@", "#", "$", "%", "^", "&", "*",
    }
    -- stylua: ignore end

    -- Add unmapped letters
    for i = 1, 26 do
      local letter = string.char(96 + i) -- a-z
      if not letter_map[letter] then
        table.insert(all_keys, letter)
      end
    end

    for _, key in ipairs(all_keys) do
      vim.keymap.set("n", key, cleanup, opts)
    end
  end, {})
end

-- check if must open nvdash
M.show_dashboard = function()
  require("snacks").dashboard.open()
end

return M
