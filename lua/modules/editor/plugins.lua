-- TODO: database support: tpope/vim-dadbod
-- TODO: doc comment support: vim-doge
-- TODO: substitue fcitx.vim with fcitx.nvim
local config = require("modules.editor.config")
local editor = {
  ["kongjun18/vim-unimpaired"] = {
    event = { "BufReadPost", "BufNewFile" },
    ft = "qf",
  },
  ["lambdalisue/suda.vim"] = {
    cmd = { "SudaRead", "SudaWrite" },
  },
  ["bronson/vim-visual-star-search"] = {
    keys = { "*", "#" },
  },
  ["andymass/vim-matchup"] = {
    config = config.matchup,
    event = "BufReadPost",
  },
  ["ethanholz/nvim-lastplace"] = {
    event = "BufReadPost",
    config = config.nvim_lastplace,
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
  ["kylechui/nvim-surround"] = {
    config = config.nvim_surround,
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
  ["preservim/nerdcommenter"] = {
    event = "BufReadPost",
    setup = config.nerdcommenter,
  },
  ["ludovicchabant/vim-gutentags"] = {
    config = config.gutentags,
    event = "BufReadPost",
  },
  ["skywind3000/asyncrun.vim"] = {
    event = "CmdlineEnter",
  },
  ["skywind3000/asynctasks.vim"] = {
    requires = "asyncrun.vim",
    event = "CmdlineEnter",
    config = config.asynctasks,
  },
  ["ahmedkhalf/project.nvim"] = {
    event = "BufEnter",
    config = config.project,
  },
  ["nvim-telescope/telescope.nvim"] = {
    requires = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
      { "kyazdani42/nvim-web-devicons", opt = true },
      {
        "GustavoKatel/telescope-asynctasks.nvim",
        requires = {
          "nvim-lua/popup.nvim",
          "skywind3000/asynctasks.vim",
        },
        opt = true,
      },
      {
        "kongjun18/telescope-fzy-native.nvim",
        opt = true,
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
  ["ojroques/vim-oscyank"] = {
    cmd = "OSCYank",
  },
  ["dstein64/vim-startuptime"] = {
    cmd = "StartupTime",
  },
  ["ray-x/web-tools.nvim"] = {
    event = "CmdlineEnter",
    run = "npm install -g browser-sync",
  },
}

return editor
