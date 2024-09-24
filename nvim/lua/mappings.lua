require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-P>", "<cmd> Telescope find_files <CR>", { desc = "find all"})
map("n", "<C-F>", "<cmd> Telescope live_grep <CR>", { desc = "live grep"})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
