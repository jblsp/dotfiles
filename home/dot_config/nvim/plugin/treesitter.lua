local function get_installed()
  local parser_paths = vim.api.nvim_get_runtime_file("parser/*.so", true)
  return vim
    .iter(parser_paths)
    :map(function(ppath)
      return vim.fs.basename(ppath):sub(1, -4)
    end)
    :totable()
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(event.match)
    if lang == nil or not vim.list_contains(get_installed(), lang) then
      return
    end

    -- Highlighting
    if vim.treesitter.query.get(lang, "highlights") then
      pcall(vim.treesitter.start, event.buf, lang)
    end

    -- Foldexpr
    if vim.treesitter.query.get(lang, "folds") then
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
    end
  end,
})
