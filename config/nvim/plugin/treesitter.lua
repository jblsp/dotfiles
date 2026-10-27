vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting and folds",
  callback = function(ev)
    local buf, filetype = ev.buf, ev.match

    local lang = vim.treesitter.language.get_lang(filetype)
    if not lang then
      return
    end

    if not vim.treesitter.language.add(lang) then
      return
    end

    -- Highlighting
    vim.treesitter.start(buf, lang)

    -- Foldexpr
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
})
