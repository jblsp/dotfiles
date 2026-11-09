local clipboard = require("joe.clipboard")
local extui = require("vim._core.ui2")

local packhandler = require("joe.packhandler")
local sudowrite = require("joe.sudowrite")
local util = require("joe.util")

local g = vim.g
local k = vim.keycode
local lsp = vim.lsp
local set = vim.keymap.set
local o = vim.o

-- Globals
g.colors_name = "tokyonight"
g.have_nerd_font = not vim.env.TERM == "linux"
g.mapleader = k("<space>")
g.maplocalleader = k("\\")

-- Options
o.confirm = true -- Confirm to save changes when exiting modified buffer
o.cursorline = true -- Highlight current line
o.cursorlineopt = "number" -- Only highlight number of current line
o.exrc = true
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
  "nixd",
  "phpactor",
  "pyright",
  "sourcekit", -- swift/objc
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

-- Optional built-in plugins
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
set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer and close window" })
set("n", "<leader>bw", "<cmd>bw<cr>", { desc = "Wipeout buffer and close window" })
set("n", "<leader>br", "<cmd>e!<cr>", { desc = "Reload buffer" })

-- tabs
set("n", "[t", "<cmd>tabprev<cr>", { desc = "Previous tab" })
set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close tab" })
set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })

-- Clipboard
set("n", "<leader>cc", function()
  clipboard.copy(vim.fn.getreg('"'))
end, { desc = 'Copy anon register (") to system clipboard' })
set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
set("n", "<leader>cf", function()
  clipboard.copy(vim.fn.expand("%"))
end, { desc = "Copy filepath to system clipboard" })

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
  -- oil nvim
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open()
    return
  end

  -- open without plugin explorer
  local path = vim.api.nvim_buf_get_name(0)
  local dir
  if path ~= "" and vim.uv.fs_stat(path) then
    dir = vim.fs.dirname(path)
  else
    dir = vim.fn.getcwd()
  end
  vim.cmd.edit(dir)
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
packhandler.setup({
  { "cb:mfussenegger/nvim-jdtls" },
  { "gh:alker0/chezmoi.vim" },
  { "gh:folke/tokyonight.nvim" },
  { "gh:folke/which-key.nvim" },
  { "gh:ibhagwan/fzf-lua" },
  { "gh:j-hui/fidget.nvim", ver = "*" },
  { "gh:lewis6991/gitsigns.nvim", ver = "*" },
  -- { "gh:mason-org/mason.nvim", enabled = not vim.tbl_contains({ "nixos" }, util.get_os_identifier()) },
  { "gh:neovim/nvim-lspconfig", ver = "*" },
  { "gh:nvim-mini/mini.ai", ver = "*", call_setup = true },
  { "gh:nvim-mini/mini.icons", call_setup = true },
  { "gh:nvim-mini/mini.move", ver = "*", call_setup = true },
  { "gh:nvim-mini/mini.splitjoin", ver = "*", call_setup = true },
  { "gh:nvim-mini/mini.surround", ver = "*" },
  { "gh:nvim-treesitter/nvim-treesitter" },
  { "gh:nvim-treesitter/nvim-treesitter-context" },
  { "gh:rafamadriz/friendly-snippets" },
  { "gh:saghen/blink.cmp", ver = "1.*" },
  { "gh:saghen/blink.indent", ver = "2.*" },
  { "gh:stevearc/conform.nvim" },
  { "gh:stevearc/oil.nvim", ver = "*" },
  { "gh:stevearc/quicker.nvim", call_setup = true },
  { "gh:tpope/vim-endwise" },
})
