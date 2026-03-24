return {
  "mason-org/mason.nvim",
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "●",
          package_uninstalled = "○",
        },
      },
    })

    local mason_api = require("mason.api.command")
    local mason_registry = require("mason-registry")

    local ensure_installed = {
      "bash-language-server",
      "black",
      "clang-format",
      "css-lsp",
      "gdscript-formatter",
      "gopls",
      "html-lsp",
      "isort",
      "jdtls",
      "json-lsp",
      "lua-language-server",
      "marksman",
      "prettier",
      "pyright",
      "shfmt",
      "stylua",
      "tinymist",
      "tombi",
      "typescript-language-server",
      "yaml-language-server",
    }

    vim.schedule(function()
      local pkg_set = {}
      for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
        pkg_set[pkg] = true
      end

      local to_install = vim.tbl_filter(function(pkg)
        return not pkg_set[pkg]
      end, ensure_installed)

      if #to_install ~= 0 then
        mason_api.MasonInstall(to_install)
      end
    end)
  end,
}
