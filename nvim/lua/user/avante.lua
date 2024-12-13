local avante = require('avante')

avante.setup({
  provider = "ollama",
  vendors = {
    ollama = {
      __inherited_from = "openai",
      api_key_name = "",
      endpoint = "http://127.0.0.1:11434/v1",
      model = "codegemma",
    },
  },
  behaviour = {
    auto_set_highlight_group = true,
    auto_apply_diff_after_generation = false,
  },
  mappings = {
    ask = "<leader>aa",
    refresh = "<leader>ar",
  },
  windows = {
    wrap = true,
    width = 40,
  },
})
