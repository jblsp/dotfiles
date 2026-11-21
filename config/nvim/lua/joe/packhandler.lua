--[[
Packhandler: minimal wrapper around vim.pack.

Spec:
  { "gh:user/repo", name?, ver?, priority?, enabled?, before?, call_setup? }

  Sources:    gh: (GitHub), cb: (Codeberg), or full URL
  name:       Override repository-derived name
  ver:        Version range
  priority:   Load order, ascending (default: 500)
  enabled:    Skip when false
  before:     Function called before vim.pack.add()
  call_setup: true or module name; used only when no config exists

Config:
  Requires vim.g.packhandler_configs (Lua module prefix).
  Loads <packhandler_configs>.<name> (trailing .nvim removed).
  Return a function or { before?, config? }.
  Top-level imports must not depend on the plugin being loaded.

Order:
  spec.before -> config.before -> vim.pack.add -> config
]]

local M = {}

---@class PackhandlerSpec
---@field [1] string Plugin URL (supports gh: and cb: prefixes)
---@field name? string Override the plugin name
---@field ver? string Version range
---@field priority? integer Load priority (default: 500)
---@field enabled? boolean Whether to load the plugin (default: true)
---@field before? fun() Called before vim.pack.add()
---@field call_setup? boolean|string Call setup() when no config module exists

---@param spec PackhandlerSpec
---@return vim.pack.Spec
local function build_spec(spec)
  local src = spec[1]:gsub("^gh:", "https://github.com/"):gsub("^cb:", "https://codeberg.org/")

  return {
    src = src,
    name = spec.name or src:gsub("%.git$", ""):match("[^/]+$"),
    version = spec.ver and vim.version.range(spec.ver) or nil,
  }
end

---@param spec PackhandlerSpec
local function load(spec)
  if spec.before then
    spec.before()
  end

  local pack = build_spec(spec)
  local module = pack.name:gsub("%.nvim$", "")
  local path = vim.g.packhandler_configs .. "." .. module

  local has_config = vim.loader.find(path)[1] ~= nil
  local config = has_config and require(path) or nil

  if type(config) == "table" and config.before then
    config.before()
  end

  vim.pack.add({ pack }, { confirm = false })

  local call_setup = spec.call_setup

  if has_config then
    if type(config) == "function" then
      config()
    elseif type(config) == "table" and config.config then
      config.config()
    end
  elseif type(call_setup) == "string" then
    require(call_setup).setup()
  elseif call_setup == true then
    require(module).setup()
  end
end

---@param specs PackhandlerSpec[]
function M.setup(specs)
  if not vim.g.packhandler_configs then
    vim.notify("packhandler: vim.g.packhandler_configs must be set before setup()", vim.log.levels.ERROR)
    return
  end

  local plugins = {}

  for _, spec in ipairs(specs) do
    if spec.enabled ~= false then
      plugins[#plugins + 1] = spec
    end
  end

  table.sort(plugins, function(a, b)
    return (a.priority or 500) < (b.priority or 500)
  end)

  for _, spec in ipairs(plugins) do
    load(spec)
  end
end

return M
