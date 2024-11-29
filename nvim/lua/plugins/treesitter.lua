-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"go",
		"lua",
		"python",
		"rust",
		"typescript",
		"regex",
		"bash",
		"markdown",
		"markdown_inline",
		"kdl",
		"sql",
		"org",
		"terraform",
		"html",
		"css",
		"javascript",
		"yaml",
		"json",
		"toml",
	},

	highlight = { enable = true },
	indent = { enable = true },
})
