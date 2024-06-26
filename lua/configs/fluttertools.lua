local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

return {
  dev_log = {
    enabled = true,
    open_cmd = "10new", -- command to use to open the log buffer
  },

  dev_tools = {
    autostart = true, -- autostart devtools server if not detected
    auto_open_browser = false, -- Automatically opens devtools in the browser
  },

  lsp = {
    color = {
      enabled = true,
    },

    on_attach = on_attach,
    capabilities = capabilities,

    settings = {
      showTodos = true,
      completeFunctionCalls = true,
      renameFilesWithClasses = "prompt",
      enableSnippets = true,
    },
  },
}
