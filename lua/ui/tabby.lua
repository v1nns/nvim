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
        return {
          line.sep(" ", hl, theme.fill),
          -- tab.is_current() and "󰄲" or "",
          tab.number(),
          tab.name(),
          tab.close_btn "",
          line.sep(" ", hl, theme.fill),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      hl = theme.fill,
    }
  end, options)
end

return M
