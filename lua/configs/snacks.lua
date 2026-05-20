return {
  dashboard = {
    -- stylua: ignore start
    preset = {
      keys = {
        { icon = " ", key = "d", desc = "Open Directory", action = ":Telescope file_browser prompt_title=Open\\ directory", },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰒲 ", key = "r", desc = "Recent Sessions", action = ":AutoSession search" },
        { icon = " ", key = "m", desc = "See Mappings", action = ":NvCheatsheet" },
        { icon = "󱐥 ", key = "u", desc = "Update Plugins", action = ":Lazy sync", enabled = package.loaded.lazy ~= nil },
        { icon = " ", key = "q", desc = "Quit", action = ":qa!" },
      },
    },
    sections = {
        { text = { [[                                           ]], hl = "DashboardHeader1" }, align = "center" },
        { text = { [[    ███╗   ███╗ █████╗ ██╗  ██╗███████╗    ]], hl = "DashboardHeader1" }, align = "center" },
        { text = { [[    ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝    ]], hl = "DashboardHeader2" }, align = "center" },
        { text = { [[    ██╔████╔██║███████║█████╔╝ █████╗      ]], hl = "DashboardHeader2" }, align = "center" },
        { text = { [[    ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝      ]], hl = "DashboardHeader2" }, align = "center" },
        { text = { [[    ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗    ]], hl = "DashboardHeader3" }, align = "center" },
        { text = { [[    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ]], hl = "DashboardHeader3" }, align = "center" },
        { text = { [[      ██████╗ ██████╗  ██████╗ ██╗         ]], hl = "DashboardHeader3" }, align = "center" },
        { text = { [[     ██╔════╝██╔═══██╗██╔═══██╗██║         ]], hl = "DashboardHeader3" }, align = "center" },
        { text = { [[     ██║     ██║   ██║██║   ██║██║         ]], hl = "DashboardHeader3" }, align = "center" },
        { text = { [[     ██║     ██║   ██║██║   ██║██║         ]], hl = "DashboardHeader4" }, align = "center" },
        { text = { [[     ╚██████╗╚██████╔╝╚██████╔╝███████╗    ]], hl = "DashboardHeader4" }, align = "center" },
        { text = { [[      ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝    ]], hl = "DashboardHeader4" }, align = "center" },
        { text = { [[ ███████╗████████╗██╗   ██╗███████╗███████╗]], hl = "DashboardHeader4" }, align = "center" },
        { text = { [[ ██╔════╝╚══██╔══╝██║   ██║██╔════╝██╔════╝]], hl = "DashboardHeader5" }, align = "center" },
        { text = { [[ ███████╗   ██║   ██║   ██║█████╗  █████╗  ]], hl = "DashboardHeader5" }, align = "center" },
        { text = { [[ ╚════██║   ██║   ██║   ██║██╔══╝  ██╔══╝  ]], hl = "DashboardHeader6" }, align = "center" },
        { text = { [[ ███████║   ██║   ╚██████╔╝██║     ██║     ]], hl = "DashboardHeader6" }, align = "center" },
        { text = { [[ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝     ]], hl = "DashboardHeader6" }, align = "center" },
        { text = { [[                                           ]], hl = "DashboardHeader1" }, align = "center" },
        { padding = 1 },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
    },
    -- stylua: ignore end
  },

  explorer = {},
  picker = {
    enabled = true,
    actions = {
      pick_win_custom = function(picker)
        if not picker.layout.split then
          picker.layout:hide()
        end
        local ok = require("configs.windowpicker").pick_window()
        if not ok then
          if not picker.layout.split then
            picker.layout:unhide()
          end
          return true
        end
        picker.main = vim.api.nvim_get_current_win()
        if not picker.layout.split then
          vim.defer_fn(function()
            if not picker.closed then
              picker.layout:unhide()
            end
          end, 100)
        end
      end,
      toggle_dir = function(picker, item, _)
        if not item then
          return
        end
        if item.dir then
          picker:action "confirm"
        end
      end,
      toggle_or_open = function(picker, item, _)
        if not item then
          return
        end
        if item.dir then
          picker:action "confirm"
        else
          picker:action { "pick_win_custom", "jump" }
        end
      end,
    },
    sources = {
      explorer = {
        enabled = true,
        hidden = true,
        ignored = true,
        auto_close = false,
        follow_file = false,
        transform = function(item)
          if not item.ignored then
            if item.dir then
              item.filename_hl = "SnacksPickerDirectory"
            else
              item.filename_hl = "SnacksPickerFile"
            end
          end
        end,
        layout = {
          config = function(layout)
            for _, box in ipairs(layout.layout) do
              if box.win == "input" then
                box.border = "bottom"
                box.wo = { winhighlight = "FloatBorder:SnacksPicker" }
                break
              end
            end
            return layout
          end,
        },
        win = {
          list = {
            keys = {
              ["."] = { "nop", mode = { "n", "i" } },
              ["l"] = { "toggle_dir", mode = { "n", "i" } },
              ["o"] = { "toggle_or_open", mode = { "n", "i" } },
              ["O"] = { "toggle_or_open", mode = { "n", "i" } },
              ["<CR>"] = { "toggle_or_open", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },

  -- TODO: change animation time for scroll
  scroll = { enabled = false },

  words = { enabled = true },

  zen = {
    enabled = true,
    on_open = function()
      require("incline").disable()
    end,
    on_close = function()
      require("incline").enable()
    end,
  },
}
