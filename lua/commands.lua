local session = require "resession"

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

  -- auto load session when neovim is opened
  autocmd({ "VimEnter" }, {
    callback = function()
      -- only load the session if nvim was started with no args
      if vim.fn.argc(-1) == 0 then
        -- Save these to a different directory, so our manual sessions don't get polluted
        session.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
      end
    end,
  })

  -- close some stuff before exitting and save a session
  autocmd({ "VimLeavePre" }, {
    callback = function()
      vim.cmd "DiffviewClose"
      -- vim.cmd ":tabdo Neotree close"
      vim.cmd "NvimTreeClose"

      -- do not save session if current buffer is a gitcommit
      if vim.bo.filetype == "gitcommit" then
        return
      end

      -- exclude some paths to avoid saving any session
      if vim.fn.getcwd() ~= vim.env.HOME and string.find(vim.fn.getcwd(), "/tmp/") == nil then
        -- save session
        session.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
      end
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

  -- open nvdash on startup
  autocmd({ "UIEnter" }, {
    callback = function()
      M.show_dashboard()
    end,
  })

  -- auto-wrap comments, don't auto insert comment on o/O and enter
  autocmd("FileType", {
    command = "set formatoptions-=cro",
  })

  -- set winbar with breadcrumbs and file path
  autocmd({
    "CursorMoved",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
  }, {
    callback = function()
      require("ui.winbar").setup()
    end,
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
end

-- Commands
M.setup_commands = function()
  local cmd = vim.api.nvim_create_user_command

  -- workaround to save session with multitabs (go to last tab before exiting nvim)
  -- NOTE: after reloading a session, buffers per tab-scoping will not properly work without this
  vim.cmd [[:cno qa :tablast \| :qa]]

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

  -- close current active buffer
  cmd("CloseBuffer", function()
    local count = M.get_non_empty_buffers()

    if count > 1 then
      -- change to last buffer and delete previous
      vim.cmd "bprev"
      vim.cmd "bd #"
    else
      -- create new buffer and delete previous
      vim.cmd "enew"
      vim.cmd "bd #"
    end

    M.show_dashboard()
  end, {})

  -- close all opened buffers
  cmd("CloseAllBuffers", function()
    -- local neotree = require "neo-tree.command"
    -- must hide neo-tree before closing all buffers
    -- neotree.execute { action = "close" }
    vim.cmd "NvimTreeClose"

    -- close all buffers
    local count = 0
    for _, _ in ipairs(vim.api.nvim_list_tabpages()) do
      count = count + 1
    end

    if count == 1 then
      vim.cmd "%bd"
      M.show_dashboard()
    else
      vim.cmd "windo bd"
    end
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

  -- find all matches
  cmd("Find", function(opts)
    if opts.args == nil then
      return
    end
    vim.cmd "tabnew"
    vim.cmd "TabRename search all"
    vim.cmd("term rg --no-ignore --hidden -g=!.git " .. tostring(opts.args))
    vim.cmd(string.format([[match Search /%s/]], tostring(opts.args)))
    -- to clear: match none
  end, { nargs = 1 })

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
end

M.get_non_empty_buffers = function()
  local count_non_empty = 0

  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buffer) ~= 0 then
      local name = vim.api.nvim_buf_get_name(buffer)
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = buffer })

      -- Do not count new buffer or nvdashboard
      -- NOTE: it looks like neo-tree filesystem does not appear in this list, so we are fine
      if name ~= nil and name ~= "" and filetype ~= "" and filetype ~= "nvdash" then
        count_non_empty = count_non_empty + 1
      end

      -- TODO: maybe return table with current buffers
      -- local buffer_name = vim.api.nvim_buf_get_name(buffer)
      -- if buffer_name == nil or buffer_name == "" then
      --     buffer_name = "[No Name]#" .. buffer
      -- end
    end
  end

  return count_non_empty
end

-- check if must open nvdash
M.show_dashboard = function()
  local count = M.get_non_empty_buffers()
  -- if count > 1 then
  --     require("neo-tree").close_all()
  -- end

  if count == 0 then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo.buflisted = true
    require("nvchad.nvdash").open(buf)
  end
end

return M
