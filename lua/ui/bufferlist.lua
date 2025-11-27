local M = {}

local LETTERS = "1234567890abcdefgimnoprstuvwxyz"
local LETTER_COLUMN = 2
local FIRST_BUFFER_LINE = 2

-- Apply syntax highlighting to buffer lines
local function apply_buffer_highlights(buf, lines, buffer_list)
  local ns_id = vim.api.nvim_create_namespace "bufferlist_highlights"

  for i, buf_info in ipairs(buffer_list) do
    local line_idx = i -- Line index in the display (accounting for top padding at line 0)

    -- Highlight the opening bracket " ["
    vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, 1, {
      end_col = 2,
      hl_group = "BufferListBracket",
    })

    -- Highlight the letter keybind
    vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, 2, {
      end_col = 3,
      hl_group = "BufferListKey",
    })

    -- Highlight the closing bracket "] "
    vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, 3, {
      end_col = 5,
      hl_group = "BufferListBracket",
    })

    -- Get the line text to find where the path starts and ends
    local line_text = lines[line_idx + 1] -- +1 because lines table is 1-indexed
    local path_start = 5 -- After " [x] "
    local path_end = #line_text

    -- Check if there's a modified indicator
    local modified_start = buf_info.modified and (#line_text - 3) or path_end

    -- Extract filename from path for bold highlighting
    local path_text = line_text:sub(path_start + 1, modified_start)
    local filename_start_idx = path_text:match "^.*()/" -- Find last slash
    local filename_start = filename_start_idx and (path_start + filename_start_idx) or path_start

    -- Apply dim effect to non-current buffers
    if not buf_info.current then
      vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, path_start, {
        end_col = modified_start,
        hl_group = "BufferListEntry",
      })
    else
      -- Highlight the file path normally for current buffer
      vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, path_start, {
        end_col = modified_start,
        hl_group = buf_info.current and "BufferListCurrent" or "BufferListPath",
      })
    end

    -- Apply bold to filename only
    vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, filename_start, {
      end_col = modified_start,
      hl_group = buf_info.current and "BufferListCurrent" or "BufferListFilename",
    })

    -- Highlight the modified indicator
    if buf_info.modified then
      vim.api.nvim_buf_set_extmark(buf, ns_id, line_idx, modified_start, {
        end_col = path_end,
        hl_group = "BufferListModified",
      })
    end
  end
end

-- Get all listed buffers with their metadata
local function get_buffer_list(original_current_buf)
  local buffers = vim.api.nvim_list_bufs()
  local buffer_list = {}
  local current_buf = original_current_buf or vim.api.nvim_get_current_buf()

  for _, buf in ipairs(buffers) do
    if vim.fn.buflisted(buf) == 1 then
      local name = vim.api.nvim_buf_get_name(buf)
      local display_name = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"

      table.insert(buffer_list, {
        bufnr = buf,
        name = display_name,
        filetype = vim.api.nvim_get_option_value("filetype", { buf = buf }),
        modified = vim.api.nvim_get_option_value("modified", { buf = buf }),
        current = buf == current_buf,
      })
    end
  end

  return buffer_list
end

-- Format buffer list into display lines with letter shortcuts
local function format_buffer_lines(buffer_list)
  local lines = {}
  local letter_map = {}
  local line_to_bufnr = {}

  for i, buf_info in ipairs(buffer_list) do
    local modified_mark = buf_info.modified and " [+]" or ""
    local letter = i <= #LETTERS and LETTERS:sub(i, i) or tostring(i)

    letter_map[letter] = buf_info.bufnr
    line_to_bufnr[i + 1] = buf_info.bufnr -- +1 for top padding line

    local line = string.format(" [%s] %s%s", letter, buf_info.name, modified_mark)
    table.insert(lines, line)
  end

  -- Add padding lines for visual spacing
  table.insert(lines, 1, "")
  table.insert(lines, "")

  return lines, letter_map, line_to_bufnr
end

-- Create and configure the floating buffer
local function create_float_buffer(lines, buffer_list)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "bufferlist", { buf = buf })

  -- Apply syntax highlighting
  apply_buffer_highlights(buf, lines, buffer_list)

  return buf
end

-- Calculate window dimensions based on content
local function calculate_window_dimensions(lines)
  local max_width = 0
  for _, line in ipairs(lines) do
    max_width = math.max(max_width, #line)
  end

  local width = math.min(max_width + 4, vim.o.columns - 10)
  local height = math.min(#lines, vim.o.lines - 10)

  return width, height
end

-- Calculate window position (bottom right corner)
local function calculate_window_position(width, height)
  local row = vim.o.lines - height - 3
  local col = vim.o.columns - width - 4
  return row, col
end

-- Create and open the floating window
local function create_floating_window(buf, width, height, row, col)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Buffers ",
    title_pos = "left",
    noautocmd = true,
  })

  vim.api.nvim_set_option_value("winblend", 0, { win = win })
  vim.api.nvim_set_option_value("cursorline", true, { win = win })
  vim.api.nvim_win_set_cursor(win, { FIRST_BUFFER_LINE, LETTER_COLUMN })

  return win
