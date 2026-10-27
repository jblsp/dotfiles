local html_preview = require("joe.html-preview")

vim.keymap.set("n", "<localleader>p", function()
  html_preview.open_generated(html_preview.pandoc_generator("latex"))
end, {
  buffer = true,
  desc = "Preview as HTML in browser",
})
