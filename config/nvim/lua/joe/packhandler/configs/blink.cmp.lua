return function()
  require("blink.cmp").setup({
    completion = {
      menu = { draw = { treesitter = { "lsp" } } },
    },
    cmdline = {
      keymap = {
        ["<Tab>"] = { "show", "accept" },
      },
      completion = { menu = { auto_show = true } },
    },
  })
end
