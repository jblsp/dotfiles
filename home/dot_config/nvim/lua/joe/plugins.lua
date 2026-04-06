local M = {}

-- TODO: add dependencies field to plugin spec. also add priority field to ensure dependencies are loaded first

function M.load(plugins)
  for _, p in ipairs(plugins) do
    if p.before ~= nil then
      p.before()
    end
  end

  vim.pack.add(
    vim.tbl_map(function(p)
      local pack_spec = vim.deepcopy(p)
      pack_spec.config = nil
      pack_spec.src = pack_spec.src:gsub("^gh:", "https://github.com/"):gsub("^cb:", "https://codeberg.org/")

      return pack_spec
    end, plugins),
    { confirm = false }
  )

  for _, p in ipairs(plugins) do
    if p.config ~= nil then
      p.config()
    end
  end
end

return M
