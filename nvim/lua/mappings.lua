require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-P>", "<cmd> Telescope find_files <CR>", { desc = "find all"})
map("n", "<C-F>", "<cmd> Telescope live_grep <CR>", { desc = "live grep"})

map("n", "<C-H>", "<cmd> lua require('tmux').move_left() <CR>", { desc = "move left"})
map("n", "<C-J>", "<cmd> lua require('tmux').move_bottom() <CR>", { desc = "move down"})
map("n", "<C-K>", "<cmd> lua require('tmux').move_top() <CR>", { desc = "move up"})
map("n", "<C-L>", "<cmd> lua require('tmux').move_right() <CR>", { desc = "move right"})

-- disable mappings
local nomap = vim.keymap.del

nomap("n", "<leader>h")
nomap("n", "<leader>v")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
