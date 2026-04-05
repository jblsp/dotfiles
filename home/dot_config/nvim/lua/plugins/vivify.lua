local util = require("joe.util")

return {
  src = "gh:jannis-baum/vivify.vim",
  config = function()
    local map = util.mapper("Vivify")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown" },
      group = vim.api.nvim_create_augroup("vivify-maps", { clear = true }),
      callback = function(ev)
        map("<localleader>p", "<cmd>Vivify<cr>", "Preview buffer", { buffer = ev.buf })
      end,
    })
  end,
}
