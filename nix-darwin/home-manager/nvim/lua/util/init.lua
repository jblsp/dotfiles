_G.util = {}

local function util_require(module)
  _G.util[module] = {}
  local tbl = require("util." .. module)
  for key, val in pairs(tbl) do
    _G.util[module][key] = val
  end
end

util_require("colorscheme")
util_require("lsp_capabilities")
util_require("fn")
