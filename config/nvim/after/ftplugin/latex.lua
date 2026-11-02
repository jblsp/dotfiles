local html_preview = require("joe.html-preview")

vim.keymap.set("n", "<localleader>p", function()
  html_preview.open(html_preview.generators.pandoc("latex"))
end, {
  buffer = true,
  desc = "Preview as HTML in browser",
})
