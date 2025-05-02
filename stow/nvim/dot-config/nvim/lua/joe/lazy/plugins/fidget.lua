return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  version = "*",
  opts = {
    progress = {
      display = {
        done_icon = "󰸞",
        done_ttl = 5,
      },
    },
    notification = {
      poll_rate = 50,
      override_vim_notify = true,
      window = {
        winblend = 45,
      },
    },
  },
}
