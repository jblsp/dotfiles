return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	dependencies = {
		{ "echasnovski/mini.icons", version = "*" },
		"nvim-tree/nvim-web-devicons",
	},
}
