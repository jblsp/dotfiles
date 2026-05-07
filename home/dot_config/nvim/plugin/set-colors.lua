-- set colorscheme to vim.g.colors_name (vim.g.colors_name should be set in init.lua)
-- NOTE: g:colors_name is automatically updated on colorscheme change
if vim.g.colors_name ~= nil then
  local ok, _ = pcall(vim.cmd.colorscheme, vim.g.colors_name)
  if not ok then
    vim.notify("Failed to load colorscheme " .. vim.g.colors_name, vim.log.levels.ERROR)
    vim.cmd.colorscheme("default")
  end
end
