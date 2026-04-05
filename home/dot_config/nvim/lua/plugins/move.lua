return {
  src = "gh:nvim-mini/mini.move",
  version = vim.version.range("*"),
  config = function()
    require("mini.move").setup()
  end,
}
