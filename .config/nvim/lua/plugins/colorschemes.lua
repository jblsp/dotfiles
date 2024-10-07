initColorscheme = function()
	if vim.g.colors_name == nil then
		vim.cmd.colorscheme(vim.g.colorscheme)
	end
end

return {
	"folke/tokyonight.nvim",
	priority = 1000,
	opts = {},
	init = initColorscheme,
}
