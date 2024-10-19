return {
	"stevearc/oil.nvim",
	version = "*",
	opts = {
		view_options = {
			show_hidden = true,
		},
		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},
	},
	dependencies = {
		{ "echasnovski/mini.icons", version = "*", opts = {} },
	},
}
