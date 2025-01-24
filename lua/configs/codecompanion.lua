return {
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        parameters = {
          sync = true,
        },
        schema = {
          model = {
            default = "deepseek-r1:14b",
          },
          num_ctx = {
            -- maybe tweak this and test
            default = 2048,
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
    agent = {
      adapter = "ollama",
    },
  },
  opts = {
    -- Change for DEBUG when necessary
    log_level = "ERROR",
  },
}
