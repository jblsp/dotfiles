return {
	"rcarriga/nvim-notify",
	version = "*",
	config = function()
		local notify = require("notify")
		notify.setup({
			render = "wrapped-compact",
			stages = "static",
			max_width = 48,
		})
		vim.notify = notify
	end,
}
