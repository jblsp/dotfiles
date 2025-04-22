local lsp = vim.lsp

lsp.config("*", {
  root_markers = { ".git" },
})
lsp.enable({
  "pyright",
  "bashls",
  "clangd",
  "lua_ls",
  "marksman",
  "nixd",
  "ts_ls",
  "jsonls",
  "yamlls",
})
