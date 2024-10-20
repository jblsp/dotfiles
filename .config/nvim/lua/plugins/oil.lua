return {
	"stevearc/oil.nvim",
	version = "*",
	dependencies = {
		{ "echasnovski/mini.icons", version = "*", opts = {} },
	},
	config = function()
		local oil = require("oil")
		oil.setup({
			win_options = {
				signcolumn = "yes",
			},
			delete_to_trash = true,
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
			float = {
				border = "none",
			},
		})

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { desc = "Oil: " .. desc })
		end

		map("<leader>eO", oil.open_float, "Open parent of current buffer")
		map("<leader>eo", function()
			oil.open_float(vim.fn.getcwd())
		end, "Open current working directory")
		map("<leader>oh", oil.toggle_hidden, "Toggle hidden files and directories")
	end,
}
