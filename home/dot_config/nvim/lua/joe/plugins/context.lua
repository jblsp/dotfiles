return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  config = function()
    require("treesitter-context").setup({
      multiwindow = true,
      line_numbers = true,
      max_lines = 4,
    })
  end,
}
