return {
  -- install treesitter playground
  {
    "nvim-treesitter/playground",
    lazy = false,
    enabled = false,
  },

  -- replace UI for messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require "configs.noice",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- override default keys to show whichkey keybinding window
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g", "z" },
    opts = require "configs.whichkey",
  },

  -- disable nvim-tree shipped by NvChad (snacks explorer is used instead)
  { "nvim-tree/nvim-tree.lua", enabled = false },

  -- select window to open new buffer
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    opts = true,
  },

  -- syntax highlight for coding
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    opts = require "configs.treesitter",
  },

  -- code completion
  {
    "nvchad/base46",
    branch = "v3.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    opts = require "configs.blink",
  },

  -- git integration with buffers
  {
    "lewis6991/gitsigns.nvim",
    opts = require "configs.gitsigns",
  },

  -- git commit message in a popup
  {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    -- config = check commands.lua...
  },

  -- git conflict (in a fancy way)
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },

  -- git diff in a separate view
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = require "configs.diffview",
  },

  -- portable package manager
  {
    "williamboman/mason.nvim",
    opts = require "configs.mason",
  },

  -- lua_ls support for the neovim runtime and plugin APIs
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- language server protocol
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- code formatting
  {
    "stevearc/conform.nvim",
    -- event = { "BufWritePre" }, -- uncomment for format on save
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
  },

  -- telescope (ui for pickers: open files, search files, ...)
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "Telescope file_browser" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "s1n7ax/nvim-window-picker",
    },
    opts = require "configs.telescope",
  },

  -- session management + limit buffers scope per tab
  {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
      {
        "tiagovla/scope.nvim",
        lazy = false,
        config = function()
          require("scope").setup {}
        end,
      },
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    opts = require "configs.autosession",
  },

  -- breadcrumbs using winbar
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = require "configs.navic",
  },
  {
    "b0o/incline.nvim",
    enabled = false,
    dependencies = "SmiteshP/nvim-navic",
    event = "VeryLazy",
    config = function()
      -- incline must be configured like this because it is using some util methods from it
      local opt = require "configs.incline"
      require("incline").setup(opt)
    end,
  },

  -- set up a virtual column (similar to a ruler in another IDEs)
  {
    "lukas-reineke/virt-column.nvim",
    lazy = false,
    opts = require "configs.virtcolumn",
  },

  -- code snippets to add documentation based on doxygen
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup {
        snippet_engine = "luasnip",
        languages = {
          ["cpp.doxygen"] = require "neogen.configurations.cpp",
        },
      }
    end,
  },

  -- disable indent-blankline shipped by NvChad (snacks.indent is used instead)
  { "lukas-reineke/indent-blankline.nvim", enabled = false },

  -- surround text selections
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability
    event = "VeryLazy",
    init = function()
      require("nvim-surround").setup()
    end,
  },

  -- syntax highlight for log files
  {
    "mtdl9/vim-log-highlighting",
    ft = "log",
    init = function() end,
  },

  -- tab navigation
  {
    "nanozuki/tabby.nvim",
    lazy = false,
    config = function()
      require("ui.tabby").setup()
    end,
  },

  -- enhance search command
  {
    "kevinhwang91/nvim-hlslens",
    keys = { "/", "?", "n", "N" },
    config = function()
      require("hlslens").setup()
    end,
  },

  -- create predefined window layouts
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = require "configs.edgy",
  },

  -- enhance code diagnostics
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = "Trouble",
    opts = require "configs.trouble",
  },

  -- word motion using search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- scrollbar
  {
    "dstein64/nvim-scrollview",
    event = "VeryLazy",
    config = function()
      require("scrollview").setup()
    end,
  },

  -- highlight TODO comments
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- -- debug applications
  -- {mfussenegger/nvim-dap",
  -- },

  -- flutter utilities
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = require "configs.fluttertools",
  },

  -- tmux navigation
  {
    "alexghergh/nvim-tmux-navigation",
    opts = require "configs.tmuxnavigation",
  },

  -- read/write files with sudo command
  {
    "lambdalisue/vim-suda",
    cmd = {
      "SudaRead",
      "SudaWrite",
    },
    init = function()
      vim.g.suda_smart_edit = 1
    end,
  },

  -- animation to yank operation
  {
    "rachartier/tiny-glimmer.nvim",
    event = "TextYankPost",
    opts = require "configs.tinyglimmer",
  },

  -- code assistant using local LLM
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = require "configs.codecompanion",
  },

  -- better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- search and replace panel
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = {},
  },

  -- collection of utilities (dashboard, ...)
  {
    "folke/snacks.nvim",
    lazy = false,
    dependencies = "b0o/incline.nvim",
    opts = require "configs.snacks",
  },

  -- inline bookmarks
  {
    "TheNoeTrevino/haunt.nvim",
    lazy = false,
    opts = {
      data_dir = vim.fn.stdpath "data" .. "/haunt",
    },
  },

  -- AI integration (NES)
  {
    "folke/sidekick.nvim",
    lazy = false,
    opts = {
      nes = {
        enabled = false,
      },
      cli = {
        mux = {
          backend = "tmux",
          dump = 50000, -- match tmux history-limit
          enabled = true,
        },
        win = {
          keys = {
            -- leave terminal mode; sidekick then opens the full scrollback
            stopinsert = { "<c-x>", "stopinsert", mode = "t", desc = "enter normal mode" },
          },
        },
      },
    },
  },

  -- markdown support
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
  },
}
