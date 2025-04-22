return {
  "stevearc/oil.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["<esc>"] = {
        "actions.close",
        mode = "n",
      },
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return vim.tbl_contains({ ".DS_Store" }, name)
      end,
    },
  },
}
