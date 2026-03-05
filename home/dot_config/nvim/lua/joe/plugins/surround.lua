return {
  "nvim-mini/mini.surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    })
  end,
}
