return {
  src = "gh:stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    local map = vim.keymap.set

    vim.o.formatexpr = [[v:lua.require'conform'.formatexpr()]]

    map("n", "<leader>f", function()
      conform.format()
      vim.cmd.w()
    end, { desc = "Format and write buffer" })
    map("n", "<leader>F", conform.format, { desc = "Format buffer" })

    conform.setup({
      notify_on_error = true,
      notify_no_formatters = true,
      default_format_opts = {
        lsp_format = "never",
        async = true,
      },
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cs = { lsp_format = "fallback" },
        css = { "prettier" },
        gdscript = { "gdscript-formatter" },
        go = { "gofmt" },
        html = { "prettier" },
        java = { lsp_format = "fallback" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { lsp_format = "fallback" },
        lua = { "stylua" },
        markdown = { "prettier" },
        -- nix = { "alejandra" },
        -- php = { "php_cs_fixer" },
        python = { "black", "isort" },
        toml = { "tombi" },
        typescript = { "prettier" },
        yaml = { "prettier" },
      },
    })
  end,
}
