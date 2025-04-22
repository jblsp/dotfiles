return {
  "nvim-treesitter/nvim-treesitter",
  version = "*",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  event = "VeryLazy",
  opts = {
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<leader><CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  },
}
