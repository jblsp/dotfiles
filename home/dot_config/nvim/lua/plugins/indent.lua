return {
  src = "gh:saghen/blink.indent",
  version = vim.version.range("2.*"),
  config = function()
    require("blink.indent").setup({
      blocked = {
        filetypes = { include_defaults = true, "markdown", "text" },
      },
    })
  end,
}
