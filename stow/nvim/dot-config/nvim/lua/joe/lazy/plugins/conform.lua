return {
  "stevearc/conform.nvim",
  version = "*",
  cmd = { "ConformInfo" },
  init = function()
    vim.opt.formatexpr = [[v:lua.require'conform'.formatexpr()]]
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format()
        vim.cmd("w")
      end,
      desc = "Format and write buffer",
    },
    {
      "<leader>F",
      function()
        require("conform").format()
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      cs = { lsp_format = "fallback" },
      css = { "prettier" },
      bash = { lsp_format = "fallback" },
      html = { "prettier" },
      java = { lsp_format = "fallback" },
      javascript = { "prettier" },
      json = { "prettier" },
      jsonc = { lsp_format = "fallback" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "alejandra" },
      python = { "black", "isort" },
      typescript = { "prettier" },
      go = { "gofmt" },
    },
    notify_on_error = true,
    notify_no_formatters = true,
    default_format_opts = {
      lsp_format = "never",
      async = true,
    },
  },
}
