return {
	-- file nav
	"preservim/nerdtree",

	-- git and tpope
	"tpope/vim-fugitive",
	"tpope/vim-commentary",
	"tpope/vim-unimpaired",

	-- formatting
	"stevearc/conform.nvim",

	-- themes
	"folke/tokyonight.nvim",
	{ "catppuccin/nvim", name = "catppuccin" },

	-- telescope
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	-- syntax highlight and status bar
	"nvim-lualine/lualine.nvim",
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"nvim-tree/nvim-web-devicons",
	"pangloss/vim-javascript",
	"jparise/vim-graphql",
	"rust-lang/rust.vim",

	"folke/trouble.nvim",
	"mileszs/ack.vim",

	-- autocomplete and LSP
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",

	-- snippets
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind.nvim",
}
