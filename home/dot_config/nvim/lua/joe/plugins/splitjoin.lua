return {
  "nvim-mini/mini.splitjoin",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("mini.splitjoin").setup()
  end
}
