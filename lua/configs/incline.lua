local helpers = require "incline.helpers"
local navic = require "nvim-navic"
local devicons = require "nvim-web-devicons"

return {
  window = {
    padding = 0,
    margin = { horizontal = 1, vertical = 0 },
    overlap = {
      borders = false,
      statusline = false,
      tabline = false,
      winbar = false,
    },
    placement = {
      horizontal = "right",
      vertical = "top",
    },
  },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end

    local ft_icon, ft_color = devicons.get_icon_color(filename)
    local modified = vim.bo[props.buf].modified
    local res = {
      ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
      {
        " " .. filename .. (modified and " " or ""),
        guibg = modified and "#e0af68" or "",
        guifg = modified and "#060606" or "",
      },
      -- modified and { "  ", guibg = "#e0af68", guifg= " #992975" } or "",
      guibg = "#24283b",
    }

    local first = true
    if props.focused then
      for _, item in ipairs(navic.get_data(props.buf) or {}) do
        table.insert(res, {
          { first and modified and "> " or " > ", group = "NavicSeparator" },
          { item.icon, group = "NavicIcons" .. item.type },
          { item.name, group = "NavicText" },
        })
      end
    end

    table.insert(res, " ")
    return res
  end,
}
