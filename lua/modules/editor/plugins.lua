-- TODO: database support: tpope/vim-dadbod
-- TODO: doc comment support: vim-doge
-- TODO: substitue vim-surround with vim-sandwich
-- TODO: substitue fcitx.vim with fcitx.nvim
local config = require("modules.editor.config")
local editor = {
	["rhysd/accelerated-jk"] = {
	},
	["hrsh7th/vim-eft"] = {
	},
	["bronson/vim-visual-star-search"] = {
	},
	["andymass/vim-matchup"] = {
		config = config.matchup,
	},
	["vim-utils/vim-man"] = {
	},
	["farmergreg/vim-lastplace"] = {},
	["tommcdo/vim-exchange"] = {
	},
	["rmagatti/auto-session"] = {
		config = config.auto_session,
	},
	["wellle/targets.vim"] = {
	},
	["skywind3000/vim-terminal-help"] = {
		cmd = {"H", "TerminalToggle"},
	},
	["tpope/vim-rsi"] = {},
	["tpope/vim-surround"] = {
	},
	["tpope/vim-projectionist"] = {
	},
	["tpope/vim-repeat"] = {
	},
	["tpope/vim-unimpaired"] = {
	},
	["yianwillis/vimcdoc"] = {},
	["lfv89/vim-interestingwords"] = {
	},
	["windwp/nvim-ts-autotag"] = {
		ft = { "html", "typescript", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue", "tsx", "php" },
		config = config.ts_autotag,
	},
	["tpope/vim-sleuth"] = {
	},
	["editorconfig/editorconfig-vim"] = {
		config = config.editorconfig,
	},
	["junegunn/vim-easy-align"] = {
	},
	["sbdchd/neoformat"] = {
		config = config.neoformat,
	},
	["lilydjwg/fcitx.vim"] = {
		event = "InsertEnter",
	},
	["folke/todo-comments.nvim"] = {
		requires = "nvim-lua/plenary.nvim",
		config = config.todo_comments,
	},
	["windwp/nvim-autopairs"] = {
		require = "hrsh7th/nvim-cmp",
		config = config.autopairs,
		after = "nvim-cmp",
	},
	["nvim-treesitter/nvim-treesitter"] = {
			config = config.treesitter,
	},
	["nvim-treesitter/nvim-treesitter-textobjects"] = {
		after = "nvim-treesitter",
	},
	["JoosepAlviste/nvim-ts-context-commentstring"] = {
		after = "nvim-treesitter",
	},
	["numToStr/Comment.nvim"] = {
		requires = "JoosepAlviste/nvim-ts-context-commentstring",
		config = config.comment,
	},
	["ludovicchabant/vim-gutentags"] = {
		requires = "skywind3000/gutentags_plus",
		config = config.gutentags,
	},
	["skywind3000/asynctasks.vim"] = {
		requires = "skywind3000/asyncrun.vim",
		config = config.asynctasks,
	},

	-- TODO: telescope-frecency.nvim and telescope-project.nvim
	["nvim-telescope/telescope.nvim"] = {
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzy-native.nvim",
		},
		config = config.telescope,
		after = "nvim-web-devicons",
	},
	["GustavoKatel/telescope-asynctasks.nvim"] = {
		requires = { "nvim-lua/popup.nvim", "skywind3000/asynctasks.vim" },
	},
	["danymat/neogen"] = {
		config = config.neogen,
		requires = "nvim-treesitter/nvim-treesitter",
	},
}

return editor
