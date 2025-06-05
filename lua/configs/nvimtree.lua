local open = function()
  local core = require "nvim-tree.core"
  local explorer = core.get_explorer()

  if not explorer then
    return
  end

  local node = explorer:get_node_at_cursor()

  -- if a directory, use default action to expand/collapse
  if node.nodes then
    node:expand_or_collapse()
    return
  end

  -- get filepath
  local path = node.absolute_path
  if node.link_to then
    path = node.link_to
  end

  -- pick a window and open file as a buffer
  require("configs.windowpicker").pick_window()
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local duplicate_file = function()
  local core = require "nvim-tree.core"
  local explorer = core.get_explorer()

  if not explorer then
    return
  end

  local node = explorer:get_node_at_cursor()

  -- if a directory, do nothing
  if node.nodes then
    return
  end

  -- get filepath
  local filepath = node.absolute_path
  if node.link_to then
    filepath = node.link_to
  end

  local command = "!cp " .. filepath .. " " .. filepath .. "1"
  vim.cmd(command)
end

local on_attach = function(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- custom mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
  vim.keymap.set("n", "K", api.node.show_info_popup, opts "Info")

  vim.keymap.set("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")
  vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts "Open: Vertical Split")
  vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts "Open: Horizontal Split")
  vim.keymap.set("n", "<Tab>", api.node.open.preview, opts "Open Preview")
  vim.keymap.set("n", "<CR>", open, opts "Open")
  vim.keymap.set("n", "o", open, opts "Open")

  vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")
  vim.keymap.set("n", "E", api.tree.expand_all, opts "Expand All")
  vim.keymap.set("n", "W", api.tree.collapse_all, opts "Collapse All")

  vim.keymap.set("n", "a", api.fs.create, opts "Create File Or Directory")

  vim.keymap.set("n", "c", api.fs.copy.node, opts "Copy")
  vim.keymap.set("n", "x", api.fs.cut, opts "Cut")
  vim.keymap.set("n", "p", api.fs.paste, opts "Paste")

  vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
  vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
  vim.keymap.set("n", "]c", api.node.navigate.git.next, opts "Next Git")
  vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts "Prev Git")
  vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
  vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")

  vim.keymap.set("n", "d", api.fs.remove, opts "Delete")
  vim.keymap.set("n", "D", api.fs.trash, opts "Trash")

  vim.keymap.set("n", "f", api.live_filter.start, opts "Live Filter: Start")
  vim.keymap.set("n", "F", api.live_filter.clear, opts "Live Filter: Clear")

  vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle Filter: No Buffer")
  vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Filter: Git Clean")
  vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Filter: Dotfiles")
  vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Filter: Git Ignore")
  vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts "Toggle Filter: Hidden")

  vim.keymap.set("n", "P", api.node.navigate.parent, opts "Parent Directory")
  vim.keymap.set("n", "r", api.fs.rename, opts "Rename")
  vim.keymap.set("n", "R", api.tree.reload, opts "Refresh")
  vim.keymap.set("n", "S", api.tree.search_node, opts "Search")

  vim.keymap.set("n", "y", api.fs.copy.filename, opts "Copy Name")
  vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
  vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
  vim.keymap.set("n", "ge", api.fs.copy.basename, opts "Copy Basename")
  vim.keymap.set("n", "<C-y>", duplicate_file, opts "Duplicate File")

  vim.keymap.set("n", "s", api.node.run.system, opts "Run System")
end

return {
  on_attach = on_attach,
  filters = {
    dotfiles = false,
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = false,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    change_dir = {
      enable = false,
      restrict_above_cwd = true,
    },
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    root_folder_label = function(path)
      return "[" .. vim.fn.fnamemodify(path, ":t") .. "]"
    end,
    highlight_git = true,
    highlight_opened_files = "none",

    indent_markers = {
      enable = true,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },

      git_placement = "after",
    },
  },
}
