return function()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "●",
        package_uninstalled = "○",
      },
    },
  })
end
