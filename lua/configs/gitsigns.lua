return {
  current_line_blame_opts = {
    delay = 300,
  },
  current_line_blame_formatter = "<abbrev_sha> (<author>, <author_time:%Y-%m-%d>) <summary>",
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "│" },
  },
  _git_version = "2.43.0",
}
