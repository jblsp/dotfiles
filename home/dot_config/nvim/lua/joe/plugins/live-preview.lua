local util = require("joe.util")

return {
  "brianhuster/live-preview.nvim",
  version = "*",
  config = function()
    local map = util.mapper("live-preview")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "html", "svg", "asciidoc" },
      group = vim.api.nvim_create_augroup("live-preview-maps", { clear = true }),
      callback = function(ev)
        map("<localleader>p", "<cmd>LivePreview start<cr>", "Preview current file", { buffer = ev.buf })
      end,
    })
  end,
}
