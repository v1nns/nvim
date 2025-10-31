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
