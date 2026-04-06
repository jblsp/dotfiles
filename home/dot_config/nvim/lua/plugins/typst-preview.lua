local util = require("joe.util")

return {
  src = "gh:chomosuke/typst-preview.nvim",
  version = vim.version.range("1.*"),
  config = function()
    require("typst-preview").setup()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "typst" },
      group = vim.api.nvim_create_augroup("typst-preview-maps", { clear = true }),
      callback = function(ev)
        local map = util.mapper("typst-preview", ev.buf)

        map("<localleader>p", "<cmd>TypstPreviewToggle<cr>", "Preview current file")
      end,
    })
  end,
}
