local M = {}

local plugins = {}

local function add_plugin(s)
  local spec
  if type(s) == "string" then
    spec = { src = s }
  else
    spec = s
  end
  if not spec.priority then
    spec.priority = 50
  end
  table.insert(plugins, spec)
  if spec.deps then
    for _, d in ipairs(spec.deps) do
      d.priority = d.priority or spec.priority + 1
      add_plugin(d)
    end
  end
end

local function load_plugin(p)
  if p.before then
    p.before()
  end
  vim.pack.add({
    {
      src = p.src:gsub("^gh:", "https://github.com/"):gsub("^cb:", "https://codeberg.org/"),
      version = p.version,
    },
  }, { confirm = false })
  if p.config then
    p.config()
  end
end

function M.setup(specs)
  for _, s in ipairs(specs) do
    add_plugin(s)
  end

  table.sort(plugins, function(a, b)
    return a.priority < b.priority
  end)

  for _, p in ipairs(plugins) do
    load_plugin(p)
  end
end

return M
