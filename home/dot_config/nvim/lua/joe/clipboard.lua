local M = {}

function M.anon_to_clip()
  local content = vim.fn.getreg('"')
  if content ~= "" then
    if vim.fn.setreg("+", content) == 0 then
      local _, lines = content:gsub("\n", "\n")
      lines = math.max(lines, 1)
      local linestr = lines == 1 and "line" or "lines"
      local out = string.format("%d %s copied to clipboard", lines, linestr)
      vim.api.nvim_echo({ { out } }, true, {})
    else
      vim.api.nvim_echo({ { "Failed to copy to clipboard" } }, true, { err = true })
    end
  end
end

return M
