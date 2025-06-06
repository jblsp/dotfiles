local bo = vim.bo

bo.softtabstop = -1
bo.expandtab = true
bo.shiftwidth = 2

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

map("n", "<localleader>X", "<cmd>source %<cr>", { desc = "Execute current file" })
map("n", "<localleader>x", "<cmd>.lua<cr>", { desc = "Execute current line" })
map("v", "<localleader>x", ":lua<CR>", { desc = "Execute current selection" })
