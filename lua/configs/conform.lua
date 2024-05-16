return {
  lsp_fallback = false,
  -- Define all formatters
  formatters_by_ft = {
    cmake = { "cmake_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    javascript = { { "prettierd", "prettier" } },
    python = { "autopep8" },
    sh = { "shfmt" },
  },
  -- Set up format-on-save
  format_on_save = nil,
  -- Customize formatters
  formatters = {
    autopep8 = {
      prepend_args = { "--max-line-length", "100" },
    },
    clang_format = {
      prepend_args = {
        "--style",
        "{BasedOnStyle: Google, Standard: c++17, ColumnLimit: 100}",
      },
    },
    stylua = {
      inherit = true,
      prepend_args = {
        "--column-width",
        "120",
        "--indent-type",
        "Spaces",
        "--indent-width",
        "2",
      },
    },
    shfmt = {
      prepend_args = { "-i", "4" },
    },
  },
}
