return {
  "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")

    local all_parsers = treesitter.get_available()

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match)
        local parsers = treesitter.get_installed()
        if not vim.list_contains(parsers, lang) and vim.list_contains(all_parsers, lang) then
          if vim.list_contains(all_parsers, lang) then
            -- :wait makes it synchronous so plugin/treesitter.lua runs after the parser is installed
            treesitter.install(lang):wait(1000 * 60 * 5)
          end
        end
        if lang ~= nil and vim.treesitter.query.get(lang, "indents") then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
