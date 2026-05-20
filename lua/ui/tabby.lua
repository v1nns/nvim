local api = require "tabby.module.api"

local M = {}

local theme = {
  fill = "TabLineFill",
  head = "TabLineFill",
  current_tab = "TabLineSel",
  tab = "TabLineFill",
  win = "TabLine",
  tail = "TabLine",
  explorer = "TabLineExplorer",
}

local snacks_filetypes = {
  snacks_picker_list = true,
  snacks_picker_input = true,
  snacks_layout_box = true,
  snacks_dashboard = true,
}

local options = {
  tab_name = {
    name_fallback = function(tabid)
      local cur_win = api.get_tab_current_win(tabid)

      -- if the focused window is a snacks window, find the last real buffer in the tab
      local buf = vim.fn.winbufnr(cur_win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
      if snacks_filetypes[ft] then
        for _, win in ipairs(api.get_tab_wins(tabid)) do
          local wbuf = vim.fn.winbufnr(win)
          local wft = vim.api.nvim_get_option_value("filetype", { buf = wbuf })
          if not snacks_filetypes[wft] and vim.bo[wbuf].buftype == "" then
            buf = wbuf
            break
          end
        end
      end

      local buf_name = vim.fn.fnamemodify(vim.fn.bufname(buf), ":t")
      if buf_name == "" or buf_name == " " then
        buf_name = "<empty>"
      end

      return buf_name
    end,
  },
}

local function get_explorer_width()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft == "snacks_layout_box" then
      if vim.api.nvim_win_get_config(win).relative == "" then
        return vim.api.nvim_win_get_width(win) + 1
      end
    end
  end
  return 0
end

M.setup = function()
  require("tabby.tabline").set(function(line)
    local explorer_width = get_explorer_width()

    local label = "[EXPLORER]"
    local label_w = vim.fn.strdisplaywidth(label)
    local content_w = math.max(0, explorer_width - 1) -- -1 for the border char
    local left_pad = math.max(0, math.floor((content_w - label_w) / 2))
    local right_pad = math.max(0, content_w - label_w - left_pad)

    return {
      { string.rep(" ", left_pad) .. (content_w >= label_w and label or "") .. string.rep(" ", right_pad), hl = theme.explorer },
      { explorer_width > 0 and "│" or "", hl = "WinSeparator" },
      {
        { "  ", hl = theme.head },
        -- line.sep("█", theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab

        -- indicate if any of buffers in tab have unsaved changes
        local modified = false
        local win_ids = require("tabby.module.api").get_tab_wins(tab.id)

        for _, win_id in ipairs(win_ids) do
          if pcall(vim.api.nvim_win_get_buf, win_id) then
            local bufid = vim.api.nvim_win_get_buf(win_id)
            if vim.api.nvim_get_option_value("modified", { buf = bufid }) then
              modified = true
              break
            end
          end
        end

        return {
          " ",
          -- tab.is_current() and "󰄲" or "",
          tab.number(),
          " ",
          tab.name(),
          modified and " ",
          " ",
          tab.close_btn "",
          " ",
          hl = hl,
          -- margin = " ",
        }
      end),
      line.spacer(),
      hl = theme.fill,
    }
  end, options)
end

return M
