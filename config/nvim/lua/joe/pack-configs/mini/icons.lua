return function()
  if vim.g.have_nerd_font then
    local icons = require("mini.icons")
    local glyph, hl = icons.get("extension", "lua")
    icons.setup({
      file = {
        ["init.lua"] = { glyph = glyph, hl = hl },
      },
    })
  end
end
