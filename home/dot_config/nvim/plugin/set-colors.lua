-- g:colors_name is automatically updated on colorscheme change
local ok, err = pcall(vim.cmd.colorscheme, vim.g.colors_name)
if not ok then
  vim.notify("Failed to load colorscheme " .. vim.g.colors_name, vim.log.levels.ERROR)
  vim.cmd.colorscheme("default")
end
