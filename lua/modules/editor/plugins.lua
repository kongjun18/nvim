-- TODO: database support: tpope/vim-dadbod
-- TODO: doc comment support: vim-doge
-- TODO: substitue fcitx.vim with fcitx.nvim
local config = require("modules.editor.config")
local editor = {
  ["tpope/vim-unimpaired"] = {
    event = { "BufReadPost", "BufNewFile" },
    ft = "qf",
  },
  ["lambdalisue/suda.vim"] = {
    cmd = { "SudaRead", "SudaWrite" },
  },
  ["nathom/filetype.nvim"] = {},
  ["bronson/vim-visual-star-search"] = {
    keys = { "*", "#" },
  },
  ["andymass/vim-matchup"] = {
    config = config.matchup,
    event = "BufReadPost",
  },
  ["farmergreg/vim-lastplace"] = {
    event = "BufReadPost",
  },
  ["tommcdo/vim-exchange"] = {
    event = "BufReadPost",
  },
  ["rmagatti/auto-session"] = {
    config = config.auto_session,
    cmd = { "SaveSession", "RestoreSession", "DeleteSession" },
  },
  ["wellle/targets.vim"] = {
    event = "BufReadPost",
  },
  ["skywind3000/vim-terminal-help"] = {
    cmd = { "H", "TerminalToggle" },
  },
  ["tpope/vim-rsi"] = {
    event = "CmdlineEnter",
  },
  ["machakann/vim-sandwich"] = {
    -- Disable sandwich.vim keymaps and use surround.vim keymaps
    setup = function()
      vim.g.sandwich_no_default_key_mappings = 1
      vim.g.operator_sandwich_no_default_key_mappings = 1
      vim.g.textobj_sandwich_no_default_key_mappings = 1
    end,
    config = config.sandwich,
    event = "BufReadPost",
  },
  ["tpope/vim-projectionist"] = {
    setup = config.projectionist,
    event = "CmdlineEnter",
  },
  ["tpope/vim-repeat"] = {
    event = "BufReadPost",
  },
  ["yianwillis/vimcdoc"] = {},
  ["milisims/nvim-luaref"] = {},
  ["lfv89/vim-interestingwords"] = {
    keys = { "<Leader>k", "<leader>K" },
  },
  ["windwp/nvim-ts-autotag"] = {
    ft = {
      "html",
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "php",
    },
    config = config.ts_autotag,
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
    event = "InsertEnter",
  },
  ["tpope/vim-sleuth"] = {
    event = "BufReadPost",
  },
  ["gpanders/editorconfig.nvim"] = {
    event = "BufReadPost",
  },
  ["junegunn/vim-easy-align"] = {
    cmd = "EasyAlign",
  },
  ["lilydjwg/fcitx.vim"] = {
    event = "InsertEnter",
  },
  ["folke/todo-comments.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = config.todo_comments,
    cmd = { "TodoQuickFix", "TodoLocList", "TodoTrouble", "TodoTelescope" },
  },
  ["windwp/nvim-autopairs"] = {
    requires = "hrsh7th/nvim-cmp",
    config = config.autopairs,
    after = "nvim-cmp",
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    config = config.treesitter,
    event = { "BufReadPost", "BufNewFile" },
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
    event = "BufReadPost",
  },
  ["ludovicchabant/vim-gutentags"] = {
    config = config.gutentags,
    event = "BufReadPost",
  },
  ["skywind3000/gutentags_plus"] = {
    requires = "vim-gutentags",
    after = "vim-gutentags",
  },
  ["skywind3000/asyncrun.vim"] = {
    event = "CmdlineEnter",
  },
  ["skywind3000/asynctasks.vim"] = {
    requires = "asyncrun.vim",
    event = "CmdlineEnter",
    config = config.asynctasks,
  },
  ["nvim-telescope/telescope.nvim"] = {
    requires = {
      "nvim-lua/plenary.nvim",
      { "kyazdani42/nvim-web-devicons", opt = true },
      {
        "GustavoKatel/telescope-asynctasks.nvim",
        requires = {
          "nvim-lua/popup.nvim",
          "skywind3000/asynctasks.vim",
        },
        after = "telescope.nvim",
      },
      {
        "https://gitee.com/kongjun18/telescope-fzy-native.nvim",
        after = "telescope.nvim",
      },
      {
        "ahmedkhalf/project.nvim",
        config = config.project,
      },
    },
    config = config.telescope,
    event = "CmdlineEnter",
  },
  ["danymat/neogen"] = {
    config = config.neogen,
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
  },
  ["romainl/vim-qf"] = {
    ft = "qf",
  },
  ["ojroques/vim-oscyank"] = {
    cmd = "OSCYank",
  },
  ["ygm2/rooter.nvim"] = {
    event = "BufReadPost",
    setup = function()
      vim.g.outermost_root = false
    end,
  },
  ["dstein64/vim-startuptime"] = {
    cmd = "StartupTime",
  },
}

return editor
