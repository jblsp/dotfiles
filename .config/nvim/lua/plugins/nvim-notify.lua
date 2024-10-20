return {
	"rcarriga/nvim-notify",
	version = "*",
	config = function()
		local notify = require("notify")
		notify.setup({
			render = "wrapped-compact",
			stages = "static",
		})
		vim.notify = notify

		-- https://github.com/rcarriga/nvim-notify/wiki/Usage-Recipes#lsp-status-updates
		-- LSP integration
		local helper = require("util.lsp-dap-notif-helper")
		vim.lsp.handlers["$/progress"] = function(_, result, ctx)
			local client_id = ctx.client_id

			local val = result.value

			if not val.kind then
				return
			end

			local notif_data = helper.get_notif_data(client_id, result.token)

			if val.kind == "begin" then
				local message = helper.format_message(val.message, val.percentage)

				notif_data.notification = vim.notify(message, "info", {
					title = helper.format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
					icon = helper.spinner_frames[1],
					timeout = false,
					hide_from_history = false,
				})

				notif_data.spinner = 1
				helper.update_spinner(client_id, result.token)
			elseif val.kind == "report" and notif_data then
				notif_data.notification = vim.notify(helper.format_message(val.message, val.percentage), "info", {
					replace = notif_data.notification,
					hide_from_history = false,
				})
			elseif val.kind == "end" and notif_data then
				notif_data.notification =
					vim.notify(val.message and helper.format_message(val.message) or "Complete", "info", {
						icon = "",
						replace = notif_data.notification,
						timeout = 3000,
					})

				notif_data.spinner = nil
			end
		end

		local severity = {
			"error",
			"warn",
			"info",
			"info", -- map both hint and info to info?
		}
		vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
			vim.notify(method.message, severity[params.type])
		end
	end,
}
