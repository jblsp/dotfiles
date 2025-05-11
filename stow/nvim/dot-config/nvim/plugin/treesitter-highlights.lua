-- Enables treesitter highlighting (:h vim.treesitter.start)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
