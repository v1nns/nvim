return {
  auto_preview = false,
  modes = {
    lsp_references = {
      params = {
        include_declaration = true,
      },
    },
    lsp_base = {
      params = {
        include_current = true,
      },
    },
    tests = {
      title = "{hl:Special} {hl} {hl:Title}Unit Tests{hl} {count}",
      mode = "lsp_document_symbols",
      focus = false,
      win = { position = "right" },
      format = "{kind_icon} {symbol.name} {pos}",
      filter = function(items)
        return vim.tbl_filter(function(item)
          -- show only tests from gtest
          return item.kind == "Class" and string.find(item.text, "TEST_F", 1, true) ~= nil
        end, items)
      end,
    },
  },
}
