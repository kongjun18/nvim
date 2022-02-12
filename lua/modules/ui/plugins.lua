-- TODO: support kristijanhusak/vim-dadbod-ui
local config = require("modules.ui.config")
local ui = {
  ["kyazdani42/nvim-tree.lua"] = {
    config = config.nvim_tree,
  },
  ["EdenEast/nightfox.nvim"] = {
    config = config.nightfox,
  },
  ["arkav/lualine-lsp-progress"] = {},
  ["SmiteshP/nvim-gps"] = {
    config = config.gps,
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
  },
  ["nvim-lualine/lualine.nvim"] = {
    config = config.lualine,
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    after = { "nvim-gps" },
  },
  ["alvarosevilla95/luatab.nvim"] = {
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = config.luatab,
  },
  ["jeffkreeftmeijer/vim-numbertoggle"] = {},
  ["camspiers/lens.vim"] = {
    requires = "camspiers/animate.vim",
    config = config.lens,
  },
  ["pocco81/truezen.nvim"] = {},
  ["wincent/terminus"] = {},
  ["nacro90/numb.nvim"] = {
    config = config.numb,
  },
  ["winston0410/range-highlight.nvim"] = {
    requires = "winston0410/cmd-parser.nvim",
    config = config.range_highlight,
  },
  ["rcarriga/nvim-notify"] = {
    config = config.notify,
  },
  ["machakann/vim-highlightedyank"] = {},
  ["p00f/nvim-ts-rainbow"] = {
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    config = config.indent_blankline,
  },
  ["kevinhwang91/nvim-bqf"] = {
    ft = "qf",
    config = config.bqf,
  },
  ["folke/trouble.nvim"] = {
    cmd = { "Trouble", "TroubleClose", "TroubleRefresh", "TroubleToggle" },
    config = config.trouble,
  },
  ["liuchengxu/vista.vim"] = {
    config = config.vista,
  },
  ["norcalli/nvim-colorizer.lua"] = {
    config = config.colorizer,
  },
}
return ui
