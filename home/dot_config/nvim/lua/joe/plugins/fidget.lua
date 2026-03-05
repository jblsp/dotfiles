return {
  "j-hui/fidget.nvim",
  version = "*",
  config = function()
    local fidget = require("fidget")
    local notification = require("fidget.notification")

    fidget.setup({
      progress = {
        display = {
          done_icon = "󰸞",
          done_ttl = 5,
        },
      },
      notification = {
        override_vim_notify = true,
        window = {
          winblend = 45,
          -- y_padding = 1,
        },
        configs = {
          default = (function()
            local notif_config = notification.default_config

            -- Remove title from notifications
            notif_config.name = nil
            notif_config.icon = nil

            return vim.tbl_extend("force", notif_config, { ttl = 7.5 })
          end)(),
        },
      },
    })
  end,
}
