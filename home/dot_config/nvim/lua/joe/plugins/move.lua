return {
  "nvim-mini/mini.move",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("mini.move").setup()
  end
}
