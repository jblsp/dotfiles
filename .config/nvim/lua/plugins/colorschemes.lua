local specs = {
	{
		"folke/tokyonight.nvim",
		opts = {},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {},
	},
}

local data_path = vim.fn.stdpath("data") .. "/colorscheme"
local saved_cs
local saved_csplugin
if vim.fn.filereadable(data_path) == 1 then
	local data = vim.fn.readfile(data_path)
	saved_cs = data[1]
	saved_csplugin = data[2]
else
	saved_cs = "default"
end

for _, spec in pairs(specs) do
	local spec_string = string.gsub(spec[1], ".*/", "")
	if (spec.name == saved_csplugin) or (not spec.name and (spec_string == saved_csplugin)) then
		spec.lazy = false
		spec.priority = 1000
		spec.init = function()
			vim.cmd.colorscheme(saved_cs)
		end
	else
		spec.event = "VeryLazy"
	end
end

if not saved_csplugin and saved_cs then
	vim.cmd.colorscheme(saved_cs)
end

vim.api.nvim_create_autocmd("ColorScheme", {
	desc = "Save selected colorscheme to stdpath('data') after loading a colorscheme",
	group = vim.api.nvim_create_augroup("colorscheme-save", { clear = true }),
	callback = function()
		local plugin_name = nil
		for _, plugin in pairs(require("lazy").plugins()) do
			local colorscheme_dir = plugin.dir .. "/colors/" .. vim.g.colors_name
			if
				vim.fn.filereadable(colorscheme_dir .. ".vim") == 1
				or vim.fn.filereadable(colorscheme_dir .. ".lua") == 1
			then
				plugin_name = plugin.name
				break
			end
		end

		local data = {
			vim.g.colors_name,
		}
		if plugin_name then
			table.insert(data, plugin_name)
		end
		vim.fn.writefile(data, vim.fn.stdpath("data") .. "/colorscheme")
	end,
})

return specs
