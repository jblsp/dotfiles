return {
  src = "gh:nvim-mini/mini.ai",
  version = vim.version.range("*"),
  config = function()
    require("mini.ai").setup({
      n_lines = 500,
    })
  end,
}
