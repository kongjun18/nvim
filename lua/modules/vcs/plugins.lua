local config = require("modules.vcs.config")

local vcs = {
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
  ["TimUntersberger/neogit"] = {
    requires = "nvim-lua/plenary.nvim",
    config = config.neogit,
    cmd = "Neogit",
  },
  ["ruifm/gitlinker.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
  },
  ["lewis6991/gitsigns.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    config = config.gitsigns,
    event = { "BufReadPost", "BufNewFile" },
  },
}

return vcs
