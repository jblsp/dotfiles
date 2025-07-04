--- Adapted from:
--- https://gist.github.com/oessessnex/d63ebe89380abff5a3ee70d6e76e4ec8

local M = {}

local uv = vim.uv

local function password()
  vim.fn.inputsave()
  local user = vim.env.USER
  local pw = vim.fn.inputsecret(string.format("[sudo] password for %s: ", user))
  vim.fn.inputrestore()
  return pw
end

local function test(pw, k)
  ---@diagnostic disable-next-line undefined-field
  local stdin = uv.new_pipe()
  ---@diagnostic disable-next-line undefined-field
  uv.spawn("sudo", {
    args = { "-S", "-k", "true" },
    stdio = { stdin, nil, nil },
  }, k)

  ---@diagnostic disable-next-line need-check-nil
  stdin:write(pw)
  ---@diagnostic disable-next-line need-check-nil
  stdin:write("\n")
  ---@diagnostic disable-next-line need-check-nil
  stdin:shutdown()
end

local function write(pw, buf, lines, k)
  ---@diagnostic disable-next-line undefined-field
  local stdin = uv.new_pipe()
  ---@diagnostic disable-next-line undefined-field
  uv.spawn("sudo", {
    args = { "-S", "-k", "tee", buf },
    stdio = { stdin, nil, nil },
  }, k)

  ---@diagnostic disable-next-line need-check-nil
  stdin:write(pw)
  ---@diagnostic disable-next-line need-check-nil
  stdin:write("\n")
  local last = table.remove(lines)
  for _, line in ipairs(lines) do
    ---@diagnostic disable-next-line need-check-nil
    stdin:write(line)
    ---@diagnostic disable-next-line need-check-nil
    stdin:write("\n")
  end
  ---@diagnostic disable-next-line need-check-nil
  stdin:write(last)
  ---@diagnostic disable-next-line need-check-nil
  stdin:shutdown()
end

function M.write()
  local pw = password()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(bufnr)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local function exitWrite(code, _)
    if code == 0 then
      vim.schedule(function()
        vim.api.nvim_echo({ { '"' .. buf_name .. '" written' } }, true, {})
        vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
      end)
    end
  end

  local function exitTest(code, _)
    if code == 0 then
      write(pw, buf_name, lines, exitWrite)
    else
      vim.schedule(function()
        vim.api.nvim_echo({ { "Incorrect password" } }, true, { err = true })
      end)
    end
  end

  test(pw, exitTest)
end

return M
