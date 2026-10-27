local M = {}

local plugins = {}

local function add_plugin(s)
  s.src = s[1]:gsub("^gh:", "https://github.com/"):gsub("^cb:", "https://codeberg.org/")
  if not s.priority then
    s.priority = 500
  end
  table.insert(plugins, s)
end

local function load_plugin(p)
  if p.before then
    p.before()
  end

  -- package name from URL
  local pname = p.src:gsub("%.git$", ""):match("[^/]+$")

  -- package name for vim.pack
  local conf_name = pname:gsub("%.nvim$", "")

  local conf_module = "joe.packhandler.configs." .. conf_name
  local has_conf = vim.loader.find(conf_module)[1] ~= nil
  local conf = has_conf and require(conf_module) or nil
  if has_conf and type(conf) == "table" and conf.before then
    conf.before()
  end
  vim.pack.add({
    {
      src = p.src,
      version = p.ver and vim.version.range(p.ver) or nil,
      name = pname,
    },
  }, { confirm = false })
  if not has_conf then
    if type(p.call_setup) == "string" then
      require(p.call_setup).setup()
    elseif p.call_setup == true then
      require(conf_name).setup()
    end
  end
  if has_conf then
    if type(conf) == "function" then
      conf()
    elseif type(conf) == "table" and conf.config then
      conf.config()
    end
  end
end

function M.setup(specs)
  for _, s in ipairs(specs) do
    if s.enabled ~= false then
      add_plugin(s)
    end
  end

  table.sort(plugins, function(a, b)
    return a.priority < b.priority
  end)

  for _, p in ipairs(plugins) do
    load_plugin(p)
  end
end

return M
