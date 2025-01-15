return {
  bottom = {
    "Trouble",
    { ft = "qf", title = "QuickFix" },
    {
      ft = "help",
      size = { height = 20 },
      -- only show help buffers
      filter = function(buf)
        return vim.bo[buf].buftype == "help"
      end,
    },
    { ft = "spectre_panel", size = { height = 0.4 } },
  },
  left = {
    {
      title = "NvimTree",
      ft = "NvimTree",
      pinned = true,
    },
  },
  right = {
    -- {
    --   ft = "trouble",
    -- },
    {
      ft = "trouble",
      filter = function(_buf, win)
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
}
