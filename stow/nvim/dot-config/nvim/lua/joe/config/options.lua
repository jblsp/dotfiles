local o = vim.o
local g = vim.g
local lsp = vim.lsp

-- Globals
g.startup_colors = "ayu-dark"
g.mapleader = vim.keycode("<space>")
g.maplocalleader = vim.keycode("\\")

-- Options
o.confirm = true -- Confirm to save changes when exiting modified buffer
o.cursorline = true -- Highlight current line
o.cursorlineopt = "number" -- Only highlight number of current line
o.foldexpr = "v:lua.require'joe.fold'.foldexpr()"
o.foldlevel = 99
o.foldmethod = "expr"
o.ignorecase = true -- Case-insensitive searching
o.inccommand = "split"
o.infercase = true
-- o.laststatus = 3 -- Global status line
o.linebreak = true
o.mouse = "a"
o.mousemodel = "extend"
o.number = true -- Line numbers
o.relativenumber = true
o.scrolloff = 8
-- o.shortmess = o.shortmess .. "I" -- Disable startup message
o.signcolumn = "yes" -- Always enable sign column
o.smartcase = true -- Case sensitive searching if \C or one or more capital letters in search
o.smartindent = true
o.smoothscroll = true -- scroll by screen line rather than by text line when 'wrap' is set
o.spelllang = "en"
o.undofile = true -- Save undo history for files
o.undolevels = 2500
o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
o.wrap = false

-- LSP
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
