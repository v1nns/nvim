-- lsp configs
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local navic = require "nvim-navic"

local servers = { "html", "bashls", "cssls", "cmake", "clangd", "jsonls", "pylsp", "ts_ls", "rust_analyzer" }

for _, lsp in ipairs(servers) do
  local settings = {}
  if lsp == "pylsp" then
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "E501" },
            maxLineLength = 100,
          },
        },
      },
    }
  end

  vim.lsp.config(lsp, {
    settings = settings,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      if lsp == "cmake" then
        return
      end

      -- enable breadcrumb
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end,
    on_init = on_init,
    capabilities = capabilities,
  })
  vim.lsp.enable(lsp)
end
