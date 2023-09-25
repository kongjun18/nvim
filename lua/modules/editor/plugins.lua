local config = require("modules.editor.config")
local editor = {
  ["folke/which-key.nvim"] = {
    event = "VeryLazy",
    opts = {
      key_labels = {
        ["<Space>"] = "SPC",
        ["Cr>"] = "RET",
        ["<Tab>"] = "TAB",
      },
    },
  },
  ["lambdalisue/suda.vim"] = {
    event = "VeryLazy",
  },
  ["andymass/vim-matchup"] = {
    config = config.matchup,
    event = "VeryLazy",
  },
  ["ethanholz/nvim-lastplace"] = {
    config = config.nvim_lastplace,
    event = "BufReadPost",
  },
  ["tommcdo/vim-exchange"] = {
    event = "VeryLazy",
  },
  ["rmagatti/auto-session"] = {
    config = config.auto_session,
    event = "VeryLazy",
  },
  ["echasnovski/mini.ai"] = {
    event = "VeryLazy",
    config = config.mini_ai,
  },
  ["skywind3000/vim-terminal-help"] = {},
  ["tpope/vim-rsi"] = {
    event = "VeryLazy",
  },
  ["kylechui/nvim-surround"] = {
    config = config.nvim_surround,
    event = "VeryLazy",
  },
  ["tpope/vim-projectionist"] = {
    init = config.projectionist,
    event = "VeryLazy",
  },
  ["yianwillis/vimcdoc"] = {},
  ["milisims/nvim-luaref"] = {},
  ["lfv89/vim-interestingwords"] = {
    event = "VeryLazy",
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
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  ["tpope/vim-sleuth"] = {
    event = "VeryLazy",
  },
  ["junegunn/vim-easy-align"] = {
    event = "VeryLazy",
  },
  ["h-hg/fcitx.nvim"] = {
    event = "VeryLazy",
  },
  ["folke/todo-comments.nvim"] = {
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    config = config.todo_comments,
  },
  ["windwp/nvim-autopairs"] = {
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = config.autopairs,
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    config = config.treesitter,
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    dependencies = { "nvim-treesitter" },
  },
  ["preservim/nerdcommenter"] = {
    init = config.nerdcommenter,
    event = "VeryLazy",
  },
  ["ludovicchabant/vim-gutentags"] = {
    config = config.gutentags,
    event = { "BufReadPost", "CmdlineEnter" },
  },
  ["skywind3000/asyncrun.vim"] = {
    event = "VeryLazy",
  },
  ["skywind3000/asynctasks.vim"] = {
    dependencies = "asyncrun.vim",
    config = config.asynctasks,
  },
  ["ahmedkhalf/project.nvim"] = {
    config = config.project,
    event = { "VeryLazy", "CmdlineEnter" },
  },
  ["nvim-telescope/telescope.nvim"] = {
    event = "CmdlineEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
      { "nvim-tree/nvim-web-devicons" },
      {
        "GustavoKatel/telescope-asynctasks.nvim",
        dependencies = {
          "nvim-lua/popup.nvim",
          "skywind3000/asynctasks.vim",
        },
      },
      {
        "nvim-telescope/telescope-fzy-native.nvim",
      },
    },
    config = config.telescope,
  },
  ["danymat/neogen"] = {
    config = config.neogen,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  ["ojroques/vim-oscyank"] = {
    event = "VeryLazy",
  },
  ["dstein64/vim-startuptime"] = {
    event = "VeryLazy",
  },
  ["ray-x/web-tools.nvim"] = {
    config = config.web_tools,
    event = "CmdlineEnter",
    -- Comment this line to avoid error on first startup.
    -- build = "npm install -g browser-sync",
  },
  ["kongjun18/any-jump.vim"] = {
    event = "CmdlineEnter",
    init = function()
      vim.g.any_jump_disable_default_keybindings = 1
    end,
  },
  ["wakatime/vim-wakatime"] = {
    event = "VeryLazy",
  },
}

return editor
