return {
  bottom = {
    "Trouble",
    { ft = "qf", title = "QuickFix" },
    {
      ft = "help",
      size = { height = 0.3 },
      -- only show help buffers
      filter = function(buf)
        return vim.bo[buf].buftype == "help"
      end,
    },
    {
      title = "Search panel",
      ft = "spectre_panel",
      size = { height = 0.4 },
    },
  },
  left = {
    {
      ft = "NvimTree",
      pinned = true,
      wo = {
        winbar = false,
      },
    },
  },
  right = {
    -- {
    --   ft = "trouble",
    -- },
    {
      ft = "trouble",
      filter = function(_, win)
        return vim.w[win].trouble
          and vim.w[win].trouble.position == "right"
          and vim.w[win].trouble.type == "split"
          and vim.w[win].trouble.relative == "editor"
          and not vim.w[win].trouble_preview
      end,
    },
  },

  options = {
    left = { size = 35 },
    bottom = { size = 10 },
    right = { size = 0.25 },
    top = { size = 10 },
  },

  animate = {
    enabled = false,
  },

  keys = {
    -- increase width
    ["<C-S-w>"] = function(win)
      win:resize("width", 2)
    end,
    -- decrease width
    ["<C-S-x>"] = function(win)
      win:resize("width", -2)
    end,
    -- increase height
    ["<C-S-y>"] = function(win)
      win:resize("height", 2)
    end,
    -- decrease height
    ["<C-S-z>"] = function(win)
      win:resize("height", -2)
    end,
    -- reset all custom sizing
    ["<C-w>r"] = function(win)
      win.view.edgebar:equalize()
    end,
  },
}
