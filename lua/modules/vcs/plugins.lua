local config = require("modules.vcs.config")

local vcs = {
  ["tpope/vim-fugitive"] = {
    dependencies = {
      "kongjun18/yadm-git.vim",
      "tpope/vim-rhubarb",
      "shumphrey/fugitive-gitlab.vim",
    },
    event = "VeryLazy",
  },
  ["tpope/vim-git"] = {},
  ["junegunn/gv.vim"] = {
    dependencies = "tpope/vim-fugitive",
  },
  ["akinsho/git-conflict.nvim"] = {
    config = config.git_conflict,
    event = "VeryLazy",
  },
  ["sindrets/diffview.nvim"] = {
    event = "VeryLazy",
  },
  ["lewis6991/gitsigns.nvim"] = {
    dependencies = "nvim-lua/plenary.nvim",
    config = config.gitsigns,
    event = "VeryLazy",
  },
}

return vcs
