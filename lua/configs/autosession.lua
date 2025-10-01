return {
  cwd_change_handling = true,
  suppressed_dirs = { "~/", "~/projects", "~/Downloads", "/", "/tmp" },

  pre_save_cmds = { "DiffviewClose", "NvimTreeClose", "ScopeSaveState" },
  post_restore_cmds = { "ScopeLoadState" },

  close_filetypes_on_save = {
    "checkhealth",
    "gitcommit",
    "NvimTree",
    "DiffviewFiles",
    "nvdash",
    "nvcheatsheet",
    "packer",
    "*Telescope*",
    "terminal",
    "mason",
    "Trouble",
    "Lazy",
    "help",
    "toggleterm",
  },
}
