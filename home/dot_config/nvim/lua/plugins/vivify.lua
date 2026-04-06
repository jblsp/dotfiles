local util = require("joe.util")

return {
  src = "gh:jannis-baum/vivify.vim",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown" },
      group = vim.api.nvim_create_augroup("vivify-maps", { clear = true }),
      callback = function(ev)
        local map = util.mapper("Vivify", ev.buf)
        map("<localleader>p", "<cmd>Vivify<cr>", "Preview buffer")
      end,
    })
  end,
}
