local api = require "tabby.module.api"

local M = {}

local theme = {
  fill = "TabLineFill",
  head = "TabLine",
  current_tab = "TabLineSel",
  tab = "TabLineFill",
  win = "TabLine",
  tail = "TabLine",
}

local options = {
  tab_name = {
    name_fallback = function(tabid)
      local cur_win = api.get_tab_current_win(tabid)
      local full_name = vim.fn.bufname(vim.fn.winbufnr(cur_win))

      local buf_name = vim.fn.fnamemodify(full_name, ":t")

      if buf_name == "" or buf_name == " " then
        buf_name = "<empty>"
      end

      return buf_name
    end,
  },
}

M.setup = function()
  require("tabby.tabline").set(function(line)
    return {
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
