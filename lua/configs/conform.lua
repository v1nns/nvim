return {
  lsp_fallback = false,
  -- Define all formatters
  formatters_by_ft = {
    cmake = { "cmake_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    javascript = { "prettier" },
    python = { "autopep8" },
    sh = { "shfmt" },
    rust = { "rustfmt" },
    yaml = { "yamlfmt" },
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
    prettier = {
      append_args = { "--print-width", "100" },
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
      args = { "-i", "2", "-ci", "-bn" },
    },
  },
}
