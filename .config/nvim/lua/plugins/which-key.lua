return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Show local keymaps",
			mode = { "n", "v" },
		},
	},
	config = function()
		require("which-key").setup({
			preset = "helix",
			icons = { mappings = false },
		})

		require("which-key").add({
			{ "<leader>l", group = "LSP" },
			{ "<leader>s", group = "Search" },
			{ "<leader>t", group = "Tools" },
			{ "<leader>o", group = "Options" },
			{ "<leader>e", group = "Explorer" },
			{ "<leader>b", group = "Buffers" },
			{ "<leader>p", group = "Sessions" },
		})
	end,
}
