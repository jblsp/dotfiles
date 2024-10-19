vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	desc = 'Remove "How to disable mouse" tip from context menu',
	group = vim.api.nvim_create_augroup("remove-disable-mouse-tip", { clear = true }),
	callback = function()
		vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
		vim.cmd([[aunmenu PopUp.-1-]])
	end,
})
