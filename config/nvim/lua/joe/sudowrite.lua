--[[
Sudowrite: save the current local file with sudo.

Usage:
  :Sudowrite

Order:
  Prompt for the password, validate sudo credentials, then write the
  buffer snapshot with tee. The write uses sudo's credential cache.
  Clear 'modified' only if the buffer has not changed since the snapshot.
]]

local M = {}

---@async
---@param cmd string[]
---@param opts vim.SystemOpts
---@return vim.SystemCompleted
local function system(cmd, opts)
  return vim.async.await(function(on_exit)
    local process = vim.system(cmd, opts, vim.schedule_wrap(on_exit))
    return {
      close = function(_, callback)
        process:close(callback)
      end,
    }
  end) --[[@as vim.SystemCompleted]]
end
local pending = {}

function M.write()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  local bo = vim.bo[buf]
  if path == "" or bo.buftype ~= "" or path:match("^%a[%w+.-]*://") then
    vim.notify("Sudowrite requires a local file buffer", vim.log.levels.ERROR)
    return
  end
  if pending[path] then
    vim.notify("Sudowrite already in progress for " .. path, vim.log.levels.WARN)
    return
  end

  vim.fn.inputsave()
  local ok, password = pcall(vim.fn.inputsecret, ("[sudo] password for %s: "):format(vim.env.USER or "current user"))
  vim.fn.inputrestore()
  if not ok then
    error(password, 0)
  end
  if password == "" then
    return
  end

  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local contents = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")

  local function write_file()
    -- Authentication gets separate stdin so tee never receives the password.
    local auth = system({ "sudo", "-S", "-p", "", "-v" }, { stdin = password .. "\n", stdout = false })
    if auth.code ~= 0 then
      error(("sudo authentication failed (exit %d): %s"):format(auth.code, vim.trim(auth.stderr or "")), 0)
    end

    local result = system({ "sudo", "-n", "--", "tee", "--", path }, { stdin = contents, stdout = false })
    if result.code ~= 0 then
      error(("Sudowrite failed (exit %d): %s"):format(result.code, vim.trim(result.stderr or "")), 0)
    end

    if
      vim.api.nvim_buf_is_loaded(buf)
      and vim.api.nvim_buf_get_name(buf) == path
      and vim.api.nvim_buf_get_changedtick(buf) == tick
    then
      bo.modified = false
    end
    vim.api.nvim_echo({ { '"' .. path .. '" written' } }, true)
  end

  pending[path] = true
  local task = vim.async.run(write_file)
  task:on_complete(function(err)
    pending[path] = nil
    if err then
      vim.notify(tostring(err), vim.log.levels.ERROR)
    end
  end)
end

return M