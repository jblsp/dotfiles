return {
  "stevearc/oil.nvim",
  version = "*",
  config = function()
    require("oil").setup({
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
          if vim.tbl_contains({ ".DS_Store" }, name) then
            return true
          end
          if vim.g.in_godot_project then
            if vim.endswith(name, ".uid") then
              return true
            end
          end
        end,
      },
    })
  end,
}
