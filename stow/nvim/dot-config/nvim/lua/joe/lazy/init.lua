local M = {}

vim.g.lazy_plugins = "joe.lazy.plugins"
vim.g.lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

function M.is_installed()
  return vim.uv.fs_stat(vim.g.lazypath) ~= nil
end

function M.install()
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, vim.g.lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

function M.setup()
  vim.opt.rtp:prepend(vim.g.lazypath)
  require("lazy").setup({
    spec = {
      { import = vim.g.lazy_plugins },
    },
    lockfile = vim.fn.stdpath("config") .. "/lua/joe/lazy/lockfile.json",
    install = { colorscheme = { vim.g.colors_name } },
    checker = { enabled = true, notify = false },
    rocks = {
      hererocks = false,
    },
    change_detection = {
      notify = false,
    },
  })
end

return M
