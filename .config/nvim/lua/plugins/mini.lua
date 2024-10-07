return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup()
		require("mini.statusline").setup()
	end,
	dependencies = {
		{ "echasnovski/mini.icons", version = "*" },
		{ "echasnovski/mini-git", version = "*" },
		{ "echasnovski/mini.diff", version = "*" },
	},
}
