return {
  sources = {
    default = { "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
    },
  },
  keymap = {
    preset = "default",
    ["<CR>"] = false,
    ["<C-Enter>"] = { "select_and_accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
    ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<Tab>"] = {
      function()
        -- sidekick next edit suggestion
        return require("sidekick").nes_jump_or_apply()
      end,
      "snippet_forward",
      "fallback",
    },
  },
}
