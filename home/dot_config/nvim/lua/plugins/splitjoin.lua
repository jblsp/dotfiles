return {
  src = "gh:nvim-mini/mini.splitjoin",
  version = vim.version.range("*"),
  config = function()
    require("mini.splitjoin").setup()
  end,
}
