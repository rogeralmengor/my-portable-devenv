return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "ollama",
    vendors = {
      ollama = {
        endpoint = "http://host.docker.internal:11434",
        model = "qwen2.5-coder:7b",
        parse_curl_args = function(opts, code_opts)
          return {
            url = opts.endpoint .. "/api/chat",
            headers = { ["Content-Type"] = "application/json" },
            body = {
              model = opts.model,
              options = {
                temperature = 0,
                num_predict = 4096,
              },
              messages = require("avante.providers.ollama").parse_messages(code_opts),
              stream = true,
            },
          }
        end,
        parse_response_data = function(data_stream, event_state, opts)
          require("avante.providers.ollama").parse_response(data_stream, event_state, opts)
        end,
      },
    },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}
