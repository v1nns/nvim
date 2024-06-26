return {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_ignore_patterns = {
      ".cache",
      ".git",
      "node_modules",
      "build",
    },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = true,
    borderchars = {
      "─",
      "│",
      "─",
      "│",
      "╭",
      "╮",
      "╯",
      "╰",
    },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,

        ["<C-k>"] = function(prompt_bufnr)
          -- select previous entry
          require("telescope.actions").move_selection_previous(prompt_bufnr)
        end,

        ["<C-j>"] = function(prompt_bufnr)
          -- select next entry
          require("telescope.actions").move_selection_next(prompt_bufnr)
        end,

        ["<C-BS>"] = { "<c-s-w>", type = "command" },
      },
      i = {
        ["<C-k>"] = function(prompt_bufnr)
          -- select previous entry
          require("telescope.actions").move_selection_previous(prompt_bufnr)
        end,

        ["<C-j>"] = function(prompt_bufnr)
          -- select next entry
          require("telescope.actions").move_selection_next(prompt_bufnr)
        end,

        ["<C-BS>"] = { "<c-s-w>", type = "command" },

        -- do not use this
        ["<C-l>"] = false,
      },
    },
  },
  -- builtins
  pickers = {
    find_files = {
      -- find_command = { "rg", "--files", "--sort", "path", "-F" },
      find_command = {
        "fd",
        "--type",
        "file",
        "--hidden",
        "--strip-cwd-prefix",
      },
      hidden = true,
      mappings = {
        i = {
          ["<CR>"] = function(prompt_bufnr)
            local actions = require "telescope.actions"
            local entry = require("telescope.actions.state").get_selected_entry()

            -- Use default action if entry does not contain a path
            if not entry.path then
              actions.select_default(prompt_bufnr)
              return
            end

            -- Otherwise, close telescope and use nvim-window-picker to choose
            -- which window to open new file buffer
            actions.close(prompt_bufnr)

            local is_window_picked = require("configs.windowpicker").pick_window()

            if is_window_picked then
              vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
            end
          end,
        },
      },
    },
    live_grep = {
      grep_open_files = false,
      additional_args = function()
        return {
          "--hidden",
          "-g",
          "!.cache/*",
          "-g",
          "!.git/*",
          "-g",
          "!node_modules/*",
          "-g",
          "!build/*",
        }
      end,
      mappings = {
        i = {
          ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
        },
      },
    },
    lsp_document_symbols = {
      symbol_width = 80,
      mappings = {
        i = {
          ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center,
        },
      },
    },
    buffers = {
      mappings = {
        i = {
          ["<C-d>"] = function(prompt_bufnr)
            local action_state = require "telescope.actions.state"
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            current_picker:delete_selection(function(selection)
              local ok = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = true })
              return ok
            end)
          end,
        },
      },
    },
  },
  extensions = {
    file_browser = require "configs.filebrowser",
  },
  extensions_list = {
    "themes",
    "terms",
    "file_browser",
  },
}
