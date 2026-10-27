return function()
  local conform = require("conform")

  local map = vim.keymap.set

  vim.o.formatexpr = [[v:lua.require'conform'.formatexpr()]]

  map("n", "<leader>f", function()
    conform.format()
    vim.cmd.w()
  end, { desc = "Format and write buffer" })
  map("n", "<leader>F", conform.format, { desc = "Format buffer" })

  -- manually set filetype for some filetypes on shfmt
  conform.formatters.shfmt = {
    append_args = function(self, ctx)
      local lang = "auto"
      if vim.bo[ctx.buf].filetype == "bash" then
        lang = "bash"
      elseif vim.bo[ctx.buf].filetype == "zsh" then
        lang = "zsh"
      end
      return { "-ln", lang }
    end,
  }

  conform.formatters.stylua = {
    prepend_args = function(_, ctx)
      local config = vim.fs.find({ "stylua.toml", ".stylua.toml" }, { upward = true, path = ctx.filename })[1]
      if config then
        return {}
      end
      return {
        "--config-path",
        vim.fn.expand("~/.config/nvim/stylua.toml"),
      }
    end,
  }

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
      nix = { "nixfmt" },
      -- php = { "php_cs_fixer" },
      python = { "black", "isort" },
      toml = { "tombi" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
      zsh = { "shfmt" },
    },
  })
end