end

-- Set up cursor movement keymaps that stay within valid buffer lines
local function setup_movement_keys(win, float_buf, last_buffer_line)
  local opts = { noremap = true, silent = true, buffer = float_buf }

  local function keep_cursor_in_bounds()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line, col = cursor[1], cursor[2]

    if line < FIRST_BUFFER_LINE then
      vim.api.nvim_win_set_cursor(win, { FIRST_BUFFER_LINE, LETTER_COLUMN })
    elseif line > last_buffer_line then
      vim.api.nvim_win_set_cursor(win, { last_buffer_line, LETTER_COLUMN })
    elseif col ~= LETTER_COLUMN then
      vim.api.nvim_win_set_cursor(win, { line, LETTER_COLUMN })
    end
  end

  vim.keymap.set("n", "j", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    if line < last_buffer_line then
      vim.api.nvim_win_set_cursor(win, { line + 1, LETTER_COLUMN })
    end
  end, opts)

  vim.keymap.set("n", "k", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    if line > FIRST_BUFFER_LINE then
      vim.api.nvim_win_set_cursor(win, { line - 1, LETTER_COLUMN })
    end
  end, opts)

  vim.keymap.set("n", "G", function()
    vim.api.nvim_win_set_cursor(win, { last_buffer_line, LETTER_COLUMN })
  end, opts)

  vim.keymap.set("n", "gg", function()
    vim.api.nvim_win_set_cursor(win, { FIRST_BUFFER_LINE, LETTER_COLUMN })
  end, opts)

  local autocmd_id = vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = float_buf,
    callback = keep_cursor_in_bounds,
  })

  return autocmd_id
end

-- Set up autocommands for window behavior
local function setup_autocommands(win, float_buf)
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    buffer = float_buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })
end

-- Update buffer content with new data
local function update_buffer_content(float_buf, lines, buffer_list)
  -- Clear existing highlights
  local ns_id = vim.api.nvim_create_namespace "bufferlist_highlights"
  vim.api.nvim_buf_clear_namespace(float_buf, ns_id, 0, -1)

  vim.api.nvim_set_option_value("modifiable", true, { buf = float_buf })
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = float_buf })

  -- Reapply highlights
  apply_buffer_highlights(float_buf, lines, buffer_list)
end

-- Clean up old keymaps before refreshing
local function cleanup_keymaps(float_buf, letter_map)
  vim.keymap.del("n", "j", { buffer = float_buf })
  vim.keymap.del("n", "k", { buffer = float_buf })
  vim.keymap.del("n", "G", { buffer = float_buf })
  vim.keymap.del("n", "gg", { buffer = float_buf })
  vim.keymap.del("n", "<C-d>", { buffer = float_buf })
  vim.keymap.del("n", "<CR>", { buffer = float_buf })

  -- Delete letter keymaps
  for letter, _ in pairs(letter_map) do
    pcall(vim.keymap.del, "n", letter, { buffer = float_buf })
  end
end

-- Recreate movement keymaps with new bounds
local function recreate_movement_keys(win, float_buf, new_last_buffer_line)
  local opts = { noremap = true, silent = true, buffer = float_buf }

  local function keep_cursor_in_bounds()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line, col = cursor[1], cursor[2]

    if line < FIRST_BUFFER_LINE then
      vim.api.nvim_win_set_cursor(win, { FIRST_BUFFER_LINE, LETTER_COLUMN })
    elseif line > new_last_buffer_line then
      vim.api.nvim_win_set_cursor(win, { new_last_buffer_line, LETTER_COLUMN })
    elseif col ~= LETTER_COLUMN then
      vim.api.nvim_win_set_cursor(win, { line, LETTER_COLUMN })
    end
  end

  vim.keymap.set("n", "j", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    if line < new_last_buffer_line then
      vim.api.nvim_win_set_cursor(win, { line + 1, LETTER_COLUMN })
    end
  end, opts)

  vim.keymap.set("n", "k", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    if line > FIRST_BUFFER_LINE then
      vim.api.nvim_win_set_cursor(win, { line - 1, LETTER_COLUMN })
    end
  end, opts)

  vim.keymap.set("n", "G", function()
    vim.api.nvim_win_set_cursor(win, { new_last_buffer_line, LETTER_COLUMN })
  end, opts)

  vim.keymap.set("n", "gg", function()
    vim.api.nvim_win_set_cursor(win, { FIRST_BUFFER_LINE, LETTER_COLUMN })
  end, opts)

  local autocmd_id = vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = float_buf,
    callback = keep_cursor_in_bounds,
  })

  return autocmd_id
