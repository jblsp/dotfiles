return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = "rafamadriz/friendly-snippets",
  event = "VeryLazy",
  opts = {
    cmdline = {
      keymap = { preset = "inherit" },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    keymap = {
      preset = "default",
    },
  },
}
