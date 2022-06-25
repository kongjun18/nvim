local config = require("modules.vcs.config")

local vcs = {
  ["tpope/vim-fugitive"] = {
    event = "CmdlineEnter",
  },
  ["tpope/vim-rhubarb"] = {
    after = "vim-fugitive",
  },
  ["shumphrey/fugitive-gitlab.vim"] = {
    after = "vim-fugitive",
  },
  ["tpope/vim-git"] = {},
  ["junegunn/gv.vim"] = {
    requires = "tpope/vim-fugitive",
    cmd = { "GV", "GV!", "GV?" },
  },
  ["akinsho/git-conflict.nvim"] = {
    event = "BufReadPost",
    config = config.git_conflict,
  },
  ["sindrets/diffview.nvim"] = {
    cmd = {
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewRefresh",
      "DiffviewFocusFile",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
    },
  },
  ["lewis6991/gitsigns.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = config.gitsigns,
    event = { "BufReadPost", "BufNewFile" },
  },
}

return vcs
