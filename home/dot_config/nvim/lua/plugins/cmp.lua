return {
  src = "gh:saghen/blink.cmp",
  version = vim.version.range("1.*"),
  -- dependencies = "rafamadriz/friendly-snippets",
  config = function()
    require("blink.cmp").setup()
  end,
}
