local M = {}

-- utils
local isempty = function(s)
  return s == nil or s == ""
end

local get_buf_option = function(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

-- exclude list
M.winbar_filetype_exclude = {
  "help",
  "packer",
  "NvimTree",
  "nvdash",
  "toggleterm",
  "neo-tree",
  "DiffviewFiles",
}

local get_filename = function()
  local filename = vim.fn.expand "%:."
  local extension = vim.fn.expand "%:e"

  -- workaround to avoid any error with :Find command
  if string.find(filename, "term://") then
    return ""
  end

  if not isempty(filename) then
    local file_icon, file_icon_color =
      require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if isempty(file_icon) then
      file_icon = ""
      file_icon_color = ""
    end

    return "%#WinbarTitle#"
      .. " "
      .. "%#"
      .. hl_group
      .. "#"
      .. file_icon
      .. "%*"
      .. "%#WinbarTitle#"
      .. " "
      .. filename
  end
end

local get_navic = function()
  local status_navic_ok, navic = pcall(require, "nvim-navic")
  if not status_navic_ok then
    return ""
  end

  local status_ok, navic_location = pcall(navic.get_location, {})
  if not status_ok then
    return ""
  end

  if not navic.is_available() or navic_location == "error" then
    return ""
  end

  if not isempty(navic_location) then
    return "> " .. navic_location
  else
    return ""
  end
end

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

M.setup = function()
  if excludes() then
    return
  end
  local value = get_filename()

  if not isempty(value) then
    local navic_value = get_navic()
    if not isempty(navic_value) then
      value = value .. " " .. navic_value .. "%#WinbarTitle#"
    end

    if get_buf_option "mod" then
      local mod = "%#DiffModified#  %*"
      value = value .. mod
    end

    value = value .. "%#WinbarTitle#"
  end

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

return M
