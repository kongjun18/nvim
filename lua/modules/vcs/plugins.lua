local config = require("modules.vcs.config")

local vcs = {
    ["TimUntersberger/neogit"] = {
        requires =  {"nvim-lua/plenary.nvim", "sindrets/diffview.nvim"},
        config = config.neogit
    },
    ["ruifm/gitlinker.nvim"] = {
        requires = 'nvim-lua/plenary.nvim',
    },
    ["lewis6991/gitsigns.nvim"] = {
    }
}

return vcs
