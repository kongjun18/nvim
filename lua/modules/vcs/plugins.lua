local config = require("modules.vcs.config")

local vcs = {
  ["tpope/vim-fugitive"] = {
    event = "VeryLazy",
  },
  ["tpope/vim-rhubarb"] = {
    dependencies = { "vim-fugitive" },
  },
  ["shumphrey/fugitive-gitlab.vim"] = {
    dependencies = { "vim-fugitive" },
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
