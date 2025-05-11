return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = "rafamadriz/friendly-snippets",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    cmdline = {
      keymap = { preset = "inherit" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    keymap = {
      preset = "default",
    },
  },
}
