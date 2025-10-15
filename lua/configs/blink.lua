return {
  keymap = {
    preset = "default",
    ["<CR>"] = false,
    ["<C-Enter>"] = { "select_and_accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
    ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
  },
}
