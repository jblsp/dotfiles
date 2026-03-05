local colorschemes = require("joe.colorschemes")

local M = {}

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
      { import = "joe.plugins" },
      colorschemes.get_lazy_specs(),
    },
    install = { colorscheme = { vim.g.colors_name } },
    checker = { enabled = true, notify = false },
    rocks = {
      hererocks = false,
    },
    change_detection = {
      notify = false,
    },
    performance = {
      rtp = {
        reset = false,
      },
    },
  })
end

return M
