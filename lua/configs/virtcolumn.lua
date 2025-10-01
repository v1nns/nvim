return {
  virtcolumn = "101",
  char = vim.g.neovide and "|" or "⡇",
  highlight = "VirtColumn",
  exclude = {
    filetypes = { "snacks_dashboard" },
  },
}
