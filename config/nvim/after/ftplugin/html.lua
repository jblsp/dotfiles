local bo = vim.bo

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = true
  vim.keymap.set(mode, lhs, rhs, opts)
end

bo.softtabstop = -1
bo.expandtab = true
bo.shiftwidth = 2

map("n", "<localleader>p", function()
  require("joe.html-preview").open()
end, { desc = "Preview file in browser" })
