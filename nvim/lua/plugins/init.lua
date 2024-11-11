return {
  {
    "NvChad/nvterm",
    enabled = false
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  --
  {
    "aserowy/tmux.nvim",
    lazy = false,
    config = function()
      require("tmux").setup()
    end,
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require "plugins.configs.lspconfig"
  --     require "custom.configs.lspconfig"
  --   end,
  -- },

  {
    "crispgm/nvim-go",
    ft = "go",
    config = function()
      require("go").setup {}
    end,
  },

  -- {
  --   "dhruvasagar/vim-table-mode",
  --   ft = "md",
  -- },
  --
  -- {
  --   "google/vim-jsonnet",
  --   ft = "jsonnet",
  -- },
}