end

-- Set up keymaps for buffer selection and window closing
local function setup_selection_keys(win, float_buf, letter_map, line_to_bufnr, refresh_callback)
  local opts = { noremap = true, silent = true, buffer = float_buf }

  local function cleanup()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function switch_to_buffer(bufnr)
    cleanup()
    vim.cmd("buffer " .. bufnr)
  end

  local function delete_buffer_and_refresh(bufnr)
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      -- Save current cursor position
      local cursor_line = vim.api.nvim_win_get_cursor(win)[1]

      -- Delete the buffer
      vim.cmd("bdelete " .. bufnr)

      -- Refresh the buffer list
      refresh_callback(cursor_line, letter_map)
    end
  end

  -- Close window with q, Esc or Ctrl-c
  vim.keymap.set("n", "q", cleanup, opts)
  vim.keymap.set("n", "<Esc>", cleanup, opts)
  vim.keymap.set("n", "<C-c>", cleanup, opts)

  -- Switch to buffer on current line with Enter
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local bufnr = line_to_bufnr[line]
    if bufnr then
      switch_to_buffer(bufnr)
    end
  end, opts)

  -- Delete buffer under cursor with Ctrl-d
  vim.keymap.set("n", "<C-d>", function()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    local bufnr = line_to_bufnr[line]
    if bufnr then
      delete_buffer_and_refresh(bufnr)
    end
  end, opts)

  -- Create letter shortcut keybinds
  for letter, bufnr in pairs(letter_map) do
    vim.keymap.set("n", letter, function()
      switch_to_buffer(bufnr)
    end, opts)
  end
end

-- Create a refresh function for updating the display after buffer deletion
local function create_refresh_function(win, float_buf, movement_autocmd_id_ref, original_current_buf)
  return function(previous_cursor_line, old_letter_map)
    local new_buffer_list = get_buffer_list(original_current_buf)

    if #new_buffer_list == 0 then
      vim.notify("No buffers open", vim.log.levels.INFO)
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      return
    end

    local new_lines, new_letter_map, new_line_to_bufnr = format_buffer_lines(new_buffer_list)
    update_buffer_content(float_buf, new_lines, new_buffer_list)

    local new_last_buffer_line = #new_buffer_list + 1

    -- Adjust cursor position
    local new_cursor_line = math.min(previous_cursor_line, new_last_buffer_line)
    if new_cursor_line < FIRST_BUFFER_LINE then
      new_cursor_line = FIRST_BUFFER_LINE
    end
    vim.api.nvim_win_set_cursor(win, { new_cursor_line, LETTER_COLUMN })

    -- Clean up old movement autocmd
    if movement_autocmd_id_ref.id then
      vim.api.nvim_del_autocmd(movement_autocmd_id_ref.id)
    end

    -- Clean up old keymaps
    cleanup_keymaps(float_buf, old_letter_map)

    -- Recreate movement keys with new bounds
    movement_autocmd_id_ref.id = recreate_movement_keys(win, float_buf, new_last_buffer_line)

    -- Recreate selection keys with new mappings
    local refresh_display = create_refresh_function(win, float_buf, movement_autocmd_id_ref, original_current_buf)
    setup_selection_keys(win, float_buf, new_letter_map, new_line_to_bufnr, refresh_display)
  end
end

-- Main function to display buffer picker
M.pick_buffer = function()
  -- Capture the current buffer before opening the picker
  local original_current_buf = vim.api.nvim_get_current_buf()

  local buffer_list = get_buffer_list(original_current_buf)

  if #buffer_list == 0 then
    vim.notify("No buffers open", vim.log.levels.INFO)
    return
  end

  -- TODO:
  -- - define max columns for buffer filepath
  -- - refresh window when buffer with extensive filepath gets deleted (may not need if first one is implemented)
  local lines, letter_map, line_to_bufnr = format_buffer_lines(buffer_list)
  local float_buf = create_float_buffer(lines, buffer_list)
  local width, height = calculate_window_dimensions(lines)
  local row, col = calculate_window_position(width, height)
  local win = create_floating_window(float_buf, width, height, row, col)

  local last_buffer_line = #buffer_list + 1 -- +1 for top padding

  -- Use a table to store autocmd ID so it can be mutated in nested functions
  local movement_autocmd_id_ref = { id = nil }

  movement_autocmd_id_ref.id = setup_movement_keys(win, float_buf, last_buffer_line)
  setup_autocommands(win, float_buf)

  local refresh_display = create_refresh_function(win, float_buf, movement_autocmd_id_ref, original_current_buf)
  setup_selection_keys(win, float_buf, letter_map, line_to_bufnr, refresh_display)
end

return M
