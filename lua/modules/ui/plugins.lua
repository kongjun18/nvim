-- TODO: support kristijanhusak/vim-dadbod-ui
local config = require("modules.ui.config")
local ui = {
    ["kyazdani42/nvim-tree.lua"] = {
        config = config.nvim_tree,
    },
    ["EdenEast/nightfox.nvim"] = {
        config = config.nightfox,
    },
    ["kyazdani42/nvim-web-devicons"] = {},
    ["arkav/lualine-lsp-progress"] = {},
    ["SmiteshP/nvim-gps"] = {
        config = config.gps
    },
    ["nvim-lualine/lualine.nvim"] = {
        config = config.lualine,
        after = {"nvim-web-devicons", "nvim-gps", "lualine-lsp-progress"}
    },
    ["romgrk/barbar.nvim"] = {
        config = config.barbar,
        after = "nvim-web-devicons"
    },
    ["jeffkreeftmeijer/vim-numbertoggle"] = {
    },
    ["camspiers/lens.vim"] = {
        requires = "camspiers/animate.vim",
        config = config.lens
    },
    ["pocco81/truezen.nvim"] = {
    },
    ["wincent/terminus"] = {},
    ["nacro90/numb.nvim"] = {
        config = config.numb
    },
    ["winston0410/range-highlight.nvim"] = {
        requires = "winston0410/cmd-parser.nvim",
        config = config.range_highlight
    },
    ["rcarriga/nvim-notify"] = {
        config = config.notify
    },
    ["machakann/vim-highlightedyank"] = {
    },
    ["p00f/nvim-ts-rainbow"] = {
        after = "nvim-treesitter"
    },
    ["lukas-reineke/indent-blankline.nvim"] = {
        config = config.indent_blankline
    },
    ["kevinhwang91/nvim-bqf"] = {
        ft = "qf",
        config = config.bqf,
    },
    ["folke/trouble.nvim"] = {
        cmd = {"Trouble", "TroubleClose", "TroubleOpen", "TroubleRefresh"},
        config = config.trouble
    },
    ["liuchengxu/vista.vim"] = {
        config = config.vista,
    },
}
return ui
