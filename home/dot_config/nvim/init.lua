local bufdelete = require("joe.bufdelete")
local clipboard = require("joe.clipboard")
-- local extui = require("vim._extui")
local lazy = require("joe.lazy")
local sudowrite = require("joe.sudowrite")
local util = require("joe.util")

local g = vim.g
local k = vim.keycode
local lsp = vim.lsp
local set = vim.keymap.set
local o = vim.o
local filetype = vim.filetype

-- Globals
g.colors_name = "tokyonight"
g.mapleader = k("<space>")
g.maplocalleader = k("\\")
g.lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Options
o.confirm = true -- Confirm to save changes when exiting modified buffer
o.cursorline = true -- Highlight current line
o.cursorlineopt = "number" -- Only highlight number of current line
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
-- o.showmode = true
-- o.showtabline = 2
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
  "bashls",
  "clangd",
  "gdscript",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "nixd",
  "phpactor",
  "pyright",
  "ts_ls",
  "yamlls",
  "tinymist",
  "tombi",
  -- "copilot",
  -- "templ",
})

-- extui
-- extui.enable({})

-- Optional plugins
-- vim.cmd([[packadd nvim.undotree]])

-- Commands:

vim.api.nvim_create_user_command("Sudowrite", sudowrite.write, { desc = "Write buffer as sudo" })

-- Keymaps:

-- escape removes search highlights, and stops snippets
set("n", "<Esc>", function()
  vim.cmd("noh")
  vim.snippet.stop()
  return "<esc>"
end)

-- buffers
set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
set("n", "<leader>bl", "<cmd>b#<cr>", { desc = "Last buffer" })
set("n", "<leader>bD", "<cmd>bd<cr>", { desc = "Delete buffer and close window" })
set("n", "<leader>bW", "<cmd>bw<cr>", { desc = "Wipeout buffer and close window" })
set("n", "<leader>bd", bufdelete.delete, { desc = "Delete buffer" })
set("n", "<leader>bw", function()
  bufdelete.delete({ wipe = true })
end, { desc = "Wipeout buffer" })
set("n", "<leader>bo", bufdelete.other, { desc = "Delete all other buffers" })
set("n", "<leader>bO", function()
  bufdelete.other({ wipe = true })
end, { desc = "Wipeout all other buffers" })

-- tabs
set("n", "[t", "<cmd>tabprev<cr>", { desc = "Previous tab" })
set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close tab" })
set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })

-- Clipboard
set("n", "<leader>cc", clipboard.anon_to_clip, { desc = 'Copy anon register (") to system clipboard' })
set({ "n", "x" }, "<leader>cy", '"+y', { desc = "Yank to system clipboard" })
set("n", "<leader>cp", '"+p', { desc = "Paste from system clipboard" })
set("x", "<leader>cp", '"+P', { desc = "Paste from system clipboard" })

-- Comments
set("n", "gcn", "yygccp", { remap = true, desc = "Duplicate line and comment out original" })
set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Terminal mappings
set("t", "<esc><esc>", "<c-\\><c-n>")

-- Open explorer
set("n", "<leader>e", function()
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open()
    return
  end
  vim.cmd.edit(".")
end, { desc = "Explore directory of current buffer", silent = true })
set("n", "<leader>E", "<cmd>e .<cr>", { desc = "Explore current working directory" })

-- Quickfix List
set("n", "<leader>qd", function()
  if #vim.diagnostic.count() == 0 and not util.qf_window_open() then
    vim.notify("No diagnostics to report", vim.log.levels.INFO)
  end
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Open workspace diagnostics in quickfix list" })

-- Undotree
set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Toggle Undotree" })

-- Filetypes
vim.filetype.add({
  pattern = {
    [".*"] = function(_, bufnr)
      local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
      if not first then
        return
      end

      local shell = first:match("^#!.*/env%s+(%S+)") or first:match("^#!.*/(%S+)")
      if shell == "bash" or shell == "zsh" or shell == "sh" then
        return shell
      end
    end,
  },
})

-- Load plugins
if not lazy.is_installed() then
  lazy.install()
end
lazy.setup()
