local opt_local = vim.opt_local

local html_preview = require("joe.html-preview")

opt_local.wrap = true

vim.keymap.set("n", "<localleader>p", function()
  html_preview.open(html_preview.generators.pandoc("gfm"))
end, {
  buffer = true,
  desc = "Preview as HTML in browser",
})
