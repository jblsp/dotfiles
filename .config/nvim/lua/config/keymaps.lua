local f = require("util.functions")

-- escape removes search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- make navigation center cursor
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")
vim.keymap.set({ "n", "v" }, "<C-f>", "<C-f>zz")
vim.keymap.set({ "n", "v" }, "<C-b>", "<C-b>zz")

-- buffers
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete current buffer and window" })
vim.keymap.set("n", "<leader>bd", f.bufremove, { desc = "Delete current buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- write file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Write File" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
