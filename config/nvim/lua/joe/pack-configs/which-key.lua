local set = vim.keymap.set

return function()
  local which_key = require("which-key")
  which_key.setup({
    delay = 200,
    plugins = {
      spelling = {
        enabled = false,
      },
    },
    icons = {
      mappings = false,
    },
  })
  set({ "n", "v" }, "<leader>?", function()
    which_key.show({ global = true })
  end, { desc = "Show keymaps" })
end
