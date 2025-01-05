return {
  "neovim/nvim-lspconfig",
  version = "*",
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      version = "*",
    },
  },
  config = function()
    local capabilities = util.lsp_capabilities.get()

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
      pyright = {},
    }

    for server, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
      require("lspconfig")[server].setup(config)
    end
  end,
}
