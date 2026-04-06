local uv = vim.uv

local M = {}

--- Returns true if cwd is inside of a git work tree
function M.in_git_project()
  local cmd = "git rev-parse --is-inside-work-tree"
  return vim.fn.system(cmd) == "true\n"
end

--- Returns true if the quickfix window is open
function M.qf_window_open()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local wininfo = vim.fn.getwininfo(win)[1]
    if wininfo.quickfix == 1 then
      return true
    end
  end
  return false
end

--- List Lua modules in a directory recursively up to max_depth
--- @param mod string Lua module path
--- @param max_depth number? maximum recursion depth
--- @return string[] list of module names
function M.lsmod(mod, max_depth)
  max_depth = max_depth or math.huge
  local base_path = vim.fn.stdpath("config") .. "/lua/" .. mod:gsub("%.", "/")
  local mods = {}

  local function scan(path, prefix, depth)
    if depth > max_depth then
      return
    end

    local fd = uv.fs_scandir(path)
    if not fd then
      return
    end

    while true do
      local name, type = uv.fs_scandir_next(fd)
      if not name then
        break
      end

      local full_path = path .. "/" .. name

      if name == "init.lua" then
        table.insert(mods, prefix)
      elseif type == "file" and name:sub(-4) == ".lua" then
        table.insert(mods, prefix .. "." .. name:sub(1, -5))
      elseif type == "directory" then
        scan(full_path, prefix .. "." .. name, depth + 1)
      end
    end
  end

  scan(base_path, mod, 1)
  return mods
end

--- Create a wrapper function for vim.keymap.set
--- @param name string
function M.mapper(name, buf)
  name = name and name .. ": "
  return function(lhs, rhs, desc, opts)
    opts = opts or {}
    local mode = opts.mode
    if desc ~= nil and desc ~= "" then
      opts.desc = (name or "") .. desc
    end
    opts.mode = nil
    opts.buffer = buf or nil
    vim.keymap.set(mode or "n", lhs, rhs, opts)
  end
end

return M
