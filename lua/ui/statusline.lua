local utils = require "nvchad.stl.utils"

return {
  theme = "vscode_colored",

  order = { "mode", "file", "git", "macro", "%=", "lsp_msg", "%=", "cursor", "diagnostics", "lsp", "filetype", "cwd" },

  modules = {
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

    cursor = function()
      local wc = vim.fn.wordcount()
      local selection = wc["visual_chars"] and " (" .. wc["visual_chars"] .. " selected)" or ""

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
