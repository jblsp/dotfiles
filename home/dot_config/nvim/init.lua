local bufdelete = require("joe.bufdelete")
local clipboard = require("joe.clipboard")
local extui = require("vim._core.ui2")
local plugins = require("joe.plugins")
local sudowrite = require("joe.sudowrite")
local util = require("joe.util")

local g = vim.g
local k = vim.keycode
local lsp = vim.lsp
local set = vim.keymap.set
local o = vim.o

-- Globals
g.colors_name = "tokyonight"
g.mapleader = k("<space>")
g.maplocalleader = k("\\")

-- Options
o.confirm = true -- Confirm to save changes when exiting modified buffer
o.cursorline = true -- Highlight current line
o.cursorlineopt = "number" -- Only highlight number of current line
o.foldlevel = 99
o.ignorecase = true -- Case-insensitive searching
o.linebreak = true
o.mouse = "a"
o.mousemodel = "extend"
o.number = true -- Line numbers
o.relativenumber = true
o.scrolloff = 8
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
lsp.enable({
  "bashls",
  "clangd",
  "cssls",
  "gdscript",
  "gopls",
  "html",
  "jdtls",
  "json",
  "jsonls",
  "lua_ls",
  "phpactor",
  "pyright",
  "tinymist",
  "tombi",
  "ts_ls",
  "yamlls",
})
lsp.config("*", {
  root_markers = { ".git" },
})
lsp.config("jdtls", {
  settings = {
    java = {
      saveActions = { organizeImports = true },
    },
  },
})

-- extui
extui.enable({})

-- Optional plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.tohtml")

-- Commands:
vim.api.nvim_create_user_command("Sudowrite", sudowrite.write, { desc = "Write buffer as sudo" })

vim.api.nvim_create_user_command("PackUpdate", function(args)
  if args.args == "" then
    vim.pack.update()
  else
    vim.pack.update(vim.split(args.args, " "))
  end
end, { desc = "Update vim.pack plugin(s)" })

vim.api.nvim_create_user_command("PackList", function()
  vim.pack.update(nil, { offline = true })
end, { desc = "List installed vim.pack plugins" })

vim.api.nvim_create_user_command("PackSync", function(args)
  if args.args == "" then
    vim.pack.update(nil, { target = "lockfile" })
  else
    vim.pack.update(vim.split(args.args, " "), { target = "lockfile" })
  end
end, { desc = "Sync vim.pack plugins to lockfile" })

vim.api.nvim_create_user_command("PackClean", function()
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  vim.pack.del(inactive)
end, { desc = "Delete inactive vim.pack plugins" })

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
set("n", "<leader>br", "<cmd>e!<cr>", { desc = "Reload buffer" })

-- tabs
set("n", "[t", "<cmd>tabprev<cr>", { desc = "Previous tab" })
set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close tab" })
set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })

-- Clipboard
set("n", "<leader>cc", clipboard.anon_to_clip, { desc = 'Copy anon register (") to system clipboard' })
set({ "n", "x" }, "<leader>cy", '"+y', { desc = "Yank to system clipboard" })

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

-- Load Plugins
plugins.load(vim.tbl_map(require, util.lsmod("plugins")))
