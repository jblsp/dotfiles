return {
  "saghen/blink.indent",
  version = "2.*",
  config = function()
    require("blink.indent").setup({
      blocked = {
        filetypes = { include_defaults = true, "markdown", "text" },
      },
    })
  end,
}
