return {
  src = "gh:nvim-treesitter/nvim-treesitter",
  before = function()
    vim.api.nvim_create_autocmd("PackChanged", {
      callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
          if not ev.data.active then
            vim.cmd.packadd("nvim-treesitter")
          end
          vim.cmd("TSUpdate")
        end
      end,
    })
  end,
  config = function()
    local treesitter = require("nvim-treesitter")

    local all_parsers = treesitter.get_available()

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match)
        local parsers = treesitter.get_installed()
        if not vim.list_contains(parsers, lang) and vim.list_contains(all_parsers, lang) then
          if vim.list_contains(all_parsers, lang) then
            -- :wait makes it synchronous so the autocmd in plugin/treesitter.lua runs after the parser is installed
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
