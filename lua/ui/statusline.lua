local utils = require "nvchad.stl.utils"
local navic = require "nvim-navic"

return {
  theme = "vscode_colored",

  order = {
    "mode",
    "file",
    "git",
    "macro",
    "%=",
    "lsp_msg",
    "%=",
    "llm",
    "cursor",
    "diagnostics",
    "lsp",
    "filetype",
    "cwd",
  },

  modules = {
    file = function()
      local x = utils.file()
      if string.find(x[2], "NvimTree") then
        return "%#StText# "
      end

      local name = " " .. x[2] .. " "
      return "%#StText# " .. x[1] .. name
    end,

    git = function()
      if not vim.b[utils.stbufnr()].gitsigns_head or vim.b[utils.stbufnr()].gitsigns_git_status then
        return ""
      end

      local git_status = vim.b[utils.stbufnr()].gitsigns_status_dict

      local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
      local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
      local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
      local branch_name = " " .. git_status.head

      return "%#GitBranch#"
        .. branch_name
        .. "%#DiffAdded#"
        .. added
        .. "%#DiffModified#"
        .. changed
        .. "%#DiffRemoved#"
        .. removed
        .. "%#StText#"
    end,

    macro = function()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end

      return "%#String#" .. " recording to " .. reg .. "%#StText#"
    end,

    breadcrumb = function()
      return navic.is_available() and navic.get_location() or ""
    end,

    llm = function()
      return _G.processing_llm and "%#@text.todo#( waiting for LLM response... )%#StText#" or ""
    end,

    cursor = function()
      local wc = vim.fn.wordcount()

      local selection = ""
      if wc["visual_chars"] then
        selection = " ("
          .. wc["visual_chars"]
          .. " chars selected, "
          .. vim.fn.abs(vim.fn.line "." - vim.fn.line "v") + 1
          .. " lines)"
      end

      return "%#StText#" .. " Ln %l, Col %c" .. selection
    end,

    lsp = function()
      if rawget(vim, "lsp") then
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.attached_buffers[utils.stbufnr()] and client.name ~= "null-ls" then
            return (vim.o.columns > 100 and "%#St_Lsp# " .. client.name .. " ") or "  LSP "
          end
        end
      end

      return ""
    end,

    filetype = function()
      local ft = vim.bo[utils.stbufnr()].ft
      return ft == "" and "%#St_ft# {} plain text  " or "%#St_ft#{} " .. ft .. " "
    end,
  },
}
